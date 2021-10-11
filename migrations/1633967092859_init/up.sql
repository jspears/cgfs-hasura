SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.address (
    id uuid NOT NULL,
    line1 text NOT NULL,
    line2 text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    zip text NOT NULL,
    location point NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);
CREATE TABLE public.game (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    home_team_id uuid NOT NULL,
    visitor_team_id uuid NOT NULL,
    start date,
    "end" date,
    address_id uuid,
    home_team_runs integer,
    visitor_team_runs integer,
    created_at timestamp with time zone,
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public.league (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    address_id uuid,
    updated_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public.player (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    "birthDate" date,
    address_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public.player_role (
    role text NOT NULL
);
CREATE TABLE public.role (
    name text NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);
CREATE TABLE public.team (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    league_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public.team_player_role (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    team_id uuid NOT NULL,
    player_id uuid NOT NULL,
    role_id text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public."user" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    last_seen timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    auth0 text,
    updated_at timestamp with time zone DEFAULT now()
);
CREATE TABLE public.user_role (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_at timestamp with time zone DEFAULT now()
);
ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.player_role
    ADD CONSTRAINT player_role_pkey PRIMARY KEY (role);
ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.team_player_role
    ADD CONSTRAINT team_player_role_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_name_key UNIQUE (name);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_user_id_role_id_key UNIQUE (user_id, role_id);
CREATE TRIGGER set_public_address_updated_at BEFORE UPDATE ON public.address FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_address_updated_at ON public.address IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_game_updated_at BEFORE UPDATE ON public.game FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_game_updated_at ON public.game IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_league_updated_at BEFORE UPDATE ON public.league FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_league_updated_at ON public.league IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_player_updated_at BEFORE UPDATE ON public.player FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_player_updated_at ON public.player IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_team_updated_at BEFORE UPDATE ON public.team FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_team_updated_at ON public.team IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_user_role_updated_at BEFORE UPDATE ON public.user_role FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_role_updated_at ON public.user_role IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_user_updated_at BEFORE UPDATE ON public."user" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_updated_at ON public."user" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES public.team(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_visitor_team_id_fkey FOREIGN KEY (visitor_team_id) REFERENCES public.team(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_league_id_fkey FOREIGN KEY (league_id) REFERENCES public.league(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.team_player_role
    ADD CONSTRAINT team_player_role_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.team_player_role
    ADD CONSTRAINT team_player_role_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.player(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.team_player_role
    ADD CONSTRAINT team_player_role_role_fkey FOREIGN KEY (role_id) REFERENCES public.player_role(role) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.team_player_role
    ADD CONSTRAINT team_player_role_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.team(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_created_by_fkey FOREIGN KEY (created_by) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE SET NULL ON DELETE SET NULL;
