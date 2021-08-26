#!/usr/bin/env python

import json
import os
import sys
import subprocess
from pathlib import Path
import argparse
## Pablo Debug, why pub 567 has no dir in the webpage? It has a pdf.

def merge_citations_crossref_into_metadata(
        input_citations_crossref_file,
        output_metadata_file,
        revision_index=None,
        write_output=False, verbose=False):
    """
    Add to an existing output_metadata_file (metadata.json) file the contents
    of the _citations_crossref_file, which has been created by query_crossref_xxx
    scripts.
    Parameters
    ----------
    input_citations_crossref_file: Str (Path)
        Input file `a_name_citations_crossref.json` generated using
        scripts `query_crossref_xxx.py`
    output_metadata_file: Str (Path)
        Path to the metadata.json file, used by gatsby to generate the publication page.
    revision_index: int
        The revision index to update, if None (default), use the last one.
        Be aware that the revision number in the old database might not be the same
        in the new one.
        We treat the old database as inmutable, and we only upload the last revised article.
        Future publications in the IJ should be more dynamic.
    write_output: Bool
        Write the updated metadata with the citations into the output_metadata_file.
    verbose: Bool
        Extra info printed to stdout
    Returns
    -------
    The updated metadata, if write_output is True, also updates the content of the metadata file.
    """

    input_citations_crossref_path = Path(input_citations_crossref_file).expanduser()
    if not input_citations_crossref_path.exists():
        print("citations_crossref_file does not exist {}".format(input_citations_crossref_file))
        raise Exception("citations_crossref_file does not exist.")

    output_metadata_path = Path(output_metadata_file).expanduser()
    if not output_metadata_path.exists():
        print("Output metadata file does not exist: {}".format(output_metadata_path))
        raise Exception("Output metadata file does not exist.")

    with open(input_citations_crossref_file, 'r') as fp:
        citation_list = json.load(fp=fp)
    with open(output_metadata_file, 'r') as fp:
        metadata = json.load(fp=fp)

    revisions = metadata["publication"]["revisions"]
    num_existing_revisions = len(revisions)
    if num_existing_revisions == 0:
        raise Exception("publication does not have any revision")
    max_index_existing_revisions = num_existing_revisions - 1

    if not revision_index:
        # Use the last one
        revision_index = max_index_existing_revisions
    else:
        if revision_index > max_index_existing_revisions:
            raise Exception("revision_index {} is greater than the max index allowed for the number of existing revisions {}".format(revision_index, max_index_existing_revisions))

    metadata["publication"]["revisions"][revision_index]["citation_list"] = citation_list

    # if verbose:
    #     json.dump(metadata["publication"]["revisions"][revision_index], fp=sys.stdout, indent=2)
    #     print()

    if write_output:
        with open(output_metadata_file, 'w') as fp:
            json.dump(metadata, fp, sort_keys=True, indent=2)

    return metadata

def merge_citations_crossref_into_metadata_whole_database(
input_folder, output_folder, verbose=False, start_at_publication=-1):
    """
    Note that this function writes into the output (write_output=True), use with caution.

    Parameters
    ----------
    input_folder: Str (Path)
        Input folder where the publications are (Note that publications should have a citations_crossref.json file in the last revision index, as created by the query_crossref_xxx.py scripts)

    output_folder: Str (Path)
        Path to the parent folder containing all the publications with a metadata.json file (i.e. /path_to_webpage_source/data/publications).

    verbose: Bool
        Extra info printed to stdout
    start_at_publication: Int
        Useful to restart at given publication if previous run has failed.
    Returns
    -------
    The updated metadata, if write_output is True, also updates the content of the metadata file.
    """
    input_folder_path = Path(input_folder).expanduser()
    if not input_folder_path.exists():
        print("Input folder does not exist {}".format(input_folder))
        raise Exception("Input folder does not exist.")

    output_folder_path = Path(output_folder).expanduser()
    if not output_folder_path.exists():
        print("Output folder does not exist {}".format(output_folder))
        raise Exception("Output folder does not exist.")


    publication_dirs = [f.name for f in os.scandir(input_folder_path) if f.is_dir()]

    run_it = False
    if start_at_publication == -1:
        run_it = True;

    for pub in publication_dirs:
        if not run_it and pub == str(start_at_publication):
            run_it = True
        if not run_it:
            continue

        publication_dir_path = input_folder_path / pub
        revision_dirs = [f.name for f in os.scandir(publication_dir_path) if f.is_dir()]
        # Only query the last revision
        if revision_dirs:
            revision_dir = max(revision_dirs)
        else: # no revision dir
            continue
        revision_dir_path = publication_dir_path / revision_dir

        citations_crossref_files = list(revision_dir_path.glob('*_citations_crossref.json'))

        # Skip if there is none
        if not citations_crossref_files:
            if verbose:
                print("No citations_crossref.json file found for pub {}, skipping".format(pub))
            continue
        if len(citations_crossref_files) > 1:
            raise Exception("Impossible to have more than one citations_crossref.json for pub {}".format(pub))

        input_citations_crossref_file = citations_crossref_files[0]
        output_metadata_file = output_folder_path / pub / "metadata.json"
        if not output_metadata_file.exists():
            print("There is not a metadata.json file for this publication {}, skipping".format(pub))
            continue

        merge_citations_crossref_into_metadata(
            input_citations_crossref_file=str(input_citations_crossref_file),
            output_metadata_file=str(output_metadata_file),
            revision_index=None,
            write_output=True,
            verbose=verbose)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Copy the content of a citations_crossref_file into a metadata json.')

    parser.add_argument("-i", "--input", dest="input",
                        help="Input folder to publications folder containing citations_crossref.json, i.e, where input_folder/pub/revision/xxx_citations_crossref.json. In case whole is False, input corresponds to the citations_crossref_file")
    parser.add_argument("-o", "--output", dest="output",
                        help="Output folder to publications containing metadata.json. i.e, path_to_web/data/output_folder/pub/metadata.json. In case whole is False, output corresponds to a metadata.json file.")

    parser.add_argument("--whole", dest="whole", action='store_true',
                        help="Apply the function to the whole databse. input_folder and output_folder points to the parent publications folders. Need to turn write--output to True to work.")

    parser.add_argument("-w", "--write-output",
                        dest="write_output", action='store_true',
                        help="Update content of metadata.json file.")

    parser.add_argument("-v", "--verbose",
                        dest="verbose", action='store_true',
                        help="Print extra info")
    parser.add_argument("-p", "--start_at_publication",
                        dest="start_at_publication",
                        default=-1,
                        help="Useful to restart at given publication if a previous run has failed.")
    args = parser.parse_args()
    print(args)


    if args.whole:
        if not args.write_output:
            raise Exception("Cannot apply to the whole database if write-output is False")
        merge_citations_crossref_into_metadata_whole_database(
            input_folder=args.input,
            output_folder=args.output,
            verbose=args.verbose,
            start_at_publication=int(args.start_at_publication))
        exit
    else:
        merge_citations_crossref_into_metadata(
            input_citations_crossref_file=args.input,
            output_metadata_file=args.output,
            revision_index=None,
            write_output=args.write_output,
            verbose=args.verbose)

