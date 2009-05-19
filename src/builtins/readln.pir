# $Id$

=head1

readln.pir -- reads a line from stdin, returns a string

=cut

.include 'cclass.pasm'

.namespace []

.sub 'readln'
	.param pmc file :optional
	.local pmc fh
	$I0 = defined file
	unless $I0, use_stdin
	fh = getattribute file, 'handle'
	goto read_line
use_stdin:
   	fh = getstdin
read_line:
   	$S0 = fh.'readline'()
	chopn $S0, 1
	.return($S0)	
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

