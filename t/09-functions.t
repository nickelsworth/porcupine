program something;
const
	k = 'ok ';
var
	ok : integer;

function incr(x : integer) :integer;
begin
	incr := x + 1;
end;
function test(y : boolean) :integer;
begin
	if not y then
		begin
			test := 5;
			exit;
		end;

	if y then
		writeln('ok 6');
end;

function pand(x : boolean; y: boolean) :boolean;
begin
	if x and y then
		pand := TRUE
	else
		pand := FALSE;
end;
begin
	writeln('1..7');
	writeln(k, 1);
	ok := incr(1);
	writeln(k, ok);
	ok := incr(ok);
	writeln(k, ok);
	writeln(k, 4);
	writeln(k, test(FALSE));
	//FIXME
	ok := test(TRUE);

	if pand(TRUE, TRUE) then
		writeln(k, 7);
end.
