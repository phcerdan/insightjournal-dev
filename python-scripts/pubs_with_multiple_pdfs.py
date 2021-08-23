#!/usr/bin/env python
import json
import sys
import argparse
import os
from pathlib import Path

def load_multiple_pdf_ignore_list():
    """
    When a publication/revision has more than one pdf, use this result to get the pdfs that are duplicates,
    or they can be ignored.
    The pdfs that aren't main articles, and neither are in this list can be considered valious supplemental data.
    The dict has been manually populated.
    """
    this_dir = os.path.dirname(os.path.realpath(__file__))
    json_filename = "multiple_pdfs_ignore_list.json"
    file = os.path.join(this_dir, json_filename)
    with open(file, 'r') as fp:
        ignore_list = json.load(fp=fp)
        return ignore_list

def load_multiple_pdf_main_articles():
    """
    When a publication/revision has more than one pdf, use this result to get the main article.
    This dict has been manually populated.
    Note: When the main article is an empty string, it means all the pdfs are supplemental.
          For example publication 969 is a compendium of various presentations with no main article.
    """
    this_dir = os.path.dirname(os.path.realpath(__file__))
    json_filename = "./multiple_pdfs_main_articles.json"
    file = os.path.join(this_dir, json_filename)
    with open(file, 'r') as fp:
        main_articles = json.load(fp=fp)
        return main_articles

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Check publications with multiple pdf.'
'After run, hard-write the result the files multiple_pdfs_ignore_list.json and multiple_pdfs_main_articles.json.'
'You can then use load_multiple_pdf_ignore_list and load_multiple_pdf_main_articles functions to reuse them in other scripts.')

    parser.add_argument("-i", "--input-folder", dest="input_folder",
                        help="Path to the root folder of the IJ data: '/path/publications'"
                        "where publications are stored by /pub_id/revision_id/*.pdf.")
    parser.add_argument("-n", "--no-write-output-json",
                        dest="no_write_output_json", action='store_true',
                        help="Avoid writing .json files with citation_list")
    parser.add_argument("-v", "--verbose",
                        dest="verbose", action='store_true',
                        help="Print the output dict")
    args = parser.parse_args()
    print(args)

    publication_main_article = {}
    publication_main_article_max_revision = {}


    # publications/pub_id/revision_id/*.pdf
    publication_dirs = [f.name for f in os.scandir(args.input_folder) if f.is_dir()]
    for publication_dir in publication_dirs:
        if args.verbose:
            print("Publication: ", publication_dir)

        publication_dir_path = os.path.join(args.input_folder, publication_dir)
        revision_dirs = [f.name for f in os.scandir(publication_dir_path) if f.is_dir()]
        # Populate dict only for max revision
        if len(revision_dirs) > 0:
            revision_dir = max(revision_dirs)
            revision_dir_path = os.path.join(publication_dir_path, revision_dir)
            pdfs = [f.name for f in os.scandir(revision_dir_path) if Path(f.name).suffix == ".pdf"]
            if len(pdfs) > 1:
                publication_main_article_max_revision[int(publication_dir)] = {revision_dir:[]}
                for pdf in pdfs:
                    publication_main_article_max_revision[int(publication_dir)][revision_dir].append(pdf)

        # Populate dict with all revisions
        for revision_dir in revision_dirs:
            revision_dir_path = os.path.join(publication_dir_path, revision_dir)
            pdfs = [f.name for f in os.scandir(revision_dir_path) if Path(f.name).suffix == ".pdf"]
            if len(pdfs) > 1:
                publication_main_article[int(publication_dir)] = {revision_dir:[]}
                for pdf in pdfs:
                    publication_main_article[int(publication_dir)][revision_dir].append(pdf)

    if False: # Disordered
        json.dump(publication_main_article, fp=sys.stdout, indent=4)
        if not args.no_write_output_json:
            out_file = "multiple_pdfs.json"
            with open(out_file, 'w') as fp:
                json.dump(publication_main_article, fp=fp, indent=4)

    publication_main_article_sorted = {}
    for key, value in sorted(publication_main_article.items()):
        publication_main_article_sorted[key] = value

    json.dump(publication_main_article_sorted, fp=sys.stdout, indent=4)
    if not args.no_write_output_json:
        out_file = "multiple_pdfs_sorted.json"
        with open(out_file, 'w') as fp:
            json.dump(publication_main_article_sorted, fp=fp, indent=4)

    publication_main_article_max_revision_sorted = {}
    for key, value in sorted(publication_main_article_max_revision.items()):
        publication_main_article_max_revision_sorted[key] = value

    json.dump(publication_main_article_max_revision_sorted, fp=sys.stdout, indent=4)
    if not args.no_write_output_json:
        out_file = "multiple_pdfs_max_revision_sorted.json"
        with open(out_file, 'w') as fp:
            json.dump(publication_main_article_max_revision_sorted, fp=fp, indent=4)

