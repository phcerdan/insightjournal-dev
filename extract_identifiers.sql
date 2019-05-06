/* WARNING: no-data/all-null, no doi or pubmed are assigned to publications */
select distinct on (pub.id) /* remove duplicates on pub.id */
json_build_object(
	'publication_id', pub.id,  /* ID */
	'identifiers', json_build_object(
            'doi', meta_doi.text_value,
            'pubmed', meta_pubmed.text_value
    )::jsonb
  )::jsonb
from isj_publication pub
left join metadatavalue meta_doi on pub.itemid = meta_doi.item_id and meta_doi.metadata_field_id = 74 /* for Doi */
left join metadatavalue meta_pubmed on pub.itemid = meta_pubmed.item_id and meta_pubmed.metadata_field_id = 75 /* for pubmed */
