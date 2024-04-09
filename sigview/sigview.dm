#if DM_VERSION < 515
#define CALL_EXT call
#else
#define CALL_EXT call_ext
#endif

/proc/check_sig(sigtext)
	var/list/splitted = splittext(replacetext(replacetext(sigtext, "\"", ""), ";", ""), " ")
	var/name = splitted[1]
	var/rest = copytext(sigtext, length(name) + 2)
	var/ret = CALL_EXT("./byond_sigview.dll", "check_for_sig")(rest)
	if(ret == "false")
		world.log << "Did not find [name]"
	else if(ret == "true")
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
