/*! ===========================================================================
 @file RenderGradient.c
 
 @brief A simple function that fills in an array of pixel data.
 
 @copyright 2015 David Owens II. All rights reserved.
 ============================================================================ */

typedef struct {
    uint8_t Red;
    uint8_t Blue;
    uint8_t Green;
    uint8_t Alpha;
} RGPixel;

typedef struct {
    RGPixel *Pixels;
    int Width;
    int Height;
} RGPixelBuffer, *RGPixelBufferRef;

RGPixelBufferRef RGPixelBufferCreate(int Width, int Height)
{
    assert(Width > 0);
    assert(Height > 0);
    
    RGPixelBufferRef Buffer = malloc(sizeof(RGPixelBuffer));
    assert(Buffer);
    
    Buffer->Pixels = malloc(Width * Height * sizeof(RGPixel));
    assert(Buffer->Pixels);
    
    Buffer->Width = Width;
    Buffer->Height = Height;
    
    return Buffer;
}

void RGPixelBufferRelease(RGPixelBufferRef Buffer)
{
    if (Buffer->Pixels) {
        free(Buffer->Pixels);
    }
    
    Buffer->Width = 0;
    Buffer->Height = 0;
}

void RGRenderGradient(RGPixelBufferRef Buffer, int OffsetX, int OffsetY)
{
    int Width = Buffer->Width + OffsetX;
    int Height = Buffer->Height + OffsetY;
    uint32_t *Pixel = (uint32_t *)&Buffer->Pixels[0];
    
    for (int Y = OffsetY; Y < Height; ++Y) {
        for (int X = OffsetX; X < Width; ++X) {
            *Pixel = 0xFF << 24 | (X & 0xFF) << 16 | (Y & 0xFF) << 8;
            ++Pixel;
        }
    }
}

PLResult RGRenderGradientTest(uint32_t SampleCount, uint32_t IterationCount)
{
    RGPixelBufferRef PixelBuffer = RGPixelBufferCreate(960, 540);
    
    PLResult Result = PLMeasure(SampleCount, IterationCount, ^{
        RGRenderGradient(PixelBuffer, 2, 1);
    });
    
    RGPixelBufferRelease(PixelBuffer);
    
    return Result;
}
