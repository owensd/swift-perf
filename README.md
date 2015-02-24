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

    Language: C, Optimization: -O0, Samples = 10, Iterations = 10             ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient (Pointer Math)                                             │   12.811 │   12.159 │   15.317 │  0.937 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: C, Optimization: -Os, Samples = 10, Iterations = 10             ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient (Pointer Math)                                             │    3.349 │    3.226 │    4.097 │  0.270 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: C, Optimization: -Ofast, Samples = 10, Iterations = 10          ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient (Pointer Math)                                             │    1.053 │    0.962 │    1.641 │  0.211 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: Swift, Optimization: -Onone, Samples = 10, Iterations = 10      ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient ([Pixel])                                                  │ 1135.202 │ 1126.988 │ 1150.168 │ 6.2588 │
    RenderGradient (UnsafeMutablePointer)                                     │ 51.64436 │ 51.27288 │ 53.39573 │ 0.6591 │
    RenderGradient ([Pixel].withUnsafeMutablePointer)                         │ 117.5919 │ 116.8631 │ 121.8991 │ 1.5371 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: Swift, Optimization: -O, Samples = 10, Iterations = 10          ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient ([Pixel])                                                  │ 8.530972 │ 8.472695 │ 8.741202 │ 0.0971 │
    RenderGradient (UnsafeMutablePointer)                                     │  7.71982 │ 7.075211 │  9.98452 │ 0.8856 │
    RenderGradient ([Pixel].withUnsafeMutablePointer)                         │ 7.147733 │ 7.047496 │ 7.384034 │ 0.1104 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

    Language: Swift, Optimization: -Ounchecked, Samples = 10, Iterations = 10 ┃ Avg (ms) ┃ Min (ms) ┃ Max (ms) ┃ StdDev ┃
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━━━╇━━━━━━━━┩
    RenderGradient ([Pixel])                                                  │ 6.600961 │ 6.345873 │ 7.416309 │ 0.3641 │
    RenderGradient (UnsafeMutablePointer)                                     │ 6.550115 │ 6.251274 │ 7.083578 │ 0.2752 │
    RenderGradient ([Pixel].withUnsafeMutablePointer)                         │ 6.406043 │ 6.292545 │ 6.840824 │  0.172 │
    ──────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┴────────┘

Results above were run against Xcode 6.3 (6D532l) (Xcode 6.3 β2) run on a MacBook Pro (Retina, Mid 2012)
(2.7 GHz i7, 16GB RAM).

# Contributing

If you would like to contribute any performance tests, please take a look at the exists tests, follow the
code formatting of those files, and send a pull request.

If you find any errors, please let me know by filing an issue.
