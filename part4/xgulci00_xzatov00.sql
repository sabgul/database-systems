-- Authors: Sabina Gulcikova, xgulci00@stud.fit.vutbr.cz
--          Martin Zatovic, xzatov00@stud.fit.vutbr.cz

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

DROP SEQUENCE Magia_seq;
DROP SEQUENCE Zvitok_seq;
DROP SEQUENCE Kuzlo_seq;
DROP SEQUENCE Kuzelnik_seq;

-------------------------------

CREATE SEQUENCE Magia_seq
    START WITH 10000
    INCREMENT BY 1;

CREATE SEQUENCE Zvitok_seq
    START WITH 10000
    INCREMENT BY 1;

CREATE SEQUENCE Kuzlo_seq
    START WITH 10000
    INCREMENT BY 1;

CREATE SEQUENCE Kuzelnik_seq
    START WITH 10000
    INCREMENT BY 1;

-------------------------------
CREATE TABLE element
(
    -- magicka znacka je ekvivalent chemickej znacky
    magicka_znacka      VARCHAR(2) PRIMARY KEY,
    typ                 VARCHAR(15) NOT NULL,
    specializacia       VARCHAR(254) NOT NULL,
    uroven_vzacnosti    VARCHAR(31) NOT NULL,
                        CHECK ( uroven_vzacnosti IN ('veľmi vzácny', 'vzácny', 'štandardný','frekventovaný') ),
    forma_vyskytu       VARCHAR(63)
);

CREATE TABLE magia
(
    id                  INT DEFAULT Magia_seq.NEXTVAL PRIMARY KEY,
    farba               VARCHAR(63) NOT NULL,
    charakter           VARCHAR(63) NOT NULL,
    min_uroven_kuzlenia VARCHAR(2) NOT NULL
        CHECK ( min_uroven_kuzlenia IN ('E', 'D', 'C', 'B', 'A', 'S', 'SS')),
    dlzka_posobenia     VARCHAR(63) NOT NULL,
    element             VARCHAR(2),

    CONSTRAINT magia_fk FOREIGN KEY (element) REFERENCES element (magicka_znacka) ON DELETE CASCADE
);

CREATE TABLE kuzlo
(
    ev_cislo                    INT DEFAULT Kuzlo_seq.NEXTVAL PRIMARY KEY,
    uroven_zlozitosti_zoslania  VARCHAR(2) NOT NULL
                                CHECK ( uroven_zlozitosti_zoslania IN ('E', 'D', 'C', 'B', 'A', 'S', 'SS')),
    typ                         VARCHAR(127) NOT NULL
                                CHECK ( typ IN ('verbálne', 'materiálne') ),
    sila                        INT NOT NULL
                                CHECK ( sila >= 0 AND sila <= 10),
    meno                        VARCHAR(127) NOT NULL,
    formula_vyvolania           VARCHAR(254) NOT NULL,
    hlasitost_vyvolania         VARCHAR(63) DEFAULT NULL,
    carovny_nastroj             VARCHAR(127) DEFAULT NULL,
    gesto                       VARCHAR(254) DEFAULT NULL,
    primarny_element            VARCHAR(2),

    CONSTRAINT kuzlo_fk FOREIGN KEY (primarny_element) REFERENCES element (magicka_znacka) ON DELETE CASCADE
);

CREATE TABLE zvitok
(
    id                  INT DEFAULT Zvitok_seq.NEXTVAL PRIMARY KEY,
    stav                VARCHAR(15) NOT NULL CHECK ( stav IN ('plný', 'prázdny') ),
    kuzlo               INT,

    CONSTRAINT zvitok_fk FOREIGN KEY (kuzlo) REFERENCES kuzlo (ev_cislo)
);

