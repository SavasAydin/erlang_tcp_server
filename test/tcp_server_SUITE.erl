-module(tcp_server_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0,
	 init_per_suite/1,
	 end_per_suite/1
	]).
-export([receive_msg_send_ack/2]).

all() ->
    [receive_msg_send_ack].
      
init_per_suite(Config) ->
    application:load(tcp_server),
    application:start(tcp_server),
    {ok, Sock} = connect(8080, [{active,false},{packet,2}]),
    [{socket, Sock} | Config].

end_per_suite(_Config) ->
    application:stop(tcp_server),
    application:unload(tcp_server).

receive_msg_send_ack(send_ack, Config) ->
    Socket = ?config(socket, Config),
    ok = send(Socket, hello),
    ack = recv(Socket).

connect(Port, TcpOptions)->
    gen_tcp:connect("localhost", Port, TcpOptions).
    
send(Sock, Msg) ->    
    gen_tcp:send(Sock,Msg).

recv(Sock) ->
    {ok, A} = gen_tcp:recv(Sock,0),
    A.
