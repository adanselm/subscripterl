-module(subscripterl).
-export([start/0]).

-define(APP, ?MODULE).

start() ->
  application:load(?APP),
  {ok, Apps} = application:get_key(?APP, applications),
  [ application:start(App) || App <- Apps],
  ok = application:start(?APP).
