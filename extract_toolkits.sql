/* OUTDATED, use extract_journals.sql instead */
/* Good example at:
https://stackoverflow.com/questions/42222968/create-nested-json-from-sql-query-postgres-9-4
*/
with toolkit as (
  select
    id,
    name,
    description,
    json_build_object(
        'toolkit_id',t.id,
        'toolkit_name', t.name,
        'toolkit_namelong', t.description
    ) toolkit
  from
    isj_toolkit t
),
pub2tool as (
  select
    publicationid,
    json_agg(toolkit) toolkits
  from
    isj_publication2toolkit pub2tool
    left join toolkit t on pub2tool.toolkitid = t.id
  group by publicationid
)
select
json_build_object(
        'publication_id', pub.id,  /* ID */
        'toolkits', toolkits
  )::jsonb
from isj_publication pub
left join pub2tool p2t on pub.id = p2t.publicationid
order by pub.id asc
