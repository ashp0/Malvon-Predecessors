//
//  Extensions.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-04.
//

import Cocoa

extension String {
    var isValidURL: Bool {
        // swiftlint:disable force_try
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

public func uniqueDataDir() -> URL? {
    do {
        let applicationSupportFolderURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // swiftlint:disable force_cast
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        let folder = applicationSupportFolderURL.appendingPathComponent("\(appName)/usr/data", isDirectory: true)
        print("[ERR]: Folder location: \(folder.path)")
        if !FileManager.default.fileExists(atPath: folder.path) {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        return folder
    } catch {
    }
    return nil
}

struct RootClass : Codable {

        let date : String?
        let title : String?
        let url : String?

        enum CodingKeys: String, CodingKey {
                case date = "date"
                case title = "title"
                case url = "url"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                date = try values.decodeIfPresent(String.self, forKey: .date)
                title = try values.decodeIfPresent(String.self, forKey: .title)
                url = try values.decodeIfPresent(String.self, forKey: .url)
        }

}
