program tcheck;
var
	t : real;
	x : integer;
	y : string;
	z : boolean;

procedure add1( a : integer; b :integer); 
begin
	a + b;
end;

function add( a : integer; b :integer) :integer; 
begin
	add := a + b;
end;

begin
   	writeln('1..10');
	
	try
		t := 'f';
		writeln('nok 1');
	finally
		writeln('ok 1');
	end;

	try
		x := 'sdf';
		writeln('nok 2');
	finally
		writeln('ok 2');
	end;

	try
		y := 34;
		writeln('nok 3');
	finally
		writeln('ok 3');
	end;

	try
		z := 1;
		writeln('nok 4');
	finally
		writeln('ok 4');
	end;

	try
		x := add(1, 'x');
		writeln('nok 5');
	finally
		writeln('ok 5');
	end;

	try
		addone(1, 'y');
		writeln('nok 6');
	finally
		writeln('ok 6');
	end;

	t := 0.1;
	writeln('ok 7');
	x := 1;
	writeln('ok 8');
	y := 't';
	writeln('ok 9');
	z := TRUE;	
	writeln('ok 10');
end.

