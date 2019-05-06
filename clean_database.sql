-- text_value=Budin, François <-- Change this to Francois
update metadatavalue set text_value='Budin, Francois' where metadata_value_id=171694;
update metadatavalue set text_value='Villeger, Alice' where metadatavalue_id=35392;
update metadatavalue set text_value='Flouvat, Frederic' where metadata_value_id=35393;
-- Remove tilde in publication: 105, item_id=495
update metadatavalue set text_value='Chettaoui, Hanene' where metadata_value_id=24849;
-- Remove tilde in publication: 179, item_id=1933
update metadatavalue set text_value='Macia, Ivan' where metadata_value_id=68283;
-- Remove tilde in publication: 176, item_id=1343
update metadatavalue set text_value='Lehmann, Gaetan' where metadata_value_id=68500;
-- Remove tilde in publication: 773, item_id=4888
update metadatavalue set text_value='Lehmann, Gaetan' where metadata_value_id=163741;
-- Remove tilde in publication: 852, item_id=5072
update metadatavalue set text_value='Lehmann, Gaetan' where metadata_value_id=166255;
-- Remove tilde in publication: 853, item_id=4889
update metadatavalue set text_value='Lehmann, Gaetan' where metadata_value_id=163752;
-- Add - in Hee Su--
update metadatavalue set text_value='Kim, Hee-Su' where metadata_value_id=1929;
-- Update name of Tustison epersona, from Nick to Nicholas J.
update eperson set firstname='Nicholas J.' where eperson_id=8833;
-- Update name from Jim to James
update eperson set firstname='James' where eperson_id=232;
-- Update publication name from Nick to Nicholas J.
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=160648;
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=166004;
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=166134;
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=171473;
update metadatavalue set text_value='Tustison, Nicholas J.' where metadata_value_id=171535;
-- Fix names of eperson: 9445 (Senra Filho), da Silva belongs to the name, not a last name
update eperson set firstname='Antonio Carlos da Silva', lastname='Senra Filho' where eperson_id=9445;
-- Switch lastname, firstname in pub_id=551, item_id=4454
update metadatavalue set text_value='Qizhen, He' where metadata_value_id=153390;
update metadatavalue set text_value='Horace, Ip' where metadata_value_id=153391;
update metadatavalue set text_value='Xia, James' where metadata_value_id=153392;
-- Fix switched names in pub_id=110
update metadatavalue set text_value='Enquobahrie, Andinet' where metadata_value_id=31675;
update metadatavalue set text_value='Stenzel, Roland' where metadata_value_id=31676;
update metadatavalue set text_value='Lin, Ralph' where metadata_value_id=31677;
update metadatavalue set text_value='Zhang, Hui' where metadata_value_id=31678;
update metadatavalue set text_value='Yaniv, Ziv' where metadata_value_id=31679;
update metadatavalue set text_value='Kim, Hee-su' where metadata_value_id=31680;
update metadatavalue set text_value='Cleary, Kevin' where metadata_value_id=31681;
-- Wrong firstname of author in publication:9, item_id=15,  (eperson=14)
update metadatavalue set text_value='Li, George' where metadata_value_id=12073;
-- Fix switched names in pub_id=81 (and correct case)
update metadatavalue set text_value='Zhu, Wanlin' where metadata_value_id=21679;
-- Fix switched names in pub_id=579
update metadatavalue set text_value='Taieb, Yoav' where metadata_value_id=155181;
update metadatavalue set text_value='Eliassaf, Ofer' where metadata_value_id=155182;
update metadatavalue set text_value='Freiman, Moti' where metadata_value_id=155183;
update metadatavalue set text_value='Joskowicz, Leo' where metadata_value_id=155184;
update metadatavalue set text_value='Sosna, Jacob' where metadata_value_id=155185;
-- Remove CAPS of lastnames in publication_id=158
update metadatavalue set text_value='Wang, Defeng' where metadata_value_id=71270;
update metadatavalue set text_value='Shi, Lin' where metadata_value_id=71271;
update metadatavalue set text_value='Heng, Pheng Ann' where metadata_value_id=71272;
-- Strip whitespace of firstname:
update eperson set firstname='Monica' where eperson_id=1044;
-- From Tom to Thomas
update eperson set firstname='Thomas' where eperson_id=706;
-- Fix lastname of eperson (because its me!)
update eperson set lastname='Hernandez-Cerdan' where eperson_id=9689;
-- Mosaliganti, Kishore (2x) (Both with sumissions!) Merge
update isj_publication set authorid=1022 where authorid=51;
update isj_user set submissions=6 where id=1022 and submissions=4;
delete from eperson where eperson_id=49;
-- --
update isj_revision_comment set eperson_id=981 where eperson_id=49;
update isj_revision_comment set eperson_id=77 where eperson_id=3254;
update isj_revision_comment set eperson_id=234 where eperson_id=1053;
update isj_revision_comment set eperson_id=104 where eperson_id=48;
-- Lloyd, Bryn A.
update isj_publication set authorid=25 where authorid=3203;
update isj_user set submissions=4 where id=25 and submissions=3;
delete from resourcepolicy where eperson_id=2553;
delete from eperson where eperson_id=2553;
update isj_revision_comment set eperson_id=23 where eperson_id=2553;
-- --
-- Staring, Marius
delete from eperson where eperson_id=9312;
update eperson set email='marius.staring@gmail.com' where eperson_id=208;
-- Krishnan, Karthik
update isj_revision_comment set eperson_id=132 where eperson_id=1043;
update isj_revision_comment set eperson_id=132 where eperson_id=1052;
update isj_revision_comment set eperson_id=132 where eperson_id=9792;
update isj_review set user_id=133 where user_id=1142;
update isj_review set user_id=133 where user_id=1158;
update isj_review set user_id=133 where user_id=17481;
delete from resourcepolicy where eperson_id in(1043, 1052, 9792);
delete from eperson where eperson_id in(1043, 1052, 9792);
update eperson set email='karthik.krshnan@gmail.com' where eperson_id=132;
--  Lorensen, Bill
update isj_review set user_id=3583 where user_id=19;
update isj_user set reviews=5 where id=3583 and reviews=3;
update isj_revision_comment set eperson_id=2746 where eperson_id=17;
delete from eperson where eperson_id = 17;
-- Okuda, Hirohito
update isj_revision_comment set eperson_id=1094 where eperson_id=307;
delete from eperson where eperson_id = 307;
update isj_revision_comment set eperson_id=1094 where eperson_id=485;
delete from eperson where eperson_id = 485;
-- Daenzer, Stefan
delete from eperson where eperson_id = 2555;
update eperson set email='stefan.daenzer@gmail.com' where eperson_id=444;
-- Styner, Martin
delete from eperson where eperson_id = 273;
update eperson set email='styner@cs.unc.edu' where eperson_id=28;
-- Avants, Brian
-- update isj_revision_comment set eperson_id=2243 where eperson_id=11;
delete from eperson where eperson_id = 11;
-- Gelas, Arnaud
update isj_revision_comment set eperson_id=7896 where eperson_id=947;
update isj_user set reviews=1 where id=13778 and reviews=0;
update isj_user set submissions=5 where id=13778 and submissions=1;
update isj_review set user_id=13778 where user_id=854;
delete from eperson where eperson_id = 947;
-- Tustison, Nick
update isj_revision_comment set eperson_id=8833 where eperson_id=105;
update isj_publication set authorid=15570 where authorid=106;
update isj_user set submissions=23, reviews=4 where id=15570 and submissions=2;
delete from resourcepolicy where eperson_id=105;
delete from eperson where eperson_id=105;
-- delete from isj_user where id=106;
-- Bilgin, Cemal Catagay
update isj_revision_comment set eperson_id=6593 where eperson_id=717;
update eperson set firstname='Cemal Cagatay' where eperson_id=6593;
update isj_publication set authorid=11206 where authorid=641;
delete from eperson where eperson_id=717;
-- delete from isj_user where erperson_id=717;
-- Blezek, Daniel
update isj_revision_comment set eperson_id=1018 where eperson_id=15;
update isj_revision_comment set eperson_id=1018 where eperson_id=786;
update isj_revision_comment set eperson_id=1018 where eperson_id=139;
update isj_review set user_id=1096 where user_id=17;
update isj_review set user_id=1096 where user_id=702;
update isj_review set user_id=1096 where user_id=140;
delete from eperson where eperson_id=15;
delete from eperson where eperson_id=786;
delete from eperson where eperson_id=139;
-- Reynolds, Patrick--
delete from resourcepolicy where eperson_id=652;
delete from eperson where eperson_id=652;
update isj_revision_comment set eperson_id=6056 where eperson_id=652;
update isj_review set user_id=10134 where user_id=582;
-- Liu, Xiaxiao
-- delete from resourcepolicy where eperson_id=959;
delete from eperson where eperson_id=959;
update isj_publication set authorid=3102 where authorid=959;
update isj_review set user_id=4277 where user_id=864;
update isj_revision_comment set eperson_id=3102 where eperson_id=959;
-- Vo, Huy
delete from eperson where eperson_id=6057;
update eperson set email='huy.tuan.vo@gmail.com' where eperson_id=6190;
update isj_publication set authorid=10400 where authorid=10136;
update isj_review set user_id=10400 where user_id=10136;
update isj_revision_comment set eperson_id=6190 where eperson_id=6057;
-- Krissian, Karl
delete from eperson where eperson_id=46;
-- Bowers, Michael
delete from eperson where eperson_id=6785;
update eperson set email='michaelbowersjhu@gmail.com' where eperson_id=2380;
update isj_publication set authorid=2859 where authorid=11590;
update isj_review set user_id=2859 where user_id=11590;
-- Vera, Sergio
delete from eperson where eperson_id=2551;
-- Rey, Alberto
delete from eperson where eperson_id=2758;
update eperson set email='bertorey@gmail.com' where eperson_id=5874;
-- Damon, Stephen
delete from eperson where eperson_id=9539;
-- Seo, Dohyunk, duplicate user, duplicated submissions deleted
delete from resourcepolicy where eperson_id=9261;
delete from eperson where eperson_id=9261;
update isj_user set submissions=0 where id=16389;
update isj_user set submissions=0 where id=16425;
-- Remove duplicated publications: 943, 944 and keep 958.
delete from isj_publication where id=943;
delete from isj_publication where id=944;
-- Keep 958
-- Fix Lastname of Jeroen vanbaar, to Van Baar
update eperson set lastname='Van Baar' where eperson_id=9260
-- Suarez-Santana, Eduardo duplicated submissions 135, 156 _keep_
update eperson set lastname='Suarez-Santana' where eperson_id=488;
delete from isj_publication where id=135;
-- Delete non-publications--
-- MICCAI 2005 announcement
delete from isj_publication where id=8;
-- Test
delete from isj_publication where id=922;
-- Yank, Haisheng
delete from eperson where eperson_id=847;
-- Hammer, Peter
delete from eperson where eperson_id=812;
-- Zhou, Jaiyin
delete from eperson where eperson_id=2693;
-- Wang, Chunliang (+ require replace Wang, Chunfang)
delete from eperson where eperson_id=587;
delete from eperson where eperson_id=907;
-- Shimizu, Akinobu
delete from eperson where eperson_id=888;
-- Tek, Huyesin
delete from eperson where eperson_id=910;
-- Abolmaesumi, Purang
delete from eperson where eperson_id=469;
--  Burgert, Oliver
delete from resourcepolicy where eperson_id=2192;
delete from eperson where eperson_id=2192;
update isj_user set submissions=4 where id=14086;
update isj_publication set authorid=14086 where authorid=2487;
update isj_review set user_id=14086 where user_id=2487;
-- Fasquel, Jean-Baptiste
delete from eperson where eperson_id=915;
-- Xia, Tian
delete from eperson where eperson_id=2273;
-- Radau, Perry
delete from eperson where eperson_id=72;
-- Benmansour, Fethallah
delete from resourcepolicy where eperson_id=2214;
delete from eperson where eperson_id=2214;
update isj_user set submissions=1 where id=3781;
update isj_publication set authorid=3781 where authorid=2531;
update isj_review set user_id=3781 where user_id=2531;
-- Hibbard, Lyndon S.
delete from eperson where eperson_id=312;
update eperson set firstname='Lyndon' where eperson_id=4564;
-- Dowling, Jason
delete from eperson where eperson_id=8866;
update eperson set email='dowlingjad@gmail.com' where eperson_id=2286;
--  Stolka, Philipp
delete from eperson where eperson_id=2478;
-- Gao, Yixin -- Not duplicate, but similar name, replace after
-- Constantin, Alexandra
delete from eperson where eperson_id=2696;
-- Durkin, John
delete from eperson where eperson_id=2156;
-- Hatt, Charles
delete from eperson where eperson_id=9488;
update eperson set email='charlesrayhatt@gmail.com' where eperson_id=5871;
-- Gong, Ren Hui
delete from eperson where eperson_id=515;
-- Irshad, Humayun
delete from eperson where eperson_id=6974;
-- Fuerst, Bernhard
delete from eperson where eperson_id=7877;
update eperson set email='be.fuerst@gmail.com' where eperson_id=7864;
-- Wang, Kevin (two persons same name?)
-- Van Reeth, Eric
delete from eperson where eperson_id=9141;
delete from eperson where eperson_id=8812;
update eperson set email='eric.vanreeth@gmail.com' where eperson_id=9470;
-- Aghdasi, Nava
delete from eperson where eperson_id=9736;
-- Jaberzadeh, Amir
delete from eperson where eperson_id=9750;
-- Dowson, Nicholas
delete from eperson where eperson_id=9362;
update eperson set email='nick.dowson@gmail.com' where eperson_id=9215;
----------------
delete from resourcepolicy where eperson_id in(
    2553,
    1043, 1052, 9792,
    105,
    652,
    2192
);
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
474,
652,
959,
6057,
46,
6785,
2551,
2758,
9539,
847,
812,
2693,
587,
907,
888,
910,
469,
2192,
915,
2273,
72,
2214,
312,
8866,
2478,
2696,
2156,
9488,
515,
6974,
7877,
9141,
8812,
9736,
9750
);
update eperson set email='marius.staring@gmail.com' where eperson_id=208;
update eperson set firstname='Leila' where eperson_id=7;
update eperson set email='karthik.krshnan@gmail.com' where eperson_id=132;
update isj_user set reviews=5 where id=3583 and reviews=3;
/* bill lorensen has reviews/comments */
update isj_revision_comment set eperson_id=2746 where eperson_id=17;
update isj_review set user_id=3583 where user_id=19;
update eperson set email='stefan.daenzer@gmail.com' where eperson_id=444;
update eperson set email='styner@cs.unc.edu' where eperson_id=28;
update eperson set email='j.plumat@gmail.com' where eperson_id=1017;
update eperson set email='maciejorkisz@gmail.com' where eperson_id=879;

