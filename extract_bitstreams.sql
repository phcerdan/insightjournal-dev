with bs as
(
  select bitstream_id
  from bitstream bs
),
it2bitstream as
(
  select
    it2bu.item_id,
    jsonb_agg(bs) bitstreams
  from item2bundle it2bu
  left join bundle2bitstream bu2bit on it2bu.bundle_id = bu2bit.bundle_id
  left join bs on bs.bitstream_id = bu2bit.bitstream_id
  group by it2bu.item_id
)
select json_build_object(
  'publication_id', pub.id,
  'bitstreams', bitstreams
)::jsonb
from isj_publication pub
left join it2bitstream on pub.itemid = item_id

/*

select
  pub.id as pub_id,
  pub.itemid,
  it2bu.bundle_id,
  bs.bitstream_id
from isj_publication pub
left join item2bundle it2bu on pub.itemid = it2bu.item_id
left join bundle2bitstream bu2bit on it2bu.bundle_id = bu2bit.bundle_id
left join bitstream bs on bs.bitstream_id = bu2bit.bitstream_id
order by pub.id, bundle_id, bitstream_id ASC
*/