CREATE TABLE grimoar
(
    -- msgn - magical standard grimoire number, ekvivalent ISBN
    -- uvazujeme format MSGN-10 (ekviv. ISBN-10), pricom kontrolujeme len lexikalnu spravnost
    -- delitelnost 11 je overena triggerom
    -- MSGN 80-204-0105-9
    msgn                    VARCHAR(18)
                            CHECK ( LENGTH(msgn) = 18 )
                            CHECK ( REGEXP_LIKE(msgn, '^MSGN ([0-9]|X|x){1,5}[- ]([0-9]|X|x){1,7}[- ]([0-9]|X|x){1,6}[- ]([0-9]|X|x)$', 'i') ),
    historia_vlastnictva    INT NOT NULL,
    mnozstvo_magie          VARCHAR(4) NOT NULL,
    datum_konca             DATE,
    stav                    VARCHAR(254) NOT NULL,
    primarny_element        VARCHAR(2),

    CONSTRAINT grimoar_pk PRIMARY KEY (msgn),
    CONSTRAINT grimoar_fk FOREIGN KEY (primarny_element) REFERENCES element (magicka_znacka) ON DELETE CASCADE
);

CREATE TABLE kuzelnik
(
    id                  INT DEFAULT Kuzelnik_seq.NEXTVAL PRIMARY KEY,
    pseudonym           VARCHAR(255) NOT NULL,
    datum_zrodenia      VARCHAR(63),
    uroven_kuzlenia     VARCHAR(2) NOT NULL
                        CHECK ( uroven_kuzlenia IN ('E', 'D', 'C', 'B', 'A', 'S', 'SS')),
    velkost_many        NUMBER(7,2) NOT NULL
);

CREATE TABLE magicke_miesto
(
    gps_suradnice       varchar(32)
                        CHECK ( REGEXP_LIKE(
                        gps_suradnice, '^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$', 'i') ),
    miera_presakovania  NUMBER(5,2) NOT NULL,
    oblast              VARCHAR(254) NOT NULL,
    ulica               VARCHAR(254) NOT NULL,
    poznavacie_znamenie VARCHAR(254) NOT NULL,
    presakujuca_magia   INT,

    CONSTRAINT magicke_miesto_pk PRIMARY KEY (gps_suradnice),
    CONSTRAINT magicke_miesto_fk FOREIGN KEY (presakujuca_magia) REFERENCES magia (id)
);

CREATE TABLE kuzelnik_vlastni_grimoar
(
    msgn                VARCHAR(18),
    id_kuzelnika        INT,
    od                  VARCHAR(63),
    do                  VARCHAR(63),

    CONSTRAINT kuzelnik_vlastni_grimoar_pk PRIMARY KEY (msgn, id_kuzelnika),
    CONSTRAINT kuzelnik_vlastni_grimoar_fk_grimoar FOREIGN KEY (msgn) REFERENCES grimoar (msgn),
    CONSTRAINT kuzelnik_vlastni_grimoar_fk_kuzelnik FOREIGN KEY (id_kuzelnika) REFERENCES kuzelnik (id)
);

CREATE TABLE vedlajsi_element_kuzla
(
    magicka_znacka  VARCHAR(2),
    ev_cislo        INT,

    CONSTRAINT vedlajsi_element_kuzla_pk PRIMARY KEY (magicka_znacka, ev_cislo),
    CONSTRAINT vedlajsi_element_kuzla_fk_element FOREIGN KEY (magicka_znacka) REFERENCES element (magicka_znacka),
    CONSTRAINT vedlajsi_element_kuzla_fk_kuzlo FOREIGN KEY (ev_cislo) REFERENCES kuzlo (ev_cislo)
);

CREATE TABLE grimoar_zoskupuje_kuzla
(
    msgn          VARCHAR(18),
    ev_cislo      INT,

    CONSTRAINT grimoar_zoskupuje_kuzla_pk PRIMARY KEY (msgn, ev_cislo),
    CONSTRAINT grimoar_zoskupuje_kuzla_fk_msgn FOREIGN KEY (msgn) REFERENCES grimoar (msgn),
    CONSTRAINT grimoar_zoskupuje_kuzla_fk_ev_cislo FOREIGN KEY (ev_cislo) REFERENCES kuzlo (ev_cislo)
);

