#!/usr/bin/env python
import psycopg2
import re
import os
import sys
import json
import itertools # for izip_longest

def get_json_data_from_sql_script(sql_script):
    conn = None
    json_list_of_dict = []
    try:
        # connect to the PostgresQL database
        conn = psycopg2.connect(dbname="midasjournal", user="midas")
        # create a new cursor object
        cur = conn.cursor()
        # execute the SELECT statement
        with open(sql_script, 'r') as f:
            content = f.read()
        print(content)
        cur.execute(content)
        rows = cur.fetchall()
        for row in rows:
            json_list_of_dict.append(row[0])
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        if conn is not None:
            conn.close()
        raise error
    finally:
        if conn is not None:
            conn.close()
    return json_list_of_dict

if __name__ == '__main__':
    metadata_file = sys.argv[1]
    content = dict()
    if not os.path.exists(metadata_file):
        print("File does not exist, the script will generate with name: {}".format(metadata_file))
    else:
        with open(metadata_file, 'r') as f:
            content = json.load(f)
    print(content)
    sql_scripts = sys.argv[2:]
    final_json_list_of_dict = []
    for sql_script in sql_scripts:
        new_json_list_of_dict = get_json_data_from_sql_script(sql_script)
        if not final_json_list_of_dict:
            final_json_list_of_dict = new_json_list_of_dict
            continue

        for index, (new_pub_dict, final_pub_dict) in enumerate(itertools.zip_longest(new_json_list_of_dict, final_json_list_of_dict)):
            if final_pub_dict is None:
                final_pub_dict = new_pub_dict
            else:
                final_pub_dict.update(new_pub_dict)
            print(final_pub_dict)
            final_json_list_of_dict[index] = final_pub_dict
    # print(final_json_list_of_dict)

