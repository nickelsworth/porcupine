program something;
const
	k = 'ok ';
var
	global : boolean;

procedure simple;
var
	global : integer;
begin
	writeln('ok 1');
end;

procedure ok(x : integer);
begin
	global := TRUE;
	writeln(k,  x); 
end;

procedure add(x: integer; y : integer);
var
	total : integer;
begin
	total := x + y;
	writeln(k, total);
end;
	

begin
	writeln('1..7');
	simple();
	if global then
		writeln('fail');
	writeln('ok 2');
	ok(3);
	ok(4);
	writeln('ok 5');
	if global then
		writeln('ok 6');
	add(6, 1);
end.
