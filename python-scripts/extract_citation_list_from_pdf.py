#!/usr/bin/env python
import json
import os
import re
import sys
import subprocess
from pathlib import Path
import argparse
import xml.etree.ElementTree as ET

from pubs_with_multiple_pdfs import load_multiple_pdf_main_articles

def query_from_citation_list(citation_list):
    query_list = []
    for key, value in citation_list.items():
        if key == "authors":
            for author in value:
                author_fullname = []
                if "given-names" in author:
                    author_fullname.append(author["given-names"])
                if "surname" in author:
                    author_fullname.append(author["surname"])
                author_fullname_str = " ".join(author_fullname).strip()
                if author_fullname_str:
                    query_list.append(author_fullname_str)
        else:
            query_list.append(str(value))

    query = "+".join(query_list)
    return query


def extract_citation_list_from_pdf(input_folder, cermine_path, no_write_output_json=False, verbose=False):
    """
    Parameters
    ----------
    input_folder: Str (Path)
        Input folder where the pdf(s) are.
        Note that all the pdfs in the folder and subfolder will be processed.
    cermine_path: Str (Path)
        Path to the cermine .jar file. See https://github.com/CeON/CERMINE
    no_write_output_json: Bool
        Do not write the resulting dictionary with all keys and values to a json file.
    verbose: Bool
        Extra info printed to stdout
    Returns
    -------
    [dict(filename_str, refs), dict(filename_str, ref_query)]
        Tuple with two dicts. The first returning the references in a dict structure, and the second with all the values (keys are lost) merged into a single stringfor query purposes.
    """
    # The example folder has been downloaded from https://data.kitware.com/#collection/5cb75e388d777f072b41e8db
    # input folder where pdf file(s) can be found.
    # Using CERMINE: https://github.com/CeON/CERMINE
    # Recommended by crossref and used in production by OpenAIRE. It's good!
    # The output of CERMINE will be in the same folder than input path
    # with the format pdf_filename.stem().cermxml.
    # Dev: Note that all pdfs files will be processed recursively, producing corresponding cermxml files.
    input_folder_path = Path(input_folder).expanduser()
    if not input_folder_path.exists():
        print("Input folder does not exist {}".format(input_folder))
        raise Exception("Input folder does not exist.")

    if not Path(cermine_path).expanduser().exists():
        print("CERMINE jar file does not exists {}".format(cermine_path))
        raise Exception("CERMINE jar file does not exist.")

    # Build the command:
    # Download CERMINE from  github: https://github.com/CeON/CERMINE
    java_class = "pl.edu.icm.cermine.ContentExtractor"
    output_types = "jats" # xml format
    command_base = "java -cp " + cermine_path + " " + java_class + " -outputs " + output_types + " -path "
    # Apply the command to input_folder
    command = command_base + " " + input_folder

    # java -cp ~/Downloads/cermine-impl-1.13-jar-with-dependencies.jar pl.edu.icm.cermine.ContentExtractor -outputs jats -path $input_folder
    subprocess.run(args=command, shell=True, check=True)

    # The ".cermxml" files would be generated
    # list to iterate twice
    cermxml_files = list(input_folder_path.glob("*.cermxml"))
    output_dict = dict() # {cermxml_file.stem: {refs}}
    output_queries = dict() # {cermxml_file.stem: query_string}

    # When multiple pdfs, only use the main article files with load_multiple_pdf_main_articles
    num_of_cermxml_files = len(cermxml_files)
    if num_of_cermxml_files > 1:
        if verbose:
            print("Num of cermxml files:", num_of_cermxml_files)
        main_articles = load_multiple_pdf_main_articles()
        folder_parts = input_folder_path.parts
        rev = int(folder_parts[-1])
        pub = int(folder_parts[-2])
        main_article_file = main_articles[str(pub)][str(rev)][0]
    for cermxml_file in cermxml_files:
        # Exit early if the cermxml_file is not the main article and delete it otherwise.
        if num_of_cermxml_files > 1:
            if cermxml_file.stem != Path(main_article_file).stem:
                os.remove(cermxml_file)
                continue

        refs = {}
        queries = {}
        if verbose:
            print("cermxml_file:" , str(cermxml_file))
        xml_tree = ET.parse(str(cermxml_file))
        # xpath magic, see:
        # https://docs.python.org/3/library/xml.etree.elementtree.html#supported-xpath-syntax
        refs_all = xml_tree.findall(".//ref")
        number_of_refs = len(refs_all)
        if number_of_refs == 0:
            if verbose:
                print("  0 references")
            continue
        for ref in refs_all:
            ref_id = ref.attrib["id"]
            value = {}
            for mixed_citation in list(ref):
                # Parse the text of mixed_citation. It tends to include [2] for ref2
                # and similar, but also captures important text for non-journal refs.
                mixed_citation_text = mixed_citation.text
                strings_to_remove = [r'\[[0-9]+\]', r'[0-9]+\.(?=[^0-9])']
                mixed_citation_text_trimmed = str(mixed_citation_text)
                for s in strings_to_remove:
                    mixed_citation_text_trimmed = re.sub(s, '', mixed_citation_text_trimmed)
                mixed_citation_text_trimmed.strip(' \t\n\r')

                value["unstructured"] = mixed_citation_text_trimmed
                # print("DEBUG, unstructured:", value["unstructured"])
                author_list = list()
                ##### Get all others in a string for the query #######
                for sub in list(mixed_citation):
                    ##### Authors #######
                    if sub.tag == "string-name":
                        author = sub
                        given_names = author.find("given-names")
                        surname = author.find("surname")
                        author_dict = dict()
                        if given_names is not None:
                            author_dict["given-names"] = str(given_names.text)
                        if surname is not None:
                            author_dict["surname"] = str(surname.text)

                        author_list.append(author_dict)

                    # All others as simple string
                    else:
                        if sub is not None:
                            value[sub.tag] = str(sub.text)

                if author_list:
                    value["authors"] = author_list

            # Remove the unstructured key if there are other structured keys.
            # We only want it when the parsing failed, to keep something.
            if len(value) > 1:
                # value.pop("unstructured", None)
                del value["unstructured"]

            refs[ref_id] = value
            queries[ref_id] = query_from_citation_list(value)

        if refs is not None:
            output_dict[cermxml_file.stem] = refs
            output_queries[cermxml_file.stem] = queries

            if not no_write_output_json:
                out_citation_list_file = Path.joinpath(cermxml_file.parent, cermxml_file.stem + "_citations.json")
                if verbose:
                    print("output citations file:", out_citation_list_file)
                with open(out_citation_list_file, 'w') as fp:
                    json.dump(refs, fp=fp, indent=4)
        else:
            print("refs for {} file is empty".format(cermxml_file))

    return output_dict, output_queries


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Extract citation list from pdf using CERMINE.')

    parser.add_argument("--cermine-path", dest="cermine_path",
                        default="~/Downloads/cermine-impl-1.13-jar-with-dependencies.jar",
                        help="Path to cermine jar file, downloaded from https://github.com/CeON/CERMINE")
    parser.add_argument("-i", "--input-folder", dest="input_folder",
                        help="Input folder where pdfs are. It is also the output folder.")
    parser.add_argument("-n", "--no-write-output-json",
                        dest="no_write_output_json", action='store_true',
                        help="Avoid writing .json files with citation_list")
    parser.add_argument("-v", "--verbose",
                        dest="verbose", action='store_true',
                        help="Print the output dict")
    args = parser.parse_args()
    print(args)

    output_dict, output_queries = extract_citation_list_from_pdf(input_folder=args.input_folder,
                                   cermine_path = args.cermine_path,
                                   no_write_output_json = args.no_write_output_json)
    if args.verbose:
        print("output queries:")
        json.dump(output_queries, fp=sys.stdout, indent=4)
        # json.dump(output_dict, fp=sys.stdout, indent=4)
        print()
