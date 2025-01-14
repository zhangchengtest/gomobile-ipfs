//
//  InputStreamToGo.swift
//  GomobileIPFS
//
//  Created by CI Agent on 20/01/2020.
//

import Foundation
import Core

public class InputStreamToGo: NSObject, CoreReaderProtocol {
    private var inputStream: InputStream

    init(_ inputStream: InputStream) {
        self.inputStream = inputStream
        self.inputStream.open()
    }

    public func read(_ buffer: Data?, n len: UnsafeMutablePointer<Int>?) throws {
        var read: Int

        let bytes = UnsafeMutablePointer<UInt8>(OpaquePointer((buffer! as NSData).bytes))
        read = self.inputStream.read(bytes, maxLength: buffer!.count)
        len?.initialize(to: read)

        if read == 0 && self.inputStream.streamStatus == .atEnd {
            self.inputStream.close()
            throw NSError(domain: "", code: 0, userInfo: ["NSLocalizedDescription": "EOF"])
        }
    }
}
