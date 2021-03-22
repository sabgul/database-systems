DROP TABLE pizzerie CASCADE CONSTRAINTS;
DROP TABLE druh_pizzy CASCADE CONSTRAINTS;
DROP TABLE provozni_doba CASCADE CONSTRAINTS;
DROP TABLE objednavka CASCADE CONSTRAINTS;
DROP TABLE objednavka_druh_pizzy CASCADE CONSTRAINTS;
DROP TABLE dostupnost CASCADE CONSTRAINTS;
DROP TABLE zakaznik CASCADE CONSTRAINTS;
DROP TABLE se_zabavou CASCADE CONSTRAINTS;
DROP TABLE druh_zabavy CASCADE CONSTRAINTS;
DROP TABLE bavic_druh_zabavy CASCADE CONSTRAINTS;

CREATE TABLE druh_zabavy
(
    nazev VARCHAR(70),

    CONSTRAINT druh_zabavy_pk PRIMARY KEY (nazev)
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
    cena_za_30_min      VARCHAR(10) DEFAULT NULL,
    druh_zabavy         VARCHAR(50) DEFAULT NULL,
    dorucovaci_adresa   VARCHAR(100) DEFAULT NULL,
    linkedin_ucet       VARCHAR(100) DEFAULT NULL,

    CONSTRAINT zakaznik_fk_druh_zabavy FOREIGN KEY (druh_zabavy) REFERENCES druh_zabavy (nazev)
);

CREATE TABLE objednavka
(
    id                  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    datum_objednavky    DATE DEFAULT CURRENT_DATE NOT NULL ,
    cas_objednavky      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    datum_doruceni      VARCHAR(50) NOT NULL,
    cas_doruceni        VARCHAR(50) NOT NULL,
    objednavatel        INT NOT NULL,

    CONSTRAINT objednavka_fk FOREIGN KEY (objednavatel) REFERENCES zakaznik (id)
);

CREATE TABLE pizzerie
(
    nazev   VARCHAR(70) NOT NULL,
    adresa  VARCHAR(100) NOT NULL,
    telefon VARCHAR(70),
    majitel INT NOT NULL,

    CONSTRAINT pizzerie_pk PRIMARY KEY (nazev, adresa),
    CONSTRAINT pizzerie_fk FOREIGN KEY (majitel) REFERENCES zakaznik (id) ON DELETE CASCADE
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

CREATE TABLE se_zabavou
(
    id           INT NOT NULL,
    delka_zabavy VARCHAR(50), -- napr 1h 20min
    nazev_zabavy VARCHAR(50),

    CONSTRAINT se_zabavou_pk PRIMARY KEY (id),
    CONSTRAINT se_zabavou_fk_id FOREIGN KEY (id) REFERENCES objednavka (id),
    CONSTRAINT se_zabavou_fk_nazev FOREIGN KEY (nazev_zabavy) REFERENCES druh_zabavy (nazev)
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

CREATE TABLE druh_pizzy
(
    nazev_pizzerie       VARCHAR(70) NOT NULL,
    adresa_pizzerie      VARCHAR(100) NOT NULL,
    jmeno                VARCHAR(70) NOT NULL,
    cena                 VARCHAR(10) NOT NULL,
    krusta               VARCHAR(70),
    objednavka           INT NOT NULL,

    CONSTRAINT druh_pizzy_pk PRIMARY KEY (nazev_pizzerie, adresa_pizzerie, jmeno),
    CONSTRAINT druh_pizzy_fk_nazev FOREIGN KEY (nazev_pizzerie, adresa_pizzerie) REFERENCES pizzerie (nazev, adresa) ON DELETE CASCADE,
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
    CONSTRAINT provozni_doba_fk_nazev FOREIGN KEY (nazev_pizzerie, adresa_pizzerie) REFERENCES pizzerie (nazev, adresa) ON DELETE CASCADE
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
    CONSTRAINT objednavka_druh_pizzy_fk_druh_pizzy_jmeno FOREIGN KEY (nazev_pizzerie, adresa_pizzerie, jmeno_pizzy) REFERENCES druh_pizzy (nazev_pizzerie, adresa_pizzerie, jmeno) ON DELETE CASCADE
);


-- inserty
INSERT INTO druh_zabavy
    VALUES ('Napodobnovanie hereckych vykonov');

INSERT INTO zakaznik
    VALUES (default, 'John Smith', '30-November-1980', 'Ptašínského 6, Brno - Královo Pole', 'vlastnikFirmy', NULL, NULL, NULL, NULL, NULL, 'linkedin.com/SmithJohnJr');

INSERT INTO zakaznik
    VALUES (default, 'Kristof Kolumbus', '12-September-1995', 'Foustkova 2, Brno - Žabovřesky', 'hladovyZakaznik', NULL, NULL, NULL, NULL, 'Foustkova 2, Brno - Žabovřesky', NULL);

INSERT INTO zakaznik
    VALUES (default, 'Vincent Carls', '2-December-1999', 'Přístavní 12, Brno - Bystrc', 'bavic', 'Absurdna drama', '2000 - sucasnost - Profesionalny bavic', '300 kc', 'Napodobnovanie hereckych vykonov', NULL, NULL);

INSERT INTO objednavka                                                      
    VALUES (default, DEFAULT, DEFAULT, '22-March-2021', '12:45:07', 2);

INSERT INTO pizzerie
    VALUES ('Dominos', 'Luční 7, Brno - Žabovřesky', '+420123456789', 1);

INSERT INTO dostupnost
    VALUES ('Pondeli', 3, '15:00', '21:00');

INSERT INTO bavic_druh_zabavy
    VALUES (3, 'Napodobnovanie hereckych vykonov');

INSERT INTO druh_pizzy
    VALUES ('Dominos', 'Luční 7, Brno - Žabovřesky', 'Margherita', '120 kc', 'Celozrnna', 1);

INSERT INTO provozni_doba
    VALUES ('Dominos', 'Luční 7, Brno - Žabovřesky', 'Pondeli', '7:30', '22:00');

INSERT INTO objednavka_druh_pizzy
    VALUES (1, 'Dominos', 'Luční 7, Brno - Žabovřesky', 'Margherita', 5);

INSERT INTO se_zabavou
    VALUES (1, '2h 30min', 'Napodobnovanie hereckych vykonov');

SELECT * FROM pizzerie;
SELECT * FROM zakaznik;
SELECT * FROM dostupnost;
SELECT * FROM druh_pizzy;
SELECT * FROM objednavka;
SELECT * FROM provozni_doba;
SELECT * FROM objednavka_druh_pizzy;
SELECT * FROM se_zabavou;
SELECT * FROM druh_zabavy;
SELECT * FROM bavic_druh_zabavy;