.namespace[]

.sub '!NEWINTEGERARRAY'
	.param int size
	.local pmc array
	array = new 'FixedPMCArray'
	array = size
	.return (array)
.end

.sub '!NEWSTRINGARRAY'
	.param int size
	.local pmc array
	array = new 'FixedStringArray'
	array = size
	.return (array)
.end

.sub '!NEWREALARRAY'
	.param int size
	.local pmc array
	array = new 'FixedFloatArray'
	array = size
	.return (array)
.end

.sub '!NEWBOOLEANARRAY'
	.param int size
	.local pmc array
	array = new 'FixedBooleanArray'
	array = size
	.return (array)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

