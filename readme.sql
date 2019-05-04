/* NOTE: dbeaver is great to interact with the database (pgadmin4 seems buggy) */
/* IMPORT dump database (midasjournal):
createuser --interactive midas
psql -U midas -a -f ~/Data/MidasJournal/midasjournal_2017-09-08.Friday.sql
*/
/* COPY DATABASES:
createdb -O midas -T midasjournal insightjournal
*/
/*-------CLEAN insightjournal------*/
/* eperson */
/* KEEP
 eperson_id
 email
 firstname
 lastname
 */
ALTER TABLE eperson
DROP COLUMN IF EXISTS netid,
DROP COLUMN IF EXISTS phone,
DROP COLUMN IF EXISTS sub_frequency,
DROP COLUMN IF EXISTS last_active,
DROP COLUMN IF EXISTS self_registered,
DROP COLUMN IF EXISTS require_certificate,
DROP COLUMN IF EXISTS can_log_in,
DROP COLUMN IF EXISTS password;

Cleaning:
TODO: Clean, Patrick Reynolds, and Liu, Xiaoxiao
{"authors": [
{"persona_id": 652, "author_place": 4, "persona_email": "patrick.reynolds@kitware.com", "author_fullname": "Reynolds, Patrick", "persona_lastname": "Reynolds", "persona_firstname": "Patrick"}, 
{"persona_id": 6056, "author_place": 4, "persona_email": "cpreynolds@gmail.com", "author_fullname": "Reynolds, Patrick", "persona_lastname": "Reynolds", "persona_firstname": "Patrick"}, 
{"persona_id": 2509, "author_place": 5, "persona_email": "matthew.m.mccormick@gmail.com", "author_fullname": "McCormick, Matthew", "persona_lastname": "Mccormick", "persona_firstname": "Matthew"}, 
{"persona_id": null, "author_place": 6, "persona_email": null, "author_fullname": "Turner, Wes", "persona_lastname": null, "persona_firstname": null}, 
{"persona_id": null, "author_place": 7, "persona_email": null, "author_fullname": "Ibáñez, Luis", "persona_lastname": null, "persona_firstname": null}, 
{"persona_id": 959, "author_place": 1, "persona_email": "sharonxx@cs.unc.edu", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoxiao"}, 
{"persona_id": 2304, "author_place": 1, "persona_email": "lxmspace@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"}, 
{"persona_id": 3102, "author_place": 1, "persona_email": "xiaoxiao.liu@kitware.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoxiao"}, 
{"persona_id": 8894, "author_place": 1, "persona_email": "lxmspace@163.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"}, 
{"persona_id": 9219, "author_place": 1, "persona_email": "xiaokailiusq@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaokai"}, 
{"persona_id": null, "author_place": 2, "persona_email": null, "author_fullname": "Helba, Brian", "persona_lastname": null, "persona_firstname": null}, 
{"persona_id": 132, "author_place": 3, "persona_email": "karthik.krshnan@gmail.com", "author_fullname": "Krishnan, Karthik", "persona_lastname": "Krishnan", "persona_firstname": "Karthik"}, 
{"persona_id": null, "author_place": 8, "persona_email": null, "author_fullname": "Yankelevitz, David", "persona_lastname": null, "persona_firstname": null}, 
{"persona_id": 214, "author_place": 9, "persona_email": "rick.avila@kitware.com", "author_fullname": "Avila, Rick", "persona_lastname": "Avila", "persona_firstname": "Rick"}], "publication_id": 869},


Change name from François to Francois in publication=985
pub_id=985, item_id=5363
metadatavalue_id= 171694
text_value=Budin, François <-- Change this to Francois
----- SCRIPT ----
update metadatavalue set text_value='Budin, Francois' where metadata_value_id=171694
----------------
Change name of Villéger, Alice in publication=98  (remove tilde)
Change name of Flouvat, Frederic in publication=98  (remove tilde, for consistencty)
to match eperson: 450: Villeger, Alice
isj_user=421
item_id=508
metadatavalue_id=35392
----- SCRIPT ----
update metadatavalue set text_value='Villeger, Alice' where metadata_value_id=35392;
update metadatavalue set text_value='Flouvat, Frederic' where metadata_value_id=35393;
--
-- Remove tilde in publication: 105 item_id=495
update metadatavalue set text_value='Chettaoui, Hanene' where metadata_value_id=24849;
-----
-- Remove tilde in publication: 176, item_id=1343
update metadatavalue set text_value='Lehmann, Gaetan' where metadata_value_id=68500;
--
-- Remove tilde in publication: 179, item_id=1933
update metadatavalue set text_value='Macia, Ivan' where metadata_value_id=68283;
--
-- Fix names of eperson: 9445 (Senra Filho), da Silva belongs to the name, not a last name
update eperson set firstname='Antonio Carlos da Silva', lastname='Senra Filho' where eperson_id=9445;
-- Switch lastname, firstname in pub_id=551, item_id=4454
update metadatavalue set text_value='Qizhen, He' where metadata_value_id=153390;
update metadatavalue set text_value='Horace, Ip' where metadata_value_id=153391;
update metadatavalue set text_value='Xia, James' where metadata_value_id=153392;
--
Add - in author first name of publication 21:
item_id=36
----- SCRIPT ----
update metadatavalue set text_value='Kim, Hee-Su' where metadata_value_id=1929
----------------
-- Update name of Tustison epersona, from Nick to Nicholas J.
-- pub_id=57, item_id=225
update eperson set firstname='Nicholas J.' where eperson_id=8833;
-- Update name from Jim to James
update eperson set firstname='James' where eperson_id=232;
-- Update Tustison name from Nick To Nicholas J.
-- pub_id=681, item_id=4685
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=160648;
-- pub_id=841, item_id=5053
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=166004;
-- pub_id=849, item_id=5063
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=166134;
-- pub_id=979, item_id=5342
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=171473;
-- pub_id=982, item_id=5356
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=171535;
---------------
Change first name of eperson: 706
{"persona_id": 706, "author_place": 1, "persona_email": "piekot@rpi.edu", "author_fullname": "Piekos, Thomas", "persona_lastname": "Piekos", "persona_firstname": "Tom"}], "publication_id": 193},
-- SCRIPT --
update eperson set firstname='Thomas' where eperson_id=706;
--
Fix switched firstname, lastname in all names of publication_id=110
item_id=574
from: 'Andinet, Enquobahrie' to 'Enquobahrie, Andinet' publication_id=110
-- SCRIPT --
update metadatavalue set text_value='Cheng, Peng' where metadata_value_id=31674;
update metadatavalue set text_value='Enquobahrie, Andinet' where metadata_value_id=31675;
update metadatavalue set text_value='Stenzel, Roland' where metadata_value_id=31676;
update metadatavalue set text_value='Lin, Ralph' where metadata_value_id=31677;
update metadatavalue set text_value='Zhang, Hui' where metadata_value_id=31678;
update metadatavalue set text_value='Yaniv, Ziv' where metadata_value_id=31679;
update metadatavalue set text_value='Kim, Hee-su' where metadata_value_id=31680;
update metadatavalue set text_value='Cleary, Kevin' where metadata_value_id=31681;
-------
Fix switched firstname, lastname in all names of publication_id=81
item_id=372
update metadatavalue set text_value='Zhu, Wanlin' where metadata_value_id=21679;
-----
Remove lastname in CAPS in publication_id=158
item_id=1221
-- SCRIPT --
update metadatavalue set text_value='Wang, Defeng' where metadata_value_id=71270;
update metadatavalue set text_value='Shi, Lin' where metadata_value_id=71271;
update metadatavalue set text_value='Heng, Pheng Ann' where metadata_value_id=71272;
--
Strip whitespace of firstname of eperson=1044
{"persona_id": 1044, "author_place": 3, "persona_email": "mhg@unizar.es", "author_fullname": "Hernandez, Monica", "persona_lastname": "Hernandez", "persona_firstname": "Monica "},
update eperson set firstname='Monica' where eperson_id=1044;
--
Switch firstname, lastname of publication_id=579
item_id=4501
-- SCRIPT --
update metadatavalue set text_value='Taieb, Yoav' where metadata_value_id=155181;
update metadatavalue set text_value='Eliassaf, Ofer' where metadata_value_id=155182;
update metadatavalue set text_value='Freiman, Moti' where metadata_value_id=155183;
update metadatavalue set text_value='Joskowicz, Leo' where metadata_value_id=155184;
update metadatavalue set text_value='Sosna, Jacob' where metadata_value_id=155185;
--
Change lastname of eperson=9689
lastname = 'Hernandez-Cerdan'
----- SCRIPT ----
update eperson set lastname='Hernandez-Cerdan' where eperson_id=9689
-----------------

