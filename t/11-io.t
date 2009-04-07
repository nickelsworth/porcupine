program io;
var
	fh : text;
begin
	writeln('1..7');

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
end.
