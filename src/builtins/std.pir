# $Id$

=head1
standard and some slightly less standard functions
=cut

.namespace []
.include "tm.pasm"

.sub 'dumper'
	.param pmc var
	.param string label 
	.local pmc dumper
	dumper = new 'Data::Dumper'
	dumper.'dumper'( var, label )
.end

.sub 'upcase'
	.param string in
	upcase in
	new $P0, "String"
	assign $P0, in
	.return($P0)
.end

.sub 'lwcase'
	.param string in
	downcase in
	new $P0, "String"
	assign $P0, in
	.return($P0)
.end

.sub 'sprintf'
	.param pmc fmt
	.param pmc args     :slurpy
	$P0 = new 'PorcupineString'
	sprintf $P0, fmt, args
	.return ($P0)
.end

.sub 'popen'
	.param string cmd
	.local pmc pipe
	pipe = open cmd, "-|"
	.local string buffer
	.local pmc output
	output = new 'PorcupineString'
	$S0 = pop pipe      # pop buf layer
	goto lp
lp:
	buffer = read pipe, 256
	output.'concat'(buffer)
	if pipe goto lp
	goto done
done:
	.return(output)
.end

.sub 'system'
	.param string syscall
	spawnw $I0, syscall
	if $I0 == 0 goto done_t
	goto done_f
done_t:
	$S0 = "true"
	goto ret
done_f:
	$S0 = "false"
	goto ret
ret:
	.return ($S0)
.end

.sub 'chomp'
	.param string str
	chopn str, 1
	.return(str)
.end

.sub 'concat'
	.param pmc args :slurpy
	.local string r
	.local pmc it
	it = new 'Iterator', args
  iter_loop:
	unless it goto iter_end
	$S0 = shift it
	r = concat r, $S0
    goto iter_loop
  iter_end:
	.return(r)
.end

.sub 'time'
	time $I0
	.return($I0)
.end

.sub 'localtime'
	.param int i :optional
	if i goto tcall
	time i
tcall:
	$S0 = localtime i
	chopn $S0, 1
	.return($S0)
.end

.sub 'split'
	.param string objst
    .param string delim
    .local pmc pieces
    .local pmc tmps
    .local pmc retv
    .local int len
    .local int i

	retv = new 'ResizablePMCArray'

    split pieces, delim, objst

    len = pieces
    i = 0
  loop:
    if i == len goto done

	tmps = new 'PorcupineString'
    tmps = pieces[i]
	retv.'push'(tmps)

    inc i
    goto loop
  done:
    .return(retv)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

