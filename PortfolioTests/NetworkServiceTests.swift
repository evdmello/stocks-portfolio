import XCTest
@testable import Portfolio

final class NetworkServiceTests: XCTestCase {
    func test_fetch_whenSessionReturnsData_shouldReturnData() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com")!
        let dummyData = Data()
        let request = URLRequest(url: url)
        MockURLProtocol.mockResponses[url] = (data: dummyData, response: URLResponse(), error: nil)
        
        let expectation = self.expectation(description: "Data fetched")
        sut.sut.fetch(request: request) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, dummyData)
            case .failure:
                XCTFail("Expected data, but got an error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetch_whenSessionReturnsError_shouldReturnError() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com")!
        let dummyError = NSError(domain: "test", code: 0, userInfo: nil)
        let request = URLRequest(url: url)
        MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: dummyError)
        
        let expectation = self.expectation(description: "Data fetched")
        sut.sut.fetch(request: request) { result in
            switch result {
            case .success:
                XCTFail("Expected an error, but got data")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.systemError(dummyError).localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func test_fetch_whenSessionReturnsNoDataAndNoResponse_shouldReturnError() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Data fetched")
        sut.sut.fetch(request: request) { result in
            switch result {
            case .success:
                XCTFail("Expected an error, but got data")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidData.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func test_fetch_whenSessionReturnsData_shouldStoreDataInCache() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let dummyData = Data()
        MockURLProtocol.mockResponses[url] = (data: dummyData, response: URLResponse(), error: nil)
        
        let expectation = self.expectation(description: "Data fetched")
        sut.sut.fetch(request: request) { _ in
            XCTAssertNotNil(sut.cache.cachedResponse)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func test_fetch_whenSessionReturnsError_shouldNotStoreDataInCache() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let dummyError = NSError(domain: "test", code: 0, userInfo: nil)
        MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: dummyError)
        
        let expectation = self.expectation(description: "Data fetched")
        sut.sut.fetch(request: request) { _ in
            XCTAssertNil(sut.cache.cachedResponse)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func test_fetch_whenSessionReturnsNoDataAndNoResponse_shouldNotStoreDataInCache() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        MockURLProtocol.mockResponses[url] = (data: nil, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Data fetched")
        sut.sut.fetch(request: request) { _ in
            XCTAssertNil(sut.cache.cachedResponse)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    private func makeSUT() -> (sut: NetworkServiceImpl, session: URLSession, cache: URLCacheMock) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let cache = URLCacheMock()
        return (NetworkServiceImpl(session: session, cache: cache), session, cache)
    }
    
    final class MockURLProtocol: URLProtocol {
        static var mockResponses: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let url = request.url, let mockResponse = MockURLProtocol.mockResponses[url] {
                if let error = mockResponse.error {
                    client?.urlProtocol(self, didFailWithError: error)
                } else {
                    if let response = mockResponse.response {
                        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    }
                    if let data = mockResponse.data {
                        client?.urlProtocol(self, didLoad: data)
                    }
                    client?.urlProtocolDidFinishLoading(self)
                }
            }
        }
        
        override func stopLoading() {}
    }

    final class URLCacheMock: URLCache, @unchecked Sendable {
        var cachedResponse: CachedURLResponse?
        
        override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
            self.cachedResponse = cachedResponse
        }
    }
}
