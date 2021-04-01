select
jsonb_build_object(
 'publication_id', pub.id,
 'reviews', coalesce(jsonb_agg(irjson) filter (where irjson is not null), '[]')
 )
 from isj_publication pub
 left join
 (
   select
   review.publication,
   jsonb_build_object(
   'review_id', review.id,
   'date', review.date,
   'content', review.review,
   'author', jsonb_build_object(
     'author_id', ep.eperson_id,
     'author_firstname', ep.firstname,
     'author_lastname', ep.lastname,
     'author_email', ep.email
     ) 
   ) as irjson
   from isj_review review
   left join isj_user iu on iu.id = review.user_id
   left join (select ep.eperson_id, ep.firstname, ep.lastname, ep.email from eperson ep) ep on ep.eperson_id = iu.erperson_id
   where (review.user_id != 182 /*Insight toolkit kit automated*/
   and review.review is not null)
   group by review.id, review.publication, review.user_id, ep.eperson_id, ep.firstname, ep.lastname, ep.email
 ) ir on ir."publication" = pub.id
 group by pub.id
 order by pub.id asc
