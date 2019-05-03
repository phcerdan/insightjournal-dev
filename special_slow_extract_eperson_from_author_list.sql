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
  /* Use full lastname and first letter of firstname, Tustiston was the reason for this. Nick, Nicholas A., etc*/
  left join author_persona persona on meta_authors.text_value ilike concat(persona.lastname,',%', left(persona.firstname,1), '%')
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
:%s/, "persona_email": null//
:%s/, "persona_firstname": null//
:%s/, "persona_lastmail": null//
*/
