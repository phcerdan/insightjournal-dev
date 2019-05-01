#!/usr/bin/env python
# From: https://stackoverflow.com/questions/748675/finding-duplicate-files-and-removing-them (fast)
import sys
import os
import hashlib
import re

global_total_deletions = 0
global_removed_files = []
global_same_files_with_different_name = []

def check_duplicates_in_revision_folders(path_publication, dirname_revisions):
    for dirname_revision in dirname_revisions:
        path_revision = os.path.join(path_publication, dirname_revision)
        print("Accessing dir: {}".format(path_revision))
        check_for_duplicates([path_revision])
        print("---------")

def chunk_reader(fobj, chunk_size=1024):
    """Generator that reads a file in chunks of bytes"""
    while True:
        chunk = fobj.read(chunk_size)
        if not chunk:
            return
        yield chunk


def get_hash(filename, first_chunk_only=False, hash=hashlib.sha1):
    hashobj = hash()
    file_object = open(filename, 'rb')

    if first_chunk_only:
        hashobj.update(file_object.read(1024))
    else:
        for chunk in chunk_reader(file_object):
            hashobj.update(chunk)
    hashed = hashobj.digest()

    file_object.close()
    return hashed


def check_for_duplicates(paths, hash=hashlib.sha1):
    hashes_by_size = {}
    hashes_on_1k = {}
    hashes_full = {}
    files_to_remove = []
    equal_files_with_different_name = []

    print("Paths: {}".format(paths))
    for path in paths:
        print("Path: {}".format(path))
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in sorted(filenames):
                full_path = os.path.join(dirpath, filename)
                try:
                    # if the target is a symlink (soft one), this will
                    # dereference it - change the value to the actual target file
                    full_path = os.path.realpath(full_path)
                    file_size = os.path.getsize(full_path)
                except (OSError,):
                    # not accessible (permissions, etc) - pass on
                    continue

                duplicate = hashes_by_size.get(file_size)

                if duplicate:
                    hashes_by_size[file_size].append(full_path)
                else:
                    hashes_by_size[file_size] = []  # create the list for this file size
                    hashes_by_size[file_size].append(full_path)

    # For all files with the same file size, get their hash on the 1st 1024 bytes
    for __, files in hashes_by_size.items():
        if len(files) < 2:
            continue    # this file size is unique, no need to spend cpy cycles on it

        for filename in files:
            try:
                small_hash = get_hash(filename, first_chunk_only=True)
            except (OSError,):
                # the file access might've changed till the exec point got here
                continue

            duplicate = hashes_on_1k.get(small_hash)
            if duplicate:
                hashes_on_1k[small_hash].append(filename)
            else:
                hashes_on_1k[small_hash] = []          # create the list for this 1k hash
                hashes_on_1k[small_hash].append(filename)

    # For all files with the hash on the 1st 1024 bytes, get their hash on the full file - collisions will be duplicates
    for __, files in hashes_on_1k.items():
        if len(files) < 2:
            continue    # this hash of fist 1k file bytes is unique, no need to spend cpy cycles on it

        for filename in files:
            try:
                full_hash = get_hash(filename, first_chunk_only=False)
            except (OSError,):
                # the file access might've changed till the exec point got here
                continue

            duplicate = hashes_full.get(full_hash)
            if duplicate:
                print("Duplicate found:\n"
                "  {}\n"
                "  {}".format(filename, duplicate))
                # We want to remove the filename with greatest duplicateName of the two
                re_duplicate_name_number = re.compile(r'duplicatedName_([0-9]*)')
                s_filename = re_duplicate_name_number.search(filename)
                filename_n = 0
                if s_filename:
                     filename_n = int(s_filename.group(1))
                duplicate_n = 0
                s_duplicate = re_duplicate_name_number.search(duplicate)
                if s_duplicate:
                     duplicate_n = int(s_duplicate.group(1))

                if(filename_n > duplicate_n):
                    print("Selected for removal: {}".format(filename))
                    files_to_remove.append(filename)
                elif(duplicate_n > filename_n):
                    print("Selected for removal: {}".format(duplicate))
                    files_to_remove.append(duplicate)
                else:
                    print("SAME FILE with different name!.".format(duplicate))
                    equal_files_with_different_name.append(filename)
                    equal_files_with_different_name.append(duplicate)

            else:
                hashes_full[full_hash] = filename

    removeDuplicated = True
    print("Removing all duplicated files. N: {}".format(len(files_to_remove)))
    print("Files removed: {}".format(files_to_remove))
    if files_to_remove and removeDuplicated:
        for file_to_remove in files_to_remove:
            os.remove(file_to_remove)
            global_removed_files.append(file_to_remove)
            global global_total_deletions
            global_total_deletions +=1

    if equal_files_with_different_name:
        print("WARNING. There are equal_files_with_different_name: {}".format(len(equal_files_with_different_name)))
        equal_files_pairs = zip(equal_files_with_different_name[0::2], equal_files_with_different_name[1::2])
        global global_same_files_with_different_name
        global_same_files_with_different_name.append(equal_files_pairs)
        for file_pairs in equal_files_pairs:
            print("Equal file pair:\n"
                  "  {}\n"
                  "  {}\n".format(file_pairs[0], file_pairs[1]))

if __name__ == "__main__":
    if sys.argv[1:]:
        for path in sys.argv[1:]:
            if not os.path.exists(path):
                raise Exception('path {} does not exist'.format(path))
            re_dirname_is_a_number = re.compile(r'/[0-9]+(/)?$')
            s_dirname_is_a_number = re_dirname_is_a_number.search(path)
            if s_dirname_is_a_number:
                print('input path is a specific publication folder: {}'.format(s_dirname_is_a_number.group(0)))
                # Get the revisions of the input publication
                path_publication = path
                dirname_revisions = next(os.walk(path_publication))[1]
                check_duplicates_in_revision_folders(path_publication, dirname_revisions)
            else:
                print('input path not a publication, but a parent folder')
                dirnames_publications = next(os.walk(path))[1]
                for dirname_publication in dirnames_publications:
                    path_publication = os.path.join(path, dirname_publication)
                    dirname_revisions = next(os.walk(path_publication))[1]
                    check_duplicates_in_revision_folders(path_publication, dirname_revisions)
        print("Finished!")
        print("Stats:")
        print("Total files deleted: {}".format(global_total_deletions))
        print("Files deleted: {}".format(global_removed_files))
        print("Equal files with different names:\n{}".format(global_same_files_with_different_name))
        print("Pairs of equal files with different names: {}.".format(len(global_same_files_with_different_name)))
    else:
        print("Please pass the paths to the publications folder: publications/pub_id or a path to the parent folder: publications/"
              "The script will remove duplicates only in subfolders revisions_number")
