/*! ===========================================================================
@file RenderGradient.swift

@brief A simple function that fills in an array of pixel data.

@copyright 2015 David Owens II. All rights reserved.
============================================================================ */

import simd

func renderGradient_PixelArray(samples: Int, iterations: Int) -> Result {
    struct Pixel {
        var red: UInt8
        var green: UInt8
        var blue: UInt8
        var alpha: UInt8
    }
    
    struct RenderBuffer {
        var pixels: [Pixel]
        var width: Int
        var height: Int
        
        init(width: Int, height: Int) {
            assert(width > 0)
            assert(height > 0)
            
            let pixel = Pixel(red: 0, green: 0, blue: 0, alpha: 0xFF)
            pixels = [Pixel](count: width * height, repeatedValue: pixel)
            
            self.width = width
            self.height = height
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int)
    {
        // I truly hope you have turned down the number of iterations or you have picked
        // up a new build of Swift where this is not dog slow with -Onone.
        var offset = 0
        for (var y = 0, height = buffer.height; y < height; ++y) {
            for (var x = 0, width = buffer.width; x < width; ++x) {
                let pixel = Pixel(
                    red: 0,
                    green: UInt8((y + offsetY) & 0xFF),
                    blue: UInt8((x + offsetX) & 0xFF),
                    alpha: 0xFF)
                buffer.pixels[offset] = pixel;
                ++offset;
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
 
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_PixelArray_UInt32(samples: Int, iterations: Int) -> Result {
    typealias Pixel = UInt32
    
    struct RenderBuffer {
        var pixels: [Pixel]
        var width: Int
        var height: Int
        
        static func rgba(red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8) -> Pixel {
            let r = UInt32(red)
            let g = UInt32(green) << 8
            let b = UInt32(blue) << 16
            let a = UInt32(alpha) << 24
            return r | g | b | a
        }

        init(width: Int, height: Int) {
            assert(width > 0)
            assert(height > 0)
            
            let pixel = RenderBuffer.rgba(0, 0, 0, 0xFF)
            pixels = [Pixel](count: width * height, repeatedValue: pixel)
            
            self.width = width
            self.height = height
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int)
    {
        // I truly hope you have turned down the number of iterations or you have picked
        // up a new build of Swift where this is not dog slow with -Onone.
        var offset = 0
        for (var y = 0, height = buffer.height; y < height; ++y) {
            for (var x = 0, width = buffer.width; x < width; ++x) {
                let pixel = RenderBuffer.rgba(
                    0,
                    UInt8((y + offsetY) & 0xFF),
                    UInt8((x + offsetX) & 0xFF),
                    0xFF)
                buffer.pixels[offset] = pixel;
                ++offset;
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
    
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_unsafeMutablePointer(samples: Int, iterations: Int) -> Result {
    struct Pixel {
        var red: UInt8
        var green: UInt8
        var blue: UInt8
        var alpha: UInt8
    }
    
    struct RenderBuffer {
        var pixels: UnsafeMutablePointer<Pixel>
        var width: Int
        var height: Int
        
        init(width: Int, height: Int) {
            assert(width > 0)
            assert(height > 0)
            
            pixels = UnsafeMutablePointer.alloc(width * height * sizeof(Pixel))
            
            self.width = width
            self.height = height
        }
        
        mutating func release() {
            pixels.dealloc(width * height * sizeof(Pixel))
            width = 0
            height = 0
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int)
    {
        var offset = 0
        for (var y = 0, height = buffer.height; y < height; ++y) {
            for (var x = 0, width = buffer.width; x < width; ++x) {
                let pixel = Pixel(
                    red: 0,
                    green: UInt8((y + offsetY) & 0xFF),
                    blue: UInt8((x + offsetX) & 0xFF),
                    alpha: 0xFF)
                buffer.pixels[offset] = pixel;
                ++offset;
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)

    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_unsafeMutablePointer_UInt32(samples: Int, iterations: Int) -> Result {
    typealias Pixel = UInt32
    
    struct RenderBuffer {
        var pixels: UnsafeMutablePointer<Pixel>
        var width: Int
        var height: Int
        
        static func rgba(red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8) -> Pixel {
            let r = UInt32(red)
            let g = UInt32(green) << 8
            let b = UInt32(blue) << 16
            let a = UInt32(alpha) << 24
            return r | g | b | a
        }

        init(width: Int, height: Int) {
            assert(width > 0)
            assert(height > 0)
            
            pixels = UnsafeMutablePointer.alloc(width * height * sizeof(Pixel))
            
            self.width = width
            self.height = height
        }
        
        mutating func release() {
            pixels.dealloc(width * height * sizeof(Pixel))
            width = 0
            height = 0
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int)
    {
        var offset = 0
        for (var y = 0, height = buffer.height; y < height; ++y) {
            for (var x = 0, width = buffer.width; x < width; ++x) {
                let pixel = RenderBuffer.rgba(
                    0,
                    UInt8((y + offsetY) & 0xFF),
                    UInt8((x + offsetX) & 0xFF),
                    0xFF)
                buffer.pixels[offset] = pixel;
                ++offset;
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
    
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_ArrayUsingUnsafeMutablePointer(samples: Int, iterations: Int) -> Result {
    struct Pixel {
        var red: UInt8
        var green: UInt8
        var blue: UInt8
        var alpha: UInt8
    }
    
    struct RenderBuffer {
        var pixels: [Pixel]
        var width: Int
        var height: Int
        
        init(width: Int, height: Int) {
            assert(width > 0)
            assert(height > 0)
            
            let pixel = Pixel(red: 0, green: 0, blue: 0, alpha: 0xFF)
            pixels = [Pixel](count: width * height, repeatedValue: pixel)
            
            self.width = width
            self.height = height
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int)
    {
        // Turn this code on for at least some sanity back to your debug builds. It's still
        // going to be slow, but at compared to the code above, it's going to feel glorious.
        buffer.pixels.withUnsafeMutableBufferPointer { (inout p: UnsafeMutableBufferPointer<Pixel>) -> () in
            var offset = 0
            for (var y = 0, height = buffer.height; y < height; ++y) {
                for (var x = 0, width = buffer.width; x < width; ++x) {
                    let pixel = Pixel(
                        red: 0,
                        green: UInt8((y + offsetY) & 0xFF),
                        blue: UInt8((x + offsetX) & 0xFF),
                        alpha: 0xFF)
                    p[offset] = pixel
                    ++offset;
                }
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
    
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_ArrayUsingUnsafeMutablePointer_UInt32(samples: Int, iterations: Int) -> Result {
    typealias Pixel = UInt32
    
    struct RenderBuffer {
        var pixels: [Pixel]
        var width: Int
        var height: Int
        
        static func rgba(red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8) -> Pixel {
            let r = UInt32(red)
            let g = UInt32(green) << 8
            let b = UInt32(blue) << 16
            let a = UInt32(alpha) << 24
            return r | g | b | a
        }
        
        init(width: Int, height: Int) {
            assert(width > 0)
            assert(height > 0)
            
            let pixel = RenderBuffer.rgba(0, 0, 0, 0xFF)
            pixels = [Pixel](count: width * height, repeatedValue: pixel)
            
            self.width = width
            self.height = height
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int)
    {
        // Turn this code on for at least some sanity back to your debug builds. It's still
        // going to be slow, but at compared to the code above, it's going to feel glorious.
        buffer.pixels.withUnsafeMutableBufferPointer { (inout p: UnsafeMutableBufferPointer<Pixel>) -> () in
            var offset = 0
            for (var y = 0, height = buffer.height; y < height; ++y) {
                for (var x = 0, width = buffer.width; x < width; ++x) {
                    let pixel = RenderBuffer.rgba(
                        0,
                        UInt8((y + offsetY) & 0xFF),
                        UInt8((x + offsetX) & 0xFF),
                        0xFF)
                    p[offset] = pixel
                    ++offset;
                }
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
    
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_ArrayUsingUnsafeMutablePointer_Pixel_SIMD(samples: Int, iterations: Int) -> Result {
    struct Pixel {
        var red: UInt8
        var green: UInt8
        var blue: UInt8
        var alpha: UInt8
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        init(red: Int32, green: Int32, blue: Int32, alpha: Int32 = 255) {
            self.red = UInt8(red & 255)
            self.green = UInt8(green & 255)
            self.blue = UInt8(blue & 255)
            self.alpha = UInt8(alpha & 255)
        }
        
        init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
            self.red = UInt8(red & 255)
            self.green = UInt8(green & 255)
            self.blue = UInt8(blue & 255)
            self.alpha = UInt8(alpha & 255)
        }
    }
    
    struct RenderBuffer {
        var pixels: [Pixel]
        var width: Int
        var height: Int
        
        init(width: Int, height: Int) {
            precondition(width > 0)
            precondition(height > 0)
            
            let pixel = Pixel(red: 0, green: 0, blue: 0, alpha: 0xFF)
            pixels = [Pixel](count: width * height, repeatedValue: pixel)
            
            self.width = width
            self.height = height
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int) {
        buffer.pixels.withUnsafeMutableBufferPointer { (inout p: UnsafeMutableBufferPointer<Pixel>) -> () in
            var offset = 0

            let yoffset = int4(Int32(offsetY))
            let xoffset = int4(Int32(offsetX))

            // NOTE(owensd): There is a performance loss using the friendly versions.
            
            //for y in 0..<buffer.height {
            for var y = 0, height = buffer.height; y < height; ++y {
                let green = min(int4(Int32(y)) + yoffset, 255)
                
                //for x in stride(from: 0, through: buffer.width - 1, by: 4) {
                for var x: Int32 = 0, width = buffer.width; x < Int32(width); x += 4 {
                    let blue = min(int4(x, x + 1, x + 2, x + 3) + xoffset, 255)
                    
                    p[offset++] = Pixel(red: 0, green: green.x, blue: blue.x, alpha: 255)
                    p[offset++] = Pixel(red: 0, green: green.y, blue: blue.y, alpha: 255)
                    p[offset++] = Pixel(red: 0, green: green.z, blue: blue.z, alpha: 255)
                    p[offset++] = Pixel(red: 0, green: green.w, blue: blue.w, alpha: 255)
                }
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
    
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}

func renderGradient_ArrayUsingUnsafeMutablePointer_UInt32_SIMD(samples: Int, iterations: Int) -> Result {
    typealias Pixel = UInt32
    
    struct RenderBuffer {
        var pixels: [Pixel]
        var width: Int
        var height: Int
        
        static func rgba(red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8) -> Pixel {
            let r = UInt32(red)
            let g = UInt32(green) << 8
            let b = UInt32(blue) << 16
            let a = UInt32(alpha) << 24
            return r | g | b | a
        }
        
        init(width: Int, height: Int) {
            precondition(width > 0)
            precondition(height > 0)
            
            let pixel = RenderBuffer.rgba(0, 0, 0, 255)
            pixels = [Pixel](count: width * height, repeatedValue: pixel)
            
            self.width = width
            self.height = height
        }
    }
    
    func RenderGradient(inout buffer: RenderBuffer, offsetX: Int, offsetY: Int) {
        buffer.pixels.withUnsafeMutableBufferPointer { (inout p: UnsafeMutableBufferPointer<Pixel>) -> () in
            var offset = 0
            
            let yoffset = int4(Int32(offsetY))
            let xoffset = int4(Int32(offsetX))
            
            // TODO(owensd): Move to the 8-bit SIMD instructions when they are available.
            
            // NOTE(owensd): There is a performance loss using the friendly versions.
            
            //for y in 0..<buffer.height {
            for var y: Int32 = 0, height = buffer.height; y < Int32(height); ++y {
                let green = int4(y) + yoffset
                
                //for x in stride(from: 0, through: buffer.width - 1, by: 4) {
                for var x: Int32 = 0, width = buffer.width; x < Int32(width); x += 4 {
                    let blue = int4(x, x + 1, x + 2, x + 3) + xoffset
                    
                    p[offset++] = 0xFF << 24 | UInt32(blue.x & 0xFF) << 16 | UInt32(green.x & 0xFF) << 8
                    p[offset++] = 0xFF << 24 | UInt32(blue.y & 0xFF) << 16 | UInt32(green.y & 0xFF) << 8
                    p[offset++] = 0xFF << 24 | UInt32(blue.z & 0xFF) << 16 | UInt32(green.z & 0xFF) << 8
                    p[offset++] = 0xFF << 24 | UInt32(blue.w & 0xFF) << 16 | UInt32(green.w & 0xFF) << 8
                }
            }
        }
    }
    
    var buffer = RenderBuffer(width: 960, height: 540)
    
    return perflib.measure(samples, iterations) {
        RenderGradient(&buffer, offsetX: 2, offsetY: 1)
    }
}