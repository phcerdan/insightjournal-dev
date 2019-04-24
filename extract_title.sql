select distinct on (pub.id) /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	'title', meta_title.text_value
  )::jsonb
from isj_publication pub
left join metadatavalue meta_title on pub.itemid = meta_title.item_id and meta_title.metadata_field_id = 64 /* for Title */
