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
- Summary image (or placeholder)
- Links to PDF, data
- Accessed at /browse/publication/986. phc:Probably not needed, we keep the publication_id
- License
 */

/* The logos are stored in bytea format (SQL), and there is no reference to their filetype.
To solve this, I used a postgres extension that bridges to the c library libmagic to get the mime type of the bytea types
https://github.com/nmandery/pg_byteamagic/blob/master/doc/byteamagic.md
Test:
psql -U midas -d midasjournal -a -c "CREATE EXTENSION byteamagic"
psql -U midas -d midasjournal -a -c "select id, byteamagic_mime(logo) from isj_publication where id = 987"
*/
