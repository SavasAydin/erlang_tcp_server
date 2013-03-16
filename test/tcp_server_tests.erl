-module(tcp_server_tests).

-include_lib("eunit/include/eunit.hrl").

%% server_start_and_stop_test() ->
%%     ?assertMatch({ok, _}, tcp_server:start_link(8080)),
%%     {ok, _Socket} = connect(8080, [{active,false},{packet,2}]),
%%     ?assertEqual(ok, tcp_server:stop()),
%%     {error, econnrefused} = connect(8080, [{active,false},{packet,2}]).

receive_message_send_ack_test_() ->
    {setup,
     fun setup/0,
     fun cleanup/1,
     fun recv_hello/0
    }.

recv_hello() ->
    {ok, Sock} = connect(8090, [{active,false},{packet,2}]),
    ok = send(Sock, "hello"),
    ?assertEqual("hello", recv(Sock)),
    ok = gen_tcp:close(Sock).
    

send(Sock, Msg) ->    
    gen_tcp:send(Sock,Msg).

recv(Sock) ->
    {ok, A} = gen_tcp:recv(Sock,0),
    A.

connect(Port, TcpOptions)->
    gen_tcp:connect("localhost", Port, TcpOptions).
    
setup() ->
    {ok, Pid} = tcp_server:start_link(8090),
    Pid.

cleanup(_Pid) ->
    tcp_server:stop().

    
