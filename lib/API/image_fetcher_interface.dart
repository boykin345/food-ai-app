/// An abstract class defining the interface for fetching images related to a query.
abstract class ImageFetcherInterface {
  /// Fetches an image URL based on the provided [query].
  /// Returns a [Future] that resolves to a [String] containing the URL of the fetched image.
  Future<String> fetchImage(String query);
}
