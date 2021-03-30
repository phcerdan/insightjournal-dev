select
  jsonb_build_object(
    'publication_id', pub.id,
    'issues',
    jsonb_agg( /* aggregate by pub.id */
      cx.collection_id
    )
  )
from isj_publication pub
left join collection2item c2i on pub.itemid = c2i.item_id
  left join
    (
  	  select
  	    collection_id
  	  from
  	    collection cx
    ) as cx on cx.collection_id = c2i.collection_id
group by pub.id
order by pub.id asc
