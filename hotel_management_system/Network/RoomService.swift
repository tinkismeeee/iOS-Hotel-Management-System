//
//  RoomService.swift
//  hotel_management_system
//
//  Created by mac on 16/3/26.
//

import Foundation
class RoomService {
    static func fetchRooms(completion: @escaping ([RoomModel]) -> Void) {
        guard let url = URL(string: "http://38.242.228.108:5000/api/rooms") else {
            completion([])
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API error:", error)
                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }
            do {
                let rooms = try JSONDecoder().decode([RoomModel].self, from: data)
                completion(rooms)
            }
            catch {
                print("Decode error:", error)
                completion([])
            }
        }.resume()
    }
}
