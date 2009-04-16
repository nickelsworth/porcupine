# $Id$

=head1

load.pir -- loads external modules

=cut

.include 'cclass.pasm'

.namespace []

.sub '!LOADMODULE'
	.param string basename
	.local string realfilename
    .local pmc compiler
	.local pmc result
	#append lib
	basename	= concat 'library/', basename
	#find file name
    realfilename = concat basename, '.pbc'
    $I0 = stat realfilename, 0
	if $I0 goto load_parrot
    realfilename = concat basename, '.pir'
    $I0 = stat realfilename, 0
	if $I0 goto load_parrot
	realfilename = concat basename, '.pas'
    $I0 = stat realfilename, 0
	if $I0 goto load_pascal
	$S0 = concat "Can't open unit : ", basename
	'!EXCEPTION'($S0)
load_parrot:
    load_bytecode realfilename
	.return(1)
load_pascal:
	compiler = compreg 'porcupine'
    .tailcall compiler.'evalfiles'(realfilename)
.end

.sub '!REGISTERCLASS'
	.param string name
	.local pmc metaclass
	.local pmc c
	 metaclass = get_root_global ['parrot'], 'P6metaclass'
	 c = metaclass.'new_class'(name, 'parent'=>'parrot;Integer')
	 metaclass.'register'(name)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

