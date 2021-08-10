#!/usr/bin/env python
import json
import sys
import subprocess
from pathlib import Path
import argparse
import xml.etree.ElementTree as ET

def extract_citation_list_from_pdf(input_folder, cermine_path, no_write_output_json=False):
    # The example folder has been downloaded from https://data.kitware.com/#collection/5cb75e388d777f072b41e8db
    # input folder where pdf file(s) can be found.
    # Using CERMINE: https://github.com/CeON/CERMINE
    # Recommended by crossref and used in production by OpenAIRE. It's good!
    # The output of CERMINE will be in the same folder than input path
    # with the format pdf_filename.stem().cermxml.
    # Dev: Note that all pdfs files will be processed recursively, producing corresponding cermxml files.
    input_folder_path = Path(input_folder).expanduser()
    if not input_folder_path.exists():
        print("File does not exist {}".format(input_folder))
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

    print("\ncommand:", command)
    # java -cp ~/Downloads/cermine-impl-1.13-jar-with-dependencies.jar pl.edu.icm.cermine.ContentExtractor -outputs jats -path $input_folder
    subprocess.run(args=command, shell=True, check=True)

    # The ".cermxml" files would be generated
    cermxml_files = input_folder_path.glob("*.cermxml")
    output_dict = dict() # {cermxml_file.stem: {refs}}
    for cermxml_file in cermxml_files:
        refs = {}
        print("\ncermxml_file:" , str(cermxml_file))
        xml_tree = ET.parse(str(cermxml_file))
        # xpath magic, see:
        # https://docs.python.org/3/library/xml.etree.elementtree.html#supported-xpath-syntax
        refs_all = xml_tree.findall(".//ref")
        number_of_refs = len(refs_all)
        if number_of_refs == 0:
            print("  0 references")
            continue
        for ref in refs_all:
            ref_id = ref.attrib["id"]
            print("  ref_id:", ref_id)
            value = {}
            for mixed_citation in list(ref):
                authors = mixed_citation.findall(".//string-name")
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
                            author_dict["given-names"] = given_names.text
                        if surname is not None:
                            author_dict["surname"] = surname.text

                        author_list.append(author_dict)

                    # All others as simple string
                    else:
                        if sub is not None:
                            value[sub.tag] = sub.text

                value["authors"] = author_list

            refs[ref_id] = value

        if refs is not None:
            output_dict[cermxml_file.stem] = refs

            if not no_write_output_json:
                out_citation_list_file = Path.joinpath(cermxml_file.parent, cermxml_file.stem + "_citations.json")
                print("  output citations file:", out_citation_list_file)
                with open(out_citation_list_file, 'w') as fp:
                    json.dump(refs, fp=fp, indent=4)
        else:
            print("refs for {} file is empty".format(cermxml_file))

    return output_dict


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

    output_dict = extract_citation_list_from_pdf(input_folder=args.input_folder,
                                   cermine_path = args.cermine_path,
                                   no_write_output_json = args.no_write_output_json)
    if args.verbose:
        json.dump(output_dict, fp=sys.stdout, indent=4)


