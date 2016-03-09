/*! ===========================================================================
@file main.swift

@brief The performance test runner for Swift code.

@copyright 2015 David Owens II. All rights reserved.
============================================================================ */

#if OPT_Ounchecked
    let opt = "Ounchecked"
#else
#if OPT_O
    let opt = "O"
#else
    let opt = "Onone"
#endif
#endif

let NumberOfSamples = 10
let NumberOfIterations = 30

let header = "Language: Swift, Optimization: -\(opt), Samples = \(NumberOfSamples), Iterations = \(NumberOfIterations)"

perflib.header(header)

perflib.test("RenderGradient ([Pixel])", NumberOfSamples, NumberOfIterations, renderGradient_PixelArray)
perflib.test("RenderGradient ([UInt32])", NumberOfSamples, NumberOfIterations, renderGradient_PixelArray_UInt32)
perflib.test("RenderGradient (UnsafeMutablePointer)", NumberOfSamples, NumberOfIterations, renderGradient_unsafeMutablePointer)
perflib.test("RenderGradient (UnsafeMutablePointer<UInt32>)", NumberOfSamples, NumberOfIterations, renderGradient_unsafeMutablePointer_UInt32)
perflib.test("RenderGradient ([Pixel].withUnsafeMutablePointer)", NumberOfSamples, NumberOfIterations, renderGradient_ArrayUsingUnsafeMutablePointer)
perflib.test("RenderGradient ([UInt32].withUnsafeMutablePointer)", NumberOfSamples, NumberOfIterations, renderGradient_ArrayUsingUnsafeMutablePointer_UInt32)
perflib.test("RenderGradient ([UInt32].withUnsafeMutablePointer (SIMD))", NumberOfSamples, NumberOfIterations, renderGradient_ArrayUsingUnsafeMutablePointer_UInt32_SIMD)
perflib.test("RenderGradient ([Pixel].withUnsafeMutablePointer (SIMD))", NumberOfSamples, NumberOfIterations, renderGradient_ArrayUsingUnsafeMutablePointer_Pixel_SIMD)

perflib.separator()
