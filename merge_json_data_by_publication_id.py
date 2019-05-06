#!/usr/bin/env python
import os
import sys
import json
import itertools # for izip_longest


if __name__ == '__main__':
    output_file = sys.argv[1]
    data_files = sys.argv[2:]
    a_file_doest_not_exist = False
    for data_file in data_files:
        if not os.path.exists(data_file):
            print("File does not exist {}".format(metadata_file))
            a_file_doest_not_exist = True
    if a_file_doest_not_exist:
        raise Exception("Some files do not exist")

    final_json_list_of_dict = []
    for data_file in data_files:
        new_json_list_of_dict = []
        with open(data_file, "r") as f:
            new_json_list_of_dict = json.load(f)
            if not final_json_list_of_dict:
                final_json_list_of_dict = new_json_list_of_dict
                continue

        for index, (new_pub_dict, final_pub_dict) in enumerate(itertools.zip_longest(new_json_list_of_dict, final_json_list_of_dict)):
            if final_pub_dict is None:
                final_pub_dict = new_pub_dict
            else:
                final_pub_dict.update(new_pub_dict)
            final_json_list_of_dict[index] = final_pub_dict

    print("Dumping to {}".format(output_file))
    with open(output_file, "w") as o:
        json.dump(final_json_list_of_dict, o, sort_keys=True)
    # print(final_json_list_of_dict)


#  /merge_json_data_by_publication_id.py /tmp/database_output.json \
#      ~/Dropbox/dev/InsightJournal/data/publication_all.json \
#      ~/Dropbox/dev/InsightJournal/data/publication_author_names_with_epersona_4firstname_letters_match.json \
#      ~/Dropbox/dev/InsightJournal/data/publication_handles.json \
#      ~/Dropbox/dev/InsightJournal/data/publication_identifiers.json \
#      ~/Dropbox/dev/InsightJournal/data/publication_journals.json \
#      ~/Dropbox/dev/InsightJournal/data/publication_submitted_by_author.json
#      ~/Dropbox/dev/InsightJournal/data/publication_tags.json \

