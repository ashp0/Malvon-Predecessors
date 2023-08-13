//
//  Downloader.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-08.
//

import Cocoa

class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, path: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  path

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.progress.observe(\.fractionCompleted) { progress, _ in
                            print("progress: ", progress.fractionCompleted)
                        }
                        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            MyVariables.downloadProgress = Double(task.progress.fractionCompleted * 100)
                            MyVariables.downloadSize = Double(task.countOfBytesExpectedToReceive / 10)
                            //task.countOfBytesExpectedToReceive / 100
                           // MyVariables.downloadSpeed = "\(Double(task.fractionCompleted) / task.progress.countOfBytesExpectedToReceive * 100)"
                            let adsfdsf = Double(task.countOfBytesReceived) / task.progress.fractionCompleted
                            let start = Date.timeIntervalSinceReferenceDate
                            let asd: Double = Double(task.progress.fractionCompleted) / (Date.timeIntervalSinceReferenceDate - start)
//                            MyVariables.downloadSpeed = "\(asd * 100)"
                            print(task.countOfBytesReceived)
                        }
            task.resume()
            if task.progress.isFinished {
                timer.fire()
                MyVariables.isDone = true
            }
        }
    }
}

struct MyVariables {
    static var downloadProgress = Double(0)
    static var downloadSize = Double(0)
    static var isDone = false
}
