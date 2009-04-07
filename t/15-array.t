program arrays;

var
	i : array[0..5] of integer;
	s : array[0..2] of string;
	b : array[0..2] of boolean;
	r : array[0..2] of real;
	index : integer;

procedure ok(t : integer);
begin
	writeln('ok ', t);
end;

begin
	writeln('1..11');
	i[0] := 1;
	ok(i[0]);
	index := 3;
	i[0] := 6;
	i[1] := 5;
	i[2] := 4;
	i[index] := 2;
	ok(i[index]);
	ok(i[2]- 1);
	writeln('ok ', i[2]);
	writeln('ok ', i[1]);
	writeln('ok ', i[0]);
	s[0] := 'ok ';
	s[1] := '7';
	writeln(s[0], s[1]);
	b[0] := TRUE;
	b[1] := FALSE;

	if b[0] then
		writeln('ok 8');
	if not b[1] then
		writeln('ok 9');
	r[0] := 10.0;
	writeln('ok ', r[0]);
	writeln('ok 11');
end.
