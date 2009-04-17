=head1 TITLE

PorcupineFile - file class

=cut

.namespace ['PorcupineFile']
.include 'cclass.pasm'

.sub 'onload' :anon :init :load
	.local pmc metac,intc, c
	metac = get_hll_global ['Porcupine'], '!METACLASS'
	intc = metac.'new_class'('PorcupineFile', 'parent'=>'PorcupineMetaClass')
	c = get_class 'PorcupineFile'
	addattribute c, 'handle'
	addattribute c, 'path'
	addattribute c, 'mode'
.end

.sub 'assign' :method
		.param pmc path
		.param pmc mode
		.local pmc fh
		fh = new 'FileHandle'
		setattribute self, 'path', path
		setattribute self, 'mode', mode
		fh.'open'(path, mode)
		$I0 = defined fh
		if $I0, opened_block
		'!EXCEPTION!'('Couldnt open file!')
opened_block:
		setattribute self, 'handle', fh
.end

.sub 'close' :method
	.local pmc fh
	fh = getattribute self, 'handle'
	fh.'close'()
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

