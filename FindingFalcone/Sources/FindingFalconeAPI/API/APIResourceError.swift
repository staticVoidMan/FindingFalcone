enum APIResourceError: Error {
    case decodingFailedError(error: Error)
    case nilDataError(error: Error?)
}
