import psycopg2
import requests # For downloading the bitstream data using python instead of curl
import re
import os
import glob

def unique_out_path(folder_name, file_name):
    out_path = os.path.join(folder_name, file_name)
    if os.path.exists(out_path):
        name, ext = file_name.split(os.extsep, 1)
        # name, ext = os.path.splitext(file_name)
        existing_files_with_similar_name = glob.glob(str(os.path.join(folder_name, name)) + '*')
        re_lastid = re.compile(r'_duplicatedName_([0-9]+)')
        lastIds = []
        print('glob: {} '.format(existing_files_with_similar_name))
        for efile in existing_files_with_similar_name:
            print('efile: {}'.format(efile))
            mfile = re_lastid.search(efile)
            if mfile:
                lastIds.append(int(mfile.group(1)))

        print('lastIds: {}'.format(lastIds))
        if lastIds:
            maxId = max(lastIds)
        else:
            maxId = 1
        new_file_name = "{name}_duplicatedName_{uid}.{ext}".format(name=name, uid=maxId + 1, ext=ext)
        out_path = os.path.join(folder_name, new_file_name)
    return out_path


def download_bitstream_of_publications(path_to_dir):
    """ Query the database to get all the bitstreams per publication, and download
    them using the 'API' of the insightjournal:
    https://www.insight-journal.org/download/downloadbitstream/bsID/whatever_filename_I_want.xxx
    """
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
        cur.execute("""
with registry as
(
select
  registry.bitstream_format_id,
  /* registry.description descr, */
  registry.mimetype mime
from bitstreamformatregistry registry
)
select
pub.id as pub_id,
bs.bitstream_id,
bs.name,
bs.bitstream_format_id,
mime,
pub.revision,
bs.description
from isj_publication pub
left join item2bundle it2bu on pub.itemid = it2bu.item_id
left join bundle2bitstream bu2bit on it2bu.bundle_id = bu2bit.bundle_id
left join bitstream bs on bs.bitstream_id = bu2bit.bitstream_id
join registry on bs.bitstream_format_id = registry.bitstream_format_id
order by pub.id, it2bu.bundle_id, bitstream_id ASC
        """)
#where pub.id = 173 # duplicated files
#where pub.id = 57 # duplicated files (16 revisions)
#where pub.id = 90 # wrong description: [revisions: 1] Main articl,2]
#where pub.id = 138 # wrong description: [revisions: 5] [revisions: 5]

        rows = cur.fetchall()
        for row in rows:
            pub_id = row[0]
            bs_id = row[1]
            bs_name = row[2]
            bs_format_id = row[3]
            bs_mime_type = row[4]
            pub_revisions = row[5]
            bs_description = row[6]
            print("pub_id: {}".format(pub_id))
            print("bs_id: {}".format(bs_id))
            print("bs_name: {}".format(bs_name))
            pub_folder = os.path.join(base_dir, str(pub_id))
            if not os.path.exists(pub_folder):
                print("  Creating folder at {}".format(pub_folder))
                os.mkdir(pub_folder)

            if not bs_id:
                continue

            # Download data
            # curl -O https://www.insight-journal.org/download/downloadbitstream/bsID/whatever_filename_I_want.xxx
            url_base = 'https://www.insight-journal.org/download/downloadbitstream/'
            url = url_base + str(bs_id) + '/xxxxxWhateverNamexxxxx'
            request = requests.get(url, allow_redirects=True)
            # Parse the description to get the revision.
            # Another approach would be to query the database
            minimum_revision = 1
            if bs_description:
                re_extract = re.compile(r'Extracted text')
                if re_extract.search(bs_description):
                    print('  skipped "Extracted text" file')
                    continue # skip this non-sense file generated for web-purposes
            contains_revisions = False
            if bs_description:
                re_revisions = re.compile(r'\[revisions:\s?(.*)\]')
                re_revisions_result = re_revisions.search(bs_description)
                if re_revisions_result:
                    contains_revisions = True
                    g = re_revisions_result.group(1)
                    # workaround bad data, remove extra ] xxxx ,
                    g = re.sub('](.*),', ',', g)
                    # workaround bad data, remove extra [revisions: N] xxxx ,
                    g = re.sub('](.*)([0-9]+)\s?', '', g)
                    g_list = g.split(',')
                    revisions = map(int, g_list)
                    for rev in revisions:
                        revision_folder = os.path.join(pub_folder, str(rev))
                        if not os.path.exists(revision_folder):
                            print("  Creating folder at {}".format(revision_folder))
                            os.mkdir(revision_folder)
                        out_path = unique_out_path(revision_folder, bs_name)
                        print("  output file: {}".format(str(out_path)))
                        open(str(out_path), 'wb').write(request.content)

            if not bs_description or not contains_revisions:
                # Save it to all revisions (usually: license.txt)
                for rev in range(minimum_revision, pub_revisions + 1):
                    revision_folder = os.path.join(pub_folder, str(rev))
                    if not os.path.exists(revision_folder):
                        print("  Creating folder at {}".format(revision_folder))
                        os.mkdir(revision_folder)
                    out_path = unique_out_path(revision_folder, bs_name)
                    print("  output file: {}".format(str(out_path)))
                    open(str(out_path), 'wb').write(request.content)
        # close the communication with the PostgresQL database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        if conn is not None:
            conn.close()
        raise error
    finally:
        if conn is not None:
            conn.close()

if __name__ == '__main__':
    base_path = '/tmp/ij_base/'
    print("Start downloading bitstreams to base folder: " + base_path )
    if not os.path.exists(base_path):
        os.mkdir(base_path)
    download_bitstream_of_publications(base_path)
    print("Finished!")

