--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.2
-- Dumped by pg_dump version 9.4.2
-- Started on 2015-05-28 14:59:21 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2089 (class 1262 OID 16384)
-- Name: robocode; Type: DATABASE; Schema: -; Owner: robocode-admin
--

CREATE DATABASE robocode WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE robocode OWNER TO "robocode-admin";

\connect robocode

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 182 (class 3079 OID 11895)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2092 (class 0 OID 0)
-- Dependencies: 182
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 173 (class 1259 OID 16418)
-- Name: author; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE author (
    id integer NOT NULL,
    name character varying NOT NULL,
    activation_code text,
    activated boolean DEFAULT false NOT NULL,
    email text,
    creation_date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE author OWNER TO "robocode-admin";

--
-- TOC entry 172 (class 1259 OID 16416)
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE authors_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 2094 (class 0 OID 0)
-- Dependencies: 172
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE authors_id_seq OWNED BY author.id;


--
-- TOC entry 175 (class 1259 OID 16429)
-- Name: battle; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE battle (
    id integer NOT NULL,
    first_participant integer NOT NULL,
    second_participant integer NOT NULL,
    tournament integer
);


ALTER TABLE battle OWNER TO "robocode-admin";

--
-- TOC entry 174 (class 1259 OID 16427)
-- Name: battles_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE battles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE battles_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 174
-- Name: battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE battles_id_seq OWNED BY battle.id;


--
-- TOC entry 177 (class 1259 OID 16437)
-- Name: finished_battle; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE finished_battle (
    id integer NOT NULL,
    battle integer NOT NULL,
    first_participant_won boolean NOT NULL
);


ALTER TABLE finished_battle OWNER TO "robocode-admin";

--
-- TOC entry 176 (class 1259 OID 16435)
-- Name: finished_battles_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE finished_battles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE finished_battles_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 2100 (class 0 OID 0)
-- Dependencies: 176
-- Name: finished_battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE finished_battles_id_seq OWNED BY finished_battle.id;


--
-- TOC entry 179 (class 1259 OID 16445)
-- Name: participant; Type: TABLE; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE TABLE participant (
    id integer NOT NULL,
    name character varying NOT NULL,
    author integer NOT NULL,
    class text NOT NULL
);


ALTER TABLE participant OWNER TO "robocode-admin";

--
-- TOC entry 178 (class 1259 OID 16443)
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: robocode-admin
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE participants_id_seq OWNER TO "robocode-admin";

--
-- TOC entry 2103 (class 0 OID 0)
-- Dependencies: 178
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: robocode-admin
--

ALTER SEQUENCE participants_id_seq OWNED BY participant.id;


--
-- TOC entry 180 (class 1259 OID 16494)
-- Name: tournament; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament (
    id integer NOT NULL,
    run_at timestamp without time zone
);


ALTER TABLE tournament OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 16497)
-- Name: tournament_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tournament_id_seq OWNER TO postgres;

--
-- TOC entry 2105 (class 0 OID 0)
-- Dependencies: 181
-- Name: tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_id_seq OWNED BY tournament.id;


--
-- TOC entry 1945 (class 2604 OID 16421)
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY author ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- TOC entry 1948 (class 2604 OID 16432)
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle ALTER COLUMN id SET DEFAULT nextval('battles_id_seq'::regclass);


--
-- TOC entry 1949 (class 2604 OID 16440)
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY finished_battle ALTER COLUMN id SET DEFAULT nextval('finished_battles_id_seq'::regclass);


--
-- TOC entry 1950 (class 2604 OID 16448)
-- Name: id; Type: DEFAULT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY participant ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- TOC entry 1951 (class 2604 OID 16499)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament ALTER COLUMN id SET DEFAULT nextval('tournament_id_seq'::regclass);


--
-- TOC entry 1953 (class 2606 OID 16426)
-- Name: authors_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT authors_pk PRIMARY KEY (id);


--
-- TOC entry 1959 (class 2606 OID 16434)
-- Name: battles_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT battles_pk PRIMARY KEY (id);


--
-- TOC entry 1962 (class 2606 OID 16442)
-- Name: finished_battles_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY finished_battle
    ADD CONSTRAINT finished_battles_pk PRIMARY KEY (id);


--
-- TOC entry 1964 (class 2606 OID 16453)
-- Name: participants_pk; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT participants_pk PRIMARY KEY (id);


--
-- TOC entry 1970 (class 2606 OID 16504)
-- Name: tournament_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament
    ADD CONSTRAINT tournament_pk PRIMARY KEY (id);


