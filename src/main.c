/*! ===========================================================================
 @file main.c
 
 @brief The performance test runner for C code.
 
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
#define kNumberOfIterations     30


// ---------------------------------- TESTS ------------------------------------

#include "tests/RenderGradient.c"

// ------------------------------- END OF TESTS --------------------------------


int
main(int argc, char** argv)
{
    char Buffer[255] = {};
    sprintf(Buffer, "Language: C, Optimization: -%s, Samples = %d, Iterations = %d",
            OptimizationLevel, kNumberOfSamples, kNumberOfIterations);
    PLPrintHeader(Buffer);
    
    PLPerformTest("RenderGradient (Pointer Math)", RGRenderGradientTest);
    PLPerformTest("RenderGradient (SIMD)", RGRenderGradientTestSIMD);
    
    PLPrintSeparator(TRUE);
    
    return 0;
}