Delete duplicate users (with no submissions, keep those with submissions):
------------------------
Budin, Francois (2x)
Keep: 2586 isj_user=3269, submissions=1
Delete: 9855, isj_user=17605
---
Aylward, Stephen (3x)
eperson_ids: 186 887 1
Keep: 1, isj_user=3, submissions=8, reviews=11
Delete: 887, isj_user=795
Delete: 186, isj_user=881
---
Jomier, Julien (4x) (one of them (id=2) is the dashboard)
eperson_ids: 2 3 525 3318
WARNING: eperson_id = 2 is the dashboard, with 0 submissions and 431 reviews.
Keep: 2, isj_user=182, reviews=443 (DASHBOARD)
Keep: 3, isj_user=4, submissions=4, reviews=9
Delete: 525, isj_user=925
Delete: 3318, isj_user=4707
----- SCRIPT ----
update eperson set firstname='Dashboard', lastname='Dashboard'
where eperson_id=2
-----------------
---
Boettger, Thomas (3x)
eperson_ids: 117 252 2534
Keep: 117, isj_user=118, reviews=1
Delete: 252, isj_user=225
Delete: 2534, isj_user=3165
---
Mosaliganti, Kishore (2x) (Both with sumissions!) Merge
eperson_ids: 49 981
Keep: 49, isj_user=51, submissions=2
Keep: 981, isj_user=1022, submissions=4, reviews=1
Merge:
Keep 981 with mail: kishoreraom@gmail.com, the other mail in 49 is utah university
You will have to replace the authorid in the publications:
pub_ids associated to author_id=49, pub_ids: 19, 39
replace authorid:51 for 1022

