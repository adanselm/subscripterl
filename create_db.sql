CREATE SCHEMA sub_app;

CREATE TABLE sub_app.users (
  user_no integer UNIQUE NOT NULL,
  email text NOT NULL, 
  first_name text NOT NULL,
  last_name text NOT NULL
);

CREATE TABLE sub_app.products (
  product_no integer UNIQUE NOT NULL,
  name text NOT NULL,
  version text NOT NULL,
  public_key text,
  private_key text
);

CREATE TABLE sub_app.subscriptions (
  subscription_no integer UNIQUE NOT NULL,
  user_no integer REFERENCES sub_app.users (user_no),
  product_no integer REFERENCES sub_app.products (product_no),
  expiration_date timestamp,
  subscription_date timestamp NOT NULL,
  modification_date timestamp NOT NULL
);