CREATE TABLE kuzelnikova_synergia_s_elementom
(
    id_kuzelnika                INT,
    magicka_znacka_elementu     VARCHAR(2),

    CONSTRAINT kuzelnikova_synergia_s_elementom_pk PRIMARY KEY (id_kuzelnika, magicka_znacka_elementu),
    CONSTRAINT kuzelnikova_synergia_s_elementom_fk_kuzelnik FOREIGN KEY (id_kuzelnika) REFERENCES kuzelnik (id),
    CONSTRAINT kuzelnikova_synergia_s_elementom_fk_element FOREIGN KEY (magicka_znacka_elementu) REFERENCES element (magicka_znacka)
);

-------------------------------------
-------=======-TRIGGER-=======-------

CREATE OR REPLACE TRIGGER "INSERT_MAGIA_TRIG" BEFORE INSERT ON magia
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
BEGIN
 IF :NEW.ID IS NULL THEN
   SELECT Magia_seq.NextVal INTO :NEW.ID FROM dual;
 END IF;
END;

-- trigger kontroluje spravnost MSGN formatu (podobny ISBN-10)
CREATE OR REPLACE TRIGGER "INSERT_GRIMOAR_TRIG" BEFORE INSERT ON grimoar
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE
    it SIMPLE_INTEGER := 5;
    weight SIMPLE_INTEGER := 10;
    suma NUMBER(20) := 0;
    tmp NUMBER(3);
    pismenko char(1);
BEGIN
    WHILE it <= LENGTH(:NEW.msgn)
    LOOP
        pismenko := SUBSTR(:NEW.msgn, it, 1);
        IF pismenko = '-' THEN
            it := it + 1;
            CONTINUE;
        ELSIF pismenko = ' ' THEN
            it := it + 1;
            CONTINUE;
        ELSIF pismenko = 'X' THEN
            suma := suma + (10 * weight);
            weight := weight - 1;
        ELSE
            tmp := ASCII(pismenko);
            IF tmp = 48 THEN
                tmp := 0;
            ELSIF tmp = 49 THEN
                tmp := 1;
            ELSIF tmp = 50 THEN
                tmp := 2;
            ELSIF tmp = 51 THEN
                tmp := 3;
            ELSIF tmp = 52 THEN
                tmp := 4;
            ELSIF tmp = 53 THEN
                tmp := 5;
            ELSIF tmp = 54 THEN
                tmp := 6;
            ELSIF tmp = 55 THEN
                tmp := 7;
            ELSIF tmp = 56 THEN
                tmp := 8;
            ELSIF tmp = 57 THEN
                tmp := 9;
            END IF;
            suma := suma + (tmp * weight);
            weight := weight - 1;
        END IF;
        it := it + 1;
    END LOOP;
    IF (MOD(suma, 11) != 0) THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR IN TRIGGER: invalid msgn format');
    END IF;
END;

---=======-NAPLNENIE DATAMI-=======--

INSERT INTO element
    VALUES ('Ob', 'obranné', 'ľudské bytosti', 'vzácny', 'tuhá');

INSERT INTO element
    VALUES ('Om', 'revitalizačné', 'ľudské bytosti', 'veľmi vzácny', 'tekutá');

INSERT INTO element
    VALUES ('Sl', 'útočné', 'škriatkovia', 'štandardný', 'tekutá');

INSERT INTO element
    VALUES ('Ur', 'obranné', 'zvieratá', 'vzácny', 'plynná');

INSERT INTO element
    VALUES ('Oh', 'obranné', 'ľudské bytosti', 'vzácny', 'tuhá');

INSERT INTO element
    VALUES ('Ag', 'útočné', 'zvieratá', 'veľmi vzácny', 'tekutá');

INSERT INTO element
    VALUES ('Ey', 'útočné', 'elfovia', 'vzácny', 'plynná');

INSERT INTO element
    VALUES ('Xe', 'obranné', 'ľudské bytosti', 'štandardný', 'tuhá');