Remove:
{"persona_id": 618, "author_place": 1, "persona_email": "dfwang@cse.cuhk.edu.hk", "author_fullname": "Wang, David", "persona_lastname": "Wang", "persona_firstname": "Defeng"},

{"persona_id": 104, "author_place": 1, "persona_email": "david@wangmd.com", "author_fullname": "Wang, Defeng", "persona_lastname": "Wang", "persona_firstname": "David"},

{"persona_id": 1059, "author_place": 1, "persona_email": "yinglilu@gmail.com", "author_fullname": "Lu, Yi", "persona_lastname": "Lu", "persona_firstname": "Yingli"},


{"persona_id": 570, "author_place": 8, "persona_email": "skpathak.cmu@gmail.com", "author_fullname": "Pathak, Sayan", "persona_lastname": "Pathak", "persona_firstname": "Sudhir"},


{"persona_id": 894, "author_place": 2, "persona_email": "heye.zhang@auckland.ac.nz", "author_fullname": "Zhang, Hui", "persona_lastname": "Zhang", "persona_firstname": "Heye"},
{"persona_id": 2292, "author_place": 2, "persona_email": "zhanghua100@gmail.com", "author_fullname": "Zhang, Hui", "persona_lastname": "Zhang", "persona_firstname": "Hua "},
{"persona_id": 3011, "author_place": 2, "persona_email": "hyzh@shu.edu.cn", "author_fullname": "Zhang, Hui", "persona_lastname": "Zhang", "persona_firstname": "Haiyan"},
{"persona_id": 6406, "author_place": 2, "persona_email": "reynzhang@gmail.com", "author_fullname": "Zhang, Hui", "persona_lastname": "Zhang", "persona_firstname": "Hua"},
{"persona_id": 7237, "author_place": 2, "persona_email": "haifengzhang1986@163.com", "author_fullname": "Zhang, Hui", "persona_lastname": "Zhang", "persona_firstname": "Haifeng "},

