//
//  FilePicker.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/3/21.
//

import Foundation
import AppKit

struct FilePicker {
    
    static func presentModal(completion: @escaping (Result<URL, Error>) -> Void) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            guard let url = dialog.url else {
                completion(.failure(Error.failedToSerializeURL))
                return
            }
            completion(.success(url))
        } else {
            completion(.failure(Error.userDidSelectCancel))
        }
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
