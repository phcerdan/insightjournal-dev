select
  jsonb_build_object(
    'publication_id', pub.id,
    'license',
'You are licensing your work to Kitware Inc. under the
Creative Commons Attribution License Version 3.0.

Kitware Inc. agrees to the following:

Kitware is free
    * to copy, distribute, display, and perform the work
    * to make derivative works
    * to make commercial use of the work

Under the following conditions:
\"by Attribution\" - Kitware must attribute the work in the manner specified by the author or licensor.

    * For any reuse or distribution, they must make clear to others the license terms of this work.
    * Any of these conditions can be waived if they get permission from the copyright holder.

Your fair use and other rights are in no way affected by the above.

This is a human-readable summary of the Legal Code (the full license) available at
http://creativecommons.org/licenses/by/3.0/legalcode'
  )
from isj_publication pub
group by pub.id
order by pub.id asc
