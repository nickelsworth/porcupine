program Listner;
uses
	Logger;
const
	PIO_PF_INET = 2;
	PIO_SOCK_STREAM = 1;
	PIO_PROTO_TCP = 6;
var
	sock, session, listener : socket;
	port : integer;
	hostname : string;
	request : string;
	log : Logger;

procedure RequestHandler(req: string);
var 
	tokens : array[0..3] of string;
begin
	req := chomp(req);
	tokens :=: split(req, ' ');
	log.msg(concat('page "',tokens[1],'" requested'));
end;

begin
	listener.socket(PIO_PF_INET, PIO_SOCK_STREAM, PIO_PROTO_TCP);
	port := 8030;
	hostname := 'localhost';

	log := Logger.create();
	log.path('httpd.log');

	writeln('server started');

	sock :=: listener.sockaddr(hostname, port);
	listener.bind(sock);	
	listener.listen(1);
	

	if listener then
		log.msg(concat('listening on ', hostname, ':', port));
	
	writeln('main loop');
	while session := listener.accept() do
		begin
			log.msg('new session');
			
			request := session.recv();
			RequestHandler(request);

			session.close();
			log.msg('session closed');
		end;
end.
