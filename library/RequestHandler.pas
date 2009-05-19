unit RequestHandler;
type
	RequestHandler = class
		function process;
	end;

const
	OK = 'HTTP/1.0 200 OK';
	NF = 'HTTP/1.0 404 Not Found';
	ERR = 'HTTP/1.0 500 Server Error';

function getpage(path :string) :string;
var
	fh :text;
	l : string;
begin
	fh := assign(path, 'r');
	while l := readln(fh) do
		getpage := concat(getpage, l);
end;

function RequestHandler.process(log :Logger; req: string) : string;
var 
	token : array[0..3] of string;
begin
	req := chomp(req);
	token :=: split(req, ' ');
	

	if upcase(token[0]) = 'GET' then
		begin
			log.msg(concat('page "',token[1],'" requested'));
		end
	else
		begin
			process := concat(ERR, nl(),nl());
			log.error('bad / unsupported request');
			exit;
		end;

end;
