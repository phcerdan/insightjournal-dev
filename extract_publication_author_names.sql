/* OUTDATED use special_slow_extract_eperson_from_author_list.sql instead */
select distinct on (pub.id) /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	/* [Authors] */
	'authors', authors
  )::jsonb
from isj_publication pub
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
