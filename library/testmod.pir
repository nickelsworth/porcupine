

.include 'cclass.pasm'
.namespace[]
.sub 'testfunc'
	print "ok 1\n"
	print "ok 2\n"
	print "ok 3\n"
.end

.sub 'anothertestfunc'
	print "ok 5\n"
	print "ok 6\n"
	print "ok 7\n"
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
