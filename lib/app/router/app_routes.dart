abstract final class AppRoutes {
  static const root = '/';
  static const login = '/login';
  static const register = '/register';
  static const customerHome = '/home';
  static const customerOrders = '/orders';
  static const customerMessages = '/chat';
  static const customerProfile = '/profile';
  static const customerCreateOrder = '/order/new';
  static const customerOrderDetails = '/order/details/:id';
  static const customerOffers = '/order/:id/offers';
  static const customerReview = '/order/:id/review';
  static const technicianSendOffer = '/tech/order/:id/offer';

  static String orderDetails(String id) => '/order/details/$id';
  static String offers(String id) => '/order/$id/offers';
  static String review(String id) => '/order/$id/review';
  static String sendOffer(String id) => '/tech/order/$id/offer';

  static const technicianDashboard = '/tech';
  static const technicianOrders = '/tech/orders';
  static const technicianCalendar = '/tech/calendar';
  static const technicianEarnings = '/tech/earnings';
  static const technicianProfile = '/tech/profile';

  static const adminDashboard = '/admin';
  static const adminOrders = '/admin/orders';
  static const adminUsers = '/admin/technicians';
  static const adminAnalytics = '/admin/analytics';
  static const adminSettings = '/admin/settings';
}
