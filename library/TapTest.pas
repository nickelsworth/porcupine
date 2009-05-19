unit TapTest;
uses
	Logger;
type
	TapTest = class
		procedure log_result;
		procedure log_to;
		procedure plan;
		procedure cmp;
		procedure ok;
		procedure nok;
	end;

var
   current_test : integer;
   log : Logger;

procedure TapTest.log_to(filename :string);
begin
	log := Logger.create();
	log.path(filename);
	log.msg('log started');
end;

procedure TapTest.log_result(res : integer; desc: string);
var
	res_str : string;
begin
	current_test := current_test + 1;
	
	if res then
		res_str := 'ok '
	else
		res_str:= 'fail ';
	
	writeln(res_str,current_test, ' # ',desc);
	log.msg(res_str, current_test, ' # ', desc);
end;

procedure TapTest.plan(tests: integer);
begin
	writeln(1,'..',tests);
	log.msg(concat(1,'..',tests));
end;

procedure TapTest.cmp(res1, res2: integer; desc :string);
begin
		TapTest.log_result((res1 = res2), desc);
end;

procedure TapTest.ok(res :integer; desc :string);
begin
		TapTest.log_result(res,desc);
end;

procedure TapTest.nok(res :integer; desc :string);
begin
		TapTest.log_result((not res), desc);
end;


