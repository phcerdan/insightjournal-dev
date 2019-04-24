import psycopg2
import os

def read_blob_publication_logo(path_to_dir):
    """ read BLOB logo and biglogo from isj_publication """
    conn = None
    base_dir = os.path.dirname(path_to_dir)
    try:
        # connect to the PostgresQL database
        conn = psycopg2.connect(dbname="midasjournal", user="midas")
        # create a new cursor object
        cur = conn.cursor()
        # execute the SELECT statement
        # Requires CREATE EXTENSION byteamagic
        # From: https://github.com/nmandery/pg_byteamagic/blob/master/doc/byteamagic.md
        cur.execute(""" select pub.id,
                        pub.logo, byteamagic_mime(pub.logo),
                        pub.biglogo, byteamagic_mime(pub.biglogo)
                        from isj_publication pub
                        """)
                        # WHERE pub.id = %s """, (part_id,))

        rows = cur.fetchall()
        for row in rows:
            pub_id = row[0]
            logo_data = row[1]
            logo_mime_type = row[2]
            biglogo_data = row[3]
            biglogo_mime_type = row[4]
            print("id: {}".format(pub_id))
            pub_folder = os.path.join(base_dir, str(pub_id))
            if not os.path.exists(pub_folder):
                print("  Creating folder at {}".format(pub_folder))
                os.mkdir(pub_folder)

            if logo_data and logo_mime_type:
                print(" logo")
                extension = logo_mime_type.split('/')[1]
                print("  extension: {}".format(extension))
                out_path = os.path.join(pub_folder, 'publication_logo.' + extension)
                print("  output file: {}".format(str(out_path)))
                open(str(out_path), 'wb').write(logo_data)
            if biglogo_data and biglogo_mime_type:
                print(" biglogo")
                extension = biglogo_mime_type.split('/')[1]
                print("  extension: {}".format(extension))
                out_path = os.path.join(pub_folder, 'publication_biglogo.' + extension)
                print("  output file: {}".format(str(out_path)))
                open(str(out_path), 'wb').write(biglogo_data)
        # close the communication with the PostgresQL database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

if __name__ == '__main__':
    print("writing logos")
    base_path = '/tmp/ij_base/'
    if not os.path.exists(base_path):
        os.mkdir(base_path)
    read_blob_publication_logo(base_path)
    print("Finished!")

