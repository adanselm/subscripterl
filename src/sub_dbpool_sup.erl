-module(sub_dbpool_sup).

-behaviour(supervisor).

-export([start_link/0, stop/1]).
-export([init/1]).

-define(APPLICATION, subscripterl).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
  ok.

init([]) ->
  {ok, Pools} = application:get_env(?APPLICATION, pools),
  PoolSpecs = lists:map(fun({Name, SizeArgs, WorkerArgs}) ->
    PoolArgs = [{name, {local, Name}},
                {worker_module, sub_dbworker}] ++ SizeArgs,
    poolboy:child_spec(Name, PoolArgs, WorkerArgs)
  end, Pools),
  {ok, {{one_for_one, 10, 10}, PoolSpecs}}.


