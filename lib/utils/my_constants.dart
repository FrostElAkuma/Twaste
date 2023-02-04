class MyConstants {
  static const String APP_NAME = "Twaste";
  static const int APP_VERSION = 1;

  //10.0.2.2:8000 127.0.0.1:8000 mvs.bslmeiyu.com ngrok http 127.0.0.1:8000
  //Since I am developing on android. When trying on IOS make sure that everything thing is ok. I need to add some specific code for IOS later
  static const String BASE_URL = "https://71e7-2-49-199-148.in.ngrok.io";
  static const String POPULAR_PRODUCT_URI = "/api/v1/products/popular";
  static const String RECOMMENDED_PRODUCT_URI = "/api/v1/products/recommended";
  //static const String DRINKS_URI = "/api/v1/products/drinks";
  static const String UPLOAD_URL = "/uploads/";

  //restaurant info
  static const String RESTAURANT_INFO_URI = "/api/v1/restaurant/info";

  //user auth end points
  static const String REGISTRATION_URI = "/api/v1/auth/register";
  static const String LOGIN_URI = "/api/v1/auth/login";
  static const String USER_INFO_URI = "/api/v1/customer/info";
  //location
  static const String USER_ADDRESS = "user_address";
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';
  static const String ADD_USER_ADDRESS = "/api/v1/customer/address/add";
  static const String ADDRESS_LIST_URI = "/api/v1/customer/address/list";

  static const String ZONE_URI = "/api/v1/config/get-zone-id";

  static const String SEARCH_LOCATION_URI =
      "/api/v1/config/place-api-autocomplete";
  //End point for when we chose a place from thje search
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-details';

  //Orders
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';

  static const String TOKEN = "";
  static const String PHONE = "";
  static const String PASSWORD = "";
  static const String CART_LIST = "cart-list";
  static const String CART_HISTORY_LIST = "cart-history-list";

  //Googel api key AIzaSyD-qjHDwSanKXTEiua0tHl2fV1dLcKqB-o

  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
}