--
{"persona_id": 481, "author_place": 2, "persona_email": "wang.liqin@mayo.edu", "author_fullname": "Wang, Linwei", "persona_lastname": "Wang", "persona_firstname": "Liqin"},
{"persona_id": 986, "author_place": 2, "persona_email": "madwanglei@qq.com", "author_fullname": "Wang, Linwei", "persona_lastname": "Wang", "persona_firstname": "Lei"},
{"persona_id": 2442, "author_place": 2, "persona_email": "wangliansheng.exe@gmail.com", "author_fullname": "Wang, Linwei", "persona_lastname": "Wang", "persona_firstname": "Ls"},
{"persona_id": 7195, "author_place": 2, "persona_email": "leowang0714@gmail.com", "author_fullname": "Wang, Linwei", "persona_lastname": "Wang", "persona_firstname": "Leo"},
{"persona_id": 9407, "author_place": 2, "persona_email": "li_wang@med.unc.edu", "author_fullname": "Wang, Linwei", "persona_lastname": "Wang", "persona_firstname": "Li"},
--

{"persona_id": 313, "author_place": 3, "persona_email": "zhang@isis.imac.georgetown.edu", "author_fullname": "Zhang, Heye", "persona_lastname": "Zhang", "persona_firstname": "Hui"},
{"persona_id": 2292, "author_place": 3, "persona_email": "zhanghua100@gmail.com", "author_fullname": "Zhang, Heye", "persona_lastname": "Zhang", "persona_firstname": "Hua "},
{"persona_id": 3011, "author_place": 3, "persona_email": "hyzh@shu.edu.cn", "author_fullname": "Zhang, Heye", "persona_lastname": "Zhang", "persona_firstname": "Haiyan"},
{"persona_id": 6406, "author_place": 3, "persona_email": "reynzhang@gmail.com", "author_fullname": "Zhang, Heye", "persona_lastname": "Zhang", "persona_firstname": "Hua"},
{"persona_id": 7237, "author_place": 3, "persona_email": "haifengzhang1986@163.com", "author_fullname": "Zhang, Heye", "persona_lastname": "Zhang", "persona_firstname": "Haifeng "},