----- SCRIPT for merge ---
update isj_publication set authorid=1022 where authorid=51;
update isj_user set submissions=6 where id=1022 and submissions=4;
/* where erperson_id=981 and submissions=4 */
delete from eperson where eperson_id=49;
update isj_revision_comment set eperson_id=981 where eperson_id=49;
------------------------
Henderson, Thomas (x2)
eperson_ids: 77, 3254
Keep: 77, isj_user=78 (submissions:1)
Delete: 3254, isj_user=4581
{"authors": [{"persona_id": 77, "author_fullname": "Henderson, Thomas", "author_place": 1, "persona_email": "tch@cs.utah.edu", "persona_lastname": "Henderson", "persona_firstname": "Thomas"},
 {"persona_id": 3254, "author_fullname": "Henderson, Thomas", "author_place": 1, "persona_email": "tbainh@abaxinfo.com", "persona_lastname": "Henderson", "persona_firstname": "Thom"},
update isj_revision_comment set eperson_id=77 where eperson_id=3254;
----------------------
Awate, Suyash (x2)
eperson_ids: 234, 1053
Keep 234, isj_user=218
Delete 1053
ODD?: 1053 has no isj_user, how was the eperson generated then?
 {"persona_id": 234, "author_name": "Awate, Suyash", "author_place": 2, "persona_email": "suyash@cs.utah.edu", "persona_lastname": "Awate", "persona_firstname": "Suyash"},
 {"persona_id": 1053, "author_name": "Awate, Suyash", "author_place": 2, "persona_email": "awate@mail.med.upenn.edu", "persona_lastname": "Awate", "persona_firstname": "Suyash"},
update isj_revision_comment set eperson_id=234 where eperson_id=1053;
----------------------
Warfield, Simon (x2)
eperson_ids: 119, 514
Keep 514, isj_user=481 submissions=1, reviews=9
Delete 119, isj_user=120, submissions=0
 {"persona_id": 119, "author_name": "Warfield, Simon", "author_place": 4, "persona_email": "warfield@bwh.harvard.edu", "persona_lastname": "Warfield", "persona_firstname": "Simon"},
 {"persona_id": 514, "author_name": "Warfield, Simon", "author_place": 4, "persona_email": "simon.warfield@childrens.harvard.edu", "persona_lastname": "Warfield", "persona_firstname": "Simon"}], "publication_id": 29},
