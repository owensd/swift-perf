/*! ===========================================================================
 @file main.c
 
 @brief The performance test runner.
 
 @copyright 2015 David Owens II. All rights reserved.
 ============================================================================ */


#if OPT_Ofast
    const char *OptimizationLevel = "Ofast";
#elif OPT_Os
    const char *OptimizationLevel = "Os";
#else
    const char *OptimizationLevel = "O0";
#endif

// NOTE: THIS PROJECT MAKES USE OF A UNITY BUILD!!

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mach/mach_time.h>
#include <math.h>
#include <assert.h>
#include <unistd.h>
#include <sys/ioctl.h>

#include "perflib.c"

#define kNumberOfSamples        10
#define kNumberOfIterations     10


// ---------------------------------- TESTS ------------------------------------

#include "tests/RenderGradient.c"

// ------------------------------- END OF TESTS --------------------------------


int
main(int argc, char** argv)
{
    PLPrintHeader();
    
    PLResult Result = RGRenderGradientTest(kNumberOfSamples, kNumberOfIterations);
    char Buffer[255] = {};
    sprintf(Buffer, "RenderGradient (-%s) Samples = %d, Iterations = %d",
            OptimizationLevel, kNumberOfSamples, kNumberOfIterations);
    PLPrintResult(Buffer, Result);
    PLPrintResult(Buffer, Result);
    PLPrintResult(Buffer, Result);
    
    PLPrintSeparator(FALSE);
    PLPrintResult(Buffer, Result);
    PLPrintResult(Buffer, Result);
    PLPrintResult(Buffer, Result);
    PLPrintResult(Buffer, Result);
    PLPrintSeparator(TRUE);
    
    return 0;
}


/*
                                         Avg (ms)   Min (ms)   Max (ms)   StdDev
 --------------------------------------|----------|----------|------------|---------
 RenderGradient

 ━━━╇━━━━╇━━━━━━┩
    │    │      │
 ───┼────┼──────┤
    │    │      │
 ───┴────┴──────┘
┃
 
                                                                          Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃   StdDev ┃
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━┩

*/