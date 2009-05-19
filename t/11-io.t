program io;
var
	fh : text;
begin
	writeln('1..9');

	fh := assign('test.txt', 'w');
	writeln(fh, 'ok 2');
	writeln(fh, 'ok 3');
	writeln(fh, 'ok 4');
	writeln(fh, 'ok 5');
	close(fh);
	writeln('ok 1');

	fh := assign('test.txt', 'r');
	writeln(readln(fh));
	writeln(readln(fh));
	writeln(readln(fh));
	writeln(readln(fh));
	writeln('ok 6');
	close(fh);
	writeln('ok 7');
	if exists('test.txt') then
		writeln('ok 8');
	
	if not exists('foobar') then
		writeln('ok 9');
end.
