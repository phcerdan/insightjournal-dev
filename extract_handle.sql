select
json_build_object(
        'publication_id', pub.id,  /* ID */
        'handles', jsonb_agg(json_build_object(
             'handle', h.handle,
             'handle_url', 'http://hdl.handle.net/' || h.handle 
             ))
  )::jsonb
from isj_publication pub
left join handle h on h.resource_id = pub.itemid
group by pub.id
order by pub.id asc
