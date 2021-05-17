//
//  DataProvider.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 16.05.2021.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView{
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL){
        image = nil
        if let task = task{
            task.cancel()
        }
        //если изображение закэшировано, то загружаем его из кэша
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let newImage = UIImage(data: data) else { return }
            //сохраняем изображение в кэш
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
    
    
    
    
    
    
    
    
//    var imageCache = NSCache<NSString, UIImage>()
//
//    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void){
//        //проверяем, существует ли изображение в кэше
//        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString){
//            completion(cachedImage)
//        } else{
//            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
//            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//                guard error == nil,
//                      data != nil,
//                      let response = response as? HTTPURLResponse,
//                      response.statusCode == 200,
//                      let self = self else { return }
//                guard let image = UIImage(data: data!) else { return }
//                //сохраняем изображение в кэш
//                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
//
//                DispatchQueue.main.async {
//                    completion(image)
//                }
//            } .resume()
//        }
//    }

