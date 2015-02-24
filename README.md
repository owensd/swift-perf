# Swift Real-World Performance

This is a collection of tests that I have written (and others have contributed) to test out and compare some
of the real-world performance characteristcs of Swift, especially with regards to C and ObjC performance.

This is just selective sample of Swift performance for specific scenarios. The purpose of this is only to
serve as a **guide** if you start to run into any significant performance issues with Swift.

## Usage

After cloning the repo, you should simply need to run `make`.

    > make

All of the source code will be compiled for the various optimization flags for all code found.

Sample output:

    $ make
    > Building ANSI C -O0
    > Building ANSI C -Os
    > Building ANSI C -Ofast
    > Building Swift -Onone
    > Building Swift -O
    > Building Swift -Ounchecked

    Language: C, Optimization: -O0, Samples = 10, Iterations = 30             ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient (Pointer Math)                                             │   38.310 │   36.480 │   44.305 │  2.566 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: C, Optimization: -Os, Samples = 10, Iterations = 30             ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient (Pointer Math)                                             │   10.183 │    9.679 │   11.854 │  0.671 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: C, Optimization: -Ofast, Samples = 10, Iterations = 30          ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient (Pointer Math)                                             │    3.047 │    2.727 │    3.801 │  0.371 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: Swift, Optimization: -Onone, Samples = 10, Iterations = 30      ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient ([Pixel])                                                  │ 3400.302 │ 3386.940 │ 3425.773 │ 12.690 │
    RenderGradient (UnsafeMutablePointer)                                     │ 154.1663 │ 153.8226 │ 155.6124 │ 0.5233 │
    RenderGradient ([Pixel].withUnsafeMutablePointer)                         │ 351.4033 │ 350.4825 │ 354.8483 │ 1.2495 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: Swift, Optimization: -O, Samples = 10, Iterations = 30          ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient ([Pixel])                                                  │ 25.88973 │ 25.43309 │ 28.02293 │ 0.8073 │
    RenderGradient (UnsafeMutablePointer)                                     │ 21.42733 │ 21.24188 │ 22.36640 │ 0.3583 │
    RenderGradient ([Pixel].withUnsafeMutablePointer)                         │ 21.26979 │ 21.13277 │ 21.62538 │ 0.1904 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: Swift, Optimization: -Ounchecked, Samples = 10, Iterations = 30 ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient ([Pixel])                                                  │ 19.71996 │ 19.05299 │  23.1707 │ 1.2610 │
    RenderGradient (UnsafeMutablePointer)                                     │ 19.01051 │ 18.76363 │ 19.74772 │ 0.3440 │
    RenderGradient ([Pixel].withUnsafeMutablePointer)                         │ 19.42117 │ 18.89458 │ 21.11617 │ 0.8630 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

Results above were run against Xcode 6.3 (6D532l) (Xcode 6.3 β2) run on a MacBook Pro (Retina, Mid 2012)
(2.7 GHz i7, 16GB RAM).

# Contributing

If you would like to contribute any performance tests, please take a look at the exists tests, follow the
code formatting of those files, and send a pull request.

If you find any errors, please let me know by filing an issue.
