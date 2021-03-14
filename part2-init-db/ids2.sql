--=======-TYPY-ENTIT-=======--
-- uvodny drop a nastavenie oblasti na cz (kvoli spravnemu formatu datumu)

--=======-TYPY-ENTIT-=======--

create table magia
(
   magia_id int primary key,
   magia_charakter varchar(255),
   magia_min_uroven_kuzlenia varchar(2)
    --Dlzka posobenia
);

create table element
(
    element_znacka int primary key,
    element_typ varchar(255),
    element_specializacia varchar(255),
    element_uroven_vzacnosti number(2,0),
    element_forma_vyskytu varchar(255)
);

create table zvitok
(
  zvitok_id int primary key,
  zvitok_stav varchar(32)
);

create table kuzlo
(
    kuzlo_ev_cislo int primary key,
    kuzlo_uroven_zlozitosti varchar(2),
    kuzlo_typ varchar(255),
    kuzlo_sila number(2,0),
    kuzlo_meno varchar(255),
    kuzlo_formula_vyvolania varchar(255)
);

create table kuzelnik
(
  kuzelnik_id int primary key,
  kuzelnik_pseudonym varchar(255),
  kuzelnik_datum_zrodenia date,
  kuzelnik_uroven_kuzlenia varchar(2),
  kuzelnik_velkost_many number(3,2)
);

create table grimoar
(
    grimoar_msgn int primary key,
    grimoar_historia_vlastnictva number(3,0),
    grimoar_mnozstvo_magie number(3,2),
    grimoar_datum_konca date,
    gimoar_stav varchar(255)
);

create table magicke_miesto
(
    magicke_miesto_gps int primary key,
    magicke_miesto_miera_presakovania number(3,2),
    magicke_miesto_oblast varchar(255),
    magicke_miesto_ulica varchar(255),
    magicke_miesto_poznavacie_znamenie varchar(255)
);

--=======-VZTAHY-ENTIT-=======--

--=======-NAPLNENIE-DATAMI-=======--
-- create table osoba
-- (
--     cislo int primary key,
--     meno  varchar(32) not null,
--     plat  number(8, 2) default 0
-- );

-- insert into osoba values (1, 'Karol', 10000);
-- insert into osoba values (2, 'Jozef', 55000);