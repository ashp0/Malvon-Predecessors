//
//  MAPaths.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2021-12-28.
//  Copyright © 2021-2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

public enum path {
    case data
}

public class MAPaths {
    let path: path
    
    public init(_ path: path) {
        self.path = path
    }
    
    public func get() -> URL? {
        if self.path == .data {
            do {
                let applicationSupportFolderURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
                let folder = applicationSupportFolderURL.appendingPathComponent("\(appName)/data", isDirectory: true)
                if !FileManager.default.fileExists(atPath: folder.path) {
                    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
                }
                return folder
            } catch {}
        }
        return nil
    }
}
