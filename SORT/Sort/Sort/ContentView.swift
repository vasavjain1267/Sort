//
//  ContentView.swift
//  sortrough
//
//  Created by Vasav Jain on 30/01/24.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import Foundation
struct ContentView: View {
    @State var selectedDirectory: URL?
    @State var isPopoverVisible: Bool = false
    //    var allowedContentTypes: [UTType]=[.png, .pdf, .jpeg]
    var body: some View {
        HStack{
            Spacer()
            VStack {
                //          Spacer()
                Button(action: {openDirectoryPicker()}, label: {
                    Image(systemName: "folder")
                        .resizable()
                        .frame(width:100, height:100)
                })
                Button("Select Directory") {
                    openDirectoryPicker()
                }
//                .padding()
                
                if let directory = selectedDirectory {
                    Text("Selected Directory: \(directory.path)")
                        .padding()
                        .font(.caption)
                    
                }
            }
            Spacer()
            Image(systemName: "arrow.right")
                .resizable()
                .padding(.bottom, 14.0)
                .frame(width:50, height:50)
            Spacer()
            VStack{
                Button(action: {organizeFiles(in: unwrap())
                                isPopoverVisible.toggle()
                }, label: {
                    Image(systemName: "plus.rectangle.on.folder")
                        .resizable()
                        .frame(width:100, height:100)
                })

                    
                
                Button("Organize Files in Directory") {
                        organizeFiles(in: unwrap())
                    isPopoverVisible.toggle()
                            }

                            .popover(isPresented: $isPopoverVisible, content: {
                                VStack {
                                    Text("New Sorted Directories Created ")
                                        .font(.headline)
//
                                }
                                .padding()
                            })
            }
            Spacer()
            
            
        }
        .padding(.vertical, 100.0)
        .frame(width: nil)
        
    }
    
    func unwrap() -> URL{
        
        if let directory = selectedDirectory {
            return directory
            
        }
        return URL (string: "/nul/")!
        
        
    }
    
    func openDirectoryPicker() {
        let openPanel = NSOpenPanel()
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.png, .pdf, .jpeg]
        openPanel.prompt = "Select"
        
        openPanel.begin { response in
            if response == .OK {
                guard let url = openPanel.url else { return }
                selectedDirectory = url
            }
        }
    }
    
    
    func organizeFiles(in directoryURL: URL) {
            let fileManager = FileManager.default

            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)

                for fileURL in fileURLs {
                    let fileExtension = fileURL.pathExtension.lowercased()

                    // Create directories based on file types
                    let targetDirectory = getCategoryDirectory(forExtension: fileExtension, in: directoryURL)

                    // Create directory if it doesn't exist
                    if !fileManager.fileExists(atPath: targetDirectory.path) {
                        try fileManager.createDirectory(at: targetDirectory,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                    }

                    // Move the file to the corresponding directory
                    let destinationURL = targetDirectory.appendingPathComponent(fileURL.lastPathComponent)
                    try fileManager.moveItem(at: fileURL, to: destinationURL)
                }

                print("Files organized successfully.")
            } catch {
                print("Error organizing files: \(error.localizedDescription)")
            }
        }

        func getCategoryDirectory(forExtension fileExtension: String, in baseDirectory: URL) -> URL {
            switch fileExtension {
            case "jpg", "jpeg", "png", "gif", "bmp","heic":
                return baseDirectory.appendingPathComponent("Images", isDirectory: true)
            case "mp4", "mov", "avi", "mkv","mp3":
                return baseDirectory.appendingPathComponent("Videos", isDirectory: true)
            case "wav", "aac", "flac":
                return baseDirectory.appendingPathComponent("Audio", isDirectory: true)
            case "css", "js", "cpp", "py", "html","swift":
                return baseDirectory.appendingPathComponent("Coding", isDirectory: true)
            case "pdf", "exe","docx","xlxs":
                return baseDirectory.appendingPathComponent("Docs", isDirectory: true)
            default:
                return baseDirectory.appendingPathComponent("Others", isDirectory: true)
            }
        }
    }

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
