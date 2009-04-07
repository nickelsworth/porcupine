unit test;
procedure plan (tests :integer);
begin
	writeln('1..', tests);
end;

procedure ok (test :integer);
begin
	writeln('ok ', test);
end;

procedure nok (test :integer);
begin
	writeln('nok ', test);
end;

procedure diag (msg : string);
begin
	writeln('# ', msg);
end;

