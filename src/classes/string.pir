=head1 TITLE

PorcupineString -  string class

=cut

.namespace ['PorcupineString']

.sub 'onload' :anon :init :load
	.local pmc metac,intc
	metac = get_hll_global ['PorcupineMetaClass'], '!METACLASS'
	intc = metac.'new_class'('PorcupineString', 'parent'=>'parrot;String PorcupineMetaClass')
	metac.'register'('String', 'parent'=>intc, 'protoobject'=>intc)
.end

.sub '!ACCEPTS' :method
	.param pmc topic
	$I0 = 'infix:=='(self, topic)
	if $I0, same_type
	$S0 = typeof topic
	$I0 = iseq $S0, 'String' #accepts strings
	if $I0, same_type
	.return(0)
same_type:
	.return(1)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

