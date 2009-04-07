program something;
(* this is a comment *)
const
	k = 'ok ';
var
    i, x, j : integer;
begin
    writeln('1..13');
	for i := 1 to 4 do
		writeln(k, i);
	
	for x := 4 downto 1 do
		writeln(k, 9 - x);

	for j := 9 to 13 do
		begin
			writeln(k, j);
		end;
end.
