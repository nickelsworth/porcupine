unit Logger;
type
	Logger = class
		procedure path;
		procedure msg;
		procedure debug;
		procedure error;
		fh : text;
		path : string;
	end;

procedure Logger.msg(msg: string);
begin
	fh := assign(path, 'a');
	writeln(fh, localtime(), ' : ', msg);
	close(fh);
end;

procedure Logger.error(msg: string);
begin
	fh := assign(path, 'a');
	writeln(fh, localtime(), ' ERROR: ', msg);
	close(fh);
end;

procedure Logger.debug(msg: string);
begin
	fh := assign(path, 'a');
	writeln(fh, localtime(), ' DEBUG: ', msg);
	close(fh);
end;

procedure Logger.path(filename : string);
begin
	path := filename;
	fh := assign(path, 'a');
	close(fh);
end;
