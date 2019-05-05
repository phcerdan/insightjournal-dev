select pub.id, meta_title.text_value, COUNT(*)
from isj_publication pub
left join metadatavalue meta_title on pub.itemid = meta_title.item_id and meta_title.metadata_field_id = 64 /* for Title */
group by pub.id, meta_title.text_value
having COUNT(*) > 1
