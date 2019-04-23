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

/* Title of publication is in metadatavalue, with a metadatafieldregistry: metadata_field_id = 64
/* authors the same, with metadata_field_id = 3
/* metadata_value_id is linked to a item_id (one to many)


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
DROP TABLE isj_review_svn; /* empty */
DROP TABLE isj_revisionfiles_temp;
/* DROP TABLE isj_reviewcommend; /* empty comments are spam */

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


select
	isj_publication.id, /* ID */
	isj_publication.category as tag_id, /* [tags] */
	isj_category.description as tag_description,
    /* [Authors] . authorid points to isj_user, isj_user has a eperson, which contains what we want*/
	/* isj_publication.authorid, */
	eperson.eperson_id as author_id,
	eperson.firstname as author_firstname,
	eperson.lastname as author_lastname,
	eperson.email as author_email,
	isj_publication.institution /* [Institutions] */
	 /* Journal ( ignore isj_journal. It is more like a bundle of publications) */
	/* isj_toolkit */
from isj_publication
join isj_user on isj_user.id = isj_publication.authorid
left join isj_category on isj_publication.category = isj_category.id /* left join because it can be null */
join eperson on eperson.eperson_id = isj_user.erperson_id



/* NOT WORKING: */
select isj_publication.id, toolkits/* ID */
from
  isj_publication
  left join isj_publication2toolkit on isj_publication2toolkit.publicationid = isj_publication.id
  join (
    select
      array_to_json(array_agg(json_build_object('toolkit_id',pub2tool.toolkitid, 'pub_id', pub2tool.publicationid, 'hola', isj_publication.id))) as toolkits
    from isj_publication2toolkit as pub2tool
    join isj_publication on isj_publication.id = pub2tool.publicationid
    group by pub2tool.publicationid) toolkits
  on isj_publication2toolkit.publicationid = isj_publication.id



select distinct on (pub.id) /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	/* Title, authors, abstracts and many more valuable info is stored in metadatavalue: one to many with item_id)  */
	/* String */
	'title', meta_title.text_value,
	/* [Authors] */
	'authors', jsonb_agg(json_build_object(
			'author_name', meta_authors.text_value)), /* TODO: no author_id associated to these author names!  */
	'submitted_by_author', json_build_object(
			'author_id',  pub.authorid,
			'author_firstname', author_persona.firstname,
			'author_lastname', author_persona.lastname,
			'author_email', author_persona.email),
	/* [Institutions] . TODO: associated to the paper or to the authors? Secondary authors*/
	/* [Journals]. Ignore isj_journal, it's like a bundle of publications*/
	'journals', jsonb_agg(json_build_object('journal_id',toolkit.id, 'journal_name', toolkit.name, 'journal_namelong', toolkit.description)),
	/* [Tags]. Aka, categories. */
	'tags', jsonb_agg(meta_tags.text_value)
	/* Abstract. */
	/* 'abstract', meta_abstract.text_value */
	)
	from isj_publication pub
	left join isj_publication2toolkit pub2tool on pub.id = pub2tool.publicationid /* for Tags */
	left join isj_toolkit toolkit on pub2tool.toolkitid = toolkit.id /* for Tags */
	left join metadatavalue meta_title on pub.itemid = meta_title.item_id and meta_title.metadata_field_id = 64 /* for Title */
	left join metadatavalue meta_authors on pub.itemid = meta_authors.item_id and meta_authors.metadata_field_id = 3 /* for all Authors (only names, no ids) */
	left join isj_user author_user on pub.authorid = author_user.id /* for author_id expansion */
	left join eperson author_persona on author_user.erperson_id = author_persona.eperson_id  /* for author_id expansion */
	left join metadatavalue meta_abstract on pub.itemid = meta_abstract.item_id and meta_abstract.metadata_field_id = 27 /* for Abstract */
	left join metadatavalue meta_tags on pub.itemid = meta_tags.item_id and meta_tags.metadata_field_id = 57 /* for Tags */
