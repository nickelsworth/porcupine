program classtest;
type
	testclass = class
		procedure n2;
	end;
(*
procedure testclass.ok;
begin
	Writeln('ok 2');
end;
*)
var
	test : testclass;  
begin
	writeln('1..1');

	try
		testclass.n2(); 
	finally
		writeln('ok 1');
		writeln('# output: ', exception);
	end;
end.

