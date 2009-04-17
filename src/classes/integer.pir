=head1 TITLE

PorcupineInteger - type integer class

=cut

.namespace ['PorcupineInteger']

.sub 'onload' :anon :init :load
	.local pmc metac,intc
	metac = get_hll_global ['Porcupine'], '!METACLASS'
	intc = metac.'new_class'('PorcupineInteger', 'parent'=>'parrot;Integer PorcupineMetaClass')
	metac.'register'('Integer', 'parent'=>intc, 'protoobject'=>intc)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

