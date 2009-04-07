program excep;

procedure oops;
begin
	raise 'ok 6';
end;

begin
   	writeln('1..7');
	
	try
		writeln ('ok 1');
		raise 'ok 3';
		writeln('FAIL');
	finally
		writeln('ok 2');
		writeln(exception);
	end;

	writeln('ok 4');

	try
		oops();
	finally
		writeln('ok 5');
		writeln(exception);
	end;

	writeln('ok 7');
end.
