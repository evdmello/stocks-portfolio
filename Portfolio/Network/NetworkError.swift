enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidJSON
    case systemError(Error)
}
