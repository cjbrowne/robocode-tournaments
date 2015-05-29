--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.15
-- Dumped by pg_dump version 9.1.15
-- Started on 2015-05-29 12:53:42 CEST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1945 (class 1262 OID 16469)
-- Name: robocode; Type: DATABASE; Schema: -; Owner: robocode-admin
--

CREATE DATABASE robocode WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE robocode OWNER TO "robocode-admin";

\connect robocode

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 171 (class 3079 OID 11677)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1948 (class 0 OID 0)
-- Dependencies: 171
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 161 (class 1259 OID 16470)
-- Dependencies: 1809 1810 6
-- Name: author; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE author (
    id integer NOT NULL,
    name character varying NOT NULL,
    activation_code text,
    activated boolean DEFAULT false NOT NULL,
    email text,
    creation_date timestamp without time zone DEFAULT now() NOT NULL,
    secret text
);


ALTER TABLE public.author OWNER TO "robocode-admin";

--
-- TOC entry 162 (class 1259 OID 16478)
-- Dependencies: 161 6
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authors_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 1950 (class 0 OID 0)
-- Dependencies: 162
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE authors_id_seq OWNED BY author.id;


--
-- TOC entry 163 (class 1259 OID 16480)
-- Dependencies: 6
-- Name: battle; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE battle (
    id integer NOT NULL,
    first_participant integer NOT NULL,
    second_participant integer NOT NULL,
    tournament integer
);


ALTER TABLE public.battle OWNER TO "robocode-admin";

--
-- TOC entry 164 (class 1259 OID 16483)
-- Dependencies: 6 163
-- Name: battles_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE battles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.battles_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 1953 (class 0 OID 0)
-- Dependencies: 164
-- Name: battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE battles_id_seq OWNED BY battle.id;


--
-- TOC entry 165 (class 1259 OID 16485)
-- Dependencies: 6
-- Name: finished_battle; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE finished_battle (
    id integer NOT NULL,
    battle integer NOT NULL,
    first_participant_won boolean NOT NULL
);


ALTER TABLE public.finished_battle OWNER TO "robocode-admin";

--
-- TOC entry 166 (class 1259 OID 16488)
-- Dependencies: 165 6
-- Name: finished_battles_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE finished_battles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.finished_battles_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 1956 (class 0 OID 0)
-- Dependencies: 166
-- Name: finished_battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE finished_battles_id_seq OWNED BY finished_battle.id;


--
-- TOC entry 167 (class 1259 OID 16490)
-- Dependencies: 6
-- Name: participant; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE participant (
    id integer NOT NULL,
    name character varying NOT NULL,
    author integer NOT NULL,
    class text NOT NULL
);


ALTER TABLE public.participant OWNER TO "robocode-admin";

--
-- TOC entry 168 (class 1259 OID 16496)
-- Dependencies: 167 6
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participants_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 1959 (class 0 OID 0)
-- Dependencies: 168
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE participants_id_seq OWNED BY participant.id;


--
-- TOC entry 169 (class 1259 OID 16498)
-- Dependencies: 6
-- Name: tournament; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament (
    id integer NOT NULL,
    run_at timestamp without time zone
);


ALTER TABLE public.tournament OWNER TO postgres;

--
-- TOC entry 170 (class 1259 OID 16501)
-- Dependencies: 6 169
-- Name: tournament_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_id_seq OWNER TO postgres;

--
-- TOC entry 1961 (class 0 OID 0)
-- Dependencies: 170
-- Name: tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_id_seq OWNED BY tournament.id;


--
-- TOC entry 1811 (class 2604 OID 16503)
-- Dependencies: 162 161
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY author ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- TOC entry 1812 (class 2604 OID 16504)
-- Dependencies: 164 163
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle ALTER COLUMN id SET DEFAULT nextval('battles_id_seq'::regclass);


--
-- TOC entry 1813 (class 2604 OID 16505)
-- Dependencies: 166 165
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY finished_battle ALTER COLUMN id SET DEFAULT nextval('finished_battles_id_seq'::regclass);


--
-- TOC entry 1814 (class 2604 OID 16506)
-- Dependencies: 168 167
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY participant ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- TOC entry 1815 (class 2604 OID 16507)
-- Dependencies: 170 169
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament ALTER COLUMN id SET DEFAULT nextval('tournament_id_seq'::regclass);


--
-- TOC entry 1817 (class 2606 OID 16509)
-- Dependencies: 161 161 1942
-- Name: authors_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT authors_pk PRIMARY KEY (id);


--
-- TOC entry 1823 (class 2606 OID 16511)
-- Dependencies: 163 163 1942
-- Name: battles_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT battles_pk PRIMARY KEY (id);


--
-- TOC entry 1826 (class 2606 OID 16513)
-- Dependencies: 165 165 1942
-- Name: finished_battles_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY finished_battle
    ADD CONSTRAINT finished_battles_pk PRIMARY KEY (id);


