program classtest;
type
	testclass = class
		procedure n2;
		procedure ok2;
		procedure ok3;
	end;

var
	test : testclass;  

procedure testclass.ok2;
begin
	writeln('ok 2');
end;

procedure testclass.ok3;
begin
	writeln('ok 3');
end;

begin
	writeln('1..3');

	try
		testclass.n2(); 
	finally
		writeln('ok 1');
		writeln('# output: ', exception);
	end;

	testclass.ok2(); 
	testclass.ok3(); (* checks overriding *) 
end.