group by
pub.id,
pub.authorid,
meta_title.text_value,
author_persona.firstname,
author_persona.lastname,
author_persona.email,
meta_abstract.text_value

/*
This results in duplicates:
"authors" : [{"author_name": "Aylward, Stephen"}, {"author_name": "Ibanez, Luis"}, {"author_name": "Kapur, Tina"}, {"author_name": "Aylward, Stephen"}, {"author_name": "Ibanez, Luis"}, {"author_name": "Kapur, Tina"}], "submitted_by_author" : {"author_id" : 3, "author_firstname" : "Stephen", "author_lastname" : "Aylward", "author_email" : "stephen.aylward@kitware.com"}
*/


https://stackoverflow.com/questions/42222968/create-nested-json-from-sql-query-postgres-9-4

/* Suggested by Matt
- Title, author, institution
- Summary image (or placeholder)
- handle link
- Journal edition, submission author and time
- Abstract
- Links to PDF, data
- Categories, Keywords, Toolkits
- License
- Accessed at /browse/publication/986
 */


text_value = 'N4ITK:  Nick''s N3 ITK Implementation For MRI Bias Field Correction'

left join (select eperson, isj_user from isj_user left join eperson on isj_user.erperson_id = eperson.eperson_id) person on person.isj_user.id = pub.authorid
left join
  (
  select
	id,
	jsonb_agg(
	  json_build_object(
		'author_name', meta_authors.text_value))
	  )
	) authors
  from
    metadatavalue meta_authors
  group by 1
  ) meta_authors on pub.itemid = meta_authors.item_id and meta_authors.metadata_field_id = 3 /* for all Authors (only names, no ids) */


select distinct on (pub.id) /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	'title', meta_title.text_value,
	/* [Authors] */
	'authors', authors,
	'journals', toolkits,
	/* [Tags]. Aka, categories. */
	'tags', tags,
	/* Abstract. */
	'abstract', meta_abstract.text_value
	) publications
from isj_publication pub
left join isj_publication2toolkit pub2tool on pub.id = pub2tool.publicationid /* for Tags */
left join
  (
  select
	id,
	jsonb_agg(
	  json_build_object(
	    'journal_id',t.id,
	    'journal_name', t.name,
	    'journal_namelong', t.description
	  )
	) toolkits
  from
    isj_toolkit t
  group by id
  ) t on t.id = pub2tool.toolkitid /* for Tags */
left join metadatavalue meta_title on pub.itemid = meta_title.item_id and meta_title.metadata_field_id = 64 /* for Title */
left join
  (
  select
	item_id,
	metadata_field_id,
	jsonb_agg(
	  json_build_object(
		'author_name', meta_authors.text_value,
		'author_place', meta_authors.place
	  )
	) authors
  from
    metadatavalue meta_authors
  group by item_id, metadata_field_id
  ) meta_authors on pub.itemid = meta_authors.item_id and meta_authors.metadata_field_id = 3 /* for all Authors (only names, no ids) */
left join metadatavalue meta_abstract on pub.itemid = meta_abstract.item_id and meta_abstract.metadata_field_id = 27 /* for Abstract */
left join
  (
  select
    item_id,
    metadata_field_id,
    jsonb_agg(
      meta_tags.text_value
    ) tags
  from
   metadatavalue meta_tags
  group by item_id, metadata_field_id
  ) meta_tags on pub.itemid = meta_tags.item_id and meta_tags.metadata_field_id = 57 /* for Tags */
left join isj_user author_user on pub.authorid = author_user.id /* for author_id expansion */
left join
 (
 select
  eperson_id,
  json_build_object(
			'author_id',  author_persona.eperson_id,
			'author_firstname', author_persona.firstname,
			'author_lastname', author_persona.lastname,
			'author_email', author_persona.email
			) submitted_by_author
  from
    eperson author_persona
  ) author_persona on author_user.erperson_id = author_persona.eperson_id  /* for author_id expansion */





/* Nested queries: https://rextester.com/RCTE46862 */
