#!/usr/bin/env python
import os
import sys
import json
import itertools # for izip_longest


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print( "Example:\n"
              "./create_folders_with_metadata_file_from_database_json_file.py /tmp/output_folder /tmp/database_output.json")
        raise Exception("Wrong arguments")
    output_folder = sys.argv[1]
    data_file = sys.argv[2]
    if not os.path.exists(data_file):
        print("File does not exist {}".format(data_file))
        raise Exception("Input data file does not exist")
    with open(data_file, "r") as f:
        data = json.load(f)
        print(data)
        for pub in data:
            # The publication content is wrapped in a publication key
            pub_id = pub['publication']['publication_id']
            pub_dir_path = os.path.join(output_folder, str(pub_id))
            if not os.path.exists:
                print("Creating folder for publication {}".format(pub_id))
                os.mkdir(pub_dir_path)
            metadata_file_path = os.path.join(pub_dir_path, 'metadata.json')
            with open(metadata_file_path, "w") as o:
                json.dump(pub, o, indent=1, sort_keys=True)


