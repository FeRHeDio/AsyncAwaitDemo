//
//  ContentView.swift
//  AsyncAwaitDemo
//
//  Created by Fernando Putallaz on 07/11/2023.
//

import SwiftUI

struct ContentView: View {
  var vm = DogDataVM()
  @State private var dogImage: UIImage?
  
  var body: some View {
    VStack {
      DogImageView(dogImage: dogImage)
      
      Button("fetch random dog image") {
        getADog()
      }
    }
  }
  
  func getADog() {
    
    Task {
      do {
        dogImage = try await vm.fetchDogImageWithAsyncAwait()
      } catch {
        print("error in the view with: \(error.localizedDescription)")
      }
    }
  }
}

struct DogImageView: View {
  let dogImage: UIImage?
  
  var body: some View {
    if let dogImage {
      Image(uiImage: dogImage)
        .resizable()
        .scaledToFit()
    }
  }
}


#Preview {
  ContentView()
}
