# $Id$

=head1

change case.

NOTE: pascal doesn't have a lowercase function (WTF?)

=cut

.namespace []
.sub 'upcase'
	.param string in
	upcase in
	new $P0, "String"
	assign $P0, in
	.return($P0)
.end

.sub 'lwcase'
	.param string in
	downcase in
	new $P0, "String"
	assign $P0, in
	.return($P0)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

