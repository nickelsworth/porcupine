=head1 TITLE

PorcupineFile - file class

=cut

.namespace ['PorcupineFile']
.include 'cclass.pasm'

.sub 'onload' :anon :init :load
	.local pmc metac,intc
	intc = newclass 'PorcupineFile'
	addattribute intc, 'handle'
	addattribute intc, 'path'
	addattribute intc, 'mode'
#	metac = get_root_global ['parrot'], 'P6metaclass'
#	intc = metac.'new_class'('PorcupineFile', 'parent'=>'parrot;File', 'attr'=>'!io' )
#	metac.'register'('File', 'parent'=>intc, 'protoobject'=>intc)
.end

.sub 'get_bool' :vtable
    .return (1)
.end

.sub '!ACCEPTS' :method
	.param pmc topic
	$I0 = 'infix:=='(self, topic)
	if $I0, same_type
	.return(0)
same_type:
	.return(1)
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

