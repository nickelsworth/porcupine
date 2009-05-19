=head1 TITLE

porcupine.pir - A Porcupine compiler.

=head2 Description

This is the base file for the Porcupine compiler.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'Porcupine'.

=head2 Functions

=over 4

=item onload()

Creates the Porcupine compiler using a C<PCT::HLLCompiler>
object.

=cut

.HLL 'porcupine'

.namespace [ 'Porcupine';'Compiler' ]

.loadlib 'porcupine_group'

.sub '' :anon :load :init
    load_bytecode 'PCT.pbc'
	load_bytecode "Data/Dumper.pbc"
    .local pmc parrotns, hllns, exports
    parrotns = get_root_namespace ['parrot']
    hllns = get_hll_namespace
    exports = split ' ', 'PAST PCT PGE'
    parrotns.'export_to'(hllns, exports)
.end



.include 'src/gen_classes.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'

.sub 'onload' :anon :load :init
    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('porcupine')
    $P0 = get_hll_namespace ['Porcupine';'Grammar']
    $P1.'parsegrammar'($P0)
    $P0 = get_hll_namespace ['Porcupine';'Grammar';'Actions']
    $P1.'parseactions'($P0)
    $P1.'commandline_banner'("Porcupine, Pascal for Parrot.\n")
    $P1.'commandline_prompt'('>>')
.end

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the Porcupine compiler.

=cut

.sub 'main' :main
    .param pmc args

    $P0 = compreg 'porcupine'
    $P1 = $P0.'command_line'(args)
.end

.include 'src/gen_builtins.pir'

.namespace []

.sub 'init' :anon :load :init
    $P0 = new 'ResizablePMCArray'
    set_hll_global ['Porcupine';'Grammar';'Actions'], '@?BLOCK', $P0
.end

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

