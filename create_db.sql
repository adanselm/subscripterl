CREATE SCHEMA sub_app;

CREATE TABLE sub_app.users (
  user_no uuid PRIMARY KEY,
  email text NOT NULL, 
  first_name text,
  last_name text
);

CREATE INDEX users_email_index ON sub_app.users (email);

CREATE TABLE sub_app.products (
  product_no uuid PRIMARY KEY,
  name text NOT NULL,
  version text NOT NULL,
  public_key text,
  private_key text
);

CREATE TABLE sub_app.subscriptions (
  subscription_no uuid PRIMARY KEY,
  user_no uuid REFERENCES sub_app.users (user_no),
  product_no uuid REFERENCES sub_app.products (product_no),
  expiration_date timestamp,
  subscription_date timestamp NOT NULL,
  modification_date timestamp NOT NULL
);

CREATE INDEX subs_expirationdate_index ON sub_app.subscriptions (expiration_date);
