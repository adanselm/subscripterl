-module(sub_dbproxy).

-export([squery/2, squery/1, equery/3, equery/2]).

-define(DEFAULT_POOL, pool1).

squery(PoolName, Sql) ->
  poolboy:transaction(PoolName, fun(Worker) ->
    gen_server:call(Worker, {squery, Sql})
  end).

squery(Sql) ->
  squery(?DEFAULT_POOL, Sql).

equery(PoolName, Stmt, Params) ->
  poolboy:transaction(PoolName, fun(Worker) ->
    gen_server:call(Worker, {equery, Stmt, Params})
  end).

equery(Stmt, Sql) ->
  equery(?DEFAULT_POOL, Stmt, Sql).
