/*! ===========================================================================
 @file perflib.c
 
 @brief A set of utilities used to perform all of the performance measurements.
 
 @copyright 2015 David Owens II. All rights reserved.
 ============================================================================ */

typedef struct {
    float Average;
    float Minimum;
    float Maximum;
    float StdDev;
} PLResult;

typedef float (^PLCombiner)(float Accum, float Value);

static inline float
PLReduce(float *Items, int Size, float Initial, PLCombiner Combiner) {
    float Result = Initial;
    for (int Index = 0; Index < Size; ++Index) {
        Result = Combiner(Result, Items[Index]);
    }
    
    return Result;
}

static inline PLResult
PLMeasure(uint32_t SampleCount,
        uint32_t IterationCount,
        void(^FunctionToTime)(void))
{
    int SamplesSize = sizeof(float) * SampleCount;
    float *Samples = malloc(SamplesSize);
    memset(Samples, 0, SamplesSize);
    
    float *Sample = &Samples[0];
    for (int SampleIndex = 0; SampleIndex < SampleCount; ++SampleIndex, ++Sample) {
        uint64_t Elapsed = 0;
        
        for (int IterationIndex = 0; IterationIndex < IterationCount; ++IterationIndex) {
            uint64_t StartTime = mach_absolute_time();
            FunctionToTime();
            Elapsed += mach_absolute_time() - StartTime;
        }
        
        *Sample = (float)Elapsed / NSEC_PER_MSEC;
    }
    
    float Sum = PLReduce(Samples, SampleCount, 0.f, ^(float Accum, float Value) {
        return Accum + Value;
    });
    float Average = Sum / SampleCount;
    
    float Sums = PLReduce(Samples, SampleCount, 0.f, ^(float Accum, float Value) {
        float Diff = Value - Average;
        return Accum + (Diff * Diff);
    });
    float StdDev = sqrtf(Sums / (SampleCount - 1));
    
    float Minimum = 0.f;
    float Maximum = 0.f;
    
    PLResult Result = { Average, Minimum, Maximum, StdDev };
    free(Samples);
    
    return Result;
}

static inline void
PLPrintHeader()
{
    struct winsize TerminalSize;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &TerminalSize);
    
    const int ColumnCount = TerminalSize.ws_col - 5;
    const int TimingWidth = 10;
    const int NumberOfTimings = 3;
    const int StdDevWidth = 8;
    const int TitleWidth = ColumnCount - (NumberOfTimings * (TimingWidth + 1)) - StdDevWidth;
    
    printf("%*s", TitleWidth + TimingWidth + 6, "┃ Avg (ms) ┃");
    printf("%*s", TimingWidth + 3, "Min (ms) ┃");
    printf("%*s", TimingWidth + 3, "Max (ms) ┃");
    printf("%*s\n", StdDevWidth + 3, "StdDev ┃");
    
    for (int ColumnOffset = 0; ColumnOffset < TitleWidth; ++ColumnOffset) {
        printf("━");
    }
    printf("╇");
    
    for (int TimingCount = 0; TimingCount < NumberOfTimings; ++TimingCount) {
        for (int ColumnOffset = 0; ColumnOffset < TimingWidth; ++ColumnOffset) {
            printf("━");
        }
        printf("╇");
    }
    
    for (int ColumnOffset = 0; ColumnOffset < StdDevWidth; ++ColumnOffset) {
        printf("━");
    }
    printf("┩\n");
}

static inline void
PLPrintSeparator(int EndOfTable)
{
    struct winsize TerminalSize;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &TerminalSize);
    
    const int ColumnCount = TerminalSize.ws_col - 5;
    const int TimingWidth = 10;
    const int NumberOfTimings = 3;
    const int StdDevWidth = 8;
    const int TitleWidth = ColumnCount - (NumberOfTimings * (TimingWidth + 1)) - StdDevWidth;
    
    for (int ColumnOffset = 0; ColumnOffset < TitleWidth; ++ColumnOffset) {
        printf("─");
    }
    printf("%s", EndOfTable ? "┴" : "┼");
    
    for (int TimingCount = 0; TimingCount < NumberOfTimings; ++TimingCount) {
        for (int ColumnOffset = 0; ColumnOffset < TimingWidth; ++ColumnOffset) {
            printf("─");
        }
        printf("%s", EndOfTable ? "┴" : "┼");
    }
    
    for (int ColumnOffset = 0; ColumnOffset < StdDevWidth; ++ColumnOffset) {
        printf("─");
    }
    printf("%s\n", EndOfTable ? "┘" : "┤");
}

static inline void
PLPrintResult(const char *Message, PLResult Result) {
    struct winsize TerminalSize;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &TerminalSize);
    
    const int ColumnCount = TerminalSize.ws_col - 5;
    const int TimingWidth = 10;
    const int NumberOfTimings = 3;
    const int StdDevWidth = 8;
    const int TitleWidth = ColumnCount - (NumberOfTimings * (TimingWidth + 1)) - StdDevWidth;

    const int RemainingTitleWidth = TitleWidth - strlen(Message);
    
    printf("%.*s %*s │", TitleWidth, Message, RemainingTitleWidth - 2, " ");
    printf("%*.3f │", TimingWidth - 1, Result.Average);
    printf("%*.3f │", TimingWidth - 1, Result.Minimum);
    printf("%*.3f │", TimingWidth - 1, Result.Maximum);
    printf("%*.3f │\n", StdDevWidth - 1, Result.StdDev);
}


