program testuse;
uses
	test;
begin
	plan(3);
	ok(1);
	ok(2);
	diag('just checking');
	ok(3);
end.