{"persona_id": 573, "author_place": 4, "persona_email": "jinsuh-kim@uiowa.edu", "author_fullname": "Kim, Johann", "persona_lastname": "Kim", "persona_firstname": "Jinsuh"},

-- There are two persons with same name, remove this because context of publication indicates that the other person is correct (persona_id=902) --
{"persona_id": 2693, "author_place": 6, "persona_email": "jzhou@i2r.a-star.edu.sg", "author_fullname": "Zhou, Jiayin", "persona_lastname": "Zhou", "persona_firstname": "Jiayin"},

--
WRONG MATCH:, replace for null instead of just removing it
Kim, Jung does not exist as isj_user
{"persona_id": 573, "author_place": 2, "persona_email": "jinsuh-kim@uiowa.edu", "author_fullname": "Kim, Jung", "persona_lastname": "Kim", "persona_firstname": "Jinsuh"},
{"persona_id": 884, "author_place": 2, "persona_email": "jkim@definiens.com", "author_fullname": "Kim, Jung", "persona_lastname": "Kim", "persona_firstname": "Johann"}

{"persona_id": 2270, "author_place": 5, "persona_email": "jiamin75@gmail.com", "author_fullname": "Liu, Jiang", "persona_lastname": "Liu", "persona_firstname": "Jiamin"},
---




