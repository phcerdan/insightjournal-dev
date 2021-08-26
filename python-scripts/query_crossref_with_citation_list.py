#!/usr/bin/env python
import json
import sys
import urllib.parse
import requests
import argparse
from pathlib import Path

from extract_citation_list_from_pdf import extract_citation_list_from_pdf

# test_query = "D. Xu+A. Kurani+J. Furst+D. Raicu+Run length encoding for volumetric texture+International Conference on Visualization, Imaging and Image Processing (VIIP)+452+458+2004+2+2"

def query_crossref_with_citation_list(query, score_threshold = 60.0, verbose=False):
    """
    Query crossref with the input plain text query.
    Parameters
    ----------
    query: str
        Plain text query, usually all the fields from the parser are joint
        (see extract_citation_list_from_pdf.query_from_citation_list)
    score_threshold: float
        Threshold to accept the first match.
        It is data (query and target match) dependant.
    verbose: bool
        print extra info to stdout

    Returns
    -------
    Tuple[score (Float), doi (Str)]
        Returns the score of the first match. If the score is higher than
        input threshold and the match has a DOI field, returns the DOI. Otherwise the doi would be None.
    """
    url_crossref = "https://api.crossref.org/works"
    payload = {'query.bibliographic' : query}

    if not query.strip():
        raise Exception("Input query is empty")
    r = requests.get(url_crossref, params=payload)
    # Will raise if not ok (status_code == requests.codes.ok (i.e 200))
    r.raise_for_status()

    if verbose:
        print(r.url)

    response = r.json()
    try:
        first_item = response["message"]["items"][0]
    except IndexError:
        print("QUERY is too short, ignoring.")
        first_score = 0
        return first_score, None

    first_score = first_item["score"]
    has_doi = "DOI" in first_item
    if has_doi:
        first_doi = first_item["DOI"]
    else:
        first_doi = None

    if verbose:
        print("SCORE FIRST: ", first_score)
        if "title" in first_item:
            print("TITLE FIRST: ", first_item["title"][0])

    # second_item = response["message"]["items"][1]
    if first_score >= score_threshold and first_doi:
        return first_score, first_doi

    return first_score, None

def json_citation_for_ij(query, score, doi):
    """
    Because we are parsing the PDF, we cannot ensure the validity of each subfieldobtained form the parser (CERMINE) i.e title, journal, volume, authors, etc.
    Instead, we join all the information obtained from the parser in plain text.
    This plain text is the same used in the field query.bibliographic in crossref.
    If the crossref query (see query_crossref_with_citation_list) gives a first match with a high score (see score_threshold) containing a DOI, we store that DOI.
    If the score is low, or the match doesn't have a doi, then our doi is not populated, or null.
    The output keys are:
    unstructured,
    score,
    doi,

    The idea is that if we store a DOI is because we are pretty sure it's the right one. If not, we just store the unstructured text and the score.
    """
    out = {}
    out["unstructured"] = query
    if doi:
        out["doi"] = doi
    if score:
        out["score"] = score

    return out


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Query crossref with citation_list.')

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
    parser.add_argument("-s", "--score-threshold",
                        dest="score_threshold",
                        type=float,
                        default=60.0,
                        help="Threshold to accept a valid doi")
    args = parser.parse_args()
    print(args)

    output_dict, output_queries = extract_citation_list_from_pdf(
        input_folder=args.input_folder,
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
                Path(args.input_folder), file + "_citations_crossref.json")
            with open(out_citation_list_crossref_file, 'w') as fp:
                json.dump(citation_list, fp, indent=4)

