select
json_build_object(
    'publication_id', pub.id,  /* ID */
    'comments',
    jsonb_agg( /* aggregate by pub.id */
        json_build_object(
          'date', irc.date,
          'content', irc.comment,
          'persona_id', irc.eperson_id,
          'persona_firstname', ep.firstname,
          'persona_lastname', ep.lastname,
          'persona_email', ep.email
        )
     )
  )::jsonb quick_comments
from isj_publication pub
  left join (   /* Equivalent to: isj_revision_comment irc on irc.publication = pub.id, but allowing group by pub.id only. */
    select
      irc.eperson_id,
      irc.publication,
      irc.comment,
      irc.date
    from isj_revision_comment irc
    group by irc.date, irc.eperson_id, irc.publication, irc.comment
  ) as irc on irc.publication = pub.id
  left join isj_user iu on iu.erperson_id = irc.eperson_id
  left join ( /* Equivalent to eperson ep on ep.eperson_id = iu.erperson_id, but allowing group by pub.id only.*/
    select
      ep.eperson_id,
      ep.firstname,
      ep.lastname,
      ep.email
    from eperson ep
    group by ep.eperson_id, ep.firstname , ep.lastname, ep.email
  ) as ep on ep.eperson_id = iu.erperson_id
where ( not (iu.submissions = 0 and irc.comment like '%http%')  ) /* filter spam: content has links and author 0 submisisons */
group by pub.id
order by pub.id asc
