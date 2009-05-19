# $Id$

=begin comments

Porcupine::Grammar::Actions - ast transformations for Porcupine

This file contains the methods that are used by the parse grammar
to build the PAST representation of an Porcupine program.
Each method below corresponds to a rule in F<src/parser/grammar.pg>,
and is invoked at the point where C<{*}> appears in the rule,
with the current match object as the first argument.  If the
line containing C<{*}> also has a C<#= key> comment, then the
value of the comment is passed as the second argument to the method.

=end comments

class Porcupine::Grammar::Actions;
our $?BLOCK;
our @?BLOCK;
our @?CLASS;
our $?CLASS_BLOCK;
our $?NAMESPACE;
our $?CONSTANT;
our $?TYPE;
our $?ARRAY_CONST;
our $?NAMESPACE;

#array constructor table
$?ARRAY_CONST{'integer'} := '!NEWINTEGERARRAY';
$?ARRAY_CONST{'string'} := '!NEWSTRINGARRAY';
$?ARRAY_CONST{'real'} := '!NEWREALARRAY';
$?ARRAY_CONST{'boolean'} := '!NEWBOOLEANARRAY';

#type conversion table;
$?TYPE{'integer'} := 'PorcupineInteger';
$?TYPE{'real'} := 'PorcupineReal';
$?TYPE{'string'} := 'PorcupineString';
$?TYPE{'boolean'} := 'PorcupineBoolean';
$?TYPE{'text'} := 'PorcupineFile';
$?TYPE{'data'} := 'PorcupineFile';
$?TYPE{'socket'} := 'Socket';


method TOP($/, $key) {
	if $key eq 'open' {
		$?BLOCK := PAST::Block.new( :blocktype('declaration'), :hll('Porcupine'),
			:node($/) );
        $?BLOCK.symbol_defaults( :scope('package') );
		@?BLOCK.unshift($?BLOCK);
	}
	else {
		my $past := @?BLOCK.shift();
		
		if $<program_heading>{
			$past.push($($<block>));
		}	
		elsif $<unit_heading>{
			$past.push($($<unit_block>));
		}
        for @?CLASS {
            $past.unshift($?CLASS_BLOCK{$_});
        }
		make $past;
	}
}

method block($/) {
	my $past := PAST::Stmts.new( :node( $/ ));
	if $<declaration_part>[0] {
		$past.push( $( $<declaration_part>[0] ) );
	}
	$past.push($($<statement_part>));
	make $past;
}

method unit_block($/) {
	make $($<declaration_part>);
}

method declaration_part($/){
	my $past := PAST::Stmts.new( :node( $/ ));
	if $<type_definition_part>[0]{
		my $type := $($<type_definition_part>[0]);
		$past.push($type);
	}
	if $<use_declaration_part>[0]{
		my $use := $($<use_declaration_part>[0]);
		$past.push($use);
	}

	if $<variable_declaration_part>[0]{
		my $var := $($<variable_declaration_part>[0]);
		$past.push($var);
	}
	for $<procedure_declaration> {
        #if has namespace add to class block.
   		my $p := $($_);
        if($p.namespace()){
            $?CLASS_BLOCK{$p.namespace()}.push($p);
        }
        else {
            $past.push($p);
        }
	}
    for $<function_declaration> {
		my $p := $($_);
        if($p.namespace()){
            $?CLASS_BLOCK{$p.namespace()}.push($p);
        }
        else {
            $past.push($p);
        }
	}
	make $past;
}

method use_declaration_part($/) {
	my $past := PAST::Stmts.new( :node( $/ ));
	for $<identifier> {
		my $mod := PAST::Val.new(:value(~$_), :returns('String'), :node($/));
		my $load := PAST::Op.new(:name('!LOADMODULE'), :pasttype('call'), :node($/)); 
		$load.push($mod);
		$past.push($load);        
    }
	make $past;
}

method constant_definition($/){
	my $name := ~$<identifier>;
	$?CONSTANT{$name} := $<value>;
}

method type_definition_part($/){
    my $past := PAST::Stmts.new( :node( $/ ));
    for $<type_definition> {
       $past.push($($_));
    }
    make $past;
}

method type_definition($/, $key){
    make $($/{$key});
}

