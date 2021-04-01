#!/usr/bin/env python
import psycopg2
import psycopg2.extras
import os
import pathlib
import json
import sys

def get_pubs_with_filtered_comments(sql_script):
    conn = None
    json_list_of_dict = []
    try:
        # connect to the PostgresQL database
        conn = psycopg2.connect(dbname="midasjournal", user="midas")
        # create a new cursor object
        cur = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        # execute the SELECT statement
        with open(sql_script, 'r') as f:
            content = f.read()
        cur.execute(content)
        rows = cur.fetchall()
        dictionary = rows
        # for row in rows:
        #     json_list_of_dict.append(row[0])
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        if conn is not None:
            conn.close()
        raise error
    finally:
        if conn is not None:
            conn.close()
    return dictionary

def get_all_pubs():
    conn = None
    json_list_of_dict = []
    try:
        # connect to the PostgresQL database
        conn = psycopg2.connect(dbname="midasjournal", user="midas")
        # create a new cursor object
        cur = conn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        # execute the SELECT statement
        content = """
select
json_build_object(
    'publication_id', pub.id,  /* ID */
    'comments', '[]'
  )
from isj_publication pub
order by pub.id asc
"""
        cur.execute(content)
        rows = cur.fetchall()
        all_pubs_pub_id_to_index = {};
        for index, row in enumerate(rows):
            pub_id = row[0]['publication_id']
            all_pubs_pub_id_to_index[pub_id] = index;
            json_list_of_dict.append(row[0])
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        if conn is not None:
            conn.close()
        raise error
    finally:
        if conn is not None:
            conn.close()
    return [json_list_of_dict, all_pubs_pub_id_to_index]

if __name__ == '__main__':
    output_file = sys.argv[1] if len(sys.argv) == 2 else '/tmp/publication_comments.json'
    current_path = pathlib.Path(__file__).parent.absolute()
    sql_script_path = os.path.join(current_path, "../sql-scripts/extract_comments.sql")
    pubs_with_comments = get_pubs_with_filtered_comments(sql_script_path)
    all_pubs, pub_id_to_index = get_all_pubs();
    for row in pubs_with_comments:
        pub_id = row[0]['publication_id']
        # modify all_pubs with this
        index = pub_id_to_index.get(pub_id)
        all_pubs[index] = row

    with open(output_file, "w") as o:
        json.dump(all_pubs, o, indent=1, sort_keys=True)
    print("Success. File written to {}".format(output_file))
