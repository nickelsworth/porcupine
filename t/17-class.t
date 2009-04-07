program classtest;
type
	testclass = class
		procedure ok;
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
	testclass.ok(); 
end.

