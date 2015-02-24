
#if OPT_Ounchecked
    let opt = "Ounchecked"
#else
#if OPT_O
    let opt = "O"
#else
    let opt = "Onone"
#endif
#endif

println("Welcome, to the desert, of the real. (\(opt))")