--
-- TOC entry 1955 (class 2606 OID 16489)
-- Name: unique_activation_code; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT unique_activation_code UNIQUE (activation_code);


--
-- TOC entry 1957 (class 2606 OID 16477)
-- Name: unique_email; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- TOC entry 1966 (class 2606 OID 16491)
-- Name: unique_participant_name; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT unique_participant_name UNIQUE (name);


--
-- TOC entry 1968 (class 2606 OID 16493)
-- Name: unique_participants_class; Type: CONSTRAINT; Schema: public; Owner: robocode-admin; Tablespace: 
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT unique_participants_class UNIQUE (class);


--
-- TOC entry 1960 (class 1259 OID 16510)
-- Name: fki_battle_tournament_fk; Type: INDEX; Schema: public; Owner: robocode-admin; Tablespace: 
--

CREATE INDEX fki_battle_tournament_fk ON battle USING btree (tournament);


--
-- TOC entry 1975 (class 2606 OID 16454)
-- Name: authors_participants; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY participant
    ADD CONSTRAINT authors_participants FOREIGN KEY (author) REFERENCES author(id);


--
-- TOC entry 1973 (class 2606 OID 16505)
-- Name: battle_tournament_fk; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT battle_tournament_fk FOREIGN KEY (tournament) REFERENCES tournament(id);


--
-- TOC entry 1974 (class 2606 OID 16459)
-- Name: battles_finished_battles; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY finished_battle
    ADD CONSTRAINT battles_finished_battles FOREIGN KEY (battle) REFERENCES battle(id);


--
-- TOC entry 1971 (class 2606 OID 16464)
-- Name: participants_scheduled_battles_first; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT participants_scheduled_battles_first FOREIGN KEY (first_participant) REFERENCES participant(id);


--
-- TOC entry 1972 (class 2606 OID 16469)
-- Name: participants_scheduled_battles_second; Type: FK CONSTRAINT; Schema: public; Owner: robocode-admin
--

ALTER TABLE ONLY battle
    ADD CONSTRAINT participants_scheduled_battles_second FOREIGN KEY (second_participant) REFERENCES participant(id);


--
-- TOC entry 2091 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 2093 (class 0 OID 0)
-- Dependencies: 173
-- Name: author; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE author FROM PUBLIC;
REVOKE ALL ON TABLE author FROM "robocode-admin";
GRANT ALL ON TABLE author TO "robocode-admin";
GRANT ALL ON TABLE author TO robocode;


--
-- TOC entry 2095 (class 0 OID 0)
-- Dependencies: 172
-- Name: authors_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE authors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE authors_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE authors_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE authors_id_seq TO robocode;


--
-- TOC entry 2096 (class 0 OID 0)
-- Dependencies: 175
-- Name: battle; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE battle FROM PUBLIC;
REVOKE ALL ON TABLE battle FROM "robocode-admin";
GRANT ALL ON TABLE battle TO "robocode-admin";
GRANT ALL ON TABLE battle TO robocode;


--
-- TOC entry 2098 (class 0 OID 0)
-- Dependencies: 174
-- Name: battles_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE battles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE battles_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE battles_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE battles_id_seq TO robocode;


--
-- TOC entry 2099 (class 0 OID 0)
-- Dependencies: 177
-- Name: finished_battle; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE finished_battle FROM PUBLIC;
REVOKE ALL ON TABLE finished_battle FROM "robocode-admin";
GRANT ALL ON TABLE finished_battle TO "robocode-admin";
GRANT ALL ON TABLE finished_battle TO robocode;


--
-- TOC entry 2101 (class 0 OID 0)
-- Dependencies: 176
-- Name: finished_battles_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE finished_battles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE finished_battles_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE finished_battles_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE finished_battles_id_seq TO robocode;


--
-- TOC entry 2102 (class 0 OID 0)
-- Dependencies: 179
-- Name: participant; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON TABLE participant FROM PUBLIC;
REVOKE ALL ON TABLE participant FROM "robocode-admin";
GRANT ALL ON TABLE participant TO "robocode-admin";
GRANT ALL ON TABLE participant TO robocode;


--
-- TOC entry 2104 (class 0 OID 0)
-- Dependencies: 178
-- Name: participants_id_seq; Type: ACL; Schema: public; Owner: robocode-admin
--

REVOKE ALL ON SEQUENCE participants_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE participants_id_seq FROM "robocode-admin";
GRANT ALL ON SEQUENCE participants_id_seq TO "robocode-admin";
GRANT ALL ON SEQUENCE participants_id_seq TO robocode;


-- Completed on 2015-05-28 14:59:21 CEST

--
-- PostgreSQL database dump complete
--

