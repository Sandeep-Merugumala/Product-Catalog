// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Data Models
// ─────────────────────────────────────────────────────────────────────────────

enum MessageSender { user, bot }

enum NavigationAction {
  // Bottom nav tabs
  goHome,
  goFwd,
  goLuxe,
  goBag,
  goProfile,
  // Pushed pages
  goMen,
  goWomen,
  goKids,
  goWishlist,
  goOrders,
  goNotifications,
  goCheckout,
  goAddresses,
  goAccountDetails,
}

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime time;
  final NavigationAction? navigationAction;
  final String? navigationLabel;

  ChatMessage({
    required this.text,
    required this.sender,
    this.navigationAction,
    this.navigationLabel,
  }) : time = DateTime.now();
}

class ChatResponse {
  final String text;
  final NavigationAction? navigationAction;
  final String? navigationLabel;

  const ChatResponse({
    required this.text,
    this.navigationAction,
    this.navigationLabel,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Navigation Info Helper
// ─────────────────────────────────────────────────────────────────────────────

class NavigationInfo {
  final String label;
  final IconData icon;

  const NavigationInfo({required this.label, required this.icon});

  static NavigationInfo forAction(NavigationAction action) {
    switch (action) {
      case NavigationAction.goHome:
        return const NavigationInfo(label: 'Home', icon: Icons.home);
      case NavigationAction.goFwd:
        return const NavigationInfo(label: 'Fwd – Festival Deals', icon: Icons.flash_on);
      case NavigationAction.goLuxe:
        return const NavigationInfo(label: 'Luxe Studio', icon: Icons.diamond);
      case NavigationAction.goBag:
        return const NavigationInfo(label: 'My Shopping Bag', icon: Icons.shopping_bag);
      case NavigationAction.goProfile:
        return const NavigationInfo(label: 'My Profile', icon: Icons.person);
      case NavigationAction.goMen:
        return const NavigationInfo(label: "Men's Fashion", icon: Icons.man);
      case NavigationAction.goWomen:
        return const NavigationInfo(label: "Women's Fashion", icon: Icons.woman);
      case NavigationAction.goKids:
        return const NavigationInfo(label: 'Kids Fashion', icon: Icons.child_care);
      case NavigationAction.goWishlist:
        return const NavigationInfo(label: 'My Wishlist', icon: Icons.favorite);
      case NavigationAction.goOrders:
        return const NavigationInfo(label: 'My Orders', icon: Icons.receipt_long);
      case NavigationAction.goNotifications:
        return const NavigationInfo(label: 'Notifications', icon: Icons.notifications);
      case NavigationAction.goCheckout:
        return const NavigationInfo(label: 'Checkout', icon: Icons.payment);
      case NavigationAction.goAddresses:
        return const NavigationInfo(label: 'My Addresses', icon: Icons.location_on);
      case NavigationAction.goAccountDetails:
        return const NavigationInfo(label: 'Account Details', icon: Icons.manage_accounts);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Chatbot Service – Rule-Based Intent Engine
// ─────────────────────────────────────────────────────────────────────────────

class ChatbotService {
  // Singleton
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  int _messageCount = 0;

  ChatResponse respond(String rawInput) {
    _messageCount++;
    final input = rawInput.toLowerCase().trim();

    // ── Navigation Intents ──────────────────────────────────────────────────

    // Shopping Bag / Cart — SPECIFIC phrases only so 'bag' in 'handbag' / 'sling bag' doesn't match
    if (_matches(input, [
      'my bag', 'shopping bag', 'view bag', 'open bag', 'go to bag',
      'my cart', 'view cart', 'open cart', 'shopping cart', 'go to cart',
    ])) {
      return const ChatResponse(
        text: "Sure! Let me take you to your Shopping Bag.",
        navigationAction: NavigationAction.goBag,
      );
    }

    // Profile / Account
    if (_matches(input, [
      'my profile', 'go to profile', 'open profile', 'my account',
      'go to account', 'user profile', 'view profile',
    ])) {
      return const ChatResponse(
        text: "Taking you to your Profile page.",
        navigationAction: NavigationAction.goProfile,
      );
    }

    // Home
    if (_matches(input, [
      'go home', 'go to home', 'main page', 'main screen',
      'homepage', 'home page', 'back to home',
    ])) {
      return const ChatResponse(
        text: "Navigating you back to the Home page.",
        navigationAction: NavigationAction.goHome,
      );
    }

    // Fwd / Festival
    if (_matches(input, [
      'fwd', 'festival', 'ugadi', 'pongal', 'festive wear',
      'festival sale', 'festival deals', 'flash deals', 'flash sale',
    ])) {
      return const ChatResponse(
        text: "Great choice! Taking you to FWD — our exclusive festival deals page.",
        navigationAction: NavigationAction.goFwd,
      );
    }

    // Luxe
    if (_matches(input, [
      'luxe', 'luxe studio', 'style game', 'fashion game', 'premium fashion',
    ])) {
      return const ChatResponse(
        text: "Opening Luxe Studio — your premium fashion styling experience.",
        navigationAction: NavigationAction.goLuxe,
      );
    }

    // NOTE: Women MUST be checked before Men to prevent 'men' matching inside 'women'
    // Women
    if (_matchesWord(input, [
      'women', "women's", 'womenswear', 'ladies', 'female', 'womens',
      'women section', 'women clothing', 'women fashion',
      'girls section', 'ladies section',
    ])) {
      return const ChatResponse(
        text: "Taking you to the Women's Fashion section.",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // Men
    if (_matchesWord(input, [
      'men', "men's", 'menswear', 'gents', 'male', 'mens section',
      'men section', 'men clothing', 'men fashion', 'gents section',
    ])) {
      return const ChatResponse(
        text: "Taking you to the Men's Fashion section.",
        navigationAction: NavigationAction.goMen,
      );
    }

    // Kids
    if (_matches(input, [
      'kids', 'children', 'child', 'kids section', 'kids fashion',
      'boys and girls', 'infants', 'toddler', 'baby clothes',
    ])) {
      return const ChatResponse(
        text: "Opening the Kids Fashion section for you.",
        navigationAction: NavigationAction.goKids,
      );
    }

    // Wishlist
    if (_matches(input, [
      'wishlist', 'wish list', 'saved items', 'liked items',
      'my wishlist', 'go to wishlist', 'view wishlist',
    ])) {
      return const ChatResponse(
        text: "Opening your Wishlist — all your saved styles in one place.",
        navigationAction: NavigationAction.goWishlist,
      );
    }

    // Orders
    if (_matches(input, [
      'my orders', 'order status', 'track order', 'track my order',
      'order history', 'past orders', 'purchase history', 'where is my order',
      'my purchases',
    ])) {
      return const ChatResponse(
        text: "Pulling up your Orders right away.",
        navigationAction: NavigationAction.goOrders,
      );
    }

    // Notifications
    if (_matches(input, [
      'notifications', 'my alerts', 'my notifications',
      'go to notifications', 'view notifications',
    ])) {
      return const ChatResponse(
        text: "Opening your Notifications.",
        navigationAction: NavigationAction.goNotifications,
      );
    }

    // Checkout
    if (_matches(input, [
      'checkout', 'proceed to checkout', 'complete purchase',
      'place order', 'buy now', 'proceed to pay',
    ])) {
      return const ChatResponse(
        text: "Taking you to Checkout to complete your purchase.",
        navigationAction: NavigationAction.goCheckout,
      );
    }

    // Addresses
    if (_matches(input, [
      'my address', 'my addresses', 'delivery address', 'shipping address',
      'add address', 'saved address', 'manage address',
    ])) {
      return const ChatResponse(
        text: "Opening your Saved Addresses.",
        navigationAction: NavigationAction.goAddresses,
      );
    }

    // Account Details
    if (_matches(input, [
      'account details', 'edit profile', 'update profile', 'change name',
      'change email', 'personal details', 'my details', 'edit account',
    ])) {
      return const ChatResponse(
        text: "Opening your Account Details.",
        navigationAction: NavigationAction.goAccountDetails,
      );
    }

    // ── Fashion Accessories (bags as fashion, wallets as fashion) ───────────
    // IMPORTANT: check these BEFORE the payment/shopping-bag intents to avoid
    // 'wallet' or 'bag' accidentally routing to checkout/payment.

    if (_matches(input, [
      // Bags & purses (fashion)
      'handbag', 'hand bag', 'sling bag', 'shoulder bag', 'tote bag',
      'backpack', 'crossbody', 'clutch bag', 'belt bag', 'denim bag',
      'leather bag', 'mini bag', 'bucket bag', 'hobo bag', 'chain bag',
      'fanny pack', 'bum bag', 'messenger bag', 'laptop bag',
      // Wallets & small leather goods (fashion)
      'wallet', 'purse', 'cardholder', 'card holder', 'card wallet',
      'coin pouch', 'key pouch',
      // Jewellery
      'jewellery', 'jewelry', 'necklace', 'earrings', 'bracelet',
      'ring', 'anklet', 'bangle', 'pendant',
      // Eyewear
      'sunglasses', 'sunnies', 'eyewear', 'spectacles',
      // Belts, scarves
      'belt', 'scarves', 'scarf', 'stole', 'dupatta',
      // Watches
      'watch', 'watches', 'wristwatch',
      // General
      'accessories', 'accessory',
    ])) {
      return const ChatResponse(
        text: "StyleHub has a fantastic range of fashion accessories!\n\n"
            "  • Bags & Purses — Handbags, Sling Bags, Totes, Clutches\n"
            "  • Wallets & Card Holders\n"
            "  • Jewellery — Necklaces, Earrings, Bracelets\n"
            "  • Watches, Sunglasses, Belts, Scarves\n\n"
            "Browse the Accessories tab in the Men's or Women's section to explore the full collection.",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // ── Product & Category FAQ ──────────────────────────────────────────────

    // Skincare / Beauty / Grooming
    if (_matches(input, [
      'skincare', 'skin care', 'skin products', 'beauty products',
      'grooming', 'moisturizer', 'face wash', 'serum', 'sunscreen',
      'cosmetics', 'makeup', 'lip balm', 'toner', 'cleanser',
      'are skincare products', 'beauty available',
    ])) {
      return const ChatResponse(
        text: "Yes, StyleHub carries a curated range of skincare and beauty products!\n\n"
            "  • Women's section → Beauty tab: Skincare, Makeup, and more\n"
            "  • Men's section → Grooming tab: Face wash, moisturizers\n\n"
            "Tap below to explore the Beauty collection.",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // Ethnic / Festive wear
    if (_matches(input, [
      'ethnic', 'ethnic wear', 'kurta', 'salwar', 'lehenga',
      'saree', 'sherwani', 'dhoti', 'traditional wear',
      'festive collection', 'wedding wear', 'occasion wear',
    ])) {
      return const ChatResponse(
        text: "StyleHub has a rich ethnic and festive collection!\n\n"
            "  • Lehengas, Sarees, Salwar Suits for women\n"
            "  • Sherwanis, Kurtas, Dhoti Sets for men\n"
            "  • Festival specials with exclusive discounts on the FWD page\n\n"
            "Check out our Festival Deals for special offers!",
        navigationAction: NavigationAction.goFwd,
      );
    }

    // Topwear / Bottomwear / Footwear / Clothing
    if (_matches(input, [
      'topwear', 'tops', 't-shirt', 'tshirt', 'shirt', 'blouse', 'dress',
      'bottomwear', 'jeans', 'trousers', 'leggings', 'pants', 'shorts', 'skirt',
      'footwear', 'shoes', 'sandals', 'heels', 'sneakers', 'boots', 'slippers', 'flats',
      'clothing', 'clothes', 'apparel', 'outfit', 'fashion',
    ])) {
      return ChatResponse(
        text: "StyleHub offers a wide variety of fashion for everyone!\n\n"
            "  • Topwear — T-Shirts, Shirts, Blouses, Dresses, Kurtas\n"
            "  • Bottomwear — Jeans, Trousers, Leggings, Shorts, Skirts\n"
            "  • Footwear — Sneakers, Heels, Sandals, Boots, Slippers\n\n"
            "Which category would you like to explore?",
        navigationAction: _messageCount % 2 == 0
            ? NavigationAction.goWomen
            : NavigationAction.goMen,
      );
    }

    // What's available / Product range
    if (_matches(input, [
      'what products', 'what do you sell', 'what can i buy',
      'product range', 'what is available', 'what all', 'what items',
      'do you have', 'do you sell', 'available here',
    ])) {
      return const ChatResponse(
        text: "StyleHub offers a wide range of fashion and lifestyle products:\n\n"
            "  • Men's Fashion — Topwear, Bottomwear, Footwear, Accessories, Grooming\n"
            "  • Women's Fashion — Topwear, Bottomwear, Footwear, Accessories, Beauty\n"
            "  • Kids Fashion — Clothing for all ages\n"
            "  • Festival Collection — Ethnic and festive specials\n"
            "  • Luxe Studio — Premium curated fashion\n"
            "  • Accessories — Bags, Jewellery, Watches, Sunglasses & more\n\n"
            "Start exploring from the Home page!",
        navigationAction: NavigationAction.goHome,
      );
    }

    // ── FAQ Intents ─────────────────────────────────────────────────────────

    // Shipping / Delivery
    if (_matches(input, [
      'shipping', 'delivery', 'deliver', 'how long', 'when will i get',
      'shipping time', 'delivery time', 'fast delivery', 'express delivery',
      'free shipping', 'delivery charges',
    ])) {
      return const ChatResponse(
        text: "Delivery Information:\n\n"
            "  • Standard delivery: 4–7 business days\n"
            "  • Express delivery: 1–2 business days (extra charges apply)\n"
            "  • Free shipping on orders above ₹799\n\n"
            "You can track your order in real-time from the Orders section.",
        navigationAction: NavigationAction.goOrders,
      );
    }

    // Returns & Exchange
    if (_matches(input, [
      'return', 'returns', 'exchange', 'refund', 'replace',
      'send back', 'return policy', 'how to return', 'cancel order',
      'cancellation',
    ])) {
      return const ChatResponse(
        text: "Return & Exchange Policy:\n\n"
            "  • Easy 30-day returns on most items\n"
            "  • Items must be unworn with original tags\n"
            "  • Refunds processed within 5–7 business days\n\n"
            "To initiate a return, go to My Orders and select the item.",
        navigationAction: NavigationAction.goOrders,
      );
    }

    // Payment methods — SPECIFIC keywords only; 'wallet' alone goes to accessories
    if (_matches(input, [
      'payment methods', 'payment options', 'how to pay', 'pay with',
      'upi', 'credit card', 'debit card', 'net banking',
      'cash on delivery', 'cod', 'paytm', 'gpay', 'phonepe',
      'emi', 'installment', 'pay online', 'stylehub wallet',
      'accepted payments', 'payment mode',
    ])) {
      return const ChatResponse(
        text: "Payment Methods We Accept:\n\n"
            "  • UPI — GPay, PhonePe, Paytm\n"
            "  • Credit & Debit Cards — Visa, Mastercard, RuPay\n"
            "  • Net Banking\n"
            "  • Cash on Delivery (COD)\n"
            "  • StyleHub Wallet\n"
            "  • EMI available on select cards\n\n"
            "All transactions are 100% secure. Proceed to your bag to pay.",
        navigationAction: NavigationAction.goBag,
      );
    }

    // Size Guide
    if (_matches(input, [
      'size guide', 'size chart', 'which size', 'size help',
      'what size', 'size measurement', 'fit guide', 's m l xl',
      'small medium large', 'measurements',
    ])) {
      return const ChatResponse(
        text: "Size Guidance:\n\n"
            "  • Each product page has a detailed Size Chart\n"
            "  • Sizes range from XS to 5XL for most categories\n"
            "  • Between sizes? We recommend going one size up\n"
            "  • Kids' sizes are age-based: 0–12 years\n\n"
            "Browse any section and open a product to view its exact size chart.",
        navigationAction: NavigationAction.goHome,
      );
    }

    // Coupons / Offers / Discounts
    if (_matches(input, [
      'coupon', 'coupons', 'offer', 'offers', 'discount', 'promo code',
      'deals', 'sale', 'savings', 'voucher', 'promo',
    ])) {
      return const ChatResponse(
        text: "Current Offers & Coupons:\n\n"
            "  • UGADI15 — Extra 15% off on ethnic wear\n"
            "  • FIRST10 — 10% off on your first order\n"
            "  • INSIDER20 — 20% off for Insider members\n"
            "  • FREESHIP — Free shipping on any order\n\n"
            "Visit the FWD page for more exclusive flash deals!",
        navigationAction: NavigationAction.goFwd,
      );
    }

    // Login / Sign up
    if (_matches(input, [
      'login', 'log in', 'sign in', 'sign up', 'register',
      'create account', 'logout', 'log out', 'sign out',
    ])) {
      return const ChatResponse(
        text: "Account Access:\n\n"
            "  • Log in using Google or Email & Password\n"
            "  • New to StyleHub? Sign up takes under a minute\n"
            "  • To log out, go to Profile → scroll down → tap Log Out\n\n"
            "Head to your Profile to manage your account.",
        navigationAction: NavigationAction.goProfile,
      );
    }

    // How to save to wishlist
    if (_matches(input, [
      'how to wishlist', 'how to save', 'save product', 'heart icon',
      'save for later', 'add to wishlist', 'favourite a product',
    ])) {
      return const ChatResponse(
        text: "How to Save to Wishlist:\n\n"
            "  1. Open any product page\n"
            "  2. Tap the ♡ heart icon\n"
            "  3. It's saved to your Wishlist instantly\n\n"
            "View all saved styles in your Wishlist anytime.",
        navigationAction: NavigationAction.goWishlist,
      );
    }

    // How to add to bag
    if (_matches(input, [
      'how to add to bag', 'add to bag', 'how to add to cart',
      'how to buy', 'how to shop', 'how to purchase', 'add product to bag',
    ])) {
      return const ChatResponse(
        text: "How to Add a Product to Your Bag:\n\n"
            "  1. Browse any category — Men, Women, or Kids\n"
            "  2. Tap a product to open its details\n"
            "  3. Select your size and tap Add to Bag\n"
            "  4. Go to your Shopping Bag to checkout\n\n"
            "Happy shopping!",
        navigationAction: NavigationAction.goBag,
      );
    }

    // About StyleHub
    if (_matches(input, [
      'about', 'what is this app', 'what is stylehub', 'about app',
      'about stylehub', 'aura', 'tell me about',
    ])) {
      return const ChatResponse(
        text: "About StyleHub:\n\n"
            "StyleHub is your all-in-one premium fashion destination.\n\n"
            "  • Thousands of curated fashion products\n"
            "  • Dedicated sections for Men, Women & Kids\n"
            "  • Festival specials on FWD\n"
            "  • Luxury curation in Luxe Studio\n"
            "  • Secure payments & easy 30-day returns\n\n"
            "Elevate Your Style with StyleHub.",
        navigationAction: NavigationAction.goHome,
      );
    }

    // Help / Support
    if (_matches(input, [
      'help', 'support', 'customer care', 'customer service',
      'contact', 'contact us', 'issue', 'problem', 'complaint',
    ])) {
      return const ChatResponse(
        text: "Here's what I can help you with:\n\n"
            "  • Track your order — say 'track my order'\n"
            "  • Return an item — say 'how to return'\n"
            "  • Payment options — say 'payment methods'\n"
            "  • Size guidance — say 'size guide'\n"
            "  • Offers & coupons — say 'show deals'\n"
            "  • Fashion accessories — say 'show handbags'\n"
            "  • Navigate anywhere — say 'take me to Women's section'\n\n"
            "What can I help you with?",
        navigationAction: NavigationAction.goProfile,
      );
    }

    // ── NEW: Makeup & Colour Cosmetics ──────────────────────────────────────
    if (_matches(input, [
      // Lips
      'lipstick', 'lip gloss', 'lip liner', 'lip tint', 'lip plumper',
      'lip colour', 'lip color', 'lip kit', 'matte lip', 'nude lip',
      // Face makeup
      'foundation', 'concealer', 'bb cream', 'cc cream', 'primer',
      'setting spray', 'setting powder', 'loose powder', 'compact',
      'contour', 'contouring', 'bronzer', 'highlighter', 'blush',
      // Eyes
      'mascara', 'eyeliner', 'kajal', 'kohl', 'eyeshadow', 'eye shadow',
      'eye palette', 'eye liner', 'brow pencil', 'eyebrow',
      // General
      'makeup', 'colour cosmetics', 'color cosmetics',
    ])) {
      return const ChatResponse(
        text: "StyleHub has a gorgeous makeup collection! 💄\n\n"
            "  • Lips — Lipsticks, Lip Gloss, Lip Liners, Lip Tints\n"
            "  • Face — Foundation, Concealer, Blush, Highlighter, Bronzer\n"
            "  • Eyes — Mascara, Kajal, Eyeliner, Eyeshadow Palettes\n"
            "  • Setting & Primer — For all-day wear\n\n"
            "Explore the full Beauty collection in the Women's section!",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // ── NEW: Haircare ────────────────────────────────────────────────────────
    if (_matches(input, [
      'shampoo', 'conditioner', 'hair mask', 'hair oil', 'hair serum',
      'dry shampoo', 'hair color', 'hair dye', 'hair care', 'haircare',
      'hair treatment', 'scalp', 'dandruff', 'frizz', 'hair fall',
      'hair growth', 'heat protectant', 'leave in', 'hair spray',
    ])) {
      return const ChatResponse(
        text: "StyleHub's haircare range has you covered! 💇\n\n"
            "  • Shampoos & Conditioners — for all hair types\n"
            "  • Hair Oils & Serums — nourishment and shine\n"
            "  • Hair Masks & Treatments — deep care\n"
            "  • Hair Colour — home colouring kits\n\n"
            "Find haircare products under the Beauty tab in the Women's section.",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // ── NEW: Fragrance & Perfume ─────────────────────────────────────────────
    if (_matches(input, [
      'perfume', 'fragrance', 'cologne', 'deodorant', 'body spray',
      'attar', 'oud', 'eau de parfum', 'eau de toilette', 'edt', 'edp',
      'roll on', 'body mist', 'scent', 'smell good',
    ])) {
      return const ChatResponse(
        text: "Discover StyleHub's Fragrance collection! 🌸\n\n"
            "  • Perfumes & Eau de Parfum — long-lasting luxury scents\n"
            "  • Eau de Toilette — light and fresh\n"
            "  • Deodorants & Body Sprays — everyday freshness\n"
            "  • Attar & Oud — traditional Indian fragrances\n\n"
            "Find fragrances for both Men and Women in their respective sections.",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // ── NEW: Nail Care ───────────────────────────────────────────────────────
    if (_matches(input, [
      'nail polish', 'nail color', 'nail colour', 'nail art', 'nail care',
      'nail paint', 'nail gel', 'manicure', 'pedicure', 'nail kit',
      'nail remover', 'nail file',
    ])) {
      return const ChatResponse(
        text: "StyleHub has a lovely range of nail products! 💅\n\n"
            "  • Nail Polishes — Matte, Glossy, Glitter, Neons\n"
            "  • Nail Art Kits — Stickers, Stamps, Tools\n"
            "  • Nail Care — Files, Cuticle oils, Removers\n"
            "  • Gel & Long-lasting Formulas\n\n"
            "Explore all nail products in the Women's Beauty section!",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // ── NEW: New Arrivals / Trending ─────────────────────────────────────────
    if (_matches(input, [
      'new arrivals', 'new collection', 'latest', 'new in',
      'trending', 'whats trending', "what's trending", 'popular',
      'best sellers', 'bestsellers', 'top picks', 'must have',
      'new launch', 'just arrived', 'recently added',
    ])) {
      return const ChatResponse(
        text: "Here's what's trending on StyleHub right now! 🔥\n\n"
            "  • New Arrivals — Fresh drops added daily\n"
            "  • Top Picks — Our curated bestsellers\n"
            "  • Festival Specials — Season's hottest ethnic wear\n"
            "  • Luxe Studio — Premium & exclusive styles\n\n"
            "Check FWD for flash deals on the latest trends!",
        navigationAction: NavigationAction.goFwd,
      );
    }

    // ── NEW: Gifting ─────────────────────────────────────────────────────────
    if (_matches(input, [
      'gift', 'gifting', 'gift idea', 'gift for', 'present',
      'birthday gift', 'anniversary gift', 'gift set', 'gift card',
      'gift him', 'gift her', 'gift for wife', 'gift for husband',
      'gift for girlfriend', 'gift for boyfriend', 'gift for mom',
      'gift for dad', 'festival gift', 'gift someone',
    ])) {
      return const ChatResponse(
        text: "Looking for the perfect gift? 🎁 StyleHub has you covered!\n\n"
            "  • For Her — Fashion, Accessories, Beauty, Jewellery\n"
            "  • For Him — Menswear, Grooming, Watches, Wallets\n"
            "  • For Kids — Cute outfits and accessories\n"
            "  • Luxury Gifts — Browse Luxe Studio for premium picks\n"
            "  • Festival Gifts — Ethnic wear and special sets on FWD\n\n"
            "Start building the perfect gift from our collections!",
        navigationAction: NavigationAction.goLuxe,
      );
    }

    // ── NEW: Budget / Affordable ─────────────────────────────────────────────
    if (_matches(input, [
      'affordable', 'budget', 'cheap', 'low price', 'under 500',
      'under 1000', 'under 2000', 'value for money', 'best price',
      'economical', 'pocket friendly', 'inexpensive',
    ])) {
      return const ChatResponse(
        text: "StyleHub has great styles for every budget! 💰\n\n"
            "  • Items starting from ₹199\n"
            "  • Sale section with up to 70% OFF\n"
            "  • Flash deals on FWD — limited time prices\n"
            "  • Use FIRST10 for extra 10% off your first order\n"
            "  • Free shipping on orders above ₹799\n\n"
            "Catch the best deals on the FWD page!",
        navigationAction: NavigationAction.goFwd,
      );
    }

    // ── NEW: Brand Queries ───────────────────────────────────────────────────
    if (_matches(input, [
      'nike', 'adidas', 'puma', 'zara', 'h&m', 'levis', "levi's",
      'forever 21', 'mango', 'only', 'vero moda', 'w brand', 'fabindia',
      'biba', 'global desi', 'uspa', 'us polo', 'tommy', 'peter england',
      'raymond', 'wrogn', 'hrx', 'roadster', 'being human', 'brands',
      'which brands', 'brand available', 'popular brands',
    ])) {
      return const ChatResponse(
        text: "StyleHub features 500+ top fashion brands! 🏷️\n\n"
            "  • Casual & Streetwear — Nike, Adidas, Puma, HRX, Wrogn\n"
            "  • Western Wear — Zara, H&M, Mango, Only, Vero Moda\n"
            "  • Ethnic — Biba, W, Fabindia, Global Desi\n"
            "  • Men's Formals — Raymond, Peter England, US Polo\n"
            "  • Premium — Tommy Hilfiger, Being Human\n\n"
            "Browse categories to filter by your favourite brand.",
        navigationAction: NavigationAction.goHome,
      );
    }

    // ── NEW: Styling Tips / Outfit Help ──────────────────────────────────────
    if (_matches(input, [
      'styling tips', 'style tips', 'how to style', 'outfit ideas',
      'what to wear', 'outfit advice', 'fashion tips', 'what goes with',
      'what matches', 'style advice', 'pair with', 'combine', 'coordinate',
      'what to wear with jeans', 'what to wear with dress',
    ])) {
      return const ChatResponse(
        text: "Here are some quick styling tips from StyleHub! ✨\n\n"
            "  • Shirt + Slim Chinos + Loafers = Smart Casual\n"
            "  • Kurta + Palazzo + Kolhapuris = Ethnic Chic\n"
            "  • Crop Top + High-waist Jeans + Sneakers = Streetwear\n"
            "  • Blazer + Dress + Block Heels = Office Glam\n"
            "  • Saree + Blouse + Statement Jewellery = Occasion Wear\n\n"
            "Explore Luxe Studio for curated outfit inspiration!",
        navigationAction: NavigationAction.goLuxe,
      );
    }

    // ── NEW: Men's Grooming ──────────────────────────────────────────────────
    if (_matches(input, [
      'beard', 'beard oil', 'beard trimmer', 'beard care', 'shaving',
      'shaving cream', 'razor', 'aftershave', 'face scrub', 'men grooming',
      'male grooming', 'men skincare', 'face moisturizer for men',
    ])) {
      return const ChatResponse(
        text: "StyleHub has a solid Men's Grooming range! 🧔\n\n"
            "  • Beard Care — Oils, Serums, Trimmers, Balms\n"
            "  • Shaving — Creams, Razors, Aftershave\n"
            "  • Skincare for Men — Face Wash, Moisturizer, Scrubs\n"
            "  • Deodorants & Fragrances\n\n"
            "Find everything under the Grooming tab in the Men's section.",
        navigationAction: NavigationAction.goMen,
      );
    }

    // ── NEW: Swimwear / Sportswear / Activewear ──────────────────────────────
    if (_matches(input, [
      'swimwear', 'swimsuit', 'bikini', 'swim trunks', 'beachwear',
      'sportswear', 'activewear', 'gym wear', 'workout clothes',
      'yoga pants', 'sports bra', 'track pants', 'joggers',
      'running shoes', 'gym shoes', 'athleisure',
    ])) {
      return const ChatResponse(
        text: "StyleHub has a great Activewear & Sportswear range! 🏋️\n\n"
            "  • Women's — Sports Bras, Yoga Pants, Joggers, Swimwear\n"
            "  • Men's — Track Pants, Gym Tees, Shorts, Swim Trunks\n"
            "  • Footwear — Running Shoes, Training Shoes\n\n"
            "Find all activewear in the Sport & Athleisure section.",
        navigationAction: NavigationAction.goWomen,
      );
    }

    // ── NEW: Notifications / App alerts ─────────────────────────────────────
    if (_matches(input, [
      'notify me', 'price drop', 'back in stock', 'restock',
      'out of stock', 'when available', 'stock alert', 'sale alert',
      'notify when', 'wish to be notified',
    ])) {
      return const ChatResponse(
        text: "Stay updated on StyleHub! 🔔\n\n"
            "  • Add items to your Wishlist to get notified on price drops\n"
            "  • Turn on app notifications for sale alerts\n"
            "  • Check Notifications for the latest restock updates\n\n"
            "View your current notifications here.",
        navigationAction: NavigationAction.goNotifications,
      );
    }

    // Greetings
    if (_matches(input, [

      'hi', 'hello', 'hey', 'hii', 'helo',
      'good morning', 'good afternoon', 'good evening',
      'howdy', 'sup', "what's up", 'whats up',
    ])) {
      final greetings = [
        "Hello! Welcome to StyleHub. I'm your personal fashion assistant. How may I help you today?",
        "Hi there! Great to have you here. Ask me about products, orders, or let me guide you anywhere in the app.",
        "Hello! I'm here to make your shopping experience seamless. What can I do for you?",
      ];
      return ChatResponse(
        text: greetings[_messageCount % greetings.length],
        navigationAction: NavigationAction.goHome,
      );
    }

    // Thanks
    if (_matches(input, [
      'thanks', 'thank you', 'thank', 'ty', 'thx',
      'awesome', 'great', 'perfect', 'cool', 'nice', 'good',
    ])) {
      return const ChatResponse(
        text: "You're most welcome! Happy to assist whenever you need. Enjoy shopping on StyleHub! 🛍️",
        navigationAction: NavigationAction.goHome,
      );
    }

    // ── Fallback ─────────────────────────────────────────────────────────────
    return const ChatResponse(
      text: "I'm not sure I understood that, but I'm happy to help!\n\n"
          "Try asking things like:\n"
          "  • 'Show me handbags' or 'I need sunglasses'\n"
          "  • 'Take me to Men's section'\n"
          "  • 'Track my order' or 'Return policy'\n"
          "  • 'What payment methods do you accept'\n"
          "  • 'Show me current offers'\n\n"
          "Start exploring from the Home page!",
      navigationAction: NavigationAction.goHome,
    );
  }

  // ── Helper: keyword matching (substring) ────────────────────────────────────
  bool _matches(String input, List<String> keywords) {
    for (final kw in keywords) {
      if (input.contains(kw)) return true;
    }
    return false;
  }

  // ── Helper: whole-word matching (prevents 'men' matching inside 'women') ───
  bool _matchesWord(String input, List<String> keywords) {
    for (final kw in keywords) {
      final pattern = RegExp(
        r'(^|[\s,!?.])' + RegExp.escape(kw) + r'($|[\s,!?.])',
      );
      if (pattern.hasMatch(input)) return true;
    }
    return false;
  }

  // ── Welcome message ─────────────────────────────────────────────────────────
  static ChatMessage welcomeMessage() {
    return ChatMessage(
      text: "Hello! I'm your StyleHub Assistant. Here's how I can help:\n\n"
          "  • Navigate to any section of the app\n"
          "  • Find bags, jewellery, and all accessories\n"
          "  • Track your orders\n"
          "  • Answer return, payment & delivery queries\n"
          "  • Find offers and coupons\n\n"
          "What would you like to do today?",
      sender: MessageSender.bot,
      navigationAction: NavigationAction.goHome,
    );
  }

  // ── Quick reply chips ────────────────────────────────────────────────────────
  static List<String> quickReplies() {
    return [
      "Track my order",
      "Return policy",
      "Show handbags",
      "Men's section",
      "Women's section",
      "Current offers",
    ];
  }
}
