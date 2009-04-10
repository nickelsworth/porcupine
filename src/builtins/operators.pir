
.namespace []

.include 'except_types.pasm'
.include 'except_severity.pasm'

.sub 'infix::='
	.param pmc lval
	.param pmc rval
	$I0 = lval.'!ACCEPTS'(rval)
	if $I0 goto do_assign
	'!EXCEPTION'("Type mismatch in assignment!")
do_assign:
	eq_addr lval, rval, assign_done
	copy lval, rval
assign_done:
	.return(lval)
.end

.sub 'infix:<'
    .param pmc a
    .param pmc b
    islt $I0, a, b
    .return ($I0)
.end


.sub 'infix:<='
    .param pmc a
    .param pmc b
    isle $I0, a, b
    .return ($I0)
.end

.sub 'infix:>'
    .param pmc a
    .param pmc b
    isgt $I0, a, b
    .return ($I0)
.end

.sub 'infix:>='
    .param pmc a
    .param pmc b
    isge $I0, a, b
    .return ($I0)
.end

.sub 'infix:='
    .param pmc a
    .param pmc b
	iseq $I0, a, b
    .return ($I0)
.end

#not in std pascal, cmp type
.sub 'infix:=='
    .param pmc a
	.param pmc b
	$S0 = typeof a
	$S1 = typeof b
	iseq $I0, $S0, $S1
    .return ($I0)
.end

.sub 'infix:<>'
    .param pmc a
    .param pmc b
    isne $I0, a, b
    .return ($I0)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

