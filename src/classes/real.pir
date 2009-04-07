=head1 TITLE

PorcupineReal - real type class

=cut

.namespace ['PorcupineReal']

.sub 'onload' :anon :init :load
	.local pmc metac,intc
	metac = get_root_global ['parrot'], 'P6metaclass'
	intc = metac.'new_class'('PorcupineReal', 'parent'=>'parrot;Float')
	metac.'register'('Float', 'parent'=>intc, 'protoobject'=>intc)
.end

.sub '!ACCEPTS' :method
	.param pmc topic
	$I0 = 'infix:=='(self, topic)
	if $I0, same_type
	$S0 = typeof topic
	$I0 = iseq $S0, 'PorcupineInteger' #accepts ints
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