INSERT INTO element
    VALUES ('Xi', 'revitalizačné', 'škriatkovia', 'frekventovaný', 'tekutá');

INSERT INTO element
    VALUES ('Yz', 'revitalizačné', 'víly', 'frekventovaný', 'tuhá');

INSERT INTO magia
    VALUES (DEFAULT, 'žtlá', 'kladný', 'C', '2 roky', 'Ur');

INSERT INTO magia
    VALUES (DEFAULT, 'zelená', 'kladný', 'E', '1 mesiac', 'Ob');

INSERT INTO magia
    VALUES (239, 'oranžová', 'negatívny', 'A', '1 hodina', 'Sl');

INSERT INTO magia
    VALUES (1781, 'fialová', 'negatívny', 'E', '10 minút', 'Sl');

INSERT INTO magia
    VALUES (NULL, 'bordová', 'negatívny', 'E', '55 minút', 'Sl');

INSERT INTO kuzlo
    VALUES (DEFAULT, 'E', 'verbálne', 4, 'Abrakando', 'Abraka Dabra', 'šepot - 30 dB', DEFAULT, DEFAULT, 'Ob');

INSERT INTO kuzlo
    VALUES (784, 'D', 'verbálne', 5, 'Simsalando', 'Simsala bimsala sim bim', 'krik - 100 dB', DEFAULT, DEFAULT, 'Ur');

INSERT INTO kuzlo
    VALUES (1212, 'A', 'materiálne', 7, 'Karavaggio', 'Kryptonium ecce', DEFAULT, 'čarovný prútik', 'štyri otočenia zápastím pravej ruky', 'Sl');

INSERT INTO kuzlo
    VALUES (1234, 'B', 'verbálne', 4, 'Salamalamama', 'Sali soli sele', 'šepot - 30 dB',  DEFAULT, DEFAULT, 'Ur');

INSERT INTO kuzlo
    VALUES (278, 'D', 'materiálne', 2, 'Calamenium', 'Hopsa hejsa colom dejsa', DEFAULT, 'prúty zo starej vŕby', 'dva výskoky na pravej nohe', 'Ob');

INSERT INTO kuzlo
    VALUES (3421, 'A', 'materiálne', 10, 'Sebared', 'Expecto expectum', DEFAULT, 'čarovný prútik', 'dvihnutie prútika držaného v ľavej ruke nad hlavu kúzelníka', 'Ob');

INSERT INTO kuzlo
    VALUES (573, 'D', 'verbálne', 2, 'Klipsnerdo', 'Kolium koli bum', 'krik - 100 dB',  DEFAULT, DEFAULT, 'Sl');

INSERT INTO kuzlo
    VALUES (2211, 'A', 'verbálne', 10, 'Tistonaro', 'Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch', 'šepot - 30 dB',  DEFAULT, DEFAULT, 'Om');

INSERT INTO kuzlo
    VALUES (5723, 'D', 'materiálne', 4, 'Gohochoch', 'Sarati bumbi rop', DEFAULT, 'magický kotlík', 'tri žmurknutia a lusknutie prstami pravej ruky', 'Om');

INSERT INTO zvitok
    VALUES (DEFAULT, 'prázdny', NULL);

INSERT INTO zvitok
    VALUES (DEFAULT, 'prázdny', NULL);

INSERT INTO zvitok
    VALUES (DEFAULT, 'prázdny', NULL);

INSERT INTO zvitok
    VALUES (DEFAULT, 'prázdny', NULL);

INSERT INTO zvitok
    VALUES (DEFAULT, 'prázdny', NULL);

INSERT INTO zvitok
    VALUES (DEFAULT, 'plný', 784);

INSERT INTO zvitok
    VALUES (6543, 'plný', 1212);

INSERT INTO zvitok
    VALUES (DEFAULT, 'plný', 1234);

INSERT INTO zvitok
    VALUES (DEFAULT, 'plný', 278);

INSERT INTO zvitok
    VALUES (DEFAULT, 'plný', 3421);