method type_class_definition($/, $key){
    if($key eq 'open') {
        $?NAMESPACE := ~$<namespace>;
        $?TYPE{$?NAMESPACE} := $?NAMESPACE;
        @?CLASS[0] := $?NAMESPACE;
        
        #create class block
        $?CLASS_BLOCK{$?NAMESPACE} :=  
        PAST::Block.new(:pirflags(":init :load"), 
            :blocktype('declaration'), :namespace($?NAMESPACE));

    }
    else {
		my $past := PAST::Block.new( :blocktype('declaration'), :node($/) );
        $past.pirflags(':init :load');
        
        my $v := PAST::Var.new(:name('!CLASS'), :scope('lexical'));
        $v.isdecl(1);
        $past.push($v);

        #create new class
        my $nc := PAST::Op.new(
                :pasttype('bind'),
                PAST::Var.new(
                    :name('!CLASS'),
                    :scope('lexical'),
                ),
                PAST::Op.new(
                    :pasttype('call'),
                    :name('!NEWCLASS'),
                    PAST::Val.new( :value($?NAMESPACE))
                )
            );

        $past.push($nc);



        #add attr and methods
        for $<class_item> {
            my $item := $($_); 

            if($item{'name'}){ #is method proto
                $?CLASS_BLOCK{$?NAMESPACE}.push($item);
            }
            else { #is attr
                $past.push($item);
            }
        }
            
        #register class as subclass of Porcmeta
        my $reg := PAST::Op.new(
            :pasttype('callmethod'),
            :name('register'),
            PAST::Var.new(
                :scope('package'),
                :name('!METACLASS'),
                :namespace('Porcupine')
            ),
            PAST::Var.new(
                :scope('lexical'),
                :name('!CLASS')
            ),
            PAST::Val.new(
                :value('PorcupineMetaClass'),
                :named( PAST::Val.new( :value('parent') ) )
            )
        );
        $past.push($reg);

        $?NAMESPACE := '';
        make $past;
    }
}

method class_item($/, $key){
    make $($/{$key});
}

method class_def_method($/){
    my $name := ~$<identifier>;
    my $past := PAST::Block.new(:name($name), :blocktype('method'), :namespace($?NAMESPACE), :node($/));
    my $msg := "method ("~ $name ~ ") has only been prototyped!";
	$past.push(PAST::Op.new( $msg, :inline("\t'!EXCEPTION'(%0)"), :node($/) ));
    $past.control('return_pir');
    make $past;
}

method class_def_attribute($/){
    my $type := $?TYPE{lwcase(~$<type>{'simple_type'})};	
    if($<type>{'array_type'}){
        $/.panic("Arrays as attributes have not been implemented!");
	}
 
    unless $type {
        #$/.panic("Undefined type!");
        $type := ~$<type>{'simple_type'};
	}

    my $stmt := PAST::Stmts.new(:node($/));

    my $atr := PAST::Op.new(:name('!ADDATTRIBUTE'), :pasttype('call'), :node( $/ ) );
    $atr.push(PAST::Var.new(:name('!CLASS'), :scope('lexical')));
    $atr.push(PAST::Val.new(:value(~$<identifier>)));
    $stmt.push($atr);
	make $stmt;
}

method variable_declaration_part($/){
    my $past := PAST::Stmts.new( :node( $/ ));
    for $<variable_declaration>{
		$past.push( $( $_ ) );
    }
    make $past;
}

method variable_declaration($/){
   	my $past := PAST::VarList.new(:node($/));
	
	my $type;
	my $ptype := $<type>{'simple_type'};
	my $size;
	my $array := 0;
	
	if($<type>{'simple_type'}){
		$type := $?TYPE{$ptype};
	}
	elsif($<type>{'array_type'}){
		$ptype := $<type>{'array_type'}{'simple_type'};
		$type := $?TYPE{lwcase($ptype)};
		$size := $<type>{'array_type'}{'size'};
	}
	
	unless $type {
        $type := ~$ptype;
        # $/.panic("Undefined type '" ~ $ptype ~"'");
	}	

	for $<identifier>{
		my $var := PAST::Var.new(:name(~$_), :scope('lexical'), :node($/));
		$var.isdecl(1);
		$var.viviself($type);
		
		#arrays
		if($<type>{'array_type'}){
			#look up constructor
			my $const := $?ARRAY_CONST{lwcase($ptype)};
			unless $const {
				$/.panic("Undefined array type '" ~ $ptype ~"'");
			}

			$var.viviself(PAST::Op.new(
					$($size), 
					:name($const), 
					:pasttype('call'),
					:node($/)));
			$array := 1;
		}
		
		$past.push($var);
		$?BLOCK.symbol(~$_, :scope('lexical'));
	}

	make $past;
}

