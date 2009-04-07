# $Id$

=head1

exception.pir -- generates an exception

* Only callable by the compiler.
* Borrowed from examples/pir/pirric.pir

=cut

.namespace []

.sub '!EXCEPTION'
	.param string msg
    .local pmc excep
    excep = new 'Exception'
	.local pmc aux
   	aux = new 'String'
    aux = msg
    setattribute excep, 'message', aux
    throw excep
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

