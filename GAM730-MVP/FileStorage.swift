//
//  FileStorage.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 23/09/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

let storage = Storage.storage()

class FileStorage {
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("error uploading image")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                
                print("we have uploaded image to firebase yay")
                completion(downloadUrl.absoluteString)
                
            }
            
        })
    }
    
    
    class func uploadImages(_ images: [UIImage?], completion: @escaping (_ imagelinks: [String]) -> Void) {
        
        var uploadImagesCount = 0
        var imageLinkArray : [String] = []
        var nameSuffix = 0
        
        for image in images {
            
            let fileDirectory = "UserImages/" + FirebaseUser.currentId() + "/" + "\(nameSuffix)" + ".jpg"
            
            uploadImage(image!, directory: fileDirectory) { (imageLink) in
                
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            
            nameSuffix += 1
        }
        

    
    }
    
    
    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        // 46
        
        let imageFileName = ((imageUrl.components(separatedBy: "_").last!).components(separatedBy: "?").first)!.components(separatedBy: "").first!
        
    
        if fileExistsAt(path: imageFileName) {
            print("we have local file")
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDiretory(filename: imageFileName)) {
                completion(contentsOfFile)
            } else {
                print("couldn't generate image from local image")
                completion(nil)
            }
            
        } else {
            
            //download aka...
            print("Downloading")
            
            if imageUrl != "" {
                
                let documentURL = URL(string: imageUrl)
                
                let downloadQueue = DispatchQueue(label: "downloadQueue")
                
                downloadQueue.async {
                    
                    let data = NSData(contentsOf: documentURL!)
                    
                    if data != nil {
                        let imageToReturn = UIImage(data: data! as Data)
                        
                        FileStorage.saveImagelocally(imageData: data!, fileName: imageFileName)
                        
                        completion(imageToReturn)
                    } else {
                        print("no image in database")
                        completion(nil)
                    }
                }
                
            } else {
                completion(nil)
            }
            
        }
        
    }
    
    
    
    
    class func downloadImages(imageUrls: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
        
        var imageArray: [UIImage] = []
        var downloadCounter  = 0
        
        for link in imageUrls {
            
            let url = NSURL(string: link)
            
            let downloadQueue = DispatchQueue(label: "downloadQueue")
            
            downloadQueue.async {
                
                downloadCounter += 1
                
                let data = NSData(contentsOf: url! as URL)
                
                if data != nil {
                   
                    imageArray.append(UIImage(data: data! as Data)!)
                    
                    if downloadCounter == imageArray.count {
                        
                        completion(imageArray)
                        
                    }
                    
                } else {
                    print("no image in database")
                    completion(imageArray)
                }
            }
        }
        
        
            
        }
        
    
    
    
    
    
    class func saveImagelocally(imageData: NSData, fileName: String) {
        
        var docURL = getDocumentsURL()
        
        docURL = docURL.appendingPathComponent(fileName, isDirectory: false)
        
        imageData.write(to: docURL, atomically: true)
        
    }
    
}


func getDocumentsURL() -> URL {
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    return documentURL!
}

func fileInDocumentsDiretory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    
    return fileURL.path
    
    
}

func fileExistsAt(path: String) -> Bool {
    
//    var doesExist = false
//
//    let filePath = fileInDocumentsDiretory(filename: path)
//
//    if FileManager.default.fileExists(atPath: filePath) {
//        doesExist = true
//    } else {
//        doesExist = false
//    }
//
//    return doesExist
    
    return FileManager.default.fileExists(atPath: fileInDocumentsDiretory(filename: path))
}
