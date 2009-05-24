program Listner;
uses
	Logger;
	RequestHandler;
const
	PIO_PF_INET = 2;
	PIO_SOCK_STREAM = 1;
	PIO_PROTO_TCP = 6;
var
	sock, session, listener : socket;
	port : integer;
	hostname, request, responce : string;
	log : Logger;

begin
	listener.socket(PIO_PF_INET, PIO_SOCK_STREAM, PIO_PROTO_TCP);
	port := 8030;
	hostname := 'localhost';

	log := Logger.create();
	log.path('httpd.log');


	sock :=: listener.sockaddr(hostname, port);
	listener.bind(sock);
	writeln('server started');
	listener.listen(1);	

	if listener then
		log.msg(concat('listening on ', hostname, ':', port));
	
	while session := listener.accept() do
		begin
			log.debug('new session');
			try	
				request := session.recv();
				responce := RequestHandler.process(log, request);
				session.send(responce);
				session.close();
				log.debug('session closed');
			finally
				log.error(concat('error occured handling request: ',nl(), exception));
			end;
		end;
end.
