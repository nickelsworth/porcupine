unit RequestHandler;
type
	RequestHandler = class
		function process;
	end;

const
	OK = 'HTTP/1.0 200 OK';
	NF = 'HTTP/1.0 404 Not Found';
	ERR = 'HTTP/1.0 500 Server Error';
	ROOT = '/home/rob/sandbox/parrot/languages/ooporcupine/www/';

function header(code :string) :string;
begin
	header := concat(code,nl());
	header := concat(header, 'Date: ', localtime(), nl());
	header := concat(header, 'Server: Porcupine HTTPD 1.0',nl());
	header := concat(header, 'Connection: close',nl());
	header := concat(header, 'Content-Type: text/html',nl(),nl());
end;

function getpage(path :string) :string;
var
	fh :text;
	l : string;
begin
	path := concat(ROOT, path);
	fh := assign(path, 'r');
	while l := readln(fh) do
		getpage := concat(getpage, l, nl());
end;

function RequestHandler.process(log :Logger; req: string) : string;
var 
	token : array[0..3] of string;
begin
	req := chomp(req);
	token :=: split(req, ' ');

	if upcase(token[0]) = 'GET' then
		begin
			if token[1] = '/' then
				token[1] := 'index.html';
			if exists(concat(ROOT,token[1])) then
				begin
					log.msg(concat('page: "',token[1],'" requested'));
					process := header(OK);
					process := concat(process, getpage(token[1]));
					exit;
				end
			else
				begin
					log.error(concat('page: "', token[1], '" not found'));
					process := header(NF);
					exit;
				end;
		end
	else
		begin
			process := header(NF);
			log.error(concat('bad request type: "', token[1],'"'));
			exit;
		end;
end;
