--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Debian 15.4-2.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Debian 15.4-2.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: gen_hasura_uuid(); Type: FUNCTION; Schema: hdb_catalog; Owner: postgres
--

CREATE FUNCTION hdb_catalog.gen_hasura_uuid() RETURNS uuid
    LANGUAGE sql
    AS $$select gen_random_uuid()$$;


ALTER FUNCTION hdb_catalog.gen_hasura_uuid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hdb_action_log; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_action_log (
    id uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    action_name text,
    input_payload jsonb NOT NULL,
    request_headers jsonb NOT NULL,
    session_variables jsonb NOT NULL,
    response_payload jsonb,
    errors jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    response_received_at timestamp with time zone,
    status text NOT NULL,
    CONSTRAINT hdb_action_log_status_check CHECK ((status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text])))
);


ALTER TABLE hdb_catalog.hdb_action_log OWNER TO postgres;

--
-- Name: hdb_cron_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_cron_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_cron_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    trigger_name text NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_cron_events OWNER TO postgres;

--
-- Name: hdb_metadata; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_metadata (
    id integer NOT NULL,
    metadata json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL
);


ALTER TABLE hdb_catalog.hdb_metadata OWNER TO postgres;

--
-- Name: hdb_scheduled_event_invocation_logs; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_event_invocation_logs (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    event_id text,
    status integer,
    request json,
    response json,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs OWNER TO postgres;

--
-- Name: hdb_scheduled_events; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_scheduled_events (
    id text DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    webhook_conf json NOT NULL,
    scheduled_time timestamp with time zone NOT NULL,
    retry_conf json,
    payload json,
    header_conf json,
    status text DEFAULT 'scheduled'::text NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    next_retry_at timestamp with time zone,
    comment text,
    CONSTRAINT valid_status CHECK ((status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text])))
);


ALTER TABLE hdb_catalog.hdb_scheduled_events OWNER TO postgres;

--
-- Name: hdb_schema_notifications; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_schema_notifications (
    id integer NOT NULL,
    notification json NOT NULL,
    resource_version integer DEFAULT 1 NOT NULL,
    instance_id uuid NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hdb_schema_notifications_id_check CHECK ((id = 1))
);


ALTER TABLE hdb_catalog.hdb_schema_notifications OWNER TO postgres;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: postgres
--

CREATE TABLE hdb_catalog.hdb_version (
    hasura_uuid uuid DEFAULT hdb_catalog.gen_hasura_uuid() NOT NULL,
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL,
    cli_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    console_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    ee_client_id text,
    ee_client_secret text
);


ALTER TABLE hdb_catalog.hdb_version OWNER TO postgres;

--
-- Name: actors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actors (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    introduce text,
    birthday date,
    is_delete boolean DEFAULT false NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    image_actor text
);


ALTER TABLE public.actors OWNER TO postgres;

--
-- Name: TABLE actors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.actors IS 'Diß╗àn vi├¬n';


--
-- Name: actors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actors_id_seq OWNER TO postgres;

--
-- Name: actors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actors_id_seq OWNED BY public.actors.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    email text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_delete boolean DEFAULT false NOT NULL
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- Name: TABLE admins; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.admins IS 'T├ái khoß║ún admin';


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    name_en text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_by integer,
    is_delete boolean DEFAULT false
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: TABLE categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.categories IS 'Thß╗â loß║íi phim';


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_id_seq OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.categories.id;


--
-- Name: comment_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_likes (
    id integer NOT NULL,
    comment_id integer NOT NULL,
    user_like_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_unlike boolean DEFAULT false NOT NULL
);


ALTER TABLE public.comment_likes OWNER TO postgres;

--
-- Name: TABLE comment_likes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.comment_likes IS 'Th├¡ch b├¼nh luß║¡n';


--
-- Name: comment_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_likes_id_seq OWNER TO postgres;

