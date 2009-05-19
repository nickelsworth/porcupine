unit RequestHandler;
type
	RequestHandler = class
		procedure process;
	end;

procedure RequestHandler.process(log :Logger; req: string);
var 
	tokens : array[0..3] of string;
begin
	req := chomp(req);
	tokens :=: split(req, ' ');
	log.msg(concat('page "',tokens[1],'" requested'));
end;
