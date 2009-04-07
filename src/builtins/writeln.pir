# $Id$

=head1

writeln.pir -- writes a line to stdout

=cut

.namespace []

.sub 'writeln'
	.param pmc farg	:optional
	.param pmc args	:slurpy
	.local pmc fh
	.local pmc it

	$S0 = typeof farg
	$I0 = iseq $S0, 'PorcupineFile'
	if $I0 goto open_farg
	goto print_farg
open_farg:
	fh = getattribute farg, 'handle'
	$I0 = defined fh
	if $I0, print_loop
	'!EXCEPTION'("bad file handle")
print_farg:
	fh = getstdout
	print fh, farg
  print_loop:
	it = new 'Iterator', args
  iter_loop:
	unless it goto iter_end
	$P0 = shift it
	print fh, $P0
    goto iter_loop
  iter_end:
    print fh, "\n"
    .return ()
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