method procedure_declaration($/){
    my $past := $($<procedure_heading>);

   	$past.push($($<procedure_body>));

	#remove block from stack 
    @?BLOCK.shift();
    $?BLOCK := @?BLOCK[0];

    $?NAMESPACE := ''; # leave namespace

    make $past;
}

method procedure_heading($/){
    my $name :=  ~$<identifier>;
    my $blk := 'declaration';

    if $<namespace>[0] {
        $blk := 'method';
        $?NAMESPACE := ~$<namespace>[0];
    }

    my $past := PAST::Block.new(:name($name), :blocktype($blk), :namespace($?NAMESPACE),:node($/));
    $past.symbol_defaults( :scope('lexical') );

    if $<formal_parameter_list> {
        $past.push($( $<formal_parameter_list>[0] ) );
    }

    # add block to stack.
    $?BLOCK := $past;
    @?BLOCK.unshift($past);

    make $past;
}

method function_declaration($/){
    my $past := $($<function_heading>);
	my $name := $past.name();

    $past.push($($<function_body>));

	#remove block from stack 
    @?BLOCK.shift();
    $?BLOCK := @?BLOCK[0];	

	my $var := PAST::Var.new( :name($name),
			:scope('lexical'),
			:node($/));

	$past.push( PAST::Op.new( $var, :pasttype('return'), :node($/)));
    $past.control('return_pir');

    $?NAMESPACE := ''; # leave namespace

    make $past;
}

method function_heading($/){
    my $name :=  ~$<identifier>;
    
    my $blk := 'declaration';
    if $<namespace>[0] {
        $blk := 'method';
        $?NAMESPACE := ~$<namespace>[0];
        #load namespace block onto stack.

    }

    my $past := PAST::Block.new(:name($name), :blocktype($blk), :namespace($?NAMESPACE), :node($/));
	$past.symbol($name, :scope('lexical') );

    my $ptype := ~$<type>;
    $past.symbol_defaults( :scope('lexical') );

	if $<formal_parameter_list>{
    	$past.push($( $<formal_parameter_list>[0] ) );
    }
	
	my $type := $?TYPE{lwcase($ptype)};
	
	unless $type {
		$/.panic("Undefined type '" ~ $ptype ~"'");
	}

	$past.push( PAST::Var.new( :name($name),
			:scope('lexical'),
			:viviself($type),
			:isdecl(1),
			:node($/) ) );

    
	# add block to stack.
    $?BLOCK := $past;
    @?BLOCK.unshift($past);


	make $past;
}

method formal_parameter_list($/){
    my $past := PAST::Stmts.new(:node($/));
	for $<formal_parameter_section> {
		$past.push($( $_ ) );
	}
	make $past;
}

method formal_parameter_section($/, $key){
	make $( $/{$key} );
}

method value_parameter($/){
	my $past := PAST::VarList.new(:node($/));
    my $type := ~$<type>;

	for $<variable>{
		my $var := $( $_ );
		my $name := $var.name();
		$var.scope('parameter');
		$?BLOCK.symbol($name, :scope('lexical'));
		$past.push($var);
	}
	make $past;
}

method statement_part($/){
	my $past := PAST::Stmts.new(:node($/));
	for $<statement> {
		$past.push( $( $_) );
	}
	make $past;
}

method statement($/, $key) {
	make $( $/{$key} );
}

method compound_statement($/){
	my $past := PAST::Stmts.new(:node($/));
	for $<statement> {
		$past.push($( $_ ) );
	}
	make $past;
}

