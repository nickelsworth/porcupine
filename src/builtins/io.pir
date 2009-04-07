# $Id$

=head1

io.pir -- io functions

=cut

.namespace []

=head2 assign
assigns file to a filehandle object
=cut

.sub 'assign' 
	.param string file
	.param string mode
	$P0 = new 'PorcupineFile'
	$P0.'assign'(file, mode)
	.return($P0)
.end

.sub 'close'
	.param pmc fh
	fh.'close'()
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

