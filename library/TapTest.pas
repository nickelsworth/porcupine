unit TapTest;
type
	TapTest = class
		procedure plan;
		procedure cmp;
		procedure ok;
		procedure nok;
	end;

var
   current_test : integer;
   log_handle : text;

procedure log(res : integer; desc: string);
var
	res_str : string;
begin
	current_test := current_test + 1;
	
	if res then
		res_str := 'ok '
	else
		res_str:= 'fail ';
	
	writeln(res_str,current_test, ' # ',desc);
	if log_handle then
		writeln(log_handle, res_str, current_test, ' # ', desc);
end;

procedure TapTest.recordto(filename : string);
begin
	log_handle := assign(filename, 'a');
	writeln(log_handle,'Log started!');
end;

procedure TapTest.plan(tests: integer);
begin
	writeln(1,'..',tests);
	if log_handle then
		writeln(log_handle,1,'..',tests);
end;

procedure TapTest.cmp(res1, res2: integer; desc :string);
begin
		log((res1 = res2), desc);
end;

procedure TapTest.ok(res :integer; desc :string);
begin
		log(res,desc);
end;

procedure TapTest.nok(res :integer; desc :string);
begin
		log((not res), desc);
end;


