--=======-TYPY-ENTIT-=======--

-- uvodny drop a nastavenie oblasti na cz (kvoli spravnemu formatu datumu)
DROP TABLE magia CASCADE CONSTRAINTS;
DROP TABLE element CASCADE CONSTRAINTS;
DROP TABLE zvitok CASCADE CONSTRAINTS;
DROP TABLE kuzlo CASCADE CONSTRAINTS;
DROP TABLE kuzelnik CASCADE CONSTRAINTS;
DROP TABLE grimoar CASCADE CONSTRAINTS;
DROP TABLE magicke_miesto CASCADE CONSTRAINTS;


--=======-TYPY-ENTIT-=======--

create table magia
(
   id int primary key,
   charakter varchar(255),
   min_uroven_kuzlenia varchar(2)
    --Dlzka posobenia
);

create table element
(
    znacka int primary key,
    typ varchar(255),
    specializacia varchar(255),
    uroven_vzacnosti number(2,0),
    forma_vyskytu varchar(255)
);

create table zvitok
(
  id int primary key,
  stav varchar(32)
);

create table kuzlo
(
    ev_cislo int primary key,
    uroven_zlozitosti varchar(2),
    typ varchar(255),
    sila number(2,0),
    meno varchar(255),
    formula_vyvolania varchar(255)
);

create table kuzelnik
(
  id int primary key,
  pseudonym varchar(255),
  datum_zrodenia date,
  uroven_kuzlenia varchar(2),
  velkost_many number(3,2)
);

create table grimoar
(
    msgn int primary key,
    historia_vlastnictva number(3,0),
    mnozstvo_magie number(3,2),
    datum_konca date,
    stav varchar(255)
);

create table magicke_miesto
(
    gps int primary key,
    miera_presakovania number(3,2),
    oblast varchar(255),
    ulica varchar(255),
    poznavacie_znamenie varchar(255)
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