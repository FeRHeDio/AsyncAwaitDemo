//
//  DogDataVM.swift
//  AsyncAwaitDemo
//
//  Created by Fernando Putallaz on 07/11/2023.
//

import Foundation
import SwiftUI

class DogDataVM {
  func fetchDogImageWithAsyncAwait() async throws -> UIImage {
    guard let jsonURL = URL(string: "https://random.dog/woof.json") else { throw DogImageError.invalidURL }
    
    let (jsonData, response) = try await URLSession.shared.data(from: jsonURL)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw DogImageError.invalidResponse }
    
    let dogPhotoResponse = try JSONDecoder().decode(DogPhoto.self, from: jsonData)
    guard let imageURL = URL(string: dogPhotoResponse.url) else { throw DogImageError.invalidURL }

    let (imageData, imageResponse) = try await URLSession.shared.data(from: imageURL)
    
    guard (imageResponse as? HTTPURLResponse)?.statusCode == 200 else { throw DogImageError.invalidResponse }
    guard let image = UIImage(data: imageData) else { throw DogImageError.decodingError }
    
    return image
  }
}

enum DogImageError: Error {
    case invalidURL
    case networkError
    case invalidResponse
    case decodingError
    case imageDownloadError
}

struct DogPhoto: Decodable {
  let url: String
}
