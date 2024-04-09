/proc/check_sig(sigtext)
	var/list/splitted = splittext(replacetext(replacetext(sigtext, "\"", ""), ";", ""), " ")
	var/name = splitted[1]
	var/rest = copytext(sigtext, length(name) + 2)
	var/ret = call_ext("byond_sigview", "byond:check_for_sig")(rest)
	if(ret == 0)
		world.log << "Did not find [name]"
	else if(ret == 1)
		world.log << "Found [name]"
	else
		world.log << "Error finding [name]: [ret]"


/world/New()
	var/sigs = file2text("sigs.txt")
	for(var/sig in splittext(sigs, "\n"))
		if(length(sig) < 5)
			continue
		check_sig(sig)
	del(src)