INSERT INTO zvitok
    VALUES (DEFAULT, 'plný', 573);

INSERT INTO grimoar
    VALUES ('MSGN 80-204-0105-9', 8, '50%', '12-December-4020', 'použitý', 'Ob');

INSERT INTO grimoar
    VALUES ('MSGN 3-16-148410-X', 1, '84%', '10-December-8021', 'nový', 'Om');

INSERT INTO grimoar
    VALUES ('MSGN 9971-5-0210-0', 3721, '12%', '1-November-2030', 'zachovalý', 'Ur');

INSERT INTO kuzelnik
    VALUES (DEFAULT, 'Bilbian Hop', '30-November-1807', 'B', 127.02);

INSERT INTO kuzelnik
    VALUES (172, 'Jakobian Hugger', '12-September-2000', 'E', 1200.00);

INSERT INTO kuzelnik
    VALUES (823, 'Halabala Vincentala', '13-December-1321', 'SS', 1500.89);

INSERT INTO magicke_miesto
    VALUES ('33.961973, 108.248309', 98.04, 'Tarpotove výšiny', 'Spodná', 'Tri topole v jednom kmeni', 239);

INSERT INTO magicke_miesto
    VALUES ('23.441948, 120.987931', 12.01, 'Medvedia hora', 'Krútivá', 'Nehasnúce ohnisko', 10001);

INSERT INTO magicke_miesto
    VALUES ('-15.417006, 166.934858', 100.00, 'Oskarie jaskyne', 'Kalabodova', 'Trhlina krútivého tvaru v stene', 1781);

INSERT INTO kuzelnik_vlastni_grimoar
    VALUES ('MSGN 80-204-0105-9', 10000, '24-03-1981', '15-07-2029');

INSERT INTO kuzelnik_vlastni_grimoar
    VALUES ('MSGN 3-16-148410-X', 172, '13-07-2012', '17-04-7054');

INSERT INTO kuzelnik_vlastni_grimoar
    VALUES ('MSGN 9971-5-0210-0', 823, '31-12-1902', '15-04-2021');

INSERT INTO vedlajsi_element_kuzla
    VALUES ('Ob', 784);

INSERT INTO vedlajsi_element_kuzla
    VALUES ('Ur', 784);

INSERT INTO vedlajsi_element_kuzla
    VALUES ('Ur', 1212);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 9971-5-0210-0', 784);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 9971-5-0210-0', 1212);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 80-204-0105-9', 784);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 3-16-148410-X', 1234);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 3-16-148410-X', 278);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 3-16-148410-X', 573);

INSERT INTO grimoar_zoskupuje_kuzla
    VALUES ('MSGN 3-16-148410-X', 5723);

INSERT INTO kuzelnikova_synergia_s_elementom
    VALUES (172, 'Sl');

INSERT INTO kuzelnikova_synergia_s_elementom
    VALUES (823, 'Ob');

INSERT INTO kuzelnikova_synergia_s_elementom
    VALUES (823, 'Om');

INSERT INTO kuzelnikova_synergia_s_elementom
    VALUES (10000, 'Ob');

--=======-ZOBRAZENIE VŠETKÝCH DÁT-=======--

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

-------------------------------------------

----------------======= PROCEDURY =======----------------
--1----------------------------------------

-- Procedúra prehľadá všetky magické miesta podľa oblasti zadanej užívateľom.
-- Magické miesto presakuje určitú mágiu, ktorá rozhoduje o tom, či má kladný alebo pozitívny charakter.
-- Pre oblasť zadanú užívateľom je teda vypísaná štatistika celkového počtu miest,
-- z toho pozitívnych a negatívnych.

CREATE OR REPLACE PROCEDURE pozitivita_magickeho_miesta
    (oblast_miesta IN VARCHAR)
AS
    pozitivne_miesta NUMBER := 0;
    negativne_miesta NUMBER := 0;
    pozitivita NUMBER;
    negativita NUMBER;
    miesta_celkom NUMBER;

    magia_identif magia.id%TYPE;
    charakter_miesta magia.charakter%TYPE;
    CURSOR cursor_magia IS SELECT presakujuca_magia FROM magicke_miesto;

    BEGIN
        SELECT COUNT(*) INTO miesta_celkom FROM magicke_miesto WHERE oblast = oblast_miesta;
        IF miesta_celkom = 0 THEN
            	DBMS_OUTPUT.put_line('Oblasť "' || oblast_miesta || '" neobsahuje žiadne magické miesta.');
        ELSE
            OPEN cursor_magia;
            LOOP
                FETCH cursor_magia INTO magia_identif;
                EXIT WHEN cursor_magia%NOTFOUND;
                SELECT magia.charakter INTO charakter_miesta FROM magia WHERE magia.id = magia_identif;

                IF charakter_miesta = 'kladný' or charakter_miesta = 'pozitívny' THEN
                    pozitivne_miesta := pozitivne_miesta + 1;
                ELSIF charakter_miesta = 'negatívny' or charakter_miesta = 'záporný' THEN
                    negativne_miesta := negativne_miesta + 1;
                END IF;
            END LOOP;
            CLOSE cursor_magia;

            pozitivita := (pozitivne_miesta / miesta_celkom) * 100;

            negativne_miesta := miesta_celkom - pozitivne_miesta;
            negativita := 100 - pozitivita;

            DBMS_OUTPUT.put_line('---------------------------------------------------------------------------');
            DBMS_OUTPUT.put_line('Štatistika pre oblasť ' || oblast_miesta || ':');
            DBMS_OUTPUT.put_line('     Miest celkom: '|| miesta_celkom );
            DBMS_OUTPUT.put_line('     Pozitívnych miest: '|| pozitivne_miesta || ' ( ' || pozitivita ||'% pozitivita )');
            DBMS_OUTPUT.put_line('     Negatívnych miest: '|| negativne_miesta || ' ( '|| negativita ||'%  negativita )');
            DBMS_OUTPUT.put_line('---------------------------------------------------------------------------');

        END IF;

        EXCEPTION WHEN NO_DATA_FOUND THEN
        BEGIN
           DBMS_OUTPUT.put_line('error: dáta v procedure pozitivita_magickeho_miesta() neboli nájdené!');
        END;
    END;

-- ukážka funkcie procedúry
BEGIN pozitivita_magickeho_miesta('Tarpotove výšiny'); END;
BEGIN pozitivita_magickeho_miesta('Neexistujúca oblasť'); END;


--2----------------------------------------



----------------======= EXPLAIN PLAN =======----------------
-- vypíše všetky grimoáre, ktorých majiteľ má úroveň kúzlenia aspoň B
-- (ide teda o úrovne B, A, S, SS)
EXPLAIN PLAN FOR
SELECT grimoar.msgn,
       kuzelnik_vlastni_grimoar.id_kuzelnika,
       kuzelnik.uroven_kuzlenia
FROM grimoar
    JOIN kuzelnik_vlastni_grimoar ON kuzelnik_vlastni_grimoar.msgn = grimoar.msgn
    JOIN kuzelnik ON kuzelnik_vlastni_grimoar.id_kuzelnika = kuzelnik.id
    WHERE kuzelnik.uroven_kuzlenia = 'B' OR
          kuzelnik.uroven_kuzlenia = 'A' OR
          kuzelnik.uroven_kuzlenia = 'S' OR
          kuzelnik.uroven_kuzlenia = 'SS'
GROUP BY grimoar.msgn, kuzelnik_vlastni_grimoar.id_kuzelnika, kuzelnik.uroven_kuzlenia;

-- výpis výstupu explain plane-u pred optimalizáciou
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- vytvorenie indexu pre úroveň kúzlenia
CREATE INDEX uroven ON kuzelnik(uroven_kuzlenia);

-- opätovný výpis po optimalizácii
EXPLAIN PLAN FOR
SELECT grimoar.msgn,
       kuzelnik_vlastni_grimoar.id_kuzelnika,
       kuzelnik.uroven_kuzlenia
FROM grimoar
    JOIN kuzelnik_vlastni_grimoar ON kuzelnik_vlastni_grimoar.msgn = grimoar.msgn
    JOIN kuzelnik ON kuzelnik_vlastni_grimoar.id_kuzelnika = kuzelnik.id
    WHERE kuzelnik.uroven_kuzlenia = 'B' OR
          kuzelnik.uroven_kuzlenia = 'A' OR
          kuzelnik.uroven_kuzlenia = 'S' OR
          kuzelnik.uroven_kuzlenia = 'SS'
GROUP BY grimoar.msgn, kuzelnik_vlastni_grimoar.id_kuzelnika, kuzelnik.uroven_kuzlenia;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

----------------======= MATERIALIZOVANÝ POHĽAD =======-----------------
-- vypíše všetky grimoáre, id ich majiteľa a počet kúzel ktoré zoskupujú
CREATE MATERIALIZED VIEW grimoar_majitel_pocet_kuzel AS
SELECT
    grimoar.msgn,
    kuzelnik_vlastni_grimoar.id_kuzelnika AS id_majitela,
    COUNT(grimoar_zoskupuje_kuzla.ev_cislo) AS pocet_kuzel
FROM grimoar
JOIN grimoar_zoskupuje_kuzla ON grimoar.msgn = grimoar_zoskupuje_kuzla.msgn
JOIN kuzelnik_vlastni_grimoar ON grimoar.msgn = kuzelnik_vlastni_grimoar.msgn
GROUP BY grimoar.msgn, kuzelnik_vlastni_grimoar.id_kuzelnika;

-- zobrazenie materializovaného pohľadu
SELECT * FROM grimoar_majitel_pocet_kuzel;

-- grimoáre kúzelnika s id 823 presunieme kúzelnikovi s id 172
UPDATE kuzelnik_vlastni_grimoar SET id_kuzelnika = 172 WHERE id_kuzelnika = 823;

-- hodnoty sa zmenili:
SELECT
    grimoar.msgn,
    kuzelnik_vlastni_grimoar.id_kuzelnika AS id_majitela,
    COUNT(grimoar_zoskupuje_kuzla.ev_cislo) AS pocet_kuzel
FROM grimoar
JOIN grimoar_zoskupuje_kuzla ON grimoar.msgn = grimoar_zoskupuje_kuzla.msgn
JOIN kuzelnik_vlastni_grimoar ON grimoar.msgn = kuzelnik_vlastni_grimoar.msgn
GROUP BY grimoar.msgn, kuzelnik_vlastni_grimoar.id_kuzelnika;

-- v materializovanom pohľade však ostali rovnaké:
SELECT * FROM grimoar_majitel_pocet_kuzel;


----------------======= PRÍSTUPOVÉ PRÁVA =======-----------------
-- definícia prístupových práv k db objektom pre druhého člena týmu
GRANT ALL ON magia TO XZATOV00;
GRANT ALL ON element TO XZATOV00;
GRANT ALL ON zvitok TO XZATOV00;
GRANT ALL ON kuzlo TO XZATOV00;
GRANT ALL ON kuzelnik TO XZATOV00;
GRANT ALL ON grimoar TO XZATOV00;
GRANT ALL ON magicke_miesto TO XZATOV00;
GRANT ALL ON kuzelnik_vlastni_grimoar TO XZATOV00;
GRANT ALL ON vedlajsi_element_kuzla TO XZATOV00;
GRANT ALL ON grimoar_zoskupuje_kuzla TO XZATOV00;
GRANT ALL ON kuzelnikova_synergia_s_elementom TO XZATOV00;

-- povolenie pre procedury
GRANT EXECUTE ON pozitivita_magickeho_miesta TO XZATOV00;
-- GRANT EXECUTE ON name_of_procedure2 TO XZATOV00;

-- povolenie pre materialized view
GRANT ALL ON grimoar_majitel_pocet_kuzel TO XZATOV00;
