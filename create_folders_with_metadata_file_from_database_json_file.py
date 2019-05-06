#!/usr/bin/env python
import os
import sys
import json
import itertools # for izip_longest


if __name__ == '__main__':
    output_folder = sys.argv[1]
    data_file = sys.argv[2]
    if not os.path.exists(data_file):
        print("File does not exist {}".format(metadata_file))
        raise Exception("File does not exist")
    with open(data_file, "r") as f:
        data = json.load(f)
        print(data)
        for pub in data:
            print(pub['publication_id'])
            pub_dir_path = os.path.join(output_folder, str(pub['publication_id']))
            if not os.path.exists:
                os.mkdir(pub_dir_path)
            metadata_file_path = os.path.join(pub_dir_path, 'metadata.json')
            with open(metadata_file_path, "w") as o:
                json.dump(pub, o, indent=4, sort_keys=True)

