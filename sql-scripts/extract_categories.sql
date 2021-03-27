select
  json_build_object(
  	  'publication_id', pub.id,
      'categories',
      coalesce(jsonb_agg(distinct ic.description) filter (where ic.description is not null), '[]')
    )
from isj_publication pub
left join isj_publication2category p2c on p2c.publicationid = pub.id
left join ( select id, description, subid from isj_category ic group by id) ic on ic.id = p2c.categoryid
group by pub.id
