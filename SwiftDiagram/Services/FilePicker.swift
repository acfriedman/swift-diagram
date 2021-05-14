//
//  FilePicker.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/3/21.
//

import Foundation
import AppKit

struct FilePicker {
    
    static var defaultFileManager: FileManager = {
        .default
    }()
    
    static func presentModal(completion: @escaping (Result<[URL], Error>) -> Void) {
        let openPanel = NSOpenPanel();

        openPanel.message = "Choose your directory or file"
        openPanel.prompt = "Choose"
        openPanel.allowedFileTypes = ["none", "swift"]
        openPanel.showsResizeIndicator    = true;
        openPanel.showsHiddenFiles        = false;
        openPanel.allowsMultipleSelection = true;
        openPanel.canChooseDirectories = true;

        if (openPanel.runModal() ==  NSApplication.ModalResponse.OK) {
            guard let url = openPanel.url else {
                completion(.failure(Error.failedToSerializeURL))
                return
            }
            
            guard url.hasDirectoryPath else {
                completion(.success([url]))
                return
            }
            completion(.success(allRecursiveFiles(at: url)))
        } else {
            completion(.failure(Error.userDidSelectCancel))
        }
    }
    
    
    private static func allRecursiveFiles(at directory: URL) -> [URL] {
        var files = [URL]()
        if let enumerator = defaultFileManager.enumerator(at: directory,
                                                           includingPropertiesForKeys: [.isRegularFileKey],
                                                           options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                } catch {
                    print(error, fileURL)
                }
            }
        }
        return files
    }
    
    private static func allSubUrlsAt(_ directory: URL) -> [URL] {
        guard let subPaths = defaultFileManager.subpaths(atPath: directory.path) else {
            return []
        }
        return subPaths.compactMap { directory.absoluteURL.appendingPathComponent($0) }
    }
}

extension FilePicker {
    enum Error: Swift.Error {
        case userDidSelectCancel
        case failedToSerializeURL
    }
}

extension FilePicker.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToSerializeURL:
            return "Could not get URL from selected file"
        case .userDidSelectCancel:
            return "User selected to close the file picker."
        }
    }
}
