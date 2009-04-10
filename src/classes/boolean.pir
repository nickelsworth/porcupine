=head1 TITLE

PorcupineBoolean - integer class

=cut

.namespace ['PorcupineBoolean']

.sub 'onload' :anon :init :load
	.local pmc metac,intc
	metac = get_hll_global ['PorcupineMetaClass'], '!METACLASS'
	intc = metac.'new_class'('PorcupineBoolean', 'parent'=>'parrot;Boolean PorcupineMetaClass')
	metac.'register'('Boolean', 'parent'=>intc, 'protoobject'=>intc)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

