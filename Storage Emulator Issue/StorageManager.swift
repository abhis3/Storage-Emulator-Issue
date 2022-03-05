//
//  StorageManager.swift
//  Storage Emulator Issue
//
//  Created by Stewart Lynch on 2021-10-20.
//


import SwiftUI
import Firebase

class StorageManager: ObservableObject {
    let storage = Storage.storage()
    func upload(image: UIImage, for uid: String, named name: String) {
        let storageRef = storage.reference().child("\(uid)//\(name).jpg")
        let resizedImage = image.aspectFittedToHeight(200)
        let data = resizedImage.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        metadata.contentDisposition = "initialCommit";
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let url = url {
                                print(url.absoluteString)
                            }
                            print("vvv putData metadata vvv")
                            print(metadata ?? "Default Metadata")
                            print("^^^^^^^^^^^^")
                        }
                    }
                }

            }
        }
    }
    
    func getMetadata(image: UIImage, for uid: String, named name: String) {
        let storageRef = storage.reference().child("\(uid)//\(name).jpg")
        storageRef.getMetadata { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("++++++++++++")
                print(metadata ?? "Default Metadata")
                print("++++++++++++")
            }
            
        }
    }
    
    func updateMetadata(image: UIImage, for uid: String, named name: String) {
        let storageRef = storage.reference().child("\(uid)//\(name).jpg")
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/png";
        newMetadata.cacheControl = "true";
        newMetadata.contentDisposition = "disposed";
        newMetadata.contentEncoding = "encoded";
        newMetadata.contentLanguage = "martian";
        newMetadata.customMetadata = ["hello": "world"];
        
        storageRef.updateMetadata(newMetadata) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("$$$$$$$$$$$$$$$$$")
                print(metadata ?? "Default Metadata")
                print(metadata?.contentType == "image/jpeg")
                print(metadata?.cacheControl == "true")
                print(metadata?.contentDisposition == "disposed")
                print(metadata?.contentEncoding == "encoded")
                print(metadata?.contentLanguage == "martian")
                print(metadata?.customMetadata == ["hello": "world"])
                print("$$$$$$$$$$$$$$$$$")
            }
            
        }
    }
    
    func getImage(for uid: String, named name: String, completion: @escaping (Result<URL, Error>) -> Void)  {
        let storageRef = storage.reference().child("\(uid)//\(name).jpg")
        storageRef.downloadURL { url, err in
            if err != nil {
                print((err?.localizedDescription)!)
                completion(.failure(err!))
            }
            if let url = url {
                completion(.success(url))
            }
        }
    }
}


extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
