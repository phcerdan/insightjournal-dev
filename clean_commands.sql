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

/*---------------------*/
DROP TABLE subscription; /* empty */
DROP TABLE thumbnail; /* empty */
DROP TABLE workflowitem, tasklistitem; /* empty */
DROP TABLE workspaceitem, epersongroup2workspaceitem;
/* DROP VIEW community2item; */
DROP TABLE collection, community, community2collection, community2community, communities2item, collection2item;
DROP TABLE registrationdata;
DROP TABLE resourcepolicy; /* used, but irrelevant for the future */
DROP TABLE epersongroup, group2group, group2groupcache, epersongroup2eperson;
DROP TABLE shoppingcart, shoppingcart2bitstream, shoppingcart2eperson;
DROP TABLE trackpro_stats, trackpro_config;
DROP TABLE history, historystate;
DROP TABLE checksum_history, checksum_results, most_recent_checksum;
DROP TABLE midas_bitstream, midas_bitstreamstats, midas_collectionsubmit, midas_resourcelog, midas_searchsshfs, midas_sshfs, midas_statistics, midas_userquota;


/* ------------------- */
DROP TABLE isj_blog; /* only 4 entries 2008 */
DROP TABLE isj_email; /* empty */
DROP TABLE isj_password; /* empty */
DROP TABLE isj_osehr_disclaimer, isj_osehr_publication, isj_osehr_publication_temp, isj_osehr_review, isj_osehr_review_content; /* all empty */
DROP TABLE isj_associateeditor2publication, isj_associateeditor2journal;
DROP TABLE isj_shepherd2publication;
DROP TABLE isj_version;
DROP TABLE isj_subscribers_queries;
DROP TABLE isj_revisionplatforms; /* publication, revision, MAC, linux, windows? */

DROP TABLE isj_publication2category_temp;
DROP TABLE isj_publication2toolkit_temp;
DROP TABLE isj_publication_temp;
DROP TABLE isj_review_temp;
DROP TABLE isj_revisionfiles_temp;

/* Used, but removed anyway: */
DROP TABLE isj_helpful;
DROP TABLE isj_journal; /* Example: MICCAI 2005, SCIPY 2014. Not useful, not a journal. */
DROP TABLE isj_userinvite;
DROP TABLE isj_useradmin;
DROP TABLE isj_user_lastvisited;
DROP TABLE isj_user_mail; /* connects user, journal and policy */

/* To keep: */
select * from isj_category;
select * from isj_publication;



/* Used queries */
select * from isj_user
where submissions > 0
order by submissions DESC

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


