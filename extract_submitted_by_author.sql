/* Good example at:
https://stackoverflow.com/questions/42222968/create-nested-json-from-sql-query-postgres-9-4
*/
with submitted_by_author as (
  select
    author_persona.eperson_id,
    author_persona.firstname,
    author_persona.lastname,
    author_persona.email
  from
    eperson author_persona
),
author_user as (
  select
    id,
    json_build_object(
        'author_id',  s.eperson_id,
        'author_firstname', s.firstname,
        'author_lastname', s.lastname,
        'author_fullname', concat(s.lastname,', ', s.firstname),
        'author_email', s.email,
        'author_institution', author_user.institution
    ) submitted_by_author
  from
    isj_user author_user
    left join submitted_by_author s on author_user.erperson_id = s.eperson_id
)
select
json_build_object(
        'publication_id', pub.id,  /* ID */
        'submitted_by_author', submitted_by_author
  )::jsonb
from isj_publication pub
left join author_user au on pub.authorid = au.id
order by pub.id asc
