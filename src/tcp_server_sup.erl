-module(tcp_server_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1, stop/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, no_args).

stop() ->
    exit(whereis(?MODULE), shutdown).


start_child(SupPid) ->
    supervisor:start_child(SupPid, []).

init(no_args) ->
    Child = {tcp_server, {tcp_server, start_link, []},
	      permanent, brutal_kill, worker, [tcp_server]},
    RestartStrategy = {rest_for_one, 5, 2000},
    {ok, {RestartStrategy, [Child]}}.

