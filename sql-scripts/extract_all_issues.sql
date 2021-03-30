/* all issues (collections) */
select
json_build_object(
  'id', cx.collection_id,
  'name', name,
  'short_description', short_description,
  'introductory_text', introductory_text
)
from collection cx
order by cx.collection_id asc
