-module(sub_store).

-export([create_user/1, retrieve_user/0, update_user/0, delete_user/0]).
-export([create_product/2, retrieve_product/0,
         update_product/0, delete_product/0]).
-export([create_subscription/2, retrieve_subscription/0,
         update_subscription/0, delete_subscription/0]).

%% Users
%%
create_user(Email) ->
  Uuid = sub_uuid:generate(),
  sub_dbproxy:equery("INSERT INTO sub_app.users VALUES ($1, $2, $3, $4);",
    [Uuid, Email, null, null]).

retrieve_user() ->
  ok.

update_user() ->
  ok.

delete_user() ->
  ok.

%% Products
%%
create_product(Name, Version) ->
  Uuid = sub_uuid:generate(),
  sub_dbproxy:equery("INSERT INTO sub_app.products VALUES ($1, $2, $3, $4, $5);",
    [Uuid, Name, Version, null, null]).

retrieve_product() ->
  ok.

update_product() ->
  ok.

delete_product() ->
  ok.

%% Subscriptions
%%
create_subscription(UserId, ProductId) ->
  Uuid = sub_uuid:generate(),
  Now = erlang:universaltime(),
  sub_dbproxy:equery("INSERT INTO sub_app.subscriptions VALUES ($1, $2, $3, $4, $5, $6);",
    [Uuid, UserId, ProductId, null, Now, Now]).

retrieve_subscription() ->
  ok.

update_subscription() ->
  ok.

delete_subscription() ->
  ok.
