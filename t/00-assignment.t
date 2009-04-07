program something;
(* this is a comment *)
var
    three, four, seven : integer;
    five : string;
    one : boolean;
begin
	three := 3;
	one := TRUE;
	three := 3;
    four := 4;
   	five := '5';
   	seven := 5 + 2;
	writeln('1..7');
   	writeln('ok ', one);
   	writeln('ok 2');
    // this is a comment
	writeln('ok ', three);
    writeln('ok ', four);
	{ this is a comment }	
    writeln('ok ', five);
    writeln('ok ', '6');
    writeln('ok ', seven);
end.
