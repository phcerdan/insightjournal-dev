/* Good example at:
https://stackoverflow.com/questions/42222968/create-nested-json-from-sql-query-postgres-9-4
*/
with com as (
  select
    community_id,
    name,
    json_build_object(
        'journal_id',c.community_id,
        'journal_name', c.name
    )::jsonb com
  from community c
),
com2item as (
  select
    com2item.community_id,
    com2item.item_id,
    jsonb_agg(com) communities
  from com c
  join community2item com2item on com2item.community_id = c.community_id
  group by com2item.community_id, com2item.item_id
)
select
case when com is not null and communities is not null and c2t.community_id != singlecom.community_id then
     json_build_object(
        'publication_id', pub.id,  /* ID */
        'journals', com::jsonb || communities
  )::jsonb
     when com is not null and communities is null then
     json_build_object(
        'publication_id', pub.id,  /* ID */
        'journals', jsonb_build_array(com::jsonb)
  )::jsonb
     when communities is not null then
     json_build_object(
        'publication_id', pub.id,  /* ID */
        'journals', communities
  )::jsonb
     when com is null then
     json_build_object(
        'publication_id', pub.id,  /* ID */
        'journals', communities
  )::jsonb
     end
from isj_publication pub
left join com singlecom on singlecom.community_id = pub.journalid
left join com2item c2t on pub.itemid = c2t.item_id
order by pub.id asc
