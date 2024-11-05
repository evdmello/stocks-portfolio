import Foundation

protocol NetworkService {
    func fetch(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkServiceImpl: NetworkService {
    private let session: URLSession
    private let cache: URLCache
    
    init(session: URLSession = .shared, cache: URLCache = .shared) {
        self.session = session
        self.cache = cache
    }
    
    func fetch(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error = error {
                completion(.failure(.systemError(error)))
                return
            }
            guard let data, let response else {
                completion(.failure(.invalidData))
                return
            }
            self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
            completion(.success(data))
        }
        .resume()
    }
}
