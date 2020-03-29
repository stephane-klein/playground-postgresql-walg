SET client_min_messages = error;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

DROP TABLE IF EXISTS public.contacts CASCADE;

CREATE TABLE public.contacts (
    id             UUID PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
    email          VARCHAR(255) NOT NULL,
    firstname      VARCHAR(255),
    lastname       VARCHAR(255),
    created_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX contacts_email_index ON public.contacts (email);

SET client_min_messages = INFO;
