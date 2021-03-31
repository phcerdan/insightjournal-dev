/* all issues (collections) with publications */
with pubcol as (
  select
    pub.id,
    pub.itemid,
    it.owning_collection
  from isj_publication pub
  left join collection2item c2i on c2i.item_id = pub.itemid
  left join
    (
     select
       item_id,
       it.owning_collection
     from
       item it
    ) as it on it.item_id = c2i.item_id
)
select
json_build_object(
  'id', cx.collection_id,
  'name', name,
  'short_description', short_description,
  'introductory_text', introductory_text,
  'publications', coalesce(jsonb_agg(pubcol.id order by pubcol.id)
    filter (where pubcol.id is not null), '[]')
)
from collection cx
left join pubcol on cx.collection_id = pubcol.owning_collection
group by cx.collection_id
