import Foundation
import Alamofire

class makeStoryViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var storyResponse: StoryResponse?
    @Published var navigateToDetail = false

    func MakeStory(title: String, start: String) {
        self.isLoading = true
        self.navigateToDetail = false
        let url = "http://3.36.125.253:3000/story"
        let parameters: [String: Any] = [
            "title": title,
            "prompt": start
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            self.isLoading = false
            switch response.result {
            case .success(let data):
                print("응답 성공: \(data)")
                if let jsonData = data.data(using: .utf8) {
                    do {
                        let storyResponse = try JSONDecoder().decode(StoryResponse.self, from: jsonData)
                        self.storyResponse = storyResponse
                        self.navigateToDetail = true
                    } catch {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: jsonData)
                            print("Error: \(errorResponse.message)")
                        } catch {
                            print("Decoding error: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        print("Title: \(title), Start: \(start)")
    }
    
    func continueStory(id: Int, choiceIndex: Int) {
        self.isLoading = true
        let url = "http://3.36.125.253:3000/story/\(id)/continue/\(choiceIndex)"
        
        AF.request(url, method: .post).responseString { response in
            self.isLoading = false
            switch response.result {
            case .success(let data):
                print("응답 성공: \(data)")
                if let jsonData = data.data(using: .utf8) {
                    do {
                        let storyResponse = try JSONDecoder().decode(StoryResponse.self, from: jsonData)
                        self.storyResponse = storyResponse
                    } catch {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: jsonData)
                            print("Error: \(errorResponse.message)")
                        } catch {
                            print("Decoding error: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

struct StoryResponse: Codable {
    let title: String?
    let content: String
    let choices: [String]
    let imageUrl: String?
    let id: Int
    let continuationCount: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case choices
        case imageUrl
        case id
        case continuationCount
    }
}

struct ErrorResponse: Codable {
    let statusCode: Int
    let message: String
}
