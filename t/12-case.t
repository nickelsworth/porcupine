program testcase;
var
	s1, s2 :string;
begin
	writeln('1..6');
	s1 := 'OK 1';
	s2 := lwcase(s1);
	writeln(s2);
	s1 := 'x';
	s2 := upcase(s1);
	if s2 = 'X' then
		writeln('ok 2');	
	writeln('ok 3');
	
	if localtime() then
		writeln('ok 4');
	
	if time() then
		writeln('ok 5');
	
	if chomp(localtime()) then
		writeln('ok 6');
		
end.
