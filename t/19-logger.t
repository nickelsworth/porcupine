program logtester;
uses
	Logger;
var
	log : Logger;
begin

	writeln('1..5');
	Logger.path('test.log');
	writeln('ok 1');
	Logger.msg('Hello world!');
	writeln('ok 2');
	Logger.error('Hello again');
	writeln('ok 3');
	Logger.debug('Hello again');
	writeln('ok 4');

	log := Logger.create();
	log.path('test2.log');
	log.msg('test2.log');
	
	writeln('ok 5');
end.