----------- With 4 characters: -------
Remove:
{"persona_id": 2304, "author_place": 1, "persona_email": "lxmspace@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"},
{"persona_id": 8894, "author_place": 1, "persona_email": "lxmspace@163.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"},
{"persona_id": 9219, "author_place": 1, "persona_email": "xiaokailiusq@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaokai"},
Remove:
{"persona_id": 9407, "author_place": 2, "persona_email": "li_wang@med.unc.edu", "author_fullname": "Wang, Linwei", "persona_lastname": "Wang", "persona_firstname": "Li"},
Remove:
{"persona_id": 774, "author_place": 1, "persona_email": "wchunfang@gmail.com", "author_fullname": "Wang, Chunliang", "persona_lastname": "Wang", "persona_firstname": "Chunfang"},
Remove:
{"persona_id": 468, "author_place": 1, "persona_email": "yi.gao@gatech.edu", "author_fullname": "Gao, Yixin", "persona_lastname": "Gao", "persona_firstname": "Yi"},
-- THis one is an extrapolation, maybe is not needed:
{"persona_id": 2611, "author_place": 1, "persona_email": "ygao20@jhu.edu", "author_fullname": "Gao, Yi", "persona_lastname": "Gao", "persona_firstname": "Yixin"},


In vim:
firstdo:
%s/{"persona_id/\r{"persona_id/g

g/{"persona_id": 774, "author_place": .*, "persona_email": "wchunfang@gmail.com", "author_fullname": "Wang, Chunliang", "persona_lastname": "Wang", "persona_firstname": "Chunfang"},/d

g/{"persona_id": 2304, "author_place": .*, "persona_email": "lxmspace@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"},/d
g/{"persona_id": 8894, "author_place": .*, "persona_email": "lxmspace@163.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaoming"},/d
g/{"persona_id": 9219, "author_place": .*, "persona_email": "xiaokailiusq@gmail.com", "author_fullname": "Liu, Xiaoxiao", "persona_lastname": "Liu", "persona_firstname": "Xiaokai"},/d


g/{"persona_id": 468, "author_place": .*, "persona_email": "yi.gao@gatech.edu", "author_fullname": "Gao, Yixin", "persona_lastname": "Gao", "persona_firstname": "Yi"},/d


g/{"persona_id": 785, "author_place": .*, "persona_email": "jati.lue@gmail.com", "author_fullname": "Lu, Ying[L|l]i", "persona_lastname": "Lu", "persona_firstname": "Yi"},/d

%s/, "persona_email": null//g
%s/, "persona_lastname": null//g
%s/, "persona_firstname": null//g
