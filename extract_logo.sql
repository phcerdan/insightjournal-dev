copy (
  select
    pub.logo
  from isj_publication pub
  limit 10
)
to stdout binary
