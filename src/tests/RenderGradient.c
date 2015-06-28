/*! ===========================================================================
 @file RenderGradient.c
 
 @brief A simple function that fills in an array of pixel data.
 
 @copyright 2015 David Owens II. All rights reserved.
 ============================================================================ */

#import <simd/simd.h>

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
    int Width = Buffer->Width;
    int Height = Buffer->Height;
    uint32_t *Pixel = (uint32_t *)&Buffer->Pixels[0];
    int Offset = 0;
    
    for (int Y = 0; Y < Height; ++Y) {
        for (int X = 0; X < Width; ++X) {
            *Pixel++ = 0xFF << 24 | ((X + OffsetX) & 0xFF) << 16 | ((Y + OffsetY) & 0xFF) << 8;
        }
    }
}

void RGRenderGradientSIMD(RGPixelBufferRef Buffer, int OffsetX, int OffsetY)
{
    int Width = Buffer->Width;
    int Height = Buffer->Height;
    uint32_t *Pixel = (uint32_t *)&Buffer->Pixels[0];
    int Offset = 0;
    
    vector_uchar4 VOffsetY = OffsetY;
    vector_uchar4 VOffsetX = OffsetX;
    
    vector_uchar4 VInc = { 0, 1, 2, 3 };
    vector_uchar4 VBlueAddr = VInc + VOffsetX;
    
    for (int Y = 0; Y < Height; ++Y) {
        vector_uchar4 Green = vector_min(Y + VOffsetY, 255);
        
        for (int X = 0; X < Width; X += 4) {
            vector_uchar4 Blue = vector_min(X + VBlueAddr, 255);

            Pixel[Offset++] = 0xFF << 24 | Blue.x << 16 | Green.x << 8;
            Pixel[Offset++] = 0xFF << 24 | Blue.y << 16 | Green.y << 8;
            Pixel[Offset++] = 0xFF << 24 | Blue.z << 16 | Green.z << 8;
            Pixel[Offset++] = 0xFF << 24 | Blue.w << 16 | Green.w << 8;
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

PLResult RGRenderGradientTestSIMD(uint32_t SampleCount, uint32_t IterationCount)
{
    RGPixelBufferRef PixelBuffer = RGPixelBufferCreate(960, 540);
    
    PLResult Result = PLMeasure(SampleCount, IterationCount, ^{
        RGRenderGradientSIMD(PixelBuffer, 2, 1);
    });
    
    RGPixelBufferRelease(PixelBuffer);
    
    return Result;
}
