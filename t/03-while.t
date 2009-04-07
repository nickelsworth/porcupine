program something;
(* this is a comment *)
var
    test : integer;
begin

    writeln('1..5');
    test:= 1;

    while test < 4 do
	begin
	    writeln('ok ', test);
	    test := test + 1;
	end;

    writeln('ok 4');

	test := 0;

    while test > 1 do
	begin
	    writeln('FAIL');
	end;
   
    writeln('ok 5');
end.
