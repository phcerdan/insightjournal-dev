#!/usr/bin/env python
import os
import sys
import json
import itertools # for izip_longest


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Example:\n"
              "./merge_json_data_by_publication_id.py /tmp/database_output.json \\ \n"
              "~/InsightJournal/data/publication_all.json \\ \n"
              "~/InsightJournal/data/publication_tags.json")
        raise Exception("Wrong arguments")
    output_file = sys.argv[1]
    data_files = sys.argv[2:]
    a_file_doest_not_exist = False
    for data_file in data_files:
        if not os.path.exists(data_file):
            print("File does not exist {}".format(data_file))
            a_file_doest_not_exist = True
    if a_file_doest_not_exist:
        raise Exception("Some files do not exist")

    final_json_list_of_dict = []
    for data_file in data_files:
        print("data_file {}".format(data_file))
        new_json_list_of_dict = []
        with open(data_file, "r") as f:
            new_json_list_of_dict = json.load(f)
            if not final_json_list_of_dict:
                final_json_list_of_dict = new_json_list_of_dict
                continue

        for index, (new_pub_dict, final_pub_dict) in enumerate(itertools.zip_longest(new_json_list_of_dict, final_json_list_of_dict)):
            # In some cases new_pub_dict is a list with one dict element
            if isinstance(new_pub_dict, list):
               new_pub_dict = new_pub_dict[0]
               if not isinstance(new_pub_dict, dict):
                   raise "new_pub_dict is not a dict"
            if final_pub_dict is None:
                final_pub_dict = new_pub_dict
            else:
                final_pub_dict.update(new_pub_dict)
            final_json_list_of_dict[index] = final_pub_dict

    print("Dumping to {}".format(output_file))
    final_json_list_of_dict_with_publication = []
    for pub in final_json_list_of_dict:
        pub = {'publication': pub}
        final_json_list_of_dict_with_publication.append(pub)
    with open(output_file, "w") as o:
        json.dump(final_json_list_of_dict_with_publication, o, indent=1, sort_keys=True)
    # print(final_json_list_of_dict)

"""
./python-scripts/merge_json_data_by_publication_id.py /tmp/output_database.json \
./cleaned_json_data/publication_all.json \
./cleaned_json_data/publication_author_names_with_epersona_4firstname_letters_match.json \
./cleaned_json_data/publication_handles.json \
./cleaned_json_data/publication_identifiers.json \
./cleaned_json_data/publication_journals.json \
./cleaned_json_data/publication_submitted_by_author.json \
./cleaned_json_data/publication_tags.json \
./cleaned_json_data/publication_categories.json \
./cleaned_json_data/publication_comments.json \
./cleaned_json_data/publication_reviews.json \
./cleaned_json_data/publication_license.json
"""
