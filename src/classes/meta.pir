=head1 TITLE

PorcupineMetaClass - type metaclass class

=cut

.namespace ['PorcupineMetaClass']

.sub 'onload' :anon :init :load
	.local pmc p6mc,pc
	p6mc = get_root_global ['parrot'], 'P6metaclass'
	p6mc.'new_class'('PorcupineMetaClass')
	pc = p6mc.'HOW'()
	set_hll_global ['PorcupineMetaClass'], '!METACLASS', pc
.end

#accepts same time

.sub '!ACCEPTS' :method
	.param pmc topic
	.tailcall 'infix:=='(self, topic)
.end

#constructor borrowed from cardinal
.sub 'create' :method
#	.param pmc args :slurpy
#	.param pmc args_named :named :slurpy
	.local pmc meta
	meta = get_hll_global ['PorcupineMetaClass'], '!METACLASS'
	$P0 = meta.'get_parrotclass'(self)
	$P1 = $P0.'new'()
	.return($P1)
.end

.sub 'get_bool' :vtable
    .return (1)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

