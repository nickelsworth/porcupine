program something;
const
	k = 'ok ';
var
    count : integer;
begin 
	count := 1;
	writeln('1..6');
	repeat
		writeln(k, count);
		count := count + 1;
	until count > 6;
end.
