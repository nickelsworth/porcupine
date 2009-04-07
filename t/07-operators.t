program something;
const
	k = 'ok ';
var
    test : integer;
    t : real;
begin
	writeln('1..17');

	if 1 < 2 then
		writeln(k, 1);
	
	if 2 > 1 then
		writeln(k, 2);

	if 3 = 3 then
		writeln(k, 3);
	
	if 4 <> 3 then
		writeln(k, 4);
	
	if 4 >= 3 then
		writeln(k, 5);

	if 2 <= 2 then
		writeln(k, 6);

	test := 1;

	if TRUE or (test > 0) then
		writeln(k, 7);
	
	if TRUE and (test > 0) then
		writeln(k, 8);

	test := test + 1;

	if test = 2 then
		writeln(k, 9);
	
	test := test - 1;

	if test = 1 then
		writeln(k, 10);
	
	test := 2  * 8;

	if test = 16 then
		writeln(k, 11);

	t := 32 / 16;

	if t = 2 then
		writeln(k, 12);

	t := 64 div 16;

	if t = 4 then
		writeln(k, 13);

	t := 7 mod 6;

	if t = 1 then
		writeln(k, 14);
	
	t := 0;

	if (1 < 2) and (3 < 4) then
		writeln(k,15);

	if not FALSE then
		writeln(k, 16);

	if (TRUE or FALSE) and TRUE then
		writeln(k, 17);
end.