method assignment($/, $key){
    my $lval := $($<variable>);
    my $past;

    #bind used for attributes and scopes
    if($key eq 'lazy' or $lval.scope() eq 'attribute' or 'keyed' eq $lval.scope()){
        $past := PAST::Op.new( :pasttype('bind'),:node($/));
    }
    else {
        $past := PAST::Op.new( :name('infix::='), :pasttype('call'),:node($/));
    }
   
    $lval.lvalue(1);
    $past.push($lval);
    $past.push($($<expression>)); #rval

    make $past;
}

method procedure_statement($/){
    my $func := ~$<identifier>;
    my $past := PAST::Op.new( :name($func), :pasttype('call'), :node( $/ ) );
    
    if $<expression>{
        for $<expression> {
	    $past.push( $( $_ ) );
        }
    }

    make $past;
}

method method_statement($/){
    my $past := PAST::Op.new( :name(~$<method>), :pasttype('callmethod'), :node( $/ ) );
    my $ob;
    my $ns;
    my $owner;

    #if called on a object set object as method owner
    if $<variable> {
        for @?BLOCK {
            if $_.symbol(~$<variable>) {
                $ob := 1;
            }
        }
        if $ob {
            $owner := $($<variable>)
        }
    }
    
    #else is namespace
    unless $owner {
        if $<variable> {
            $ns := ~$<variable>;
        }else{
            $ns := ~$<namespace>;
        }
        $owner := PAST::Var.new(:scope('package'), :name($ns), :node($/));
    }

    unless $owner {
        $/.panic("Couldn't find namespace or object: " ~ $ns);
    }
  
    $past.push($owner);
    
    if $<expression>{
        for $<expression> {
	        $past.push( $( $_ ) );
        }
    }
    make $past;
}

method if_statement($/){
    my $cond := $($<expression>);
    my $then := $($<statement>);    
	my $past := PAST::Op.new( $cond, $then, :pasttype('if'), :node( $/ ) );
	if $<else> {
        $past.push($($<else>[0]));
    }
    make $past;
}

method while_statement($/) {
    my $cond := $($<expression>);
    my $stmt := $($<statement>);
    make PAST::Op.new( $cond, $stmt, :pasttype('while'), :node( $/ ) );
}

method for_assignment ($/){
    my $past := PAST::Op.new(:pasttype('bind'), :node($/));

	my $lval := $($<variable>);
	my $rval := $($<expression>);
    $past.push($lval);
    $past.push($rval);

	$past.name($lval.name());
	$?BLOCK := PAST::Block.new(:blocktype('immediate'), :node($/));
	@?BLOCK.unshift($?BLOCK);
	make $past;
}

method for_statement ($/){
	my $assign := $( $<for_assignment>);

	#create new var for loop condition.
	my $iterator :=  PAST::Var.new(:name($assign.name()), :scope('lexical'), :node($/));

	my $loop_block := @?BLOCK.shift(); #get block created by assignment
	my $?BLOCK :=  @?BLOCK[0]; #set current block to top of stack.

	$loop_block.push($($<statement>));

	my $limit := $( $<expression> );
	$limit.returns('PorcupineInteger');

	my $dir := ~$<for_direction>;

	my $condition;

	if($dir eq 'to'){
		$loop_block.push(PAST::Op.new( $iterator, :pirop('inc'), :node($/) ));
   		$condition := PAST::Op.new( $iterator, $limit, :name('infix:<=') );
	}else{
		$loop_block.push(PAST::Op.new( $iterator, :pirop('dec'), :node($/) ));
   		$condition := PAST::Op.new( $iterator, $limit, :name('infix:>=') );
	}
	
	my $loop := PAST::Op.new( $condition, $loop_block, :pasttype('while'), :node($/) );

	make PAST::Stmts.new( $assign, $loop, :node($/) );
}

method variable($/, $key) {
	make $( $/{$key} );
}

method entire_variable($/) {
	my $name  := ~$<identifier>;
    my $scope := 'lexical';
	if $?CONSTANT{$name} {
		make $( $?CONSTANT{$name});
	}else{
        my $sym;

        for @?BLOCK {
            $sym := $_.symbol($name);
        }
        
        if($?NAMESPACE and !$sym){
            $scope := 'attribute';
        }

		make PAST::Var.new( :name($name),
            # :viviself('PorcupineInteger'),
			:scope($scope),
			:node($/) );
	}
}