-----------------------
Wang, David (x2)
epersons_ids: 48, 104
Keep 104, isj_user=105, submissions=2
Delete 48, isj_user=50, sumissions =0
{"authors": [{"persona_id": 48, "author_name": "Wang, David", "author_place": 1, "persona_email": "dw31@cornell.edu", "persona_lastname": "Wang", "persona_firstname": "David"},
 {"persona_id": 104, "author_name": "Wang, David", "author_place": 1, "persona_email": "david@wangmd.com", "persona_lastname": "Wang", "persona_firstname": "David"},
update isj_revision_comment set eperson_id=104 where eperson_id=48;
--------------------------
Machiraju, Raghu (x2)
eperson_ids: 195, 595
Keep 595, isj_user=943, submissions=0, (keep because email:gmail instead of uni.edu)
Delete 195, isj_user=181, submissions=0
 {"persona_id": 195, "author_name": "Machiraju, Raghu", "author_place": 4, "persona_email": "raghu@cse.ohio-state.edu", "persona_lastname": "Machiraju", "persona_firstname": "Raghu"},
 {"persona_id": 595, "author_name": "Machiraju, Raghu", "author_place": 4, "persona_email": "raghu.machiraju@gmail.com", "persona_lastname": "machiraju", "persona_firstname": "raghu"},
---------------------------
Lloyd, Bryn A. (x2)
eperson_ids: 23, 2553
Keep 23, isj_user: 25, submissions=3, reviews=1
Keep 2553, isj_user:3203, submissions=1
Delete 2553 after merge
{"authors": [{"persona_id": 23, "author_name": "Lloyd, Bryn A.", "author_place": 1, "persona_email": "blloyd@ee.ethz.ch", "persona_lastname": "Lloyd", "persona_firstname": "Bryn"},
 {"persona_id": 2553, "author_name": "Lloyd, Bryn A.", "author_place": 1, "persona_email": "blloyd@vision.ee.ethz.ch", "persona_lastname": "Lloyd", "persona_firstname": "Bryn"},
----- SCRIPT for merge ---
update isj_publication set authorid=25 where authorid=3203;
update isj_user set submissions=4 where id=25 and submissions=3;
/* where erperson_id=981 and submissions=4 */
delete from resourcepolicy where eperson_id=2553;
delete from eperson where eperson_id=2553;
update isj_revision_comment set eperson_id=23 where eperson_id=2553;
---------------
Staring, Marius (x2)
eperson_ids: 208, 9312
Keep 208, isj_user=191, submissions=8
Delete 9312, isj_user=16527
{"authors": [{"persona_id": 208, "author_name": "Staring, Marius", "author_place": 1, "persona_email": "m.staring@lumc.nl", "persona_lastname": "Staring", "persona_firstname": "Marius"},
 {"persona_id": 9312, "author_name": "Staring, Marius", "author_place": 1, "persona_email": "marius.staring@gmail.com", "persona_lastname": "Staring", "persona_firstname": "Marius"},
Update the email before deletion
------------
delete from eperson where eperson_id=9312;
update eperson set email='marius.staring@gmail.com' where eperson_id=208
------------
Krishnan, Karthik (x4)
eperson_ids: 132, 1043, 1052, 9792
Keep 132, isj_user=133, submissions=1
Delete 1043, isj_user=1142
Delete 1052, isj_user=1158
Delete 9792, isj_user=17481
 {"persona_id": 1043, "author_name": "Krishnan, Karthik", "author_place": 2, "persona_email": "karthik.krishan@kitware.com", "persona_lastname": "Krishnan", "persona_firstname": "Karthik"},
 {"persona_id": 1052, "author_name": "Krishnan, Karthik", "author_place": 2, "persona_email": "karthik.krishnan@kitware.com", "persona_lastname": "Krishnan", "persona_firstname": "Karthik"},
 {"persona_id": 132, "author_name": "Krishnan, Karthik", "author_place": 2, "persona_email": "Karthik.Krishnan@kitware.com", "persona_lastname": "Krishnan", "persona_firstname": "Karthik"},
 {"persona_id": 9792, "author_name": "Krishnan, Karthik", "author_place": 2, "persona_email": "karthik.krshnan@gmail.com", "persona_lastname": "Krishnan", "persona_firstname": "Karthik"},
----SCRIPT---
update isj_revision_comment set eperson_id=132 where eperson_id=1043;
update isj_revision_comment set eperson_id=132 where eperson_id=1052;
update isj_revision_comment set eperson_id=132 where eperson_id=9792;
update isj_review set user_id=133 where user_id=1142;
update isj_review set user_id=133 where user_id=1158;
update isj_review set user_id=133 where user_id=17481;
delete from resourcepolicy where eperson_id in(1043, 1052, 9792);
delete from eperson where eperson_id in(1043, 1052, 9792);
update eperson set email='karthik.krshnan@gmail.com' where eperson_id=132;
------------
Lorensen, Bill (x2)
eperson_ids: 17, 2746
Keep 17, isj_user=19, submissions=0, reviews=2
Keep 2746, isj_user=3583, submissions=0, reviews=3

After merge, remove 17, and keep 2746
Delete 17
 {"persona_id": 17, "author_name": "Lorensen, Bill", "author_place": 5, "persona_email": "lorensen@crd.ge.com", "persona_lastname": "Lorensen", "persona_firstname": "Bill"},
 {"persona_id": 2746, "author_name": "Lorensen, Bill", "author_place": 5, "persona_email": "bill.lorensen@gmail.com", "persona_lastname": "Lorensen", "persona_firstname": "Bill"},

----- SCRIPT ---------
update isj_user set reviews=5 where id=3583 and reviews=3;
update isj_revision_comment set eperson_id=2746 where eperson_id=17;
delete from eperson where eperson_id = 17;
----------------------
-------------------------------------
Okuda, Hirohito (x2) : Update (x3)
eperson_ids: 307, 1094, 485
Delete 307, isj_user=281
Keep 1094, isj_user=1238, revisions=0, reviews=0 (just because the email)
Delete 485, isj_user=456, submissions=0, reviews=0 (errata in first name)
 {"persona_id": 307, "author_name": "Okuda, Hirohito", "author_place": 5, "persona_email": "okdhrht@aol.com", "persona_lastname": "Okuda", "persona_firstname": "Hirohito"},
 {"persona_id": 1094, "author_name": "Okuda, Hirohito", "author_place": 5, "persona_email": "hirohito.okuda@ge.com", "persona_lastname": "Okuda", "persona_firstname": "Hirohito"},
FIRST NAME HAS AN ERROR!
{"persona_id": 485, "author_place": 5, "persona_email": "hirohito.okuda@yale.edu", "author_fullname": "Okuda, Hirohito", "persona_lastname": "Okuda", "persona_firstname": "Hirohiro"}, 
----- SCRIPT ---------
update isj_revision_comment set eperson_id=1094 where eperson_id=307;
delete from eperson where eperson_id = 307;
update isj_revision_comment set eperson_id=1094 where eperson_id=485;
delete from eperson where eperson_id = 485;
----------------------
---------------------------------------------
Daenzer, Stefan (x2)
eperson_ids: 444, 2555
Keep 444, isj_user=413, submissions=1 BUT CHANGE EMAIL
Delete 2555, isj_user=3207, submissions=0
{"authors": [{"persona_id": 444, "author_name": "Daenzer, Stefan", "author_place": 1, "persona_email": "stefan.daenzer@stanford.edu", "persona_lastname": "Daenzer", "persona_firstname": "Stefan"},
 {"persona_id": 2555, "author_name": "Daenzer, Stefan", "author_place": 1, "persona_email": "stefan.daenzer@gmail.com", "persona_lastname": "Daenzer", "persona_firstname": "Stefan"},
----- SCRIPT ---------
/*update isj_revision_comment set eperson_id=444 where eperson_id=2555;*/
delete from eperson where eperson_id = 2555;
update eperson set email='stefan.daenzer@gmail.com' where eperson_id=444;
----------------------
---------------------------------------------
Styner, Martin (x2)
eperson_ids: 28, 273
Keep 28, isj_user=30, submissions=1, reviews=10 but CHANGE MAIL
Delete 273 isj_user=246
{"authors": [{"persona_id": 28, "author_name": "Styner, Martin", "author_place": 1, "persona_email": "martin_styner@ieee.org", "persona_lastname": "Styner", "persona_firstname": "Martin"},
 {"persona_id": 273, "author_name": "Styner, Martin", "author_place": 1, "persona_email": "styner@cs.unc.edu", "persona_lastname": "Styner", "persona_firstname": "Martin"},
----- SCRIPT ---------
-- update isj_revision_comment set eperson_id=28 where eperson_id=273;
delete from eperson where eperson_id = 273;
update eperson set email='styner@cs.unc.edu' where eperson_id=28;
----------------------
---------------------------------------------
Avants, Brian (x2)
eperson_ids: 11, 2243
Delete 11, isj_user=13
Keep 2243, isj_user=2589, submissions=1
 {"persona_id": 11, "author_name": "Avants, Brian", "author_place": 2, "persona_email": "avants@seas.upenn.edu", "persona_lastname": "Avants", "persona_firstname": "Brian"},
 {"persona_id": 2243, "author_name": "Avants, Brian", "author_place": 2, "persona_email": "stnava@gmail.com", "persona_lastname": "Avants", "persona_firstname": "Brian"},
----- SCRIPT ---------
-- update isj_revision_comment set eperson_id=2243 where eperson_id=11;
delete from eperson where eperson_id = 11;
----------------------
---------------------------------------------
Zwettler, Gerald (x2)
eperson_ids: 645, 742
Keep 645, isj_user=577, submissions=0, reviews=0
Delete 742, isj_user=661
 {"persona_id": 645, "author_name": "Zwettler, Gerald", "author_place": 2, "persona_email": "gerald.zwettler@fh-hagenberg.at", "persona_lastname": "Zwettler", "persona_firstname": "Gerald"},
 {"persona_id": 742, "author_name": "Zwettler, Gerald", "author_place": 2, "persona_email": "mse07033@fh-hagenberg.at", "persona_lastname": "Zwettler", "persona_firstname": "Gerald"},
----- SCRIPT ---------
-- update isj_revision_comment set eperson_id=2243 where eperson_id=11;
delete from eperson where eperson_id = 742;
----------------------
---------------------------------------------
Backfrieder, Werner (x2)
eperson_ids: 759, 2444
Delete 759, isj_user=677, submissions=0, reviews=0
Keep 2444, isj_user=2985, submissions=0, reviews=0 (because newer)
 {"persona_id": 759, "author_name": "Backfrieder, Werner", "author_place": 4, "persona_email": "werner.backfrieder@fh-hagenberg.at", "persona_lastname": "Backfrieder", "persona_firstname": "Werner"},
 {"persona_id": 2444, "author_name": "Backfrieder, Werner", "author_place": 4, "persona_email": "Werner.Backfrieder@fh-hagenberg.at", "persona_lastname": "Backfrieder", "persona_firstname": "Werner"}], "publication_id": 209},
----- SCRIPT ---------
delete from eperson where eperson_id = 759;
----------------------
---------------------------------------------
Pathak, Sayan (x2)
eperson_ids: 499, 86
Delete 499, isj_user=869 submissions=0, reviews=0, (WRONG MAIL)
Keep 86, isj_user=87, submissions=1

 {"persona_id": 499, "author_name": "Pathak, Sayan", "author_place": 8, "persona_email": "sayanp@alleninstitute,org", "persona_lastname": "Pathak", "persona_firstname": "Sayan"},
 {"persona_id": 86, "author_name": "Pathak, Sayan", "author_place": 8, "persona_email": "sayanp@alleninstitute.org", "persona_lastname": "Pathak", "persona_firstname": "Sayan"}], "publication_id": 211},
----- SCRIPT ---------
delete from eperson where eperson_id = 499;
----------------------
---------------------------------------------
Gelas, Arnaud (x2)
eperson_ids: 947, 7896
Keep 947, isj_user=854, submissions=4, reviews=1
Keep 7896, isj_user=13778, submissions=1
Merge and keep latest:7896
Delete 947
{"authors": [{"persona_id": 947, "author_name": "Gelas, Arnaud", "author_place": 1, "persona_email": "arnaud_gelas@hms.harvard.edu", "persona_lastname": "Gelas", "persona_firstname": "Arnaud"},
 {"persona_id": 7896, "author_name": "Gelas, Arnaud", "author_place": 1, "persona_email": "arnaudgelas@gmail.com", "persona_lastname": "Gelas", "persona_firstname": "Arnaud"},

----- SCRIPT ---------
update isj_revision_comment set eperson_id=7896 where eperson_id=947;
update isj_user set reviews=1 where id=13778 and reviews=0;
update isj_user set submissions=5 where id=13778 and submissions=1;
update isj_review set user_id=13778 where user_id=854;
delete from eperson where eperson_id = 947;
----------------------
---------------------------------------------
Zhang, Hui (x2)
eperson_ids: 94, 313
Delete 94, isj_user=95, submissions=0, reviews=0
Keep 313, isj_user=287, submissions=0, reviews=0 (Keep because modern)
 {"persona_id": 94, "author_name": "Zhang, Hui", "author_place": 2, "persona_email": "huiz@gradient.cis.upenn.edu", "persona_lastname": "Zhang", "persona_firstname": "Hui"},
 {"persona_id": 313, "author_name": "Zhang, Hui", "author_place": 2, "persona_email": "zhang@isis.imac.georgetown.edu", "persona_lastname": "Zhang", "persona_firstname": "Hui"},
----- SCRIPT ---------
-- update isj_user set reviews=1 where id=287 and reviews=0;
-- update isj_user set submissions=5 where id=287 and submissions=1;
-- update isj_revision_comment set eperson_id=313 where eperson_id=94;
-- update isj_review set user_id=287 where user_id=95;
delete from eperson where eperson_id = 94;
/* delete from isj_user where id=95 */
----------------------
---------------------------------------------
Kahn, Eliezer (x3)
eperson_ids: 325, 779, 941
Delete 325, isj_user=299 (0,0)
Keep 779, isj_user=697 submissions=1, reviews=0
Delete 941, isj_user=848, submissions=0, reviews=0
{"authors": [{"persona_id": 325, "author_name": "Kahn, Eliezer", "author_place": 1, "persona_email": "eliezer.kahn@yale.edu", "persona_lastname": "Kahn", "persona_firstname": "Eli"},
 {"persona_id": 779, "author_name": "Kahn, Eliezer", "author_place": 1, "persona_email": "eliezer.kahn@jhuapl.edu", "persona_lastname": "Kahn", "persona_firstname": "Eli"},
 {"persona_id": 941, "author_name": "Kahn, Eliezer", "author_place": 1, "persona_email": "eliezer.kahn@jhuapl.com", "persona_lastname": "Kahn", "persona_firstname": "Eliezer"},
----- SCRIPT ---------
-- update isj_revision_comment set eperson_id=779 where eperson_id=325;
-- update isj_review set user_id=697 where user_id=299;
delete from eperson where eperson_id = 325;
-- update isj_revision_comment set eperson_id=779 where eperson_id=941;
-- update isj_review set user_id=697 where user_id=848;
delete from eperson where eperson_id = 941;
/* delete from isj_user where id=299 */
----------------------
-- Tustison, Nicholas (Nick, Nicholas J.)
erperson_id: 105, 8833
Both with submissions
Keep 105, isj_user=106, submissions=21, reviews=4
Keep 8833, isj_user=15570, submissions=2, reviews=0
Merge both and keep 8833
Delete 105
{"persona_id": 105, "author_place": 1, "persona_email": "ntustison@wustl.edu", "author_fullname": "Tustison, Nicholas J.", "persona_lastname": "Tustison", "persona_firstname": "Nick"},
{"persona_id": 8833, "author_place": 1, "persona_email": "ntustison@gmail.com", "author_fullname": "Tustison, Nicholas J.", "persona_lastname": "Tustison", "persona_firstname": "Nick"},
--SCRIPT--
update isj_revision_comment set eperson_id=8833 where eperson_id=105;
update isj_publication set authorid=15570 where authorid=106;
update isj_user set submissions=23, reviews=4 where id=15570 and submissions=2;
delete from resourcepolicy where eperson_id=105;
delete from eperson where eperson_id=105;
-- delete from isj_user where id=106;

-- Bilgin, Cemal Cagatay (x2)
eperson_ids: 717, 6593
Delete 717, isj_user=641, submissions=1, reviews=0
Keep 6593, isj_user=11206 (because mail)

{"persona_id": 717, "author_place": 1, "persona_email": "bilgic@rpi.edu", "author_fullname": "Bilgin, Cemal Cagatay", "persona_lastname": "Bilgin", "persona_firstname": "Cagatay"}, 
{"persona_id": 6593, "author_place": 1, "persona_email": "bilgincc@gmail.com", "author_fullname": "Bilgin, Cemal Cagatay", "persona_lastname": "Bilgin", "persona_firstname": "C.cagatay"}], "publication_id": 198},

-- SCRIPT --
update isj_revision_comment set eperson_id=6593 where eperson_id=717;
update eperson set firstname='Cemal Cagatay' where eperson_id=6593;
update isj_publication set authorid=11206 where authorid=641;
delete from eperson where eperson_id=717;
-- delete from isj_user where erperson_id=717;

-- Blezek, Daniel (x4)
eperson_ids: 15, 139, 786, 1018
Keep 1018, isj_user=1096, submissions=2, reviews=0
Merge 15, isj_user=17, reviews=1
Merge 786, isj_user=702, reviews=2
Delete 139, isj_user=140

{"persona_id": 139, "author_place": 1, "persona_email": "blezek@crd.ge.com", "author_fullname": "Blezek, Daniel", "persona_lastname": "Blezek", "persona_firstname": "Daniel"},
{"persona_id": 15, "author_place": 1, "persona_email": "blezek@research.ge.com", "author_fullname": "Blezek, Daniel", "persona_lastname": "Blezek", "persona_firstname": "Daniel"},
{"persona_id": 786, "author_place": 1, "persona_email": "blezek.daniel@mayo.edu", "author_fullname": "Blezek, Daniel", "persona_lastname": "Blezek", "persona_firstname": "Daniel"},
{"persona_id": 1018, "author_place": 1, "persona_email": "daniel.blezek@gmail.com", "author_fullname": "Blezek, Daniel", "persona_lastname": "Blezek", "persona_firstname": "Daniel"}
"publication_id": 307},

-- SCRIPT --
update isj_revision_comment set eperson_id=1018 where eperson_id=15;
update isj_revision_comment set eperson_id=1018 where eperson_id=786;
update isj_revision_comment set eperson_id=1018 where eperson_id=139;
update isj_review set user_id=1096 where user_id=17;
update isj_review set user_id=1096 where user_id=702;
update isj_review set user_id=1096 where user_id=140;
delete from eperson where eperson_id=15;
delete from eperson where eperson_id=786;
delete from eperson where eperson_id=139;
--

Plumat, Jerome (x2)
eperson_ids: 1017, 9578
Keep 1017, isj_user=1094, sumissions=1, changing email
Delete 9578, isj_user=17057, submissions=0, but change email from eperson and institution from user
{"persona_id": 1017, "author_place": 1, "persona_email": "jerome.plumat@uclouvain.be", "author_fullname": "Plumat, Jerome", "persona_lastname": "Plumat", "persona_firstname": "Jerome"}, 
{"persona_id": 9578, "author_place": 1, "persona_email": "j.plumat@gmail.com", "author_fullname": "Plumat, Jerome", "persona_lastname": "Plumat", "persona_firstname": "Jerome"}, 
-- SCRIPT -
update isj_user set institution='University of Auckland' where id=1094;
delete from eperson where eperson_id=9578;
update eperson set email='j.plumat@gmail.com' where eperson_id=1017;
--
Becciu, Alessandro (x2)
eperson_ids: 840, 839
Keep 840, isj_user= submissions=0!! (even though there is one for sure 558)
Delete 839
{"persona_id": 840, "author_place": 1, "persona_email": "a.becciu@tue.nl", "author_fullname": "Becciu, Alessandro", "persona_lastname": "Becciu", "persona_firstname": "Alessandro"}, 
{"persona_id": 839, "author_place": 1, "persona_email": "abecciu@tue.nl", "author_fullname": "Becciu, Alessandro", "persona_lastname": "Becciu", "persona_firstname": "Alessandro"}, pub_id=558
--SCRIPT--
delete from eperson where eperson_id=839
--
Hammer, Peter(x2)
Delete 812, isj_user=720 
Keep 851, isj_user=758 (there is one submission for sure)
{"persona_id": 812, "author_place": 1, "persona_email": "peter.hammer@tufts.edu", "author_fullname": "Hammer, Peter", "persona_lastname": "Hammer", "persona_firstname": "Peter"}, 
{"persona_id": 851, "author_place": 1, "persona_email": "peter.hammer@childrens.harvard.edu", "author_fullname": "Hammer, Peter", "persona_lastname": "Hammer", "persona_firstname": "Peter"}, pub_id=546
--SCRIPT--
delete from eperson where eperson_id=812
--
Orkisz, Maciej (x2)
Keep 879, isj_user=786, but change email
Delete 2226, isj_user=2555
{"persona_id": 879, "author_place": 7, "persona_email": "maciej.orkisz@creatis.insa-lyon.fr", "author_fullname": "Orkisz, Maciej", "persona_lastname": "Orkisz", "persona_firstname": "Maciej"}, 
{"persona_id": 2226, "author_place": 7, "persona_email": "maciejorkisz@gmail.com", "author_fullname": "Orkisz, Maciej", "persona_lastname": "Orkisz", "persona_firstname": "Maciej"}], "publication_id": 575},
--SCRIPT--
delete from eperson where eperson_id=2226;
update eperson set email='maciejorkisz@gmail.com' where eperson_id=879;
--
Liu, Yixun(x2)
eperson_ids: 474, 6473
Delete 474, isj_user=445
Keep 6473, isj_user=10966
{"persona_id": 474, "author_place": 1, "persona_email": "yxliu@fudan.edu.cn", "author_fullname": "Liu, Yixun", "persona_lastname": "Liu", "persona_firstname": "Yixun"}, 
{"persona_id": 6473, "author_place": 1, "persona_email": "yxliuwm@gmail.com", "author_fullname": "Liu, Yixun", "persona_lastname": "Liu", "persona_firstname": "Yixun"}, 
--SCRIPT--
delete from eperson where eperson_id=474;
--

---------------------------------------------

PROBLEMs to solve:
1: TODO
{"authors": [{"persona_id": 150, "author_name": "Williams, Kent\r\nJohnson, Hans", "author_place": 1, "persona_email": "norman-k-williams@uiowa.edu", "persona_lastname": "Williams", "persona_firstname": "Kent"}], "publication_id": 62},
Split Williams, Kent and Hans Johnson should be another author

1: TODO
Tustison first name is a mess, maybe use only last name and first letter of first name?

2: DONE
{"authors": [{"persona_id": null, "author_name": "Baghdadi, Leila", "author_place": 1, "persona_email": null, "persona_lastname": null, "persona_firstname": null}], "publication_id": 64},
{"publication_id": 64, "submitted_by_author": {"author_id": 7, "author_email": "baghdadi@phenogenomics.ca", "author_lastname": "Baghdadi", "author_firstname": "Leila ", "author_institution": "MICe Imaging Centre"}},
Fix:
update eperson set firstname='Leila' where eperson_id=7


Delete eperson_ids:
--------
/* Delete associated resourcepolicies first: */
delete from resourcepolicy where eperson_id in(
    2553,
    1043, 1052, 9792,
    105
)

delete from eperson where eperson_id in(
9855,
887,
186,
525,
3318,
252,
2534,
49,
3254,
1053,
119,
48,
195,
2553,
9312,
1043,
1052,
9792,
17,
307, 485,
2555,
273,
11,
742,
759,
499,
947,
94,
325, 941,
105,
717,
15, 786, 139,
9578,
839,
812,
2226,
474
);
update eperson set email='marius.staring@gmail.com' where eperson_id=208;
update eperson set firstname='Leila' where eperson_id=7:
update eperson set email='karthik.krshnan@gmail.com' where eperson_id=132;
update isj_user set reviews=5 where id=3583 and reviews=3;
/* bill lorensen has reviews/comments */
update isj_revision_comment set eperson_id=2746 where eperson_id=17;
update eperson set email='stefan.daenzer@gmail.com' where eperson_id=444;
update eperson set email='styner@cs.unc.edu' where eperson_id=28;
update eperson set email='j.plumat@gmail.com' where eperson_id=1017;
update eperson set email='maciejorkisz@gmail.com' where eperson_id=879;
---------
Delete isj_users // No need for our query purposes
but they won't  be valid because they have no associated eperson.

/* pablo:
isj_user: 17277
eperson: 9689
login: pablo.hernandez.cerdan@outlook.com

Isotropic wavelets
isj_publication:
 id: 986
 author_id: 17277
 journal_id: 81
 item_id: 5336
 bundle_id: 7686
 bitstream_id: [20240, 20241]
 git: git://github.com/phcerdan/ITKIsotropicWavelets
*/

/* Gold, Nested queries:
https://stackoverflow.com/questions/42222968/create-nested-json-from-sql-query-postgres-9-4
*/

/* Suggested by Matt
[x] Title, Abstract
[1/2] authors. (Missing matching authors to author_id, only first and lastname are available right now. TODO: do a search)
[x] submitted_by_author: author_id, firstname,lastname, email, institution
[x] date_submitted
[x] Tags, Categories, Keywords, Toolkits
[x] Journals
[x] handles. number and complete url with base http://hdl.handle.net/
[x] Links to PDF, data. Upload all biststreams to data.kitware/InsightJournal with the structure:
  - publication_id/revisions_number/ALL_FILES
[x] Accessed at /browse/publication/986. phc:Probably not needed, we keep the publication_id
- Summary image (or placeholder). Aka Logos. There are big and small logos, and default images if non-existant
- License. There is a license.txt in bitstreams
 */

/* The logos are stored in bytea format (SQL), and there is no reference to their filetype.
To solve this, I used a postgres extension that bridges to the c library libmagic to get the mime type of the bytea types
https://github.com/nmandery/pg_byteamagic/blob/master/doc/byteamagic.md
Test:
psql -U midas -d midasjournal -a -c "CREATE EXTENSION byteamagic"
psql -U midas -d midasjournal -a -c "select id, byteamagic_mime(logo) from isj_publication where id = 987"
*/


/*
You can download bitstream:
From publication to bitstream (one to many)
publication has 1 itemid
item2bundle
bundle2bitstream
bitstream

Use the "api": check
MidasJournal-copy/insightjournal/controllers/download_controller.php

Example: 20240 is one of the two bitstreams associated to the isotropic wavelets publication.
https://www.insight-journal.org/download/downloadbitstream/20240/hola.pdf

With this you should be able to download everything (all the interesting stuff is public anyway)


WIP: Use the script create_json_per_publication_sql.py to use all the extract sql
./create_json_per_publication_from_sql.py test_data.json ./extract_abstracts.sql \
./extract_bitstreams.sql ./extract_handle.sql ./extract_identifier.sql ./extract_journals.sql \
./extract_publication_author_names.sql ./extract_publications.sql ./extract_submitted_by_author.sql \
./extract_tags.sql ./extract_title.sql ./extract_toolkits.sql

Note that some grep should be applied to replace None for [] or "", depending on the key.

*/
