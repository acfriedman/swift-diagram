//
//  FilePicker.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/3/21.
//

import Foundation
import AppKit

struct FilePicker {
    
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
            completion(.success(allSubUrlsAt(url)))
        } else {
            completion(.failure(Error.userDidSelectCancel))
        }
    }
    
    
    private static func allSubUrlsAt(_ directory: URL) -> [URL] {
        let fileManager = FileManager.default
        guard let subPaths = fileManager.subpaths(atPath: directory.path) else {
            return []
        }
        
        var subUrls: [URL] = []
        for subPath in subPaths {
            subUrls += [directory.absoluteURL.appendingPathComponent(subPath)]
        }
        return subUrls
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
