select /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	/* [Tags]. Aka, categories. */
	'tags', tags
  )::jsonb
from isj_publication pub
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
order by pub.id asc