--
-- Name: comment_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_likes_id_seq OWNED BY public.comment_likes.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    user_id uuid NOT NULL,
    comment text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_like integer DEFAULT 0 NOT NULL,
    parent_comment_id integer,
    is_delete boolean DEFAULT false,
    user_id_reply uuid
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: TABLE comments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.comments IS 'B├¼nh luß║¡n';


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    code text,
    name text,
    name_en text,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    is_delete boolean DEFAULT false
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: TABLE countries; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.countries IS 'Quß╗æc gia sß║ún xuß║Ñt';


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: dictionaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dictionaries (
    id integer NOT NULL,
    word text NOT NULL,
    pronunciation text NOT NULL,
    type text NOT NULL,
    meaning text NOT NULL,
    example text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.dictionaries OWNER TO postgres;

--
-- Name: TABLE dictionaries; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dictionaries IS 'Tß╗½ ─æiß╗ân';


--
-- Name: dictionary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dictionary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dictionary_id_seq OWNER TO postgres;

--
-- Name: dictionary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dictionary_id_seq OWNED BY public.dictionaries.id;


--
-- Name: error_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.error_logs (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    is_error_movie boolean DEFAULT false NOT NULL,
    is_error_subtitle boolean DEFAULT false NOT NULL,
    note text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id uuid
);


ALTER TABLE public.error_logs OWNER TO postgres;

--
-- Name: TABLE error_logs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.error_logs IS 'Th├┤ng b├ío lß╗ùi';


--
-- Name: error_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.error_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.error_logs_id_seq OWNER TO postgres;

--
-- Name: error_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.error_logs_id_seq OWNED BY public.error_logs.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedbacks (
    id integer NOT NULL,
    user_id uuid,
    quality_movie text,
    "is_improve_Eng" boolean DEFAULT false,
    note text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.feedbacks OWNER TO postgres;

--
-- Name: TABLE feedbacks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feedbacks IS '─É├ính gi├í, ─æ├│ng g├│p ├╜ kiß║┐n cß╗ºa ng╞░ß╗¥i xem';


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedbacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feedbacks_id_seq OWNER TO postgres;

--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedbacks_id_seq OWNED BY public.feedbacks.id;


--
-- Name: movie_actors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_actors (
    movie_id integer NOT NULL,
    actor_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    is_delete boolean DEFAULT false NOT NULL
);


ALTER TABLE public.movie_actors OWNER TO postgres;

--
-- Name: TABLE movie_actors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_actors IS 'Phim - Diß╗àn vi├¬n';


--
-- Name: movie_actors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_actors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_actors_id_seq OWNER TO postgres;

--
-- Name: movie_actors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_actors_id_seq OWNED BY public.movie_actors.id;


--
-- Name: movie_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_categories (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    category_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_delete boolean DEFAULT false NOT NULL
);


ALTER TABLE public.movie_categories OWNER TO postgres;

--
-- Name: TABLE movie_categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_categories IS 'Phim - Thß╗â loß║íi';


--
-- Name: movie_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_categories_id_seq OWNER TO postgres;

--
-- Name: movie_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_categories_id_seq OWNED BY public.movie_categories.id;


--
-- Name: movie_couplets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_couplets (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    movie_id integer NOT NULL,
    couplet text NOT NULL,
    meaning text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_delete boolean DEFAULT false NOT NULL
);


ALTER TABLE public.movie_couplets OWNER TO postgres;

--
-- Name: TABLE movie_couplets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_couplets IS 'L╞░u cß║╖p c├óu';


--
-- Name: movie_couplets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_couplets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_couplets_id_seq OWNER TO postgres;

--
-- Name: movie_couplets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_couplets_id_seq OWNED BY public.movie_couplets.id;


--
-- Name: movie_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_details (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    episode integer NOT NULL,
    url_movie text NOT NULL,
    url_sub_en text NOT NULL,
    url_sub_vi text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_by integer,
    is_delete boolean DEFAULT false NOT NULL
);


ALTER TABLE public.movie_details OWNER TO postgres;

--
-- Name: TABLE movie_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_details IS 'Chi tiß║┐t phim (Tß║¡p phim)';


--
-- Name: movie_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_details_id_seq OWNER TO postgres;

--
-- Name: movie_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_details_id_seq OWNED BY public.movie_details.id;


--
-- Name: movie_favourite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_favourite (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    movie_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_delete boolean DEFAULT false NOT NULL
);


ALTER TABLE public.movie_favourite OWNER TO postgres;

--
-- Name: TABLE movie_favourite; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_favourite IS 'Phim y├¬u th├¡ch';


--
-- Name: movie_favourite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_favourite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_favourite_id_seq OWNER TO postgres;

--
-- Name: movie_favourite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_favourite_id_seq OWNED BY public.movie_favourite.id;


--
-- Name: movie_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_history (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    movie_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_delete boolean DEFAULT false NOT NULL,
    episode integer
);


ALTER TABLE public.movie_history OWNER TO postgres;

--
-- Name: TABLE movie_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_history IS 'Lß╗ïch sß╗¡ xem phim';


--
-- Name: movie_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_history_id_seq OWNER TO postgres;

--
-- Name: movie_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_history_id_seq OWNED BY public.movie_history.id;


--
-- Name: movie_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_images (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    type_image text NOT NULL,
    url text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movie_images OWNER TO postgres;

--
-- Name: TABLE movie_images; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_images IS 'H├¼nh ß║únh phim';


--
-- Name: movie_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_images_id_seq OWNER TO postgres;

--
-- Name: movie_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_images_id_seq OWNED BY public.movie_images.id;


--
-- Name: movie_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_logs (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    date date DEFAULT now() NOT NULL,
    count_view integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movie_logs OWNER TO postgres;

--
-- Name: TABLE movie_logs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_logs IS 'Log phim hß║▒ng ng├áy';


--
-- Name: movie_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_log_id_seq OWNER TO postgres;

--
-- Name: movie_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_log_id_seq OWNED BY public.movie_logs.id;


--
-- Name: movie_views_daily; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.movie_views_daily AS
 SELECT movie_logs.movie_id,
    movie_logs.count_view,
    movie_logs.date
   FROM public.movie_logs
  GROUP BY movie_logs.movie_id, movie_logs.count_view, movie_logs.date;


ALTER TABLE public.movie_views_daily OWNER TO postgres;

--
-- Name: movie_views_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.movie_views_month AS
 SELECT movie_logs.movie_id,
    date_trunc('month'::text, (movie_logs.date)::timestamp with time zone) AS fisrt_day_month,
    ((date_trunc('month'::text, (movie_logs.date)::timestamp with time zone) + '1 mon'::interval) - '1 day'::interval) AS last_day_month,
    sum(movie_logs.count_view) AS total_view
   FROM public.movie_logs
  GROUP BY movie_logs.movie_id, (date_trunc('month'::text, (movie_logs.date)::timestamp with time zone)), ((date_trunc('month'::text, (movie_logs.date)::timestamp with time zone) + '1 mon'::interval) - '1 day'::interval);


ALTER TABLE public.movie_views_month OWNER TO postgres;

--
-- Name: movie_views_week; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.movie_views_week AS
 SELECT movie_logs.movie_id,
    (date_trunc('week'::text, (movie_logs.date)::timestamp with time zone) - '1 day'::interval) AS fisrt_day_week,
    (date_trunc('week'::text, (movie_logs.date)::timestamp with time zone) + '6 days'::interval) AS last_day_week,
    sum(movie_logs.count_view) AS total_view
   FROM public.movie_logs
  GROUP BY movie_logs.movie_id, (date_trunc('week'::text, (movie_logs.date)::timestamp with time zone) - '1 day'::interval), (date_trunc('week'::text, (movie_logs.date)::timestamp with time zone) + '6 days'::interval);


ALTER TABLE public.movie_views_week OWNER TO postgres;

--
-- Name: movie_words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_words (
    id integer NOT NULL,
    word_id integer,
    movie_id integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    is_delete boolean DEFAULT false,
    user_id uuid
);


ALTER TABLE public.movie_words OWNER TO postgres;

--
-- Name: TABLE movie_words; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movie_words IS 'L╞░u tß╗½ vß╗▒ng';


--
-- Name: movie_words_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_words_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movie_words_id_seq OWNER TO postgres;

--
-- Name: movie_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_words_id_seq OWNED BY public.movie_words.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    code text,
    name_en text,
    name text,
    content text,
    view integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    created_by timestamp without time zone,
    updated_at timestamp without time zone DEFAULT now(),
    updated_by integer,
    is_delete boolean DEFAULT false NOT NULL,
    movie_type text,
    movie_status text,
    country_id integer,
    year_of_manufacture integer,
    "time" integer,
    total_episode integer
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- Name: TABLE movies; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.movies IS 'Phim';


--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movies_id_seq OWNER TO postgres;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    email text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_delete boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'T├ái khoß║ún ng╞░ß╗¥i d├╣ng';


--
-- Name: actors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actors ALTER COLUMN id SET DEFAULT nextval('public.actors_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: comment_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes ALTER COLUMN id SET DEFAULT nextval('public.comment_likes_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: dictionaries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dictionaries ALTER COLUMN id SET DEFAULT nextval('public.dictionary_id_seq'::regclass);


--
-- Name: error_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_logs ALTER COLUMN id SET DEFAULT nextval('public.error_logs_id_seq'::regclass);


--
-- Name: feedbacks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedbacks ALTER COLUMN id SET DEFAULT nextval('public.feedbacks_id_seq'::regclass);


--
-- Name: movie_actors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_actors ALTER COLUMN id SET DEFAULT nextval('public.movie_actors_id_seq'::regclass);


--
-- Name: movie_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_categories ALTER COLUMN id SET DEFAULT nextval('public.movie_categories_id_seq'::regclass);


--
-- Name: movie_couplets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_couplets ALTER COLUMN id SET DEFAULT nextval('public.movie_couplets_id_seq'::regclass);


--
-- Name: movie_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_details ALTER COLUMN id SET DEFAULT nextval('public.movie_details_id_seq'::regclass);


--
-- Name: movie_favourite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_favourite ALTER COLUMN id SET DEFAULT nextval('public.movie_favourite_id_seq'::regclass);


--
-- Name: movie_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_history ALTER COLUMN id SET DEFAULT nextval('public.movie_history_id_seq'::regclass);


--
-- Name: movie_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_images ALTER COLUMN id SET DEFAULT nextval('public.movie_images_id_seq'::regclass);


--
-- Name: movie_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_logs ALTER COLUMN id SET DEFAULT nextval('public.movie_log_id_seq'::regclass);


--
-- Name: movie_words id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_words ALTER COLUMN id SET DEFAULT nextval('public.movie_words_id_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Data for Name: hdb_action_log; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_action_log (id, action_name, input_payload, request_headers, session_variables, response_payload, errors, created_at, response_received_at, status) FROM stdin;
\.


--
-- Data for Name: hdb_cron_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_cron_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_cron_events (id, trigger_name, scheduled_time, status, tries, created_at, next_retry_at) FROM stdin;
\.


--
-- Data for Name: hdb_metadata; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_metadata (id, metadata, resource_version) FROM stdin;
1	{"backend_configs":{"dataconnector":{"athena":{"uri":"http://data-connector-agent:8081/api/v1/athena"},"mariadb":{"uri":"http://data-connector-agent:8081/api/v1/mariadb"},"mysql8":{"uri":"http://data-connector-agent:8081/api/v1/mysql"},"oracle":{"uri":"http://data-connector-agent:8081/api/v1/oracle"},"snowflake":{"uri":"http://data-connector-agent:8081/api/v1/snowflake"}}},"sources":[{"configuration":{"connection_info":{"database_url":{"from_env":"PG_DATABASE_URL"},"isolation_level":"read-committed","use_prepared_statements":false}},"kind":"postgres","name":"wmoives","tables":[{"array_relationships":[{"name":"movie_actors","using":{"manual_configuration":{"column_mapping":{"id":"actor_id"},"insertion_order":null,"remote_table":{"name":"movie_actors","schema":"public"}}}}],"table":{"name":"actors","schema":"public"}},{"table":{"name":"admins","schema":"public"}},{"table":{"name":"categories","schema":"public"}},{"table":{"name":"comment_likes","schema":"public"}},{"array_relationships":[{"name":"user_likes","using":{"manual_configuration":{"column_mapping":{"id":"comment_id"},"insertion_order":null,"remote_table":{"name":"comment_likes","schema":"public"}}}}],"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}},{"name":"user","using":{"manual_configuration":{"column_mapping":{"user_id":"id"},"insertion_order":null,"remote_table":{"name":"users","schema":"public"}}}},{"name":"user_reply","using":{"manual_configuration":{"column_mapping":{"user_id_reply":"id"},"insertion_order":null,"remote_table":{"name":"users","schema":"public"}}}}],"table":{"name":"comments","schema":"public"}},{"table":{"name":"countries","schema":"public"}},{"table":{"name":"dictionaries","schema":"public"}},{"table":{"name":"error_logs","schema":"public"}},{"table":{"name":"feedbacks","schema":"public"}},{"object_relationships":[{"name":"actor","using":{"manual_configuration":{"column_mapping":{"actor_id":"id"},"insertion_order":null,"remote_table":{"name":"actors","schema":"public"}}}},{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_actors","schema":"public"}},{"object_relationships":[{"name":"category","using":{"manual_configuration":{"column_mapping":{"category_id":"id"},"insertion_order":null,"remote_table":{"name":"categories","schema":"public"}}}},{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_categories","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}},{"name":"user","using":{"manual_configuration":{"column_mapping":{"user_id":"id"},"insertion_order":null,"remote_table":{"name":"users","schema":"public"}}}}],"table":{"name":"movie_couplets","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_details","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}},{"name":"user","using":{"manual_configuration":{"column_mapping":{"user_id":"id"},"insertion_order":null,"remote_table":{"name":"users","schema":"public"}}}}],"table":{"name":"movie_favourite","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}},{"name":"user","using":{"manual_configuration":{"column_mapping":{"user_id":"id"},"insertion_order":null,"remote_table":{"name":"users","schema":"public"}}}}],"table":{"name":"movie_history","schema":"public"}},{"table":{"name":"movie_images","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_logs","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_views_daily","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_views_month","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}}],"table":{"name":"movie_views_week","schema":"public"}},{"object_relationships":[{"name":"movie","using":{"manual_configuration":{"column_mapping":{"movie_id":"id"},"insertion_order":null,"remote_table":{"name":"movies","schema":"public"}}}},{"name":"user","using":{"manual_configuration":{"column_mapping":{"user_id":"id"},"insertion_order":null,"remote_table":{"name":"users","schema":"public"}}}},{"name":"word","using":{"manual_configuration":{"column_mapping":{"word_id":"id"},"insertion_order":null,"remote_table":{"name":"dictionaries","schema":"public"}}}}],"table":{"name":"movie_words","schema":"public"}},{"array_relationships":[{"name":"movie_actors","using":{"manual_configuration":{"column_mapping":{"id":"movie_id"},"insertion_order":null,"remote_table":{"name":"movie_actors","schema":"public"}}}},{"name":"movie_categories","using":{"manual_configuration":{"column_mapping":{"id":"movie_id"},"insertion_order":null,"remote_table":{"name":"movie_categories","schema":"public"}}}},{"name":"movie_details","using":{"manual_configuration":{"column_mapping":{"id":"movie_id"},"insertion_order":null,"remote_table":{"name":"movie_details","schema":"public"}}}},{"name":"movie_images","using":{"manual_configuration":{"column_mapping":{"id":"movie_id"},"insertion_order":null,"remote_table":{"name":"movie_images","schema":"public"}}}},{"name":"movie_logs","using":{"manual_configuration":{"column_mapping":{"id":"movie_id"},"insertion_order":null,"remote_table":{"name":"movie_logs","schema":"public"}}}}],"object_relationships":[{"name":"country","using":{"manual_configuration":{"column_mapping":{"country_id":"id"},"insertion_order":null,"remote_table":{"name":"countries","schema":"public"}}}}],"table":{"name":"movies","schema":"public"}},{"table":{"name":"users","schema":"public"}}]}],"version":3}	136
\.


--
-- Data for Name: hdb_scheduled_event_invocation_logs; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_event_invocation_logs (id, event_id, status, request, response, created_at) FROM stdin;
\.


--
-- Data for Name: hdb_scheduled_events; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_scheduled_events (id, webhook_conf, scheduled_time, retry_conf, payload, header_conf, status, tries, created_at, next_retry_at, comment) FROM stdin;
\.


--
-- Data for Name: hdb_schema_notifications; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_schema_notifications (id, notification, resource_version, instance_id, updated_at) FROM stdin;
1	{"metadata":false,"remote_schemas":[],"sources":[],"data_connectors":[]}	136	9d2c94c4-90ed-490b-8d0b-16ec2b66d6aa	2023-11-10 06:59:17.618975+00
\.


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: postgres
--

COPY hdb_catalog.hdb_version (hasura_uuid, version, upgraded_on, cli_state, console_state, ee_client_id, ee_client_secret) FROM stdin;
7af605ae-4953-4dbc-9e63-580db7a513da	48	2023-11-10 06:30:33.214667+00	{}	{"console_notifications": {"admin": {"date": "2023-11-10T12:34:45.127Z", "read": [], "showBadge": false}}}	\N	\N
\.


--
-- Data for Name: actors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actors (id, code, name, introduce, birthday, is_delete, created_by, updated_by, created_at, updated_at, image_actor) FROM stdin;
1	wentworth-miller	Wentworth Miller	Nam diß╗àn vi├¬n Wentworth Miller c├│ t├¬n ─æß║ºy ─æß╗º l├á Wentworth Earl Miller III, sinh ng├áy 2 th├íng 6 n─âm 1972, tß║íi Anh. N─âm 2005, Miller ─æ╞░ß╗úc chß╗ìn v├áo vai Michael Scofield trong "V╞░ß╗út ngß╗Ñc". Trong "V╞░ß╗út ngß╗Ñc", Michael Scofield ─æ├ú cß╗æ t├¼nh ─æi c╞░ß╗¢p ng├ón h├áng ─æß╗â ─æ╞░ß╗úc v├áo t├╣, thß╗▒c hiß╗çn kß║┐ hoß║ích gi├║p ng╞░ß╗¥i anh Lincoln Burrows bß╗ï kß║┐t ├ín oan (Dominic Purcell ─æ├│ng) v╞░ß╗út ngß╗Ñc.	\N	f	\N	\N	2023-12-24 17:13:13.160179	2023-12-24 17:13:13.160179	wentworth-miller-25-12-2023.jpeg
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, username, password, email, created_at, updated_at, is_delete) FROM stdin;
0cb93f65-c8ec-4952-9b33-869525927969	Huy Ho├áng	$2b$10$IcISvR1v4wpV8gU848jZLeeU6PiJkRTe.UpeFvT8kspH1..kPm9cy	lehuyhoang111@tlus.edu.vn	2023-12-26 09:01:33.026563	2023-12-26 09:01:33.026563	f
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, code, name, name_en, created_at, created_by, updated_at, updated_by, is_delete) FROM stdin;
1	action	H├ánh ─æß╗Öng	\N	2023-12-23 16:50:38.465103	\N	2023-12-23 16:50:38.465103	\N	f
4	cartoon	Hoß║ít h├¼nh	\N	2023-12-23 16:54:29.752589	\N	2023-12-23 16:54:29.752589	\N	f
5	documentary	T├ái liß╗çu	\N	2023-12-23 16:55:11.744256	\N	2023-12-23 16:55:11.744256	\N	f
7	comedy	H├ái h╞░ß╗¢c	\N	2023-12-23 16:56:01.299548	\N	2023-12-23 16:56:01.299548	\N	f
8	sitcom	Phim h├ái d├ái tß║¡p	\N	2023-12-23 16:57:33.758746	\N	2023-12-23 16:57:33.758746	\N	f
9	sci-fi	Khoa hß╗ìc viß╗àn t╞░ß╗ƒng	\N	2023-12-23 16:58:30.781911	\N	2023-12-23 16:58:30.781911	\N	f
2	romance	L├úng mß║ín - T├¼nh cß║úm	\N	2023-12-23 16:51:08.659731	\N	2023-12-23 16:51:08.659731	\N	f
10	test	q╞░eqeqe	\N	2023-12-23 17:05:15.739381	\N	2023-12-23 17:05:15.739381	\N	t
3	adventure	Phi├¬u l╞░u - Mß║ío hiß╗âm	\N	2023-12-23 16:52:04.711707	\N	2023-12-23 16:52:04.711707	\N	f
11	drama	Ch├¡nh kß╗ïch	\N	2024-01-02 16:47:45.700494	\N	2024-01-02 16:47:45.700494	\N	f
6	horror	Kinh dß╗ï	\N	2023-12-23 16:55:29.230052	\N	2023-12-23 16:55:29.230052	\N	f
\.


--
-- Data for Name: comment_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_likes (id, comment_id, user_like_id, created_at, updated_at, is_unlike) FROM stdin;
6	7	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 13:37:40.216876	2023-12-27 13:37:40.216876	f
11	8	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 16:35:19.070898	2023-12-27 16:35:19.070898	f
12	3	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 16:35:25.65592	2023-12-27 16:35:25.65592	f
13	2	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 16:35:26.731155	2023-12-27 16:35:26.731155	f
14	1	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 16:35:28.888173	2023-12-27 16:35:28.888173	t
16	10	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 17:49:32.416196	2023-12-27 17:49:32.416196	f
17	11	4e21dd61-8f61-4024-992c-d602cd45c272	2023-12-27 18:03:53.965137	2023-12-27 18:03:53.965137	f
18	13	4e21dd61-8f61-4024-992c-d602cd45c272	2024-01-02 15:17:53.957504	2024-01-02 15:17:53.957504	f
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, movie_id, user_id, comment, created_at, updated_at, user_like, parent_comment_id, is_delete, user_id_reply) FROM stdin;
7	3	4e21dd61-8f61-4024-992c-d602cd45c272	Good Morning\n	2023-12-27 12:36:34.877056	2023-12-27 12:36:34.877056	1	\N	f	\N
4	3	4e21dd61-8f61-4024-992c-d602cd45c272	Good Morning\n	2023-12-27 12:35:11.903455	2023-12-27 12:35:11.903455	0	\N	t	\N
6	3	4e21dd61-8f61-4024-992c-d602cd45c272	Good Morning\n	2023-12-27 12:36:28.965533	2023-12-27 12:36:28.965533	0	\N	t	\N
5	3	4e21dd61-8f61-4024-992c-d602cd45c272	Good Morning\n	2023-12-27 12:36:26.845503	2023-12-27 12:36:26.845503	0	\N	t	\N
8	3	4e21dd61-8f61-4024-992c-d602cd45c272	Th├¬m b├¼nh luß║¡n 0.1456	2023-12-27 16:19:52.379364	2023-12-27 16:19:52.379364	1	\N	f	\N
3	3	4e21dd61-8f61-4024-992c-d602cd45c272	Qu├í l├á sß║┐n	2023-12-27 12:33:38.167048	2023-12-27 12:33:38.167048	1	\N	f	\N
2	3	4e21dd61-8f61-4024-992c-d602cd45c272	hello	2023-12-27 12:31:09.184605	2023-12-27 12:31:09.184605	1	\N	f	\N
1	3	4e21dd61-8f61-4024-992c-d602cd45c272	Phim hay qu├í !!!	2023-12-27 12:13:23.655119	2023-12-27 12:13:23.655119	0	\N	f	\N
9	3	4e21dd61-8f61-4024-992c-d602cd45c272	Goob Job	2023-12-27 16:54:47.226207	2023-12-27 16:54:47.226207	0	\N	f	\N
10	3	4e21dd61-8f61-4024-992c-d602cd45c272	Thiß╗çt honggg	2023-12-27 17:35:22.548144	2023-12-27 17:35:22.548144	1	9	f	\N
11	3	4e21dd61-8f61-4024-992c-d602cd45c272	Test replay\n	2023-12-27 18:01:25.138437	2023-12-27 18:01:25.138437	1	9	f	4e21dd61-8f61-4024-992c-d602cd45c272
12	3	4e21dd61-8f61-4024-992c-d602cd45c272	hello	2024-01-02 15:17:33.868046	2024-01-02 15:17:33.868046	0	\N	f	\N
13	3	4e21dd61-8f61-4024-992c-d602cd45c272	cmm	2024-01-02 15:17:41.772938	2024-01-02 15:17:41.772938	1	\N	f	\N
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, code, name, name_en, created_by, updated_by, created_at, updated_at, is_delete) FROM stdin;
1	england	Anh	England	\N	\N	2023-12-23 18:59:27.396278	2023-12-23 18:59:27.396278	f
2	us	Mß╗╣	United States	\N	\N	2023-12-23 19:08:28.274453	2023-12-23 19:08:28.274453	f
3	sk	H├án Quß╗æc	South Korea	\N	\N	2023-12-23 19:10:11.213977	2023-12-23 19:10:11.213977	f
4	indo	Indonesia	Indonesia	\N	\N	2024-01-02 16:20:16.426927	2024-01-02 16:20:16.426927	f
5	thailand	Th├íi Lan	Thailand	\N	\N	2024-01-02 16:20:57.855517	2024-01-02 16:20:57.855517	f
\.


--
-- Data for Name: dictionaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dictionaries (id, word, pronunciation, type, meaning, example, created_at) FROM stdin;
1	trans	tr├ªnz	Danh tß╗½ (Noun)	M├ú v├╣ng s├ón bay trung t├óm	T├┤i ─æ├ú mß║Ñt nhiß╗üu thß╗¥i gian ß╗ƒ trans trong s├ón bay	2023-12-19 15:38:04.87441
2	trans	tr├ªnz	T├¡nh tß╗½ (Adjective)	Li├¬n quan ─æß║┐n viß╗çc chuyß╗ân ─æß╗òi	C├┤ng nghß╗ç trans gi├║p t─âng tß╗æc ─æß╗Ö truyß╗ün dß╗» liß╗çu	2023-12-19 15:38:04.87441
3	option	╦ê╔æp╩â(╔Ö)n	Danh tß╗½ (Noun)	Sß╗▒ lß╗▒a chß╗ìn hoß║╖c quyß╗ün ─æ╞░ß╗úc chß╗ìn	I have a few options for dinner tonight.	2023-12-19 15:40:13.273944
4	option	╦ê╔æp╩â(╔Ö)n	Danh tß╗½ (Noun)	Hß╗úp ─æß╗ông t├╣y chß╗ìn mua b├ín chß╗⌐ng kho├ín hoß║╖c h├áng h├│a	I bought an option on the stock market.	2023-12-19 15:40:13.273944
5	option	╦ê╔æp╩â(╔Ö)n	Danh tß╗½ (Noun)	C├íc t├¡nh n─âng hoß║╖c chß╗⌐c n─âng c├│ thß╗â ─æ╞░ß╗úc chß╗ìn trong mß╗Öt hß╗ç thß╗æng hoß║╖c sß║ún phß║⌐m	This software has many customization options.	2023-12-19 15:40:13.273944
6	like	la╔¬k	Danh tß╗½ (Noun)	sß╗▒ th├¡ch, sß╗▒ th├¡ch th├║, ─æiß╗üu giß╗æng nhau	I have a strong like for ice cream.	2023-12-19 15:44:00.161324
7	like	la╔¬k	─Éß╗Öng tß╗½ (Verb)	th├¡ch, th├¡ch th├║, giß╗æng	I really like the song.	2023-12-19 15:44:00.161324
8	like	la╔¬k	T├¡nh tß╗½ (Adjective)	giß╗æng, t╞░╞íng tß╗▒	He has a like mind.	2023-12-19 15:44:00.161324
9	phim	f╔¬lm	Danh tß╗½ (Noun)	mß╗Öt loß║íi nghß╗ç thuß║¡t t╞░╞íng ─æß╗æi trß║╗ cß╗ºa lo├ái ng╞░ß╗¥i, kß╗╖ niß╗çm nhß╗»ng sß╗▒ kiß╗çn, c├óu chuyß╗çn v├á ng╞░ß╗¥i kh├íc bß║▒ng c├ích thu lß║íi, l╞░u trß╗» v├á tr├¼nh chiß║┐u nhß╗»ng h├¼nh ß║únh di ─æß╗Öng	I'm going to the movie theater to watch a movie.	2023-12-19 15:44:36.875811
10	mean(s)	mi╦Én	─æß╗Öng tß╗½ (Verb)	diß╗àn tß║ú ├╜ ngh─⌐a hoß║╖c ├╜ ─æß╗ïnh cß╗ºa ─æiß╗üu g├¼ ─æ├│; g├óy ra kß║┐t quß║ú hoß║╖c hiß╗çu ß╗⌐ng nhß║Ñt ─æß╗ïnh	What does this word mean?	2023-12-19 15:49:55.415016
11	mean	mi╦Én	t├¡nh tß╗½ (Adjective)	th├┤ lß╗ù, xß║Ñu t├¡nh; h├¿n hß║í, ─æ├¬ tiß╗çn	He is mean to his little sister.	2023-12-19 15:49:55.415016
12	mean	mi╦Én	danh tß╗½ (Noun)	th├ánh phß║ºn c├│ ├╜ ngh─⌐a cß╗ºa mß╗Öt tß║¡p hß╗úp c├íc sß╗æ hß╗ìc; gi├í trß╗ï trung b├¼nh	The mean of these numbers is 10.	2023-12-19 15:49:55.415016
13	supering	/╦êsu╦Ép╔Ör╔¬┼ï/	Danh tß╗½ (Noun)	H├ánh ─æß╗Öng hoß║╖c trß║íng th├íi cß╗ºa viß╗çc l├ám si├¬u hoß║╖c xuß║Ñt sß║»c	His supering in the game impressed everyone.	2023-12-19 15:54:08.195319
14	super	/╦êsu╦Ép╔Ör/	T├¡nh tß╗½ (Adjective)	C├│ cß║Ñp ─æß╗Ö cao h╞ín b├¼nh th╞░ß╗¥ng, rß║Ñt tß╗æt, tuyß╗çt vß╗¥i	She did a super job on the project.	2023-12-19 15:54:08.195319
15	super	/╦êsu╦Ép╔Ör/	Trß║íng tß╗½ (Adverb)	Rß║Ñt, qu├í, v├┤ c├╣ng	I'm super excited about the concert.	2023-12-19 15:54:08.195319
16	Guy	╔ía╔¬	danh tß╗½ (Noun)	Mß╗Öt ng╞░ß╗¥i ─æ├án ├┤ng, mß╗Öt ch├áng trai	He is a nice guy.	2023-12-19 15:54:56.38055
17	Guying	╦ê╔ía╔¬╔¬┼ï	─æß╗Öng tß╗½ (Verb)	H├ánh ─æß╗Öng chß║┐ giß╗àu hoß║╖c tr├¬u chß╗ìc ai ─æ├│	They were guying him for his funny accent.	2023-12-19 15:54:56.38055
18	There	├░╔¢r	T├¡nh tß╗½ (Adjective)	Diß╗àn tß║ú sß╗▒ tß╗ôn tß║íi hoß║╖c vß╗ï tr├¡	There is a cat on the table.	2023-12-19 16:04:41.558983
19	There	├░╔¢r	Ph├│ tß╗½ (Adverb)	Diß╗àn tß║ú vß╗ï tr├¡	He went there yesterday.	2023-12-19 16:04:41.558983
20	There	├░╔¢r	Li├¬n tß╗½ (Conjunction)	D├╣ng ─æß╗â n├│i vß╗ü vß╗ï tr├¡, thß╗¥i gian hoß║╖c mß╗⌐c ─æß╗Ö	I will go there when I have time.	2023-12-19 16:04:41.558983
21	you	ju╦É	Danh tß╗½ (Noun)	Ng╞░ß╗¥i m├á ─æang ngß╗ôi ngay tr╞░ß╗¢c m├án h├¼nh	You are amazing.	2023-12-19 16:06:22.998973
22	you	ju╦É	─Éß║íi tß╗½ (Pronoun)	─Éß║íi tß╗½ chß╗ë ng╞░ß╗¥i nghe hoß║╖c ─æß╗ìc	I love you.	2023-12-19 16:06:22.998973
23	you	ju╦É	─Éß╗Öng tß╗½ (Verb)	N├│i vß╗¢i ai ─æ├│	I will call you later.	2023-12-19 16:06:22.998973
24	All	╔ö╦Él	T├¡nh tß╗½ (Adjective)	─É╞░ß╗úc sß╗¡ dß╗Ñng ─æß╗â chß╗ë tß╗òng sß╗æ hoß║╖c to├án bß╗Ö	All students need to submit their assignments.	2023-12-19 16:10:15.776139
25	All	╔ö╦Él	Danh tß╗½ (Noun)	Tß╗òng sß╗æ hoß║╖c to├án bß╗Ö	He ate all of the cookies.	2023-12-19 16:10:15.776139
26	All	╔ö╦Él	Ph├│ tß╗½ (Adverb)	Ho├án to├án, to├án bß╗Ö	He was all alone in the house.	2023-12-19 16:10:15.776139
27	home	/ho╩èm/	Danh tß╗½	n╞íi ß╗ƒ; n╞íi sinh sß╗æng; nh├á cß╗¡a	I'm going home (T├┤i ─æang ─æi vß╗ü nh├á)	2023-12-21 08:25:58.522733
28	home	/ho╩èm/	Danh tß╗½	qu├¬ h╞░╞íng; qu├¬ nh├á	I miss my home (T├┤i nhß╗¢ qu├¬ nh├á cß╗ºa m├¼nh)	2023-12-21 08:25:58.522733
29	home	/ho╩èm/	Danh tß╗½	gia ─æ├¼nh; tß╗ò ß║Ñm	Our home is a happy place (Gia ─æ├¼nh ch├║ng t├┤i l├á mß╗Öt n╞íi hß║ính ph├║c)	2023-12-21 08:25:58.522733
30	home	/ho╩èm/	Danh tß╗½	n╞íi ng╞░ß╗¥i phi├¬u dß║ít t├¼m vß╗ü; mß╗Ñc ti├¬u cuß╗æi c├╣ng	He finally found his way home (Anh ß║Ñy cuß╗æi c├╣ng c┼⌐ng t├¼m ─æ╞░ß╗úc con ─æ╞░ß╗¥ng vß╗ü nh├á)	2023-12-21 08:25:58.522733
31	home	/ho╩èm/	Danh tß╗½	bß╗çnh viß╗çn; nh├á h├ít (trong mß╗Öt tß║¡p thß╗â thß╗â thao)	The basketball team plays at home (─Éß╗Öi b├│ng rß╗ò ch╞íi ß╗ƒ nh├á)	2023-12-21 08:25:58.522733
32	home	/ho╩èm/	Danh tß╗½	─æiß╗âm ghi b├án	The home team scored two goals (─Éß╗Öi chß╗º nh├á ghi ─æ╞░ß╗úc hai b├án)	2023-12-21 08:25:58.522733
33	home	/ho╩èm/	Danh tß╗½	ng├┤i nh├á	This is my dream home (─É├óy l├á ng├┤i nh├á m╞í ╞░ß╗¢c cß╗ºa t├┤i)	2023-12-21 08:25:58.522733
34	home	/ho╩èm/	Danh tß╗½	trung t├óm	The city is the home of the arts (Th├ánh phß╗æ n├áy l├á trung t├óm cß╗ºa nghß╗ç thuß║¡t)	2023-12-21 08:25:58.522733
35	buzzing	╦êb╩îz╔¬┼ï	Danh tß╗½	h├ánh ─æß╗Öng rung l├¬n nhß╗ïp nh├áng; tiß║┐ng vo ve	The buzzing of bees	2023-12-28 15:36:58.843685
36	buzzing	╦êb╩îz╔¬┼ï	T├¡nh tß╗½	─æang hiß╗çn diß╗çn v├á rß║Ñt nß╗òi tiß║┐ng, ─æang ─æ╞░ß╗úc ch├║ ├╜	There's a buzzing restaurant in town.	2023-12-28 15:36:58.843685
37	buzzing	╦êb╩îz╔¬┼ï	─Éß╗Öng tß╗½	tß║ío ra ├óm thanh rung rß╗ôi	His ears were buzzing after the concert.	2023-12-28 15:36:58.843685
38	artist	╦ê╔æ╦Ért╔¬st	Danh tß╗½ (Noun)	ng╞░ß╗¥i ─æi├¬u khß║»c, hß╗ìa s─⌐, nhß║íc s─⌐ hoß║╖c ng╞░ß╗¥i biß╗âu diß╗àn nghß╗ç thuß║¡t	He is a talented artist.	2023-12-28 15:37:56.865347
39	artist	╦ê╔æ╦Ért╔¬st	Danh tß╗½ (Noun)	ng╞░ß╗¥i nghß╗ç s─⌐ chuy├¬n nghiß╗çp hoß║╖c giß╗Åi vß╗¢i mß╗Öt loß║íi nghß╗ç thuß║¡t cß╗Ñ thß╗â	She is a famous artist in the city.	2023-12-28 15:37:56.865347
40	artist	╦ê╔æ╦Ért╔¬st	Danh tß╗½ (Noun)	ng╞░ß╗¥i c├│ khß║ú n─âng tß║ío ra nhß╗»ng t├íc phß║⌐m nghß╗ç thuß║¡t s├íng tß║ío v├á ─æß╗Öc ─æ├ío	The artist displayed his paintings at the exhibition.	2023-12-28 15:37:56.865347
41	telling	╦êt╔¢l╔¬┼ï	Danh tß╗½	H├ánh ─æß╗Öng hoß║╖c qu├í tr├¼nh kß╗â chuyß╗çn hoß║╖c cho ng╞░ß╗¥i kh├íc biß║┐t vß╗ü ─æiß╗üu g├¼ ─æ├│	Her telling of the story was captivating.	2023-12-28 15:38:36.006089
42	telling	╦êt╔¢l╔¬┼ï	T├¡nh tß╗½	C├│ khß║ú n─âng chß╗⌐ng tß╗Å hoß║╖c tiß║┐t lß╗Ö th├┤ng tin hay sß╗▒ thß║¡t quan trß╗ìng	His facial expression was very telling.	2023-12-28 15:38:36.006089
43	out of	a╩èt ╔Æv	Preposition	used to show the origin or source	She took the money outta her purse.	2023-12-28 15:41:28.226172
44	from	fr╩îm, fr╔Öm	Preposition	used to indicate where something or someone is coming from	I'm from outta town.	2023-12-28 15:41:28.226172
45	going to	╦ê╔í╔Ö╩è╔¬┼ï tu╦É	Verb	expressing future intention or prediction	I'm gonna go to the store.	2023-12-28 15:41:43.777879
46	gonnaing	╦ê╔í╩în╔Ö╔¬┼ï	Noun	a made-up word for the noun form of 'gonna'	There is no example available for this noun form.	2023-12-28 15:41:43.777879
47	something	/╦ês╩îm╬╕╔¬┼ï/	Pronoun	Used to refer to a thing of unspecified kind or nature	Can you give me something to eat?	2023-12-28 15:47:47.150268
48	again	/╔Ö╦ê╔í╔¢n/	adverb	lß║íi mß╗Öt lß║ºn nß╗»a	I will never trust him again.	2023-12-28 15:53:50.83681
49	Mom	m╔æm	Danh tß╗½ (Noun)	Mß║╣, ng╞░ß╗¥i mß║╣	I love my mom very much.	2023-12-28 15:57:30.344037
50	that	├░├ªt	─æß║íi tß╗½	─æß║íi tß╗½ chß╗ë ng╞░ß╗¥i, vß║¡t, sß╗▒ viß╗çc ─æ├ú ─æ╞░ß╗úc ─æß╗ü cß║¡p tß╗¢i hoß║╖c biß║┐t ─æß║┐n	I saw a dog that was chasing a cat.	2023-12-28 15:57:38.588088
51	Wish	wi╩â	Verb (─Éß╗Öng tß╗½)	Mong ╞░ß╗¢c, ao ╞░ß╗¢c, hy vß╗ìng	I wish I could travel around the world.	2023-12-28 15:57:54.164538
52	hell	hel	noun	n╞íi chß╗ïu h├¼nh phß║ít sau khi chß║┐t	He was afraid of going to hell after he died.	2023-12-28 15:58:03.195002
53	weapon	/╦êw╔¢p╔Ön/	nounDanh tß╗½	v┼⌐ kh├¡	He was carrying a dangerous weapon.	2023-12-28 16:06:26.521597
54	confused	k╔Ön╦êfju╦Ézd	adjective (T├¡nh tß╗½)	bß╗æi rß╗æi, l├║ng t├║ng	I'm confused about which way to go.	2023-12-28 16:08:01.360727
55	Honour	/╦ê╔æn╔Ör/	Noun (Danh tß╗½)	T├┤n trß╗ìng, l├▓ng trung th├ánh v├á l├▓ng k├¡nh trß╗ìng cho ai ─æ├│ hoß║╖c cho mß╗Öt gi├í trß╗ï quan trß╗ìng	He is a man of honour.	2023-12-28 16:08:18.278379
56	come	k╩îm	verb (─Éß╗Öng tß╗½)	─æß║┐n, ─æß║┐n gß║ºn; ─æß║ít ─æ╞░ß╗úc; xuß║Ñt hiß╗çn	She came to visit me yesterday.	2023-12-28 16:08:37.722135
57	want	w╔æ╦Ént	verb (─Éß╗Öng tß╗½)	Muß╗æn c├│ hoß║╖c th├¿m muß╗æn ─æiß╗üu g├¼ ─æ├│; khao kh├ít	I want to go to the park today.	2023-12-28 16:09:03.473962
58	Next	n╔¢kst	Adjective/Adverb	Tiß║┐p theo, sau ─æ├│	What are your plans for the next weekend?	2023-12-28 16:11:38.243143
59	moving	╦êmu╦Év╔¬┼ï	verb (─Éß╗Öng tß╗½)	di chuyß╗ân, dß╗¥i chß╗ù	I am moving to a new city next month.	2023-12-28 16:11:50.474852
60	Keep	ki:p	verb (─Éß╗Öng tß╗½)	Giß╗», bß║úo quß║ún; tiß║┐p tß╗Ñc, duy tr├¼; giß╗» ─æ╞░ß╗úc, kh├┤ng ─æß╗â mß║Ñt; kh├┤ng l├ám ai mß║Ñt c├íi g├¼; duy tr├¼ trong t├¼nh trß║íng nguy├¬n vß║╣n, kh├┤ng thay ─æß╗òi	Please keep the door closed. (Vui l├▓ng giß╗» cß╗¡a ─æ├│ng lß║íi.)	2023-12-28 16:12:00.078898
61	That's	/├░├ªts/	Contraction	R├║t gß╗ìn cß╗ºa 'that is'	That's a nice car.	2024-01-02 04:49:15.064459
62	it	╔¬t	pronoun(─Éß║íi tß╗½)	n├│, mß╗Öt ng╞░ß╗¥i hay mß╗Öt vß║¡t kh├┤ng ─æ╞░ß╗úc x├íc ─æß╗ïnh r├╡ r├áng	She found a book and gave it to me.	2024-01-02 04:49:27.794376
63	You're	j╩è╔Ö(r)	Contraction	Bß║ín ─æang	You're my best friend.	2024-01-02 04:49:56.605446
64	an	├ªn	indefinite article	mß╗Öt	There is an apple on the table.	2024-01-02 04:50:05.907978
65	bag	b├ª╔í	noun (Danh tß╗½)	t├║i, chiß║┐c t├║i x├ích	She carried her books in a bag.	2024-01-02 04:50:35.190262
66	go	╔ío╩è	verb (─Éß╗Öng tß╗½)	─æi, di chuyß╗ân	I usually go to work by bus.	2024-01-04 05:40:38.376468
67		╔ío╩è	undefined			2024-01-04 05:40:51.931467
68	movie	/╦êmu╦Évi/	Noun (tiß║┐ng Anh)	Phim (tiß║┐ng Viß╗çt)	I enjoy watching movies on weekends. (tiß║┐ng Anh)	2024-01-04 05:43:22.108317
69	Hello	h╔Ö╦êlo╩è	Interjection (Th├ín tß╗½)	Xin ch├áo	Hello, how are you?	2024-01-04 05:45:22.723922
70	retire	r╔¬╦êta╔¬╔Ör	verb (─Éß╗Öng tß╗½)	nghß╗ë h╞░u, rß╗¥i bß╗Å c├┤ng viß╗çc ch├¡nh thß╗⌐c sau khi ─æß║ít tuß╗òi nghß╗ë h╞░u	He plans to retire next year at the age of 65.	2024-01-04 05:46:40.877291
71	until	╩în╦êt╔¬l	preposition (Giß╗¢i tß╗½)	tß╗½ cho biß║┐t thß╗¥i ─æiß╗âm kß║┐t th├║c cß╗ºa mß╗Öt sß╗▒ viß╗çc, hoß║ít ─æß╗Öng hoß║╖c mß╗Öt khoß║úng thß╗¥i gian	She waited until he arrived.	2024-01-04 05:46:52.147689
\.


--
-- Data for Name: error_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.error_logs (id, movie_id, is_error_movie, is_error_subtitle, note, created_at, updated_at, user_id) FROM stdin;
1	3	t	t	Test b├ío lß╗ùi	2023-12-28 16:54:49.738782	2023-12-28 16:54:49.738782	4e21dd61-8f61-4024-992c-d602cd45c272
2	3	t	t		2023-12-28 16:55:15.338023	2023-12-28 16:55:15.338023	4e21dd61-8f61-4024-992c-d602cd45c272
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedbacks (id, user_id, quality_movie, "is_improve_Eng", note, created_at, updated_at) FROM stdin;
1	4e21dd61-8f61-4024-992c-d602cd45c272	Tß╗æt	t	Good Job	\N	\N
\.


--
-- Data for Name: movie_actors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_actors (movie_id, actor_id, created_at, updated_at, id, is_delete) FROM stdin;
3	1	2023-12-25 16:16:19.664377	2023-12-25 16:16:19.664377	2	t
3	1	2023-12-26 05:46:13.118409	2023-12-26 05:46:13.118409	4	f
3	1	2023-12-26 05:40:03.701599	2023-12-26 05:40:03.701599	3	t
4	1	2023-12-26 15:21:22.438958	2023-12-26 15:21:22.438958	7	f
5	1	2023-12-26 15:27:03.868334	2023-12-26 15:27:03.868334	8	f
6	1	2024-01-02 15:28:11.719465	2024-01-02 15:28:11.719465	9	f
7	1	2024-01-02 15:38:59.551629	2024-01-02 15:38:59.551629	10	f
8	1	2024-01-02 15:45:46.74493	2024-01-02 15:45:46.74493	11	f
9	1	2024-01-02 15:51:26.222	2024-01-02 15:51:26.222	12	f
10	1	2024-01-02 15:58:46.03579	2024-01-02 15:58:46.03579	13	f
11	1	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524	14	f
12	1	2024-01-02 16:09:52.287092	2024-01-02 16:09:52.287092	15	f
13	1	2024-01-02 16:13:31.573234	2024-01-02 16:13:31.573234	16	f
14	1	2024-01-02 16:17:52.90546	2024-01-02 16:17:52.90546	17	f
16	1	2024-01-02 16:35:04.583624	2024-01-02 16:35:04.583624	18	f
17	1	2024-01-02 16:41:09.067413	2024-01-02 16:41:09.067413	19	f
18	1	2024-01-02 16:47:24.179353	2024-01-02 16:47:24.179353	20	f
15	1	2024-01-04 05:08:59.945603	2024-01-04 05:08:59.945603	21	f
\.


--
-- Data for Name: movie_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_categories (id, movie_id, category_id, created_at, updated_at, is_delete) FROM stdin;
3	3	9	2023-12-26 04:54:57.555613	2023-12-26 04:54:57.555613	t
4	3	9	2023-12-26 05:20:23.080453	2023-12-26 05:20:23.080453	t
2	3	3	2023-12-25 16:16:19.664377	2023-12-25 16:16:19.664377	t
1	3	1	2023-12-25 16:16:19.664377	2023-12-25 16:16:19.664377	t
6	3	3	2023-12-26 05:37:18.623726	2023-12-26 05:37:18.623726	t
7	3	3	2023-12-26 05:38:08.103178	2023-12-26 05:38:08.103178	t
8	3	3	2023-12-26 05:38:58.418706	2023-12-26 05:38:58.418706	t
5	3	1	2023-12-26 05:37:18.623726	2023-12-26 05:37:18.623726	t
10	3	3	2023-12-26 05:40:03.701599	2023-12-26 05:40:03.701599	t
11	3	1	2023-12-26 05:46:13.118409	2023-12-26 05:46:13.118409	f
9	3	1	2023-12-26 05:40:03.701599	2023-12-26 05:40:03.701599	t
12	3	3	2023-12-26 05:46:13.118409	2023-12-26 05:46:13.118409	t
13	3	3	2023-12-26 05:52:29.356001	2023-12-26 05:52:29.356001	f
14	4	8	2023-12-26 15:21:22.438958	2023-12-26 15:21:22.438958	f
15	4	7	2023-12-26 15:21:22.438958	2023-12-26 15:21:22.438958	f
16	4	2	2023-12-26 15:21:22.438958	2023-12-26 15:21:22.438958	f
17	5	1	2023-12-26 15:27:03.868334	2023-12-26 15:27:03.868334	f
18	5	3	2023-12-26 15:27:03.868334	2023-12-26 15:27:03.868334	f
19	6	7	2024-01-02 15:28:11.719465	2024-01-02 15:28:11.719465	f
20	7	7	2024-01-02 15:38:59.551629	2024-01-02 15:38:59.551629	f
21	7	2	2024-01-02 15:38:59.551629	2024-01-02 15:38:59.551629	f
22	8	7	2024-01-02 15:45:46.74493	2024-01-02 15:45:46.74493	f
23	8	5	2024-01-02 15:45:46.74493	2024-01-02 15:45:46.74493	f
24	9	1	2024-01-02 15:51:26.222	2024-01-02 15:51:26.222	f
25	9	3	2024-01-02 15:51:26.222	2024-01-02 15:51:26.222	f
26	10	2	2024-01-02 15:58:46.03579	2024-01-02 15:58:46.03579	f
27	10	7	2024-01-02 15:58:46.03579	2024-01-02 15:58:46.03579	f
28	11	2	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524	f
29	11	7	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524	f
30	11	6	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524	f
31	11	9	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524	f
32	12	1	2024-01-02 16:09:52.287092	2024-01-02 16:09:52.287092	f
33	12	2	2024-01-02 16:09:52.287092	2024-01-02 16:09:52.287092	f
34	12	3	2024-01-02 16:09:52.287092	2024-01-02 16:09:52.287092	f
35	13	6	2024-01-02 16:13:31.573234	2024-01-02 16:13:31.573234	f
36	13	1	2024-01-02 16:13:31.573234	2024-01-02 16:13:31.573234	f
37	14	6	2024-01-02 16:17:52.90546	2024-01-02 16:17:52.90546	f
38	14	9	2024-01-02 16:17:52.90546	2024-01-02 16:17:52.90546	f
39	16	1	2024-01-02 16:35:04.583624	2024-01-02 16:35:04.583624	f
40	16	3	2024-01-02 16:35:04.583624	2024-01-02 16:35:04.583624	f
41	17	5	2024-01-02 16:41:09.067413	2024-01-02 16:41:09.067413	f
42	17	9	2024-01-02 16:41:09.067413	2024-01-02 16:41:09.067413	f
43	18	5	2024-01-02 16:47:24.179353	2024-01-02 16:47:24.179353	f
44	15	1	2024-01-04 05:08:59.945603	2024-01-04 05:08:59.945603	f
45	15	3	2024-01-04 05:08:59.945603	2024-01-04 05:08:59.945603	f
\.


--
-- Data for Name: movie_couplets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_couplets (id, user_id, movie_id, couplet, meaning, created_at, updated_at, is_delete) FROM stdin;
1	4e21dd61-8f61-4024-992c-d602cd45c272	3	I wouldn't say it's great, or influence.\nWe're friends.	T├┤i sß║╜ kh├┤ng n├│i n├│ tuyß╗çt vß╗¥i hay c├│ ß║únh h╞░ß╗ƒng. Ch├║ng ta l├á bß║ín.	2023-12-28 11:17:44.007182	2023-12-28 11:17:44.007182	f
2	4e21dd61-8f61-4024-992c-d602cd45c272	3	You're an artist, Sid.	Anh l├á mß╗Öt nghß╗ç s─⌐, Sid.	2023-12-28 11:41:32.6376	2023-12-28 11:41:32.6376	f
3	4e21dd61-8f61-4024-992c-d602cd45c272	3	That's it.	─É├│ l├á n├│.	2023-12-28 11:44:52.570781	2023-12-28 11:44:52.570781	f
4	4e21dd61-8f61-4024-992c-d602cd45c272	3	Wish to hell I did.	╞»ß╗¢c g├¼ t├┤i ─æ├ú l├ám ─æ╞░ß╗úc.	2023-12-28 11:45:08.512592	2023-12-28 11:45:08.512592	f
5	4e21dd61-8f61-4024-992c-d602cd45c272	3	You're telling me you're gonna walk\noutta here and I'm never gonna see it again?	Bß║ín ─æang n├│i vß╗¢i t├┤i rß║▒ng bß║ín sß║╜ b╞░ß╗¢c ra khß╗Åi ─æ├óy v├á t├┤i sß║╜ kh├┤ng bao giß╗¥ nh├¼n thß║Ñy n├│ nß╗»a?	2023-12-28 11:53:48.278496	2023-12-28 11:53:48.278496	f
6	4e21dd61-8f61-4024-992c-d602cd45c272	3	Not you.	Kh├┤ng phß║úi bß║ín.	2023-12-28 11:53:55.49801	2023-12-28 11:53:55.49801	f
7	4e21dd61-8f61-4024-992c-d602cd45c272	3	<i>(woman screams)</i>	(ng╞░ß╗¥i phß╗Ñ nß╗» h├⌐t l├¬n)	2023-12-28 11:54:07.951846	2023-12-28 11:54:07.951846	f
\.


--
-- Data for Name: movie_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_details (id, movie_id, episode, url_movie, url_sub_en, url_sub_vi, created_at, created_by, updated_at, updated_by, is_delete) FROM stdin;
15	14	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:17:52.90546	\N	2024-01-02 16:17:52.90546	\N	f
16	15	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:28:04.756686	\N	2024-01-02 16:28:04.756686	\N	f
17	16	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:35:04.583624	\N	2024-01-02 16:35:04.583624	\N	f
2	3	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2023-12-25 16:16:19.664377	\N	2023-12-25 16:16:19.664377	\N	f
18	17	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:41:09.067413	\N	2024-01-02 16:41:09.067413	\N	f
4	3	2	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E02.720p%5Bfreedrivemovie.com%5D.mkv\t	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(2).vtt\t	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(2).vtt\t	2023-12-26 05:55:17.246332	\N	2023-12-26 05:55:17.246332	\N	f
5	4	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Friends%20Season%201/Friends.S01E01.720p.%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2023-12-26 15:19:59.912495	\N	2023-12-26 15:19:59.912495	\N	f
6	5	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Breaking%20Bad%20Season%201/Breaking.Bad.S01%5BFreeDriveMovie.com%5DEp%20(1).mp4	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2023-12-26 15:27:03.868334	\N	2023-12-26 15:27:03.868334	\N	f
7	6	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 15:27:52.360758	\N	2024-01-02 15:27:52.360758	\N	f
8	7	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 15:38:59.551629	\N	2024-01-02 15:38:59.551629	\N	f
9	8	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 15:45:46.74493	\N	2024-01-02 15:45:46.74493	\N	f
10	9	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 15:51:26.222	\N	2024-01-02 15:51:26.222	\N	f
11	10	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 15:58:46.03579	\N	2024-01-02 15:58:46.03579	\N	f
12	11	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:05:45.454524	\N	2024-01-02 16:05:45.454524	\N	f
13	12	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:09:52.287092	\N	2024-01-02 16:09:52.287092	\N	f
14	13	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:13:31.573234	\N	2024-01-02 16:13:31.573234	\N	f
19	18	1	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Prison.Break.S01E01.720p%5Bfreedrivemovie.com%5D.mkv	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/EN/PrisonBreakS01ENG%20(1).vtt	https://wmovies.sgp1.cdn.digitaloceanspaces.com/Prison%20Break%20Season%201/Sub/VN/PrisonBreakS01VI%20(1).vtt	2024-01-02 16:47:24.179353	\N	2024-01-02 16:47:24.179353	\N	f
\.


--
-- Data for Name: movie_favourite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_favourite (id, user_id, movie_id, created_at, updated_at, is_delete) FROM stdin;
1	4e21dd61-8f61-4024-992c-d602cd45c272	5	2023-12-27 05:47:47.907853	2023-12-27 05:47:47.907853	t
3	4e21dd61-8f61-4024-992c-d602cd45c272	4	2023-12-28 06:32:01.879202	2023-12-28 06:32:01.879202	f
2	4e21dd61-8f61-4024-992c-d602cd45c272	3	2023-12-27 06:11:35.431871	2023-12-27 06:11:35.431871	f
4	4e21dd61-8f61-4024-992c-d602cd45c272	16	2024-01-03 13:43:29.2966	2024-01-03 13:43:29.2966	f
\.


--
-- Data for Name: movie_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_history (id, user_id, movie_id, created_at, updated_at, is_delete, episode) FROM stdin;
18	4e21dd61-8f61-4024-992c-d602cd45c272	16	2024-01-03 13:43:33.878206	2024-01-03 13:43:33.878206	f	1
1	4e21dd61-8f61-4024-992c-d602cd45c272	4	2023-12-29 06:21:31.353565	2023-12-29 06:21:31.353565	f	1
25	4e21dd61-8f61-4024-992c-d602cd45c272	14	2024-01-04 07:58:22.630484	2024-01-04 07:58:22.630484	f	1
9	4e21dd61-8f61-4024-992c-d602cd45c272	5	2023-12-29 06:46:19.407629	2023-12-29 06:46:19.407629	f	1
28	4e21dd61-8f61-4024-992c-d602cd45c272	8	2024-01-04 07:59:01.87617	2024-01-04 07:59:01.87617	f	1
26	4e21dd61-8f61-4024-992c-d602cd45c272	17	2024-01-04 07:58:42.280613	2024-01-04 07:58:42.280613	f	1
30	4e21dd61-8f61-4024-992c-d602cd45c272	15	2024-01-04 07:59:42.362697	2024-01-04 07:59:42.362697	f	1
31	4e21dd61-8f61-4024-992c-d602cd45c272	11	2024-01-04 08:00:51.361885	2024-01-04 08:00:51.361885	f	1
32	4e21dd61-8f61-4024-992c-d602cd45c272	10	2024-01-04 08:01:11.705526	2024-01-04 08:01:11.705526	f	1
8	4e21dd61-8f61-4024-992c-d602cd45c272	3	2023-12-29 06:31:13.120292	2023-12-29 06:31:13.120292	f	1
\.


--
-- Data for Name: movie_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_images (id, movie_id, type_image, url, created_at, updated_at) FROM stdin;
74	14	image	the-silence-of-the-lambs-image-02-01-2024.jpeg	2024-01-02 16:17:52.90546	2024-01-02 16:17:52.90546
75	14	banner	the-silence-of-the-lambs-banner-02-01-2024.jpeg	2024-01-02 16:17:52.90546	2024-01-02 16:17:52.90546
78	16	image	the-raid-2:-berandal-image-02-01-2024.jpeg	2024-01-02 16:35:04.583624	2024-01-02 16:35:04.583624
79	16	banner	the-raid-2:-berandal-banner-02-01-2024.jpeg	2024-01-02 16:35:04.583624	2024-01-02 16:35:04.583624
82	17	image	oppenheimer-image-02-01-2024.jpeg	2024-01-02 16:41:09.067413	2024-01-02 16:41:09.067413
83	17	banner	oppenheimer-banner-02-01-2024.jpeg	2024-01-02 16:41:09.067413	2024-01-02 16:41:09.067413
66	11	image	goblin--image-02-01-2024.jpeg	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524
67	11	banner	goblin--banner-02-01-2024.jpeg	2024-01-02 16:05:45.454524	2024-01-02 16:05:45.454524
88	18	image	bad-genius-image-02-01-2024.jpeg	2024-01-02 16:47:24.179353	2024-01-02 16:47:24.179353
89	18	banner	bad-genius-banner-02-01-2024.jpeg	2024-01-02 16:47:24.179353	2024-01-02 16:47:24.179353
76	15	image	the-raid-redemption-image-02-01-2024.jpeg	2024-01-02 16:28:04.756686	2024-01-02 16:28:04.756686
77	15	banner	the-raid-redemption-banner-02-01-2024.jpeg	2024-01-02 16:28:04.756686	2024-01-02 16:28:04.756686
1	3	image	prison-break-season-1-image-25-12-2023.jpeg	2023-12-25 16:16:19.664377	2023-12-25 16:16:19.664377
2	3	banner	prison-break-season-1-banner-25-12-2023.jpeg	2023-12-25 16:16:19.664377	2023-12-25 16:16:19.664377
32	4	image	friends-season-1-image-26-12-2023.jpeg	2023-12-26 15:19:59.912495	2023-12-26 15:19:59.912495
33	4	banner	friends-season-1-banner-26-12-2023.jpeg	2023-12-26 15:19:59.912495	2023-12-26 15:19:59.912495
36	5	image	breaking-bad-season-1-image-26-12-2023.jpeg	2023-12-26 15:27:03.868334	2023-12-26 15:27:03.868334
37	5	banner	breaking-bad-season-1-banner-26-12-2023.jpeg	2023-12-26 15:27:03.868334	2023-12-26 15:27:03.868334
44	6	image	the-intern-image-02-01-2024.jpeg	2024-01-02 15:27:52.360758	2024-01-02 15:27:52.360758
45	6	banner	the-intern-banner-02-01-2024.jpeg	2024-01-02 15:27:52.360758	2024-01-02 15:27:52.360758
52	7	image	me-before-you-image-02-01-2024.jpeg	2024-01-02 15:38:59.551629	2024-01-02 15:38:59.551629
53	7	banner	me-before-you-banner-02-01-2024.png	2024-01-02 15:38:59.551629	2024-01-02 15:38:59.551629
54	8	image	parasite-image-02-01-2024.jpeg	2024-01-02 15:45:46.74493	2024-01-02 15:45:46.74493
55	8	banner	parasite-banner-02-01-2024.png	2024-01-02 15:45:46.74493	2024-01-02 15:45:46.74493
58	9	image	peaky-blinders-(season-1)-image-02-01-2024.jpeg	2024-01-02 15:51:26.222	2024-01-02 15:51:26.222
59	9	banner	peaky-blinders-season-1-banner-02-01-2024.jpeg	2024-01-02 15:51:26.222	2024-01-02 15:51:26.222
64	10	image	be-with-you-image-02-01-2024.jpeg	2024-01-02 15:58:46.03579	2024-01-02 15:58:46.03579
65	10	banner	be-with-you-banner-02-01-2024.jpeg	2024-01-02 15:58:46.03579	2024-01-02 15:58:46.03579
70	12	image	the-k2-image-02-01-2024.jpeg	2024-01-02 16:09:52.287092	2024-01-02 16:09:52.287092
71	12	banner	the-k2-banner-02-01-2024.jpeg	2024-01-02 16:09:52.287092	2024-01-02 16:09:52.287092
72	13	image	hannibal-season-1-image-02-01-2024.jpeg	2024-01-02 16:13:31.573234	2024-01-02 16:13:31.573234
73	13	banner	hannibal-season-1-banner-02-01-2024.jpeg	2024-01-02 16:13:31.573234	2024-01-02 16:13:31.573234
\.


--
-- Data for Name: movie_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_logs (id, movie_id, date, count_view, created_at, updated_at) FROM stdin;
1	4	2023-12-29	4	2023-12-29 06:21:31.353565	2023-12-29 06:21:31.353565
9	5	2023-12-29	1	2023-12-29 06:46:19.407629	2023-12-29 06:46:19.407629
8	3	2023-12-29	2	2023-12-29 06:31:13.120292	2023-12-29 06:31:13.120292
13	5	2023-12-30	1	2023-12-30 06:10:18.021002	2023-12-30 06:10:18.021002
11	4	2023-12-30	2	2023-12-29 17:13:47.242641	2023-12-29 17:13:47.242641
12	3	2023-12-30	2	2023-12-30 06:07:11.756957	2023-12-30 06:07:11.756957
17	3	2024-01-02	1	2024-01-02 04:48:36.389562	2024-01-02 04:48:36.389562
16	4	2024-01-02	2	2024-01-02 04:46:49.358567	2024-01-02 04:46:49.358567
19	16	2024-01-03	2	2024-01-03 13:43:33.878206	2024-01-03 13:43:33.878206
22	16	2024-01-04	1	2024-01-04 02:26:09.637631	2024-01-04 02:26:09.637631
24	4	2024-01-04	1	2024-01-04 05:30:01.037714	2024-01-04 05:30:01.037714
26	14	2024-01-04	1	2024-01-04 07:58:22.630484	2024-01-04 07:58:22.630484
28	5	2024-01-04	1	2024-01-04 07:58:52.957534	2024-01-04 07:58:52.957534
29	8	2024-01-04	1	2024-01-04 07:59:01.87617	2024-01-04 07:59:01.87617
27	17	2024-01-04	2	2024-01-04 07:58:42.280613	2024-01-04 07:58:42.280613
31	15	2024-01-04	1	2024-01-04 07:59:42.362697	2024-01-04 07:59:42.362697
32	11	2024-01-04	1	2024-01-04 08:00:51.361885	2024-01-04 08:00:51.361885
33	10	2024-01-04	1	2024-01-04 08:01:11.705526	2024-01-04 08:01:11.705526
21	3	2024-01-04	5	2024-01-04 02:24:58.291724	2024-01-04 02:24:58.291724
\.


--
-- Data for Name: movie_words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_words (id, word_id, movie_id, created_at, updated_at, is_delete, user_id) FROM stdin;
1	35	3	2023-12-28 16:34:12.414707	2023-12-28 16:34:12.414707	f	4e21dd61-8f61-4024-992c-d602cd45c272
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies (id, code, name_en, name, content, view, created_at, created_by, updated_at, updated_by, is_delete, movie_type, movie_status, country_id, year_of_manufacture, "time", total_episode) FROM stdin;
17	oppenheimer	Oppenheimer	Oppenheimer	C├óu chuyß╗çn vß╗ü J. Robert Oppenheimer, ng╞░ß╗¥i giß╗» vß╗ï tr├¡ quan trß╗ìng trong viß╗çc chß║┐ tß║ío bom nguy├¬n tß╗¡ v├áo Thß║┐ Chiß║┐n II.	2	2024-01-02 16:41:09.067413	\N	2024-01-02 16:41:09.067413	\N	f	single	recommended	1	2023	181	1
11	goblin	Goblin	Y├¬u tinh	Y├¬u Tinh xoay quanh mß╗Öt y├¬u tinh cß║ºn t├¼m kiß║┐m mß╗Öt c├┤ d├óu l├á ng╞░ß╗¥i ─æß╗â kß║┐t th├║c cuß╗Öc sß╗æng bß║Ñt tß╗¡ cß╗ºa m├¼nh v├á mß╗Öt thß║ºn chß║┐t bß╗ï mß║Ñt tr├¡ nhß╗¢. Bß╗ùng nhi├¬n hß╗ì sß╗æng chung vß╗¢i nhau kh├┤ng biß║┐t rß║▒ng ─æ├│ l├á ─æß╗ïnh mß╗çnh hay sß╗æ phß║¡n. Bß╗Ö phim kß╗â vß╗ü cuß╗Öc sß╗æng b├¡ ß║⌐n, kß╗│ lß║í, ─æ╞░ß╗úm buß╗ôn nh╞░ng ─æß║╣p ─æß║╜ cß╗ºa nhß╗»ng ng╞░ß╗¥i ─æ╞░a tiß╗àn linh hß╗ôn ng╞░ß╗¥i chß║┐t.	1	2024-01-02 16:05:45.454524	\N	2024-01-02 16:05:45.454524	\N	f	series	recommended	3	2016	80	16
16	the-raid-2:-berandal	The Raid 2: Berandal	─Éß╗Öt k├¡ch 2: Kß║╗ s├ít nh├ón	ß╗₧ phß║ºn ─æß║ºu, Rama ─æ├ú phß║úi rß║Ñt vß║Ñt vß║ú c├╣ng ─æß╗ông ─æß╗Öi cß╗ºa m├¼nh mß╗¢i c├│ thß╗â sß╗æng s├│t ─æ╞░ß╗úc sau khi ─æß╗Öt k├¡ch hang ß╗ò cß╗ºa 1 tr├╣m tß╗Öi phß║ím. ß╗₧ phß║ºn n├áy, th├¬m mß╗Öt lß║ºn nß╗»a Rama, mß╗Öt cß║únh s├ít t├ái n─âng v├á ─æß║ºy quß║ú cß║úm phß║úi kho├íc l├¬n m├¼nh chiß║┐c ├ío "tß╗Öi phß║ím" ─æß╗â triß╗çt ph├í to├án bß╗Ö ─æ╞░ß╗¥ng d├óy Mafia v├á trß║ú lß║íi sß╗▒ b├¼nh y├¬n cho th├ánh phß╗æ. Tiß║┐p nß╗æi c├óu chuyß╗çn ß╗ƒ phß║ºn 1 nhß╗»ng pha v├╡ thuß║¡t ─æß╗ënh cao c├╣ng cß╗æt truyß╗çn chß║╖t chß║╜ ─æ├ú tß║ío n├¬n h├¼nh ß║únh mß╗Öt con ng╞░ß╗¥i d┼⌐ng cß║úm v├á can tr╞░ß╗¥ng sß║╡n s├áng hi sinh ─æß╗â bß║úo vß╗ç cho gia ─æ├¼nh v├á x├ú hß╗Öi.	3	2024-01-02 16:35:04.583624	\N	2024-01-02 16:35:04.583624	\N	f	single	latest	4	2014	150	1
14	the-silence-of-the-lambs	The Silence of the Lambs	Sß╗▒ im lß║╖ng cß╗ºa bß║ºy cß╗½u	Nh├ón vi├¬n FBI tß║¡p sß╗▒ Clarice (Foster) ─æ╞░ß╗úc cß║Ñp tr├¬n cß╗¡ ─æi phß╗Ång vß║Ñn t├¬n s├ít nh├ón cß╗▒c kß╗│ nguy hiß╗âm Hannibal ΓÇ£The CannibalΓÇ¥ Lechter tß║íi bß╗çnh viß╗çn t├óm thß║ºn Maryland. Sß╗ƒ FBI hy vß╗ìng rß║▒ng t├¼m hiß╗âu vß╗ü Lechter sß║╜ gi├║p hß╗ì nß║»m ─æ╞░ß╗úc t├óm l├╜ cß╗ºa Buffalo Bill, t├¬n giß║┐t ng╞░ß╗¥i h├áng loß║ít hiß╗çn ─æang bß║»t giß╗» con g├íi cß╗ºa mß╗Öt th╞░ß╗úng nghß╗ï s─⌐. ─Éß╗â trao ─æß╗òi cho manh mß╗æi, Hannibal ─æ├▓i hß╗Åi Clarice phß║úi cung cß║Ñp tin tß╗⌐c vß╗ü ─æß╗¥i t╞░ cß╗ºa m├¼nh. Tß╗½ng b╞░ß╗¢c mß╗Öt, ng╞░ß╗¥i xem c┼⌐ng nhß║¡n ra rß║▒ng Clarice l├á mß╗Öt phß╗Ñ nß╗» vß╗¢i nhiß╗üu ch╞░ß╗¢ng nghiß╗çp.	1	2024-01-02 16:17:52.90546	\N	2024-01-02 16:17:52.90546	\N	f	single	latest	2	2024	118	1
4	friends-season-1	Friends Season 1	Nhß╗»ng ng╞░ß╗¥i bß║ín - M├╣a 1	M├╣a phim ─æß║ºu ti├¬n giß╗¢i thiß╗çu 6 nh├ón vß║¡t ch├¡nh: Rachel, Monica, Phoebe, Joey, Chandler v├á Ross. Rachel t├¼m ─æß║┐n Central Perk sau khi bß╗Å trß╗æn khß╗Åi ─æ├ím c╞░ß╗¢i vß╗¢i h├┤n phu Barry v├á dß╗ìn ─æß║┐n ß╗ƒ c├╣ng vß╗¢i Monica, ng╞░ß╗¥i bß║ín th├ón cß╗ºa c├┤ thß╗¥i trung hß╗ìc. Ross, ng╞░ß╗¥i thß║ºm mß║┐n Rachel tß╗½ khi cß║ú hai c├▓n ß╗ƒ tr╞░ß╗¥ng trung hß╗ìc, li├¬n tß╗Ñc cß╗æ gß║»ng thß╗ò lß╗Ö t├¼nh cß║úm cß╗ºa m├¼nh vß╗¢i c├┤. D├╣ vß║¡y, anh lu├┤n gß║╖p phß║úi ch╞░ß╗¢ng ngß║íi, nh╞░ khi chuß║⌐n bß╗ï c├│ con vß╗¢i ng╞░ß╗¥i vß╗ú c┼⌐ l├á ─æß╗ông t├¡nh nß╗», Carol. Joey l├á mß╗Öt diß╗àn vi├¬n ─æß╗Öc th├ón sß╗æng chß║¡t vß║¡t, trong khi Phoebe l├á mß╗Öt nh├ón vi├¬n massage mang t├¡nh c├ích "─æi├¬n rß╗ô" dß╗▒a tr├¬n nhß╗»ng rß║»c rß╗æi l├║c nhß╗Å sau khi mß║╣ c├┤ tß╗▒ s├ít. Chandler chia tay vß╗¢i c├┤ bß║ín g├íi Janice (Maggie Wheeler), ng╞░ß╗¥i th╞░ß╗¥ng xuy├¬n c├│ mß║╖t trong nhß╗»ng m├╣a sau n├áy. V├áo cuß╗æi m├╣a phim, Chandler v├┤ t├¼nh tiß║┐t lß╗Ö t├¼nh cß║úm cß╗ºa Ross vß╗¢i Rachel, ng╞░ß╗¥i nhß║¡n ra m├¼nh c┼⌐ng c├│ cß║úm nhß║¡n t╞░╞íng tß╗▒. M├╣a phim kß║┐t th├║c khi Rachel ─æß╗⌐ng chß╗¥ Ross tß║íi s├ón bay sau mß╗Öt chuyß║┐n ─æi.	11	2023-12-26 15:19:59.912495	\N	2023-12-26 15:19:59.912495	\N	f	series	recommended	2	2023	24	24
15	the-raid-redemption	The Raid Redemption	─Éß╗Öt k├¡ch: Chuß╗Öc tß╗Öi	Tß║íi Jakarta, Indonesia, tß╗ò chß╗⌐c Lieutenant Wahyu triß╗ân khai mß╗Öt cuß╗Öc tß║Ñn c├┤ng v├áo mß╗Öt t├▓a nh├á l├á hang ß╗ò cß╗ºa Tama v├á b─âng ─æß║úng cß╗ºa hß║»n. ─Éß╗Öi SWAT bß╗ï mß║»c kß║╣t tr├¬n tß║ºng thß╗⌐ bß║úy, hß╗ì biß║┐t rß║▒ng Lieutenant Wahyu ─æ├ú kh├┤ng th├┤ng b├ío cß║Ñp tr├¬n cß╗ºa m├¼nh vß╗ü hoß║ít ─æß╗Öng n├áy. Do ─æ├│, c├íc s─⌐ quan cß║únh s├ít phß║úi chiß║┐n ─æß║Ñu vß╗¢i ─æß║ín d╞░ß╗úc hß║ín chß║┐ chß╗æng lß║íi b─âng ─æß║úng tß╗Öi phß║ím c├│ v┼⌐ trang v├á cß╗▒c kß╗│ nguy hiß╗âm.	1	2024-01-02 16:28:04.756686	\N	2024-01-02 16:28:04.756686	\N	f	single	latest	4	2011	100	1
8	parasite	Parasite	K├╜ sinh tr├╣ng	K├╜ sinh tr├╣ng (Parasite) l├á mß╗Öt bß╗Ö phim ─æiß╗çn ß║únh H├án Quß╗æc thuß╗Öc thß╗â loß║íi h├ái ─æen ΓÇô giß║¡t g├ón ΓÇô ch├¡nh kß╗ïch c├┤ng chiß║┐u n─âm 2019 do Bong Joon-ho l├ám ─æß║ío diß╗àn, viß║┐t kß╗ïch bß║ún vß╗¢i Han Jin-won v├á hß╗úp t├íc sß║ún xuß║Ñt bß╗Ö phim. Vß╗¢i sß╗▒ tham gia cß╗ºa c├íc diß╗àn vi├¬n gß╗ôm Song Kang-ho, Lee Sun-kyun, Cho Yeo-jeong, Choi Woo-shik, Park So-dam, Lee Jung-eun, Park Myung-hoon v├á Jang Hye-jin, bß╗Ö phim theo ch├ón vß╗ü mß╗Öt gia ─æ├¼nh ngh├¿o c├│ kß║┐ hoß║ích trß╗ƒ th├ánh nhß╗»ng th├ánh vi├¬n cß╗ºa mß╗Öt gia ─æ├¼nh gi├áu c├│ v├á x├óm nhß║¡p v├áo hß╗Ö gia ─æ├¼nh cß╗ºa hß╗ì bß║▒ng c├ích ─æ├│ng giß║ú l├á nhß╗»ng ng╞░ß╗¥i kh├┤ng li├¬n quan c├│ tr├¼nh ─æß╗Ö chuy├¬n m├┤n cao.	1	2024-01-02 15:45:46.74493	\N	2024-01-02 15:45:46.74493	\N	f	single	recommended	3	2019	132	1
10	be-with-you	Be With You	V├á em sß║╜ ─æß║┐n	Soo-ah (Son ye-jin) tr╞░ß╗¢c khi ra ─æi ─æ├ú tr─ân trß╗æi vß╗¢i chß╗ông c├┤ l├á Woo-jin (So Ji-sub) rß║▒ng c├┤ sß║╜ trß╗ƒ lß║íi v├áo mß╗Öt c╞ín m╞░a ─æß║ºu m├╣a n─âm sau. Thß╗¥i gian cß╗⌐ thß║┐ tr├┤i ─æi, nhß╗»ng t╞░ß╗ƒng nhß╗»ng lß╗¥i hß╗⌐a ─æ├│ c┼⌐ng sß║╜ tr├┤i theo nhß╗»ng c╞ín m╞░a ─æß║ºu m├╣a ngo├ái kia. Cho ─æß║┐n mß╗Öt ng├áy nß╗ì, ─æiß╗üu kß╗│ diß╗çu ─æ├ú ─æß║┐n, Soo-ah ─æ├ú giß╗» lß╗¥i hß╗⌐a v├á trß╗ƒ lß║íi tr╞░ß╗¢c mß║╖t chß╗ông v├á con trai nh╞░ng c├┤ lß║íi mß║Ñt hß║┐t k├╜ ß╗⌐c. Thß║¡t trß╗¢ tr├¬u l├á cuß╗Öc hß╗Öi ngß╗Ö cß╗ºa hß╗ì rß║Ñt ngß║»n ngß╗ºi v├¼ Soo-ah phß║úi rß╗¥i khß╗Åi gia ─æ├¼nh m├¼nh mß╗Öt lß║ºn nß╗»a sau khi m├╣a m╞░a n─âm ─æ├│ kß║┐t th├║c.	1	2024-01-02 15:58:46.03579	\N	2024-01-02 15:58:46.03579	\N	f	single	recommended	3	2018	132	1
6	the-intern	The Intern	Bß╗æ gi├á hß╗ìc viß╗çc	Bß╗Ö phim kß╗â vß╗ü Ben Whittaker, mß╗Öt ├┤ng l├úo g├│a vß╗ú 70 tuß╗òi (do Robert De Niro thß╗º vai) nh╞░ng kh├┤ng hß╗ü muß╗æn nghß╗ë h╞░u v├á xin v├áo l├ám nh├ón vi├¬n thß╗▒c tß║¡p tß║íi mß╗Öt cß╗¡a h├áng thß╗¥i trang online cß╗ºa c├┤ chß╗º xinh ─æß║╣p v├á s├ánh ─æiß╗çu, Jules Ostin (do Anne Hathaway thß╗º vai). V├á c├óu chuyß╗çn diß╗àn ra khi ├┤ng l├úo Ben Whittaker ch├¡nh thß╗⌐c trß╗ƒ th├ánh thß╗▒c tß║¡p sinh thß╗▒c thß╗Ñ, rß║Ñt trß║╗ trung v├á n─âng ─æß╗Öng kh├┤ng thua k├⌐m bß║Ñt k├¼ ai. H╞ín hß║┐t, Ben ─æ├ú gi├║p ─æß╗í Jules khi c├┤ n├áng gß║╖p kh├│ kh─ân, truyß╗ün cß║úm hß╗⌐ng v├á tß║ío ─æß╗Öng lß╗▒c ─æß╗â Jules tiß║┐p tß╗Ñc ─æam m├¬ ngh├¬ nghiß╗çp cß╗ºa m├¼nh.	0	2024-01-02 15:27:52.360758	\N	2024-01-02 15:27:52.360758	\N	f	single	latest	4	2015	120	1
7	me-before-you	Me Before You	Tr╞░ß╗¢c ng├áy em ─æß║┐n	Nß╗Öi dung bß╗Ö phim kß╗â vß╗ü c├óu chuyß╗çn t├¼nh cß╗ºa c├┤ g├íi 26 tuß╗òi Louisa Clark sß╗æng ß╗ƒ mß╗Öt thß╗ï trß║Ñn cß╗ò miß╗ün qu├¬ n╞░ß╗¢c Anh. Lou l├á c├┤ g├íi c├│ phong c├ích ─ân mß║╖c m├áu m├¿ kh├íc biß╗çt, kh├┤ng c├│ ph╞░╞íng h╞░ß╗¢ng v├á ╞░ß╗¢c m╞í c├í nh├ón cß╗Ñ thß╗â n├áo cß║ú, d├╣ rß║Ñt vui vß║╗ lß║íc quan nh╞░ng Lou lß║íi phß║úi vß║Ñt vß║ú l├ám viß╗çc ─æß╗â gi├║p ─æß╗í gia ─æ├¼nh kh├│ kh─ân cß╗ºa m├¼nh. C├┤ng viß╗çc mß╗¢i cß╗ºa Lou l├ám ch─âm s├│c cho Will Traynor, mß╗Öt chß╗º nh├á b─âng trß║╗ tuß╗òi gi├áu c├│ bß╗ï liß╗çt nß╗¡a ng╞░ß╗¥i v├á phß║úi gß║»n chß║╖t ─æß╗¥i m├¼nh tr├¬n chiß║┐c xe l─ân. Tai nß║ín thß║úm khß╗æc 2 n─âm tr╞░ß╗¢c ─æ├ú biß║┐n Will tß╗½ mß╗Öt ch├áng trai mß║ính mß║╜ ph├│ng kho├íng trß╗ƒ th├ánh mß╗Öt ng╞░ß╗¥i cß╗æ chß║Ñp, ─æß║ºu h├áng sß╗æ phß║¡n. Cuß╗Öc gß║╖p gß╗í ─æ├ú trß╗ƒ th├ánh b╞░ß╗¢c ngoß║╖t l├ám thay ─æß╗òi cuß╗Öc ─æß╗¥i v├á tr├íi tim cß╗ºa cß║ú hai nh├ón vß║¡t.	0	2024-01-02 15:38:59.551629	\N	2024-01-02 15:38:59.551629	\N	f	single	recommended	2	2016	110	1
12	the-k2	The K2	Mß║¡t danh K2 	The K2 xoay quanh c├óu chuyß╗çn cß╗ºa Kim Je Ha, c├▓n ─æ╞░ß╗úc gß╗ìi l├á K2, mß╗Öt ng╞░ß╗¥i l├¡nh y├¬u n╞░ß╗¢c bß╗ï ch├¡nh Tß╗ò quß╗æc v├á ─æß╗ông nghiß╗çp phß║ún bß╗Öi. Giß╗¥ ─æ├óy, anh ta ─æ╞░ß╗úc thu├¬ l├ám vß╗ç s─⌐ ri├¬ng cho Choi Yoo Jin, vß╗ú cß╗ºa ß╗⌐ng cß╗¡ vi├¬n Tß╗òng thß╗æng ─æß╗ông thß╗¥i l├á ├íi nß╗» cß╗ºa mß╗Öt gia ─æ├¼nh t├ái phiß╗çt.Go Ahn Na, c├┤ con g├íi ri├¬ng cß╗ºa vß╗ï ß╗⌐ng cß╗¡ vi├¬n Tß╗òng thß╗æng. Nhß╗»ng tß╗òn th╞░╞íng thß╗¥i th╞í ß║Ñu khiß║┐n Go Ahn Na trß╗ƒ n├¬n c├┤ lß║¡p v├á ├¡t giao tiß║┐p vß╗¢i thß║┐ giß╗¢i. ─Éß╗æi vß╗¢i c├┤, t├¼nh y├¬u chß╗ë l├á c├┤ng cß╗Ñ ─æß╗â trß║ú th├╣. ─É├óy l├á ng╞░ß╗¥i sß║╜ khiß║┐n tr├íi tim Kim Je Ha phß║úi rung ─æß╗Öng?\n\n	0	2024-01-02 16:09:52.287092	\N	2024-01-02 16:09:52.287092	\N	f	series	latest	3	2016	60	16
9	peaky-blinders-season-1	Peaky Blinders Season 1	B├│ng ma Anh Quß╗æc (M├╣a 1)	Mß╗Öt b─âng ─æß║úng kh├⌐t tiß║┐ng xuß║Ñt hiß╗çn ß╗ƒ Birmingham, Anh Quß╗æc n─âm 1919. Cß║ºm ─æß║ºu b─âng l├á Tommy Shelby, t├¬n tr├╣m tß╗Öi phß║ím kh├⌐t tiß║┐ng muß╗æn nß╗òi l├¬n bß║▒ng mß╗ìi gi├í.	0	2024-01-02 15:51:26.222	\N	2024-01-02 15:51:26.222	\N	f	series	latest	1	2024	57	6
18	bad-genius	Bad Genius	Thi├¬n t├ái bß║Ñt hß║úo	Mß╗Öt hß╗ìc sinh giß╗Åi bß╗ï l├┤i k├⌐o v├áo ─æ╞░ß╗¥ng d├óy gian lß║¡n hß╗ìc ─æ╞░ß╗¥ng vß╗¢i ─æß║ºy rß║½y rß╗ºi ro, nh╞░ng ─æi liß╗ün vß╗¢i n├│ c┼⌐ng l├á c╞í hß╗Öi kiß║┐m tiß╗ün. Nh╞░ng c├│ thß╗â c├┤ ß║Ñy sß║╜ ─æ╞░ß╗úc ├¡t h╞ín l├á mß║Ñt.	0	2024-01-02 16:47:24.179353	\N	2024-01-02 16:47:24.179353	\N	f	single	recommended	5	2017	129	1
13	hannibal-season-1	Hannibal Season 1	B├íc S─⌐ ─én Thß╗ït Ng╞░ß╗¥i M├╣a 1	Hannibal l├á mß╗Öt bß╗Ö phim truyß╗ün h├¼nh nhiß╗üu tß║¡p thuß╗Öc thß╗â loß║íi kinh dß╗ï viß╗àn t╞░ß╗ƒng, ─æiß╗üu tra hiß╗çn tr╞░ß╗¥ng vß╗Ñ ├ín cß╗ºa Mß╗╣, sß║ún xuß║Ñt n─âm 2012 v├á ─æ╞░ß╗úc ph├ít triß╗ân bß╗ƒi Bryan Fuller cho k├¬nh truyß╗ün h├¼nh NBC. Bß╗Ö phim dß╗▒a tr├¬n nhß╗»ng nh├ón vß║¡t v├á c├íc t├¼nh tiß║┐t xß║úy ra trong cuß╗æn tiß╗âu thuyß║┐t Red Dragon cß╗ºa Thomas Harris vß╗¢i mß╗Öt bß╗æi cß║únh hiß╗çn ─æß║íi v├á tß║¡p trung v├áo c├íc mß╗æi quan hß╗ç vß╗½a bß║»t ─æß║ºu giß╗»a ─æiß╗üu tra vi├¬n ─æß║╖c biß╗çt Graham Will cß╗ºa FBI v├á Tiß║┐n s─⌐ Hannibal Lecter, mß╗Öt b├íc s─⌐ t├óm thß║ºn ph├íp y ─æ├ú trß╗ƒ th├ánh ─æß╗æi thß╗º xß║úo quyß╗çt nhß║Ñt cß╗ºa Graham Will. Phim ─æ╞░ß╗úc c├┤ng chiß║┐u 13 tß║¡p cho m├╣a ra mß║»t ─æß║ºu ti├¬n v├á kh├┤ng giß╗æng nh╞░ hß║ºu hß║┐t c├íc ch╞░╞íng tr├¼nh c├┤ng chiß║┐u tr╞░ß╗¢c ─æ├óy tß║íi Hoa Kß╗│, bß║Ñt kß╗│ m├╣a chiß║┐u ra mß║»t trong t╞░╞íng lai, mß╗ùi phim truyß╗ün h├¼nh c┼⌐ng sß║╜ c├│ 13 tß║¡p. David Slade ─æiß╗üu h├ánh sß║ún xuß║Ñt v├á chß╗ë ─æß║ío th├¡ ─æiß╗âm. Bß╗Ö phim c├┤ng chiß║┐u lß║ºn ─æß║ºu tr├¬n k├¬nh NBC ng├áy 04 Th├íng T╞░ n─âm 2013.	0	2024-01-02 16:13:31.573234	\N	2024-01-02 16:13:31.573234	\N	f	series	recommended	2	2013	43	13
5	breaking-bad-season-1	Breaking Bad Season 1	Tß║¡p l├ám ng╞░ß╗¥i xß║Ñu - Phß║ºn 1	Breaking Bad - Season 1 (Ph├í Luß║¡t 1) ─æ╞░ß╗úc ─æ├ính gi├í l├á mß╗Öt trong nhß╗»ng phim truyß╗ün h├¼nh hay nhß║Ñt trong lß╗ïch sß╗¡, l├á c├óu chuyß╗çn kß╗â vß╗ü cuß╗Öc sß╗æng cß╗ºa Walter White ΓÇô mß╗Öt gi├ío vi├¬n nh├║t nh├ít dß║íy Ho├í cß║Ñp 3 c├│ cuß╗Öc sß╗æng nh├ám ch├ín tß║íi New Mexico vß╗¢i ng╞░ß╗¥i vß╗ú ─æang mang thai v├á ─æß╗⌐a con trai thiß║┐u ni├¬n mß║»c bß╗çnh bß║íi n├úo. Cuß╗Öc sß╗æng cß╗ºa Walter phß╗⌐c tß║íp h╞ín khi, v├áo ng├áy sau sinh nhß║¡t thß╗⌐ 50 cß╗ºa m├¼nh, ├┤ng ─æ╞░ß╗úc chß║⌐n ─æo├ín ß╗ƒ giai ─æoß║ín cuß╗æi cß╗ºa c─ân bß╗çnh ung th╞░ phß╗òi . ─Éß╗â ─æß║úm bß║úo t╞░╞íng lai cho gia ─æ├¼nh, ├┤ng v├á Jesse Pinkman - cß║¡u hß╗ìc tr├▓ c┼⌐ cß╗ºa m├¼nh, mß╗Öt t├¬n bu├┤n ma tu├╜, ─æ├ú hß╗úp t├íc c├╣ng nhau sß║ún xuß║Ñt ma tu├╜ ─æ├í cao cß║Ñp ─æem b├ín ra thß╗ï tr╞░ß╗¥ng. Walter bß║»t ─æß║ºu ─æß╗æi diß╗çn vß╗¢i cuß╗Öc sß╗æng b├¡ mß║¡t cß╗ºa m├¼nh, v├á t├¼m mß╗ìi c├ích ─æß╗â che giß║Ñu danh t├¡nhΓÇªMß╗ìi chuyß╗çn bi h├ái nß║úy sinh tß╗½ ─æ├óy!	3	2023-12-26 15:27:03.868334	\N	2023-12-26 15:27:03.868334	\N	f	series	latest	2	2008	58	7
3	prison-break-season-1	Prison Break Season 1	V╞░ß╗út Ngß╗Ñc Phß║ºn 1	"Prison Break" l├á mß╗Öt bß╗Ö phim truyß╗ün h├¼nh tß╗Öi phß║ím, ─æ╞░ß╗úc ph├ít s├│ng tr├¬n k├¬nh truyß╗ün h├¼nh FOX tß╗½ n─âm 2005 ─æß║┐n 2009. Phim c├│ tß╗òng cß╗Öng 5 m├╣a, nh╞░ng season 1 l├á m├╣a ─æß║ºu ti├¬n v├á l├á n╞íi khß╗ƒi ─æß║ºu cß╗ºa c├óu chuyß╗çn.\n\nV╞░ß╗út Ngß╗Ñc Phß║ºn 1 xoay quanh nh├ón vß║¡t ch├¡nh l├á Michael Scofield (do Wentworth Miller thß╗º vai), mß╗Öt kß╗╣ s╞░ trß║╗ th├┤ng minh, bß╗ï kß║┐t ├ín tß╗¡ h├¼nh v├¼ tß╗Öi giß║┐t anh em cß╗ºa Tß╗òng thß╗æng Hoa Kß╗│. Tuy nhi├¬n, anh ta tin rß║▒ng m├¼nh bß╗ï sai khiß║┐n v├á ─æ├ú t├¼m c├ích l├¬n kß║┐ hoß║ích ─æß╗â tß║⌐u tho├ít khß╗Åi nh├á t├╣ Sona.\n\n─Éß╗â l├ám ─æ╞░ß╗úc ─æiß╗üu n├áy, Michael ─æ├ú phß║úi l├¬n kß║┐ hoß║ích t├ío bß║ío, ─æ├│ l├á cß╗æ gß║»ng v├áo t├╣ vß╗¢i t╞░ c├ích mß╗Öt t├╣ nh├ón b├¼nh th╞░ß╗¥ng, x├óy dß╗▒ng c├íc mß╗æi quan hß╗ç vß╗¢i c├íc t├╣ nh├ón kh├íc v├á ─æß║╖c biß╗çt l├á anh ta phß║úi t├¼m c├ích lß║Ñy ─æ╞░ß╗úc bß║ún thiß║┐t kß║┐ chi tiß║┐t cß╗ºa nh├á t├╣ ─æß╗â thß╗▒c hiß╗çn kß║┐ hoß║ích.	10	2023-12-25 16:16:19.664377	\N	2023-12-25 16:16:19.664377	\N	f	series	latest	2	2005	40	22
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email, created_at, updated_at, is_delete) FROM stdin;
11e4f31c-b530-47ea-a05a-405067c6c1bb	lehuyhoang	$2b$10$Y5neUSKXxTY7p.yFVDnuy.0UDUebhaU1XZNeUK4trOnN180Su1yea	lehuyhoang@tlus.edu.vn	2023-12-20 12:48:07.608133	2023-12-20 12:48:07.608133	t
afc98078-d1cf-4d6f-894a-ed708dc9344d	test123	$2b$10$k/dfoCDymXIlo0JlRhPec.cZQhR5jLFHrLi7cQIINPcHJVpGaRhCG	test123@gmail.com	2023-12-20 13:14:33.226163	2023-12-20 13:14:33.226163	t
45fbcfba-ba08-49c7-98bc-e37552179839	huia	$2b$10$YmbZfU3zskfWdjSRjYoQVeDFPrurkmJxvV01aUXzBZ8/EyWKHNM6e	lehuyhoang@tlus.edu.vn	2023-12-20 13:23:05.803809	2023-12-20 13:23:05.803809	t
f4c77151-4905-477e-bed8-b6dbfba97bef	├ófasfa	$2b$10$mC/RZBrhIgnRIgeZC1YlP.T9tcvEsgUL0tHC3/pjZ5Syu7u0CTMMO	lehuyhoang@tlus.edu.vn	2023-12-20 13:24:05.365903	2023-12-20 13:24:05.365903	t
4e21dd61-8f61-4024-992c-d602cd45c272	hoang11120011	$2b$10$1DUBVNhs8cFg6/Ylyz/2p.LDFFoTUs7rQkdqJ.MiAVVNmhDyaqtCe	lehuyhoang@tlus.edu.vn	2023-12-20 13:26:32.479611	2023-12-20 13:26:32.479611	f
\.


--
-- Name: actors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actors_id_seq', 1, true);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 11, true);


--
-- Name: comment_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_likes_id_seq', 18, true);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 13, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 5, true);


--
-- Name: dictionary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dictionary_id_seq', 71, true);


--
-- Name: error_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.error_logs_id_seq', 2, true);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedbacks_id_seq', 1, true);


--
-- Name: movie_actors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_actors_id_seq', 21, true);


--
-- Name: movie_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_categories_id_seq', 45, true);


--
-- Name: movie_couplets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_couplets_id_seq', 7, true);


--
-- Name: movie_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_details_id_seq', 19, true);


--
-- Name: movie_favourite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_favourite_id_seq', 4, true);


--
-- Name: movie_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_history_id_seq', 33, true);


--
-- Name: movie_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_images_id_seq', 91, true);


--
-- Name: movie_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_log_id_seq', 35, true);


--
-- Name: movie_words_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_words_id_seq', 1, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_id_seq', 18, true);


--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: actors actors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actors
    ADD CONSTRAINT actors_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: categories category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: comment_likes comment_likes_comment_id_user_like_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_comment_id_user_like_id_key UNIQUE (comment_id, user_like_id);


--
-- Name: comment_likes comment_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: dictionaries dictionary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dictionaries
    ADD CONSTRAINT dictionary_pkey PRIMARY KEY (id);


--
-- Name: error_logs error_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT error_logs_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: movie_actors movie_actors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_actors
    ADD CONSTRAINT movie_actors_pkey PRIMARY KEY (id);


--
-- Name: movie_categories movie_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_categories
    ADD CONSTRAINT movie_categories_pkey PRIMARY KEY (id);


--
-- Name: movie_couplets movie_couplets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_couplets
    ADD CONSTRAINT movie_couplets_pkey PRIMARY KEY (id);


--
-- Name: movie_couplets movie_couplets_user_id_couplet_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_couplets
    ADD CONSTRAINT movie_couplets_user_id_couplet_key UNIQUE (user_id, couplet);


--
-- Name: movie_details movie_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_details
    ADD CONSTRAINT movie_details_pkey PRIMARY KEY (id);


--
-- Name: movie_favourite movie_favourite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_favourite
    ADD CONSTRAINT movie_favourite_pkey PRIMARY KEY (id);


--
-- Name: movie_history movie_history_movie_id_user_id_episode_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_history
    ADD CONSTRAINT movie_history_movie_id_user_id_episode_key UNIQUE (movie_id, user_id, episode);


--
-- Name: movie_history movie_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_history
    ADD CONSTRAINT movie_history_pkey PRIMARY KEY (id);


--
-- Name: movie_images movie_images_movie_id_type_image_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_images
    ADD CONSTRAINT movie_images_movie_id_type_image_key UNIQUE (movie_id, type_image);


--
-- Name: movie_images movie_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_images
    ADD CONSTRAINT movie_images_pkey PRIMARY KEY (id);


--
-- Name: movie_logs movie_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_logs
    ADD CONSTRAINT movie_log_pkey PRIMARY KEY (id);


--
-- Name: movie_logs movie_logs_movie_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_logs
    ADD CONSTRAINT movie_logs_movie_id_date_key UNIQUE (movie_id, date);


--
-- Name: movie_words movie_words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_words
    ADD CONSTRAINT movie_words_pkey PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgres
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgres
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

