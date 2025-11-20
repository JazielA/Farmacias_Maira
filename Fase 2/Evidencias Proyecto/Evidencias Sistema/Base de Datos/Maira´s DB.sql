CREATE TABLE public.boletas (
  folio integer NOT NULL,
  id integer,
  sucursal_id real,
  tipodoc character varying,
  fecha date,
  rut character varying,
  rs text,
  montoneto numeric,
  montoexento numeric,
  montoiva numeric,
  montonf numeric,
  montototal numeric,
  pdf text,
  xml text,
  estado character varying,
  trackid character varying,
  referencias jsonb,
  timestamp_descarga timestamp without time zone,
  CONSTRAINT boletas_pkey PRIMARY KEY (folio)
);
CREATE TABLE public.boletas_detalles (
  id integer NOT NULL DEFAULT nextval('boletas_detalles_id_seq'::regclass),
  boleta_folio integer,
  item_index integer,
  codigo character varying,
  nombre text,
  cantidad numeric,
  unidad character varying,
  precio numeric,
  descuento numeric,
  exento integer,
  bodega integer,
  costo_unitario_neto jsonb,
  CONSTRAINT boletas_detalles_pkey PRIMARY KEY (id),
  CONSTRAINT boletas_detalles_boleta_folio_fkey FOREIGN KEY (boleta_folio) REFERENCES public.boletas(folio),
  CONSTRAINT fk_producto FOREIGN KEY (codigo) REFERENCES public.productos_normalizados(codigo)
);
CREATE TABLE public.boletas_pagos (
  id integer NOT NULL DEFAULT nextval('boletas_pagos_id_seq'::regclass),
  boleta_folio integer,
  fecha timestamp without time zone,
  mediopago integer,
  monto numeric,
  glosa text,
  cobrar integer,
  CONSTRAINT boletas_pagos_pkey PRIMARY KEY (id),
  CONSTRAINT boletas_pagos_boleta_folio_fkey FOREIGN KEY (boleta_folio) REFERENCES public.boletas(folio)
);

CREATE TABLE public.mensaje_destinatarios (
  id bigint NOT NULL DEFAULT nextval('mensaje_destinatarios_id_seq'::regclass),
  mensaje_id bigint NOT NULL,
  destinatario_id uuid NOT NULL,
  read_at timestamp with time zone,
  archived_at timestamp with time zone,
  deleted_at timestamp with time zone,
  CONSTRAINT mensaje_destinatarios_pkey PRIMARY KEY (id),
  CONSTRAINT mensaje_destinatarios_mensaje_id_fkey FOREIGN KEY (mensaje_id) REFERENCES public.mensajes(id)
);
CREATE TABLE public.mensajes (
  id bigint NOT NULL DEFAULT nextval('mensajes_id_seq'::regclass),
  remitente_id uuid NOT NULL,
  asunto character varying NOT NULL,
  cuerpo text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT mensajes_pkey PRIMARY KEY (id)
);
CREATE TABLE public.permissions (
  id uuid NOT NULL,
  name text NOT NULL,
  description text,
  resource text NOT NULL,
  action text NOT NULL,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT permissions_pkey PRIMARY KEY (id)
);

CREATE TABLE public.productos_pos (
  id bigint NOT NULL,
  nombre text NOT NULL,
  codigo character varying,
  unidad character varying,
  descripcion text,
  exento boolean,
  fraccionable boolean,
  activo boolean DEFAULT true,
  param1 text,
  param2 text,
  param3 text,
  param4 text,
  preciocompraneto numeric,
  precioventabruto numeric,
  cod_imp_venta character varying,
  cod_imp_compra character varying,
  peso numeric,
  largo numeric,
  ancho numeric,
  alto numeric,
  stocks jsonb,
  atributos jsonb,
  otrosprecios jsonb,
  timestamp_descarga timestamp with time zone DEFAULT now(),
  CONSTRAINT productos_pos_pkey PRIMARY KEY (id)
);

CREATE TABLE public.stock_minimo (
  producto_id bigint NOT NULL REFERENCES productos_pos(id),
  bodega_id bigint NOT NULL,
  stock_minimo numeric NOT NULL DEFAULT 0,
  PRIMARY KEY (producto_id, bodega_id)
);
CREATE TABLE public.products (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  ean text UNIQUE,
  fingerprint text UNIQUE,
  name text NOT NULL,
  active_ingredient text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT products_pkey PRIMARY KEY (id)
);
CREATE TABLE public.provider_prices (
  id bigint NOT NULL DEFAULT nextval('provider_prices_id_seq'::regclass),
  product_id uuid NOT NULL,
  provider_id uuid NOT NULL,
  price numeric NOT NULL,
  last_updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT provider_prices_pkey PRIMARY KEY (id),
  CONSTRAINT provider_prices_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT provider_prices_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id)
);
CREATE TABLE public.providers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT providers_pkey PRIMARY KEY (id)
);
CREATE TABLE public.role_permissions (
  id uuid NOT NULL,
  role_id uuid NOT NULL,
  permission_id uuid NOT NULL,
  CONSTRAINT role_permissions_pkey PRIMARY KEY (id),
  CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id),
  CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id)
);
CREATE TABLE public.roles (
  id uuid NOT NULL,
  name text NOT NULL,
  description text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT roles_pkey PRIMARY KEY (id)
);
CREATE TABLE public.user_profiles (
  id uuid NOT NULL,
  user_id uuid NOT NULL,
  first_name text,
  last_name text,
  avatar text,
  bio text,
  phone text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.users (
  id uuid NOT NULL,
  email text NOT NULL,
  role_id uuid,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id)

);
