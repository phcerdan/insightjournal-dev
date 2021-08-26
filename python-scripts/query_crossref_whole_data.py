#!/usr/bin/env python
import json
import sys
import urllib.parse
import requests
import argparse
import os
from pathlib import Path

from extract_citation_list_from_pdf import extract_citation_list_from_pdf
from query_crossref_with_citation_list import (query_crossref_with_citation_list,
                                               json_citation_for_ij)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Query crossref with citation_list.')

    parser.add_argument("--cermine-path", dest="cermine_path",
                        default="~/Downloads/cermine-impl-1.13-jar-with-dependencies.jar",
                        help="Path to cermine jar file, downloaded from https://github.com/CeON/CERMINE")
    parser.add_argument("-i", "--input-folder", dest="input_folder",
                        help="Path to the root folder of the IJ data: '/path/publications' where publications are stored by /pub_id/revision_id/*.pdf.")
    parser.add_argument("-n", "--no-write-output-json",
                        dest="no_write_output_json", action='store_true',
                        help="Avoid writing .json files with citation_list")
    parser.add_argument("-v", "--verbose",
                        dest="verbose", action='store_true',
                        help="Print the output dict")
    parser.add_argument("-s", "--score-threshold",
                        dest="score_threshold",
                        type=float,
                        default=60.0,
                        help="Threshold to accept a valid doi")
    parser.add_argument("-p", "--start_at_publication",
                        dest="start_at_publication",
                        default="-1",
                        help="Useful to restart at given publication if a previous run has failed.")
    args = parser.parse_args()
    print(args)


    run_it = False
    if args.start_at_publication == "-1":
        run_it = True;

    # publications/pub_id/revision_id/*.pdf
    publication_dirs = [f.name for f in os.scandir(args.input_folder) if f.is_dir()]
    for publication_dir in publication_dirs:
        if not run_it and publication_dir == args.start_at_publication:
            run_it = True
        if not run_it:
            continue

        if args.verbose:
            print("Publication: ", publication_dir)

        publication_dir_path = os.path.join(args.input_folder, publication_dir)

        revision_dirs = [f.name for f in os.scandir(publication_dir_path) if f.is_dir()]
        # Only query the last revision
        if revision_dirs:
            revision_dir = max(revision_dirs)
        else: # no revision dir
            continue
        revision_dir_path = os.path.join(publication_dir_path, revision_dir)
        if args.verbose:
            print("Revision: ", revision_dir)

        output_dict, output_queries = extract_citation_list_from_pdf(
            input_folder=revision_dir_path,
            cermine_path = args.cermine_path,
            no_write_output_json = args.no_write_output_json,
            verbose=args.verbose)
        if args.verbose:
            json.dump(output_queries, fp=sys.stdout, indent=4)
            print()
            # json.dump(output_dict, fp=sys.stdout, indent=4)


        for file, refs in output_queries.items():
            print("FILE: ", file)
            citation_list = []
            for ref, query in refs.items():
                print("REF:", ref)
                print("QUERY: ", query)
                first_score, first_doi = query_crossref_with_citation_list(query=query, verbose=args.verbose, score_threshold=args.score_threshold)
                citation_json = json_citation_for_ij(query=query, score=first_score, doi=first_doi)
                # Add key: ref_number
                citation_json["key"] = ref
                if args.verbose:
                    json.dump(citation_json, fp=sys.stdout, indent=4)
                    print()
                citation_list.append(citation_json)

            if not args.no_write_output_json:
                out_citation_list_crossref_file = Path.joinpath(
                    Path(revision_dir_path), file + "_citations_crossref.json")
                with open(out_citation_list_crossref_file, 'w') as fp:
                    json.dump(citation_list, fp, indent=4)

