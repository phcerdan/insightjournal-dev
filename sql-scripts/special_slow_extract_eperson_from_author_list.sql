with author_persona as (
  select
    author_persona.eperson_id,
    author_persona.firstname,
    author_persona.lastname,
    author_persona.email
  from
    eperson author_persona
),
meta_authors as
(
  select
	item_id,
	metadata_field_id,
	jsonb_agg(
	  json_build_object(
		'author_fullname', meta_authors.text_value,
		'author_place', meta_authors.place,
		'persona_id', persona.eperson_id,
		'persona_lastname', persona.lastname,
		'persona_firstname', persona.firstname,
		'persona_email', persona.email
	  )
	) authors
  from metadatavalue meta_authors
  /* Use full lastname and first letter of firstname, Tustison was the reason for this. Nick, Nicholas A., etc*/
  left join author_persona persona on meta_authors.text_value ilike concat(persona.lastname,', ', left(persona.firstname,4), '%')
  group by item_id, metadata_field_id
)
select distinct on (pub.id) /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	/* [Authors] */
	'authors', authors
  )::jsonb
from isj_publication pub
left join meta_authors on pub.itemid = meta_authors.item_id and meta_authors.metadata_field_id = 3 /* for all Authors (only names, no ids) */
/* after:
%s/{"persona_id/\r{"persona_id/g

g/{"persona_id": 774, "author_place": .*, "persona_email": "wchunfang@gmail.com", "author_fullname": "Wang, Chunliang", "persona_lastname": "Wang", "persona_firstname": "Chunfang"},/d

g/{"persona_id": 2304, "author_place": .*, "persona_email": "lxmspace@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"},/d
g/{"persona_id": 8894, "author_place": .*, "persona_email": "lxmspace@163.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"},/d
g/{"persona_id": 9219, "author_place": .*, "persona_email": "xiaokailiusq@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaokai"},/d


g/{"persona_id": 468, "author_place": .*, "persona_email": "yi.gao@gatech.edu", "author_fullname": "Gao, Yixin", "persona_lastname": "Gao", "persona_firstname": "Yi"},/d


g/{"persona_id": 785, "author_place": .*, "persona_email": "jati.lue@gmail.com", "author_fullname": "Lu, Ying[L|l]i", "persona_lastname": "Lu", "persona_firstname": "Yi"},/d

%s/, "persona_email": null//g
%s/, "persona_lastname": null//g
%s/, "persona_firstname": null//g
%s/, $/,
*/
