=head1 TITLE

PorcupineInteger - type integer class

=cut

.namespace ['PorcupineInteger']

.sub 'onload' :anon :init :load
	.local pmc metac,intc
	metac = get_root_global ['parrot'], 'P6metaclass'
	intc = metac.'new_class'('PorcupineInteger', 'parent'=>'parrot;Integer')
	metac.'register'('Integer', 'parent'=>intc, 'protoobject'=>intc)
.end

.sub '!ACCEPTS' :method
	.param pmc topic
	.tailcall 'infix:=='(self, topic)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
