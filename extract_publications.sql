select
json_build_object(
	'publication_id', pub.id,  /* ID */
	'title', meta_title.text_value,
	'abstract', meta_abstract.text_value,
    'date_submitted', meta_date_submitted.text_value
  )::jsonb
from isj_publication pub
left join metadatavalue meta_title on pub.itemid = meta_title.item_id and meta_title.metadata_field_id = 64 /* for Title */
left join metadatavalue meta_abstract on pub.itemid = meta_abstract.item_id and meta_abstract.metadata_field_id = 27 /* for Abstract */
left join metadatavalue meta_date_submitted on pub.itemid = meta_date_submitted.item_id and meta_date_submitted.metadata_field_id = 15 /* date_sumitted (issued) */
order by pub.id asc
