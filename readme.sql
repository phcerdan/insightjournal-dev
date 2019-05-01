/* NOTE: dbeaver is great to interact with the database (pgadmin4 seems buggy) */
/* IMPORT dump database (midasjournal):
createuser --interactive midas
psql -U midas -a -f ~/Data/MidasJournal/midasjournal_2017-09-08.Friday.sql
*/
/* COPY DATABASES:
createdb -O midas -T midasjournal insightjournal
*/
/*-------CLEAN insightjournal------*/
/* eperson */
/* KEEP
 eperson_id
 email
 firstname
 lastname
 */
ALTER TABLE eperson
DROP COLUMN IF EXISTS netid,
DROP COLUMN IF EXISTS phone,
DROP COLUMN IF EXISTS sub_frequency,
DROP COLUMN IF EXISTS last_active,
DROP COLUMN IF EXISTS self_registered,
DROP COLUMN IF EXISTS require_certificate,
DROP COLUMN IF EXISTS can_log_in,
DROP COLUMN IF EXISTS password;

/* pablo:
isj_user: 17277
eperson: 9689
login: pablo.hernandez.cerdan@outlook.com

Isotropic wavelets
isj_publication:
 id: 986
 author_id: 17277
 journal_id: 81
 item_id: 5336
 bundle_id: 7686
 bitstream_id: [20240, 20241]
 git: git://github.com/phcerdan/ITKIsotropicWavelets
*/

/* Gold, Nested queries:
https://stackoverflow.com/questions/42222968/create-nested-json-from-sql-query-postgres-9-4
*/

/* Suggested by Matt
[x] Title, Abstract
[1/2] authors. (Missing matching authors to author_id, only first and lastname are available right now. TODO: do a search)
[x] submitted_by_author: author_id, firstname,lastname, email, institution
[x] date_submitted
[x] Tags, Categories, Keywords, Toolkits
[x] Journals
[x] handles. number and complete url with base http://hdl.handle.net/
[x] Links to PDF, data. Upload all biststreams to data.kitware/InsightJournal with the structure:
  - publication_id/revisions_number/ALL_FILES
[x] Accessed at /browse/publication/986. phc:Probably not needed, we keep the publication_id
- Summary image (or placeholder). Aka Logos. There are big and small logos, and default images if non-existant
- License. There is a license.txt in bitstreams
 */

/* The logos are stored in bytea format (SQL), and there is no reference to their filetype.
To solve this, I used a postgres extension that bridges to the c library libmagic to get the mime type of the bytea types
https://github.com/nmandery/pg_byteamagic/blob/master/doc/byteamagic.md
Test:
psql -U midas -d midasjournal -a -c "CREATE EXTENSION byteamagic"
psql -U midas -d midasjournal -a -c "select id, byteamagic_mime(logo) from isj_publication where id = 987"
*/


/*
You can download bitstream:
From publication to bitstream (one to many)
publication has 1 itemid
item2bundle
bundle2bitstream
bitstream

Use the "api": check
MidasJournal-copy/insightjournal/controllers/download_controller.php

Example: 20240 is one of the two bitstreams associated to the isotropic wavelets publication.
https://www.insight-journal.org/download/downloadbitstream/20240/hola.pdf

With this you should be able to download everything (all the interesting stuff is public anyway)


WIP: Use the script create_json_per_publication_sql.py to use all the extract sql
./create_json_per_publication_from_sql.py test_data.json ./extract_abstracts.sql \
./extract_bitstreams.sql ./extract_handle.sql ./extract_identifier.sql ./extract_journals.sql \
./extract_publication_author_names.sql ./extract_publications.sql ./extract_submitted_by_author.sql \
./extract_tags.sql ./extract_title.sql ./extract_toolkits.sql

Note that some grep should be applied to replace None for [] or "", depending on the key.

*/
