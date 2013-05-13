-module(sub_store).

-export([create_user/1, retrieve_user/1, update_user/3, delete_user/1]).
-export([create_product/1, retrieve_product/1,
         update_product/3, delete_product/1]).
-export([create_subscription/2, retrieve_subscription/2,
         update_subscription/2, delete_subscription/1]).

%% Users
%%
create_user(Email) ->
  Uuid = sub_uuid:generate(),
  {ok, _} = sub_dbproxy:equery("INSERT INTO sub_app.users VALUES ($1, $2, $3, $4);",
    [Uuid, Email, null, null]),
  {ok, Uuid}.

retrieve_user(Email) ->
  {ok, _Cols, Rows} = sub_dbproxy:equery("SELECT * FROM sub_app.users WHERE email=$1",
    [Email]),
  {ok, Rows}.

% Returns {ok, Count}
update_user(Email, NewFirstName, NewLastName) ->
  sub_dbproxy:equery("UPDATE sub_app.users SET first_name=$1, last_name=$2 WHERE email=$3",
    [NewFirstName, NewLastName, Email]).

% Returns {ok, Count}
delete_user(Email) ->
  sub_dbproxy:equery("DELETE FROM sub_app.users WHERE email=$1", [Email]).

%% Products
%%
create_product(Name) ->
  Uuid = sub_uuid:generate(),
  {ok, _} = sub_dbproxy:equery("INSERT INTO sub_app.products VALUES ($1, $2, $3, $4);",
    [Uuid, Name, null, null]),
  {ok, Uuid}.

retrieve_product(Name) ->
  {ok, _Cols, Rows} = sub_dbproxy:equery("SELECT * FROM sub_app.products WHERE name=$1",
    [Name]),
  {ok, Rows}.

update_product(Name, NewPublicKey, NewPrivateKey) ->
  sub_dbproxy:equery("UPDATE sub_app.products SET public_key=$1, private_key=$2 WHERE name=$3",
    [NewPublicKey, NewPrivateKey, Name]).

delete_product(Name) ->
  sub_dbproxy:equery("DELETE FROM sub_app.products WHERE name=$1", [Name]).

%% Subscriptions
%%
create_subscription(UserId, ProductId) ->
  Uuid = sub_uuid:generate(),
  Now = erlang:universaltime(),
  {ok, _} = sub_dbproxy:equery("INSERT INTO sub_app.subscriptions VALUES ($1, $2, $3, $4, $5, $6);",
    [Uuid, UserId, ProductId, null, Now, Now]),
  {ok, Uuid}.

retrieve_subscription(UserMail, ProductName) ->
  {ok, _Cols, Rows} = sub_dbproxy:equery("SELECT S.* FROM sub_app.subscriptions S, sub_app.users U, sub_app.products P WHERE S.user_no=U.user_no AND S.product_no=P.product_no AND U.email=$1 AND P.name=$2;",
    [UserMail, ProductName]),
  {ok, Rows}.

update_subscription(SubscriptionId, NewExpirationDate) ->
  Now = erlang:universaltime(),
  sub_dbproxy:equery("UPDATE sub_app.subscriptions SET expiration_date=$1, modification_date=$2 WHERE subscription_no=$3",
    [NewExpirationDate, Now, SubscriptionId]).

delete_subscription(SubscriptionId) ->
  sub_dbproxy:equery("DELETE FROM sub_app.subscriptions WHERE subscription_no=$1;",
    [SubscriptionId]).