method array_variable($/) {
	my $array := PAST::Var.new(
		:scope('keyed'),  :node($/));
	$array.push(PAST::Var.new(:name(~$<identifier>), :scope('lexical'),:node($/)));
	
	#so assignment method can lookup type.
	$array{'name'} := ~$<identifier>;
	
	for $<expression> {
		$array.push($($_));
	}
	make $array;
}

method repeat_statement($/, $key){
	if ($key eq 'open'){
        $?BLOCK := PAST::Block.new( :blocktype('immediate'), :hll('Porcupine') ,:node($/) );
        @?BLOCK.unshift($?BLOCK);
	}else{ 
	    my $loop_block := @?BLOCK.shift(); #get block created by assignment
	    $?BLOCK :=  @?BLOCK[0]; #set current block to top of stack.
        for $<statement>{
            $loop_block.push( $( $_ ) );
        }
        
		my $condition := $( $<expression> );
		my $past := PAST::Op.new( $condition, $loop_block, :pasttype('repeat_until'), :node($/));

		make $past;
	}
}

method exit_statement($/) {
	my $var := PAST::Var.new( :name($?BLOCK.name()),
		:scope('lexical'),
		:viviself('Undef'),
		:node($/));

	make PAST::Op.new( $var, :pasttype('return'), :node($/));
}

method raise_statement($/) {
	my $exp := $( $<expression> );
	$exp.returns('String');
	make PAST::Op.new( $exp, :inline("    '!EXCEPTION'(%0)"), :node($/) );
}

method try_statement($/) {
	# get try statements
	my $try := PAST::Stmts.new(:node($/));
	for $<try> {
		$try.push($($_));
	}
	

	#get final statments
	my $finally := PAST::Stmts.new(:node($/));
	for $<finally> {
		$finally.push($($_));
	}

    my $pir := "    .lex 'exception', %r\n"  ~ "    .get_results (%r)\n"
             ~ "    store_lex 'exception', %r";

    $finally.unshift( PAST::Op.new( :inline($pir), :node($/) ) );
    make PAST::Op.new( $try, $finally, :pasttype('try'), :node($/) );
}

method show_block_statement($/) {
	show_blocks();
	make PAST::Stmts.new(:node($/));
}

##  expression:
##    This is one of the more complex transformations, because
##    our grammar is using the operator precedence parser here.
##    As each node in the expression tree is reduced by the
##    parser, it invokes this method with the operator node as
##    the match object and a $key of 'reduce'.  We then build
##    a PAST::Op node using the information provided by the
##    operator node.  (Any traits for the node are held in $<top>.)
##    Finally, when the entire expression is parsed, this method
##    is invoked with the expression in $<expr> and a $key of 'end'.
method expression($/, $key) {
	if ($key eq 'end') {
		make $($<expr>);
	}
	else {
		my $past := PAST::Op.new( :name($<type>),
                                  :pasttype($<top><pasttype>),
                                  :pirop($<top><pirop>),
                                  :lvalue($<top><lvalue>),
                                  :node($/)
                                );
        for @($/) {
            $past.push( $($_) );
        }
        make $past;
    }
}

##  term:
##    Like 'statement' above, the $key has been set to let us know
##    which term subrule was matched.
method term($/, $key) {
    make $( $/{$key} );
}

method integer($/) {
    make PAST::Val.new( :value( ~$/ ), :returns('PorcupineInteger'), :node($/) );
}

method real($/) {
    make PAST::Val.new( :value( ~$/ ), :returns('PorcupineReal'), :node($/) );
}

method string($/) {
    make PAST::Val.new( :value( $($<string_literal>)), :node($/), :returns('String'));
}

method boolean($/) {
	my $val := 0;
	if (~$/ eq 'TRUE'){
		$val := 1;
	}
	make PAST::Val.new( :value($val), :node($/), :returns('PorcupineBoolean'));
}

sub show_blocks($point){
	my $name := $?BLOCK.name();
	writeln("# " ~ $point ~ " current: " ~ $name);

	my $i := 0;
	for @?BLOCK {
		writeln("# "~$i~" - "~$_.name());
		$i++;
	}
}


# vim: expandtab shiftwidth=4:
