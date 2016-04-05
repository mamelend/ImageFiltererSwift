//
//  Filters.swift
//  Filterer
//
//  Created by Miguel Melendez on 2/11/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

public class Filter {
    
    public func blackout(image: UIImage) -> UIImage {
        let this_image = RGBAImage(image: image)!
        for y in 0..<this_image.height {
            for x in 0..<this_image.width {
                let index = y * this_image.width + x
                var pixel = this_image.pixels[index]
                pixel.red = 0
                pixel.green = 0
                pixel.blue = 0
                this_image.pixels[index] = pixel
            }
        }
        return this_image.toUIImage()!
    }
    
    public func brightness(image: UIImage, factor: Int) -> UIImage {
        let this_image = RGBAImage(image: image)!
        for y in 0..<this_image.height {
            for x in 0..<this_image.width {
                let index = y * this_image.width + x
                var pixel = this_image.pixels[index]
                pixel.red = UInt8(max(min(255, Int(pixel.red) + factor), 0))
                pixel.green = UInt8(max(min(255, Int(pixel.green) + factor), 0))
                pixel.blue = UInt8(max(min(255, Int(pixel.blue) + factor), 0))
                
                this_image.pixels[index] = pixel
            }
        }
        return this_image.toUIImage()!
    }
    
    public func halfBrightness(image: UIImage) -> UIImage {
        let this_image = RGBAImage(image: image)!
        for y in 0..<this_image.height {
            for x in 0..<this_image.width {
                let index = y * this_image.width + x
                var pixel = this_image.pixels[index]
                pixel.red = UInt8(max(min(255, Int(pixel.red) / 2), 0))
                pixel.green = UInt8(max(min(255, Int(pixel.green) / 2), 0))
                pixel.blue = UInt8(max(min(255, Int(pixel.blue) / 2), 0))
                
                this_image.pixels[index] = pixel
            }
        }
        return this_image.toUIImage()!
    }
    
    public func contrast(image: UIImage, factor: Int) -> UIImage {
        let this_image = RGBAImage(image: image)!
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        let pixelCount = this_image.width * this_image.height
        
        for y in 0..<this_image.height {
            for x in 0..<this_image.width {
                let index = y * this_image.width + x
                let pixel = this_image.pixels[index]
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let avgRed = totalRed / pixelCount
        let avgGreen = totalGreen / pixelCount
        let avgBlue = totalBlue / pixelCount
        
        for y in 0..<this_image.height {
            for x in 0..<this_image.width {
                let index = y * this_image.width + x
                var pixel = this_image.pixels[index]
                
                let redDelta = Int(pixel.red) - avgRed
                let greenDelta = Int(pixel.green) - avgGreen
                let blueDelta = Int(pixel.blue) - avgBlue
                pixel.red = UInt8(max(min(255, avgRed + factor * redDelta), 0))
                pixel.green = UInt8(max(min(255, avgGreen + factor * greenDelta), 0))
                pixel.blue = UInt8(max(min(255, avgBlue + factor * blueDelta), 0))
                this_image.pixels[index] = pixel
            }
        }
        return this_image.toUIImage()!
    }
    
}