//
//  MainViewController.swift
//  ReleaseNotesGenerator
//
//  Created by Mihai Eros on 12.01.2023.
//

import Cocoa

final class MainViewController: NSViewController {
    
    /// Outlets
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var dragView: DragView!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupUI()
    }
    
    // MARK: - Delegates
    
    private func setupDelegates() {
        dragView.delegate = self
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        imageView.image =  Helper.imageOfDrop
    }
}

// MARK: - DragViewDelegate

extension MainViewController: DragViewDelegate {
    func didDragFileIntoView(_ fileURL: URL) {
        let fileManager = FileManager.default
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("[ERROR]: didDragFileIntoView ran into some error:\n File does not exist at path: \(fileURL.path)")
            return
        }
        
        do {
            let originalContents = try String(contentsOf: fileURL)
            let modifiedContentsAfterReplacingAsterix = originalContents.replaceAsterix()
            let modifiedContentsAfterReplacingByContents = modifiedContentsAfterReplacingAsterix.replaceByContents()
            let finalContents = modifiedContentsAfterReplacingByContents.replaceJiraCards()
            
            try finalContents.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch let error {
            print("[ERROR]: didDragFileIntoView ran into some error:\n\(error.localizedDescription)")
        }
    }
}