--
-- TOC entry 1828 (class 2606 OID 16515)
-- Dependencies: 167 167 1942
-- Name: participants_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT participants_pk PRIMARY KEY (id);


--
-- TOC entry 1834 (class 2606 OID 16517)
-- Dependencies: 169 169 1942
-- Name: tournament_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament
    ADD CONSTRAINT tournament_pk PRIMARY KEY (id);


--
-- TOC entry 1819 (class 2606 OID 16519)
-- Dependencies: 161 161 1942
-- Name: unique_activation_code; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT unique_activation_code UNIQUE (activation_code);


--
-- TOC entry 1821 (class 2606 OID 16521)
-- Dependencies: 161 161 1942
-- Name: unique_email; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- TOC entry 1830 (class 2606 OID 16523)
-- Dependencies: 167 167 1942
-- Name: unique_participant_name; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT unique_participant_name UNIQUE (name);


--
-- TOC entry 1832 (class 2606 OID 16525)
-- Dependencies: 167 167 1942
-- Name: unique_participants_class; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT unique_participants_class UNIQUE (class);


--
-- TOC entry 1824 (class 1259 OID 16526)
-- Dependencies: 163 1942
-- Name: fki_battle_tournament_fk; Type: INDEX; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE INDEX fki_battle_tournament_fk ON battle USING btree (tournament);


--
-- TOC entry 1839 (class 2606 OID 16527)
-- Dependencies: 161 167 1816 1942
-- Name: authors_participants; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT authors_participants FOREIGN KEY (author) REFERENCES author(id);


--
-- TOC entry 1835 (class 2606 OID 16532)
-- Dependencies: 169 163 1833 1942
-- Name: battle_tournament_fk; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT battle_tournament_fk FOREIGN KEY (tournament) REFERENCES tournament(id);


--
-- TOC entry 1838 (class 2606 OID 16537)
-- Dependencies: 1822 163 165 1942
-- Name: battles_finished_battles; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY finished_battle
    ADD CONSTRAINT battles_finished_battles FOREIGN KEY (battle) REFERENCES battle(id);


--
-- TOC entry 1836 (class 2606 OID 16542)
-- Dependencies: 167 1827 163 1942
-- Name: participants_scheduled_battles_first; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT participants_scheduled_battles_first FOREIGN KEY (first_participant) REFERENCES participant(id);


--
-- TOC entry 1837 (class 2606 OID 16547)
-- Dependencies: 1827 167 163 1942
-- Name: participants_scheduled_battles_second; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT participants_scheduled_battles_second FOREIGN KEY (second_participant) REFERENCES participant(id);


--
-- TOC entry 1947 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 1949 (class 0 OID 0)
-- Dependencies: 161
-- Name: author; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE author FROM PUBLIC;
REVOKE ALL ON TABLE author FROM "robocode-admin";
GRANT ALL ON TABLE author TO "robocode-admin";
GRANT ALL ON TABLE author TO robocode;


--
-- TOC entry 1951 (class 0 OID 0)
-- Dependencies: 162
-- Name: authors_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE authors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE authors_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE authors_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE authors_id_seq TO robocode;


--
-- TOC entry 1952 (class 0 OID 0)
-- Dependencies: 163
-- Name: battle; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE battle FROM PUBLIC;
REVOKE ALL ON TABLE battle FROM "robocode-admin";
GRANT ALL ON TABLE battle TO "robocode-admin";
GRANT ALL ON TABLE battle TO robocode;


--
-- TOC entry 1954 (class 0 OID 0)
-- Dependencies: 164
-- Name: battles_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE battles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE battles_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE battles_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE battles_id_seq TO robocode;


--
-- TOC entry 1955 (class 0 OID 0)
-- Dependencies: 165
-- Name: finished_battle; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE finished_battle FROM PUBLIC;
REVOKE ALL ON TABLE finished_battle FROM "robocode-admin";
GRANT ALL ON TABLE finished_battle TO "robocode-admin";
GRANT ALL ON TABLE finished_battle TO robocode;


--
-- TOC entry 1957 (class 0 OID 0)
-- Dependencies: 166
-- Name: finished_battles_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE finished_battles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE finished_battles_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE finished_battles_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE finished_battles_id_seq TO robocode;


--
-- TOC entry 1958 (class 0 OID 0)
-- Dependencies: 167
-- Name: participant; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE participant FROM PUBLIC;
REVOKE ALL ON TABLE participant FROM "robocode-admin";
GRANT ALL ON TABLE participant TO "robocode-admin";
GRANT ALL ON TABLE participant TO robocode;


--
-- TOC entry 1960 (class 0 OID 0)
-- Dependencies: 168
-- Name: participants_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE participants_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE participants_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE participants_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE participants_id_seq TO robocode;


-- Completed on 2015-05-29 12:53:42 CEST

--
-- PostgreSQL database dump complete
--

