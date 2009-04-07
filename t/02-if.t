program something;
var
	test : boolean;
begin
	if TRUE then
		writeln('1..4')
 	else
		writeln('FAIL');
    
	if test then
		writeln('FAIL')
	else
		writeln('ok 1');

    test := FALSE;

    if test then
		begin
	    	writeln('FAIL');
		end
    else
		begin
	    	test := TRUE;
	    	writeln('ok 2');
		end;

    if test then
		writeln('ok 3');

	writeln('ok 4');
end.
