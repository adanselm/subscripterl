-module(subscripterl).
-export([start/0]).
-export([create_user/1, create_product/1, generate_product_key/2]).

-define(APP, ?MODULE).

%% API
start() ->
  application:load(?APP),
  {ok, Apps} = application:get_key(?APP, applications),
  [ application:start(App) || App <- Apps],
  ok = application:start(?APP).

create_user(UserEmail) ->
  sub_store:create_user(UserEmail).

create_product(ProductName) ->
  {ok, Pid} = sub_store:create_product(ProductName),
  Key = generate_key(),
  {ok, 1} = sub_store:update_product(ProductName, Key),
  {PublicKey, _PrivateKey} = key_to_keypair_strings(Key),
  {ok, Pid, PublicKey}.

generate_product_key(UserEmail, ProductName) ->
  {ok, [{Uid, _, _, _}]} = sub_store:retrieve_user(UserEmail),
  {ok, [{Pid, _, E, N, D}]} = sub_store:retrieve_product(ProductName),
  {ok, Sid} = sub_store:create_subscription(Uid, Pid),
  {ok, [{_, _, _, EDate, SDate, _}]} = sub_store:retrieve_subscription(UserEmail, ProductName),
  Cyphered = create_keyfile([E, N, D], UserEmail, ProductName, Sid, EDate, SDate),
  {ok, Sid, Cyphered}.

%% Internals
create_keyfile(RSAKey, Email, ProductName, SubUuid, ExpDate, SubDate) ->
  Json = jsx:encode([{<<"email">>, erlang:list_to_binary(Email)},
          {<<"productName">>, erlang:list_to_binary(ProductName)},
          {<<"subscriptionSerial">>, SubUuid},
          {<<"expirationDate">>, timestamp_to_binary(ExpDate)},
          {<<"subscriptionDate">>, timestamp_to_binary(SubDate)}]),
  private_encrypt(Json, RSAKey).

timestamp_to_binary(null) ->
  "null";
timestamp_to_binary(Timestamp) ->
  {Date, Time} = Timestamp,
  erlang:list_to_binary(string:join([triplet_to_string(Date, "-"),
                                     triplet_to_string(Time, ":")], " ")).

triplet_to_string(Triplet, Separator) ->
  {A, B, C} = Triplet,
  string:join(io_lib:format("~w~w~w", [A, B, C]), Separator).

%% byte_size(Data) has to be < byte_size(N)-11
%% @see crypto:rsa_private_encrypt/3
private_encrypt(Data, [E, N, D]) when is_binary(Data), byte_size(Data) < byte_size(N) - 11 ->
  crypto:rsa_private_encrypt(Data, [E, N, D], rsa_pkcs1_padding).

key_to_keypair_strings(Key) ->
  [E, N, D] = [ bin_to_hex_list(X) || X <- Key ],
  PublicKey = string:join([E, N], ","),
  PrivateKey = string:join([D, N], ","),
  {PublicKey, PrivateKey}.

generate_key() ->
  {ok, Key} = cutkey:rsa(2048, 2049),
  Key.

%% Converts binary data to Hex string
bin_to_hex_list(Bin) when is_binary(Bin) ->
  lists:flatten([integer_to_list(X,16) || <<X>> <= Bin]).
