import Foundation

enum RepositoryError: Error {
    case failedToParseJSON
    case noCachedResponse
    case networkRequestFailed
}
