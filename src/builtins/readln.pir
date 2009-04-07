# $Id$

=head1

readln.pir -- reads a line from stdin, returns a string

TODO: use substr to remove newline from input.

=cut

.include 'cclass.pasm'

.namespace []

.sub 'readln'
	.param pmc file :optional
	.local pmc fh
	.local pmc line
	$I0 = defined file
	unless $I0, use_stdin
	fh = getattribute file, 'handle'
	goto read_line
use_stdin:
   	fh = getstdin
read_line:
	line = new "PorcupineString"
   	line = fh.'readline'()
	.return(line)	
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

