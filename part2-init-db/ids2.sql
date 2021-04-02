DROP TABLE magia CASCADE CONSTRAINTS;
DROP TABLE element CASCADE CONSTRAINTS;
DROP TABLE zvitok CASCADE CONSTRAINTS;
DROP TABLE kuzlo CASCADE CONSTRAINTS;
DROP TABLE kuzelnik CASCADE CONSTRAINTS;
DROP TABLE grimoar CASCADE CONSTRAINTS;
DROP TABLE magicke_miesto CASCADE CONSTRAINTS;
DROP TABLE kuzelnik_vlastni_grimoar CASCADE CONSTRAINTS;
DROP TABLE vedlajsi_element_kuzla CASCADE CONSTRAINTS;
DROP TABLE grimoar_zoskupuje_kuzla CASCADE CONSTRAINTS;
DROP TABLE kuzelnikova_synergia_s_elementom CASCADE CONSTRAINTS;

--=======-TYPY-ENTIT-=======--
-- TODO CHECK ON MSGN
-- TODO CHECK ON GPS
CREATE TABLE magia
(
    id                  INT GENERATED AS IDENTITY NOT NULL,
    farba               VARCHAR(63) NOT NULL,
    charakter           VARCHAR(63) NOT NULL,
    min_uroven_kuzlenia VARCHAR(63),
    dlzka_posobenia     VARCHAR(63),
    element             VARCHAR(63),
    --Dlzka posobenia

    CONSTRAINT magia_fk FOREIGN KEY (element) REFERENCES element (magicka_znacka) ON DELETE CASCADE,
);

CREATE TABLE element
(
    magicka_znacka int primary key,
    typ varchar(255),
    specializacia varchar(255),
    uroven_vzacnosti number(2,0),
    forma_vyskytu varchar(255)
);

CREATE TABLE zvitok
(
    id                  INT GENERATED AS IDENTITY NOT NULL,
    stav                varchar(32),
    kuzlo               VARCHAR(32),

    CONSTRAINT zvitok_fk FOREIGN KEY (kuzlo) REFERENCES kuzlo (ev_cislo)
);

CREATE TABLE kuzlo
(
    ev_cislo            INT GENERATED AS IDENTITY NOT NULL
    uroven_zlozitosti_zoslania varchar(2),
    typ varchar(255),
    sila number(2,0),
    meno varchar(255),
    formula_vyvolania varchar(255)
    hlasitost_vyvolania
    carovny_nastroj
    gesto
);

CREATE TABLE kuzelnik
(
    id                  INT GENERATED AS IDENTITY NOT NULL,
    pseudonym varchar(255),
    datum_zrodenia date,
    uroven_kuzlenia varchar(2),
    velkost_many number(3,2)
);

CREATE TABLE grimoar
(
    msgn                    INT GENERATED AS IDENTITY NOT NULL,
    historia_vlastnictva number(3,0),
    mnozstvo_magie number(3,2),
    datum_konca date,
    stav varchar(255)
);

CREATE TABLE magicke_miesto
(
    gps_suradnice varchar(32),
    miera_presakovania number(3,2),
    oblast varchar(255),
    ulica varchar(255),
    poznavacie_znamenie varchar(255),
    presakujuci_element varchar (32),

    CONSTRAINT magicke_miesto_pk PRIMARY KEY (gps_suradnice),
    CONSTRAINT magicke_miesto_fk FOREIGN KEY (presakujuci_element) REFERENCES element (magicka_znacka)
);

CREATE TABLE kuzelnik_vlastni_grimoar
(
    msgn                INT,
    id_kuzelnika        INT,
    od                  varchar(16),
    do                  varchar(16),

    CONSTRAINT kuzelnik_vlastni_grimoar_pk PRIMARY KEY (msgn, id_kuzelnika),
    CONSTRAINT kuzelnik_vlastni_grimoar_fk_grimoar FOREIGN KEY (msgn) REFERENCES grimoar (msgn),
    CONSTRAINT kuzelnik_vlastni_grimoar_fk_kuzelnik FOREIGN KEY (id_kuzelnika) REFERENCES kuzelnik (id)
);

CREATE TABLE vedlajsi_element_kuzla
(
    magicka_znacka
    ev_cislo

    CONSTRAINT vedlajsi_element_kuzla_pk PRIMARY KEY (magicka_znacka, ev_cislo),
    CONSTRAINT vedlajsi_element_kuzla_fk_element FOREIGN KEY (magicka_znacka) REFERENCES element (magicka_znacka),
    CONSTRAINT vedlajsi_element_kuzla_fk_kuzlo FOREIGN KEY (ev_cislo) REFERENCES kuzlo (ev_cislo)
);

CREATE TABLE grimoar_zoskupuje_kuzla
(
    msgn                 INT GENERATED AS IDENTITY NOT NULL,
    ev_cislo      INT GENERATED AS IDENTITY NOT NULL,

    CONSTRAINT grimoar_zoskupuje_kuzla_pk PRIMARY KEY (msgn, ev_cislo),
    CONSTRAINT grimoar_zoskupuje_kuzla_fk_msgn FOREIGN KEY (msgn) REFERENCES grimoar (msgn),
    CONSTRAINT grimoar_zoskupuje_kuzla_fk_ev_cislo FOREIGN KEY (ev_cislo) REFERENCES kuzlo (ev_cislo)
);

CREATE TABLE kuzelnikova_synergia_s_elementom
(
    id_kuzelnika         INT GENERATED AS IDENTITY NOT NULL,
    magicka_znacka_elementu

    CONSTRAINT kuzelnikova_synergia_s_elementom_pk PRIMARY KEY (id_kuzelnika, magicka_znacka_elementu),
    CONSTRAINT kuzelnikova_synergia_s_elementom_fk_kuzelnik FOREIGN KEY (id_kuzelnika) REFERENCES kuzelnik (id),
    CONSTRAINT kuzelnikova_synergia_s_elementom_fk_element FOREIGN KEY (magicka_znacka_elementu) REFERENCES element (magicka_znacka)
);


--=======-NAPLNENIE DATAMI-=======--

--=======-ZOBRAZENIE DAT-=======--

-- SELECT * FROM magia;
-- SELECT * FROM element;
-- SELECT * FROM zvitok;
-- SELECT * FROM kuzlo;
-- SELECT * FROM kuzelnik;
-- SELECT * FROM grimoar;
-- SELECT * FROM magicke_miesto;
-- SELECT * FROM kuzelnik_vlastni_grimoar;
-- SELECT * FROM vedlajsi_element_kuzla;
-- SELECT * FROM grimoar_zoskupuje_kuzla;
-- SELECT * FROM kuzelnikova_synergia_s_elementom;