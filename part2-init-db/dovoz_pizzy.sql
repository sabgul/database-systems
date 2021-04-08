DROP TABLE pizzerie CASCADE CONSTRAINTS;
DROP TABLE druh_pizzy CASCADE CONSTRAINTS;
DROP TABLE provozni_doba CASCADE CONSTRAINTS;
DROP TABLE objednavka CASCADE CONSTRAINTS;
DROP TABLE objednavka_druh_pizzy CASCADE CONSTRAINTS;
DROP TABLE dostupnost CASCADE CONSTRAINTS;
DROP TABLE zakaznik CASCADE CONSTRAINTS;
DROP TABLE se_zabavou CASCADE CONSTRAINTS;
DROP TABLE druh_zabavy CASCADE CONSTRAINTS;


CREATE TABLE pizzerie
(
    nazev   VARCHAR(70) NOT NULL,
    adresa  VARCHAR(100) NOT NULL,
    telefon VARCHAR(70),
    majitel INT NOT NULL,

    CONSTRAINT pizzerie_pk PRIMARY KEY (nazev, adresa),
    CONSTRAINT pizzerie_fk FOREIGN KEY (majitel) REFERENCES zakaznik (id) ON DELETE CASCADE
);

CREATE TABLE druh_pizzy
(
    nazev_pizzerie       VARCHAR(70) NOT NULL,
    adresa_pizzerie      VARCHAR(100) NOT NULL,
    jmeno                VARCHAR(70) NOT NULL,
    cena                 NUMERIC(4,2) NOT NULL,
    krusta               VARCHAR(70),
    objednavka           INT NOT NULL,

    CONSTRAINT druh_pizzy_pk PRIMARY KEY (nazev_pizzerie, adresa_pizzerie, jmeno),
    CONSTRAINT druh_pizzy_fk_nazev FOREIGN KEY (nazev_pizzerie) REFERENCES pizzerie (nazev) ON DELETE CASCADE,
    CONSTRAINT druh_pizzy_fk_adresa FOREIGN KEY (adresa_pizzerie) REFERENCES pizzerie (adresa) ON DELETE CASCADE,
    CONSTRAINT druh_pizzy_fk_objednavka FOREIGN KEY (objednavka) REFERENCES objednavka (id) ON DELETE CASCADE
);

CREATE TABLE provozni_doba
(
    nazev_pizzerie     VARCHAR(70) NOT NULL,
    adresa_pizzerie    VARCHAR(100) NOT NULL,
    den_v_tydnu        VARCHAR(8) NOT NULL,
    od                 VARCHAR(5), -- format: 00:00
    do                 VARCHAR(5),

    CONSTRAINT provozni_doba_pk PRIMARY KEY (nazev_pizzerie, adresa_pizzerie, den_v_tydnu),
    CONSTRAINT provozni_doba_fk_nazev FOREIGN KEY (nazev_pizzerie) REFERENCES pizzerie (nazev) ON DELETE CASCADE,
    CONSTRAINT provozni_doba_fk_adresa FOREIGN KEY (adresa_pizzerie) REFERENCES pizzerie (adresa) ON DELETE CASCADE,
);

CREATE TABLE objednavka
(
    id                  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    datum_objednavky    DATE DEFAULT CURRENT_DATE NOT NULL ,
    cas_objednavky      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    datum_doruceni      DATE, -- todo check how this works
    cas_doruceni        TIMESTAMP,
    objednavatel        INT NOT NULL,

    CONSTRAINT objednavka_fk FOREIGN KEY (objednavatel) REFERENCES zakaznik (id)
);

CREATE TABLE objednavka_druh_pizzy
(
    id                  INT NOT NULL,
    nazev_pizzerie      VARCHAR(70) NOT NULL,
    adresa_pizzerie     VARCHAR(100) NOT NULL,
    jmeno_pizzy         VARCHAR(70) NOT NULL,
    pocet               INT NOT NULL,

    CONSTRAINT objednavka_druh_pizzy_pk PRIMARY KEY (id, nazev_pizzerie, adresa_pizzerie, jmeno_pizzy),
    CONSTRAINT objednavka_druh_pizzy_fk_objednavka FOREIGN KEY (id) REFERENCES objednavka (id) ON DELETE CASCADE,
    CONSTRAINT objednavka_druh_pizzy_fk_druh_pizzy_nazev FOREIGN KEY (nazev_pizzerie) REFERENCES pizzerie (nazev) ON DELETE CASCADE,
    CONSTRAINT objednavka_druh_pizzy_fk_druh_pizzy_adresa FOREIGN KEY (adresa_pizzerie) REFERENCES pizzerie (adresa) ON DELETE CASCADE,
    CONSTRAINT objednavka_druh_pizzy_fk_druh_pizzy_jmeno FOREIGN KEY (jmeno_pizzy) REFERENCES druh_pizzy (jmeno) ON DELETE CASCADE
);

CREATE TABLE dostupnost
(
    den_v_tydnu VARCHAR(7) NOT NULL, -- 'pondeli'
    id_bavice   INT NOT NULL,
    od          VARCHAR(5), -- format napr 08:00
    do          VARCHAR(5), --             23:00

    CONSTRAINT dostupnost_pk PRIMARY KEY (den_v_tydnu, id_bavice),
    CONSTRAINT dostupnost_fk FOREIGN KEY (id_bavice) REFERENCES zakaznik (id)
);

CREATE TABLE zakaznik
(
    id                  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    jmeno               VARCHAR(70) NOT NULL,
    datum_narozeni      DATE NOT NULL,
    kontaktni_adresa    VARCHAR(100) NOT NULL,
    typ                 VARCHAR(70) NOT NULL, -- bavic / hladovyZakaznik / vlastnikFirmy
    nazev_sceny         VARCHAR(70) DEFAULT NULL,
    zivotopis           VARCHAR(500) DEFAULT NULL ,
    cena_za_30_min      NUMERIC(5,2) DEFAULT NULL,
    dorucovaci_adresa   VARCHAR(100) DEFAULT NULL,
    linkedin_ucet       VARCHAR(100) DEFAULT NULL,
    druh_zabavy         VARCHAR(50) DEFAULT NULL,

    --todo constraints
    CONSTRAINT zakaznik_pk PRIMARY KEY (id),
    CONSTRAINT zakaznik_fk_druh_zabavy FOREIGN KEY (druh_zabavy) REFERENCES druh_zabavy (nazev)
);

CREATE TABLE se_zabavou
(
    id           INT NOT NULL,
    delka_zabavy VARCHAR(50), -- napr 1h 20min
    nazev_zabavy VARCHAR(50),

    CONSTRAINT se_zabavou_pk PRIMARY KEY (id),
    CONSTRAINT se_zabavou_fk_id FOREIGN KEY (id) REFERENCES objednavka (id),
    CONSTRAINT se_zabavou_fk_nazev FOREIGN KEY (nazev_zabavy) REFERENCES druh_zabavy (nazev)
);

CREATE TABLE druh_zabavy
(
    nazev VARCHAR(70),

    CONSTRAINT druh_zabavy_pk PRIMARY KEY (nazev)
);

-- vytvorenie spojovacej tabulky pre vazbu m:n
CREATE TABLE bavic_druh_zabavy
(
    id_bavice    INT NOT NULL,
    nazev_zabavy VARCHAR(70) NOT NULL,

    CONSTRAINT bavic_druh_zabavy_pk PRIMARY KEY (nazev_zabavy, id_bavice),
    CONSTRAINT bavic_druh_zabavy_fk_zabava FOREIGN KEY (nazev_zabavy) REFERENCES druh_zabavy (nazev),
    CONSTRAINT bavic_druh_zabavy_fk_bavic FOREIGN KEY (id_bavice) REFERENCES zakaznik (id)
);

-- inserty



-- selekty
SELECT * FROM pizzerie;
SELECT * FROM druh_pizzy;
SELECT * FROM provozni_doba;
SELECT * FROM objednavka;
SELECT * FROM objednavka_druh_pizzy;
SELECT * FROM dostupnost;
SELECT * FROM zakaznik;
SELECT * FROM se_zabavou;
SELECT * FROM druh_zabavy;