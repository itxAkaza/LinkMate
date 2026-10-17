//
//
// class AppUrl {
//
//
//   static const String dogBase = "https://api.thedogapi.com/v1";
//
//   // For Cats
//   static String catListUrl = '$catBase/images/search?limit=10&has_breeds=1&api_key=$apiKey';
//
//   // For Dogs
//   static String dogListUrl = '$dogBase/breeds?limit=10&page=0&api_key=$apiKey';
//
//   // ---  Search URLs  ---
//
//   // Search by Text
//   static String searchCat(String query) => '$catBase/breeds/search?q=$query&api_key=$apiKey';
//   static String searchDog(String query) => '$dogBase/breeds/search?q=$query&api_key=$apiKey';
//
//   /
// }