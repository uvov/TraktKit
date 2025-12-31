//
//  DeviceCode.swift
//  TraktKit
//
//  Copyright © 2020 Maximilian Litteral. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

public struct DeviceCode: Codable {
    public let deviceCode: String
    public let userCode: String
    public let verificationURL: String
    public let expiresIn: Int
    public let interval: Int
    
    #if canImport(UIKit)
    #if canImport(CoreImage)
    public func getQRCode() -> UIImage? {
        let data = self.verificationURL.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    public func getQRCode(size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        let data = self.verificationURL.data(using: String.Encoding.ascii)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") // 设置高容错率

        guard let outputImage = filter.outputImage else { return nil }

        let scaleX = size.width / outputImage.extent.width
        let scaleY = size.height / outputImage.extent.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = outputImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
    #endif
    #endif
    
    enum CodingKeys: String, CodingKey {
        case deviceCode = "device_code"
        case userCode = "user_code"
        case verificationURL = "verification_url"
        case expiresIn = "expires_in"
        case interval
    }
}
