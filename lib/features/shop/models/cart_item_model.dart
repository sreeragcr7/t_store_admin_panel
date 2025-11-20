class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, String>? selectedVariation;

  CartItemModel({
    required this.productId,
    required this.quantity,
    this.variationId = '',
    this.image,
    this.price = 0.0,
    this.title = '',
    this.brandName,
    this.selectedVariation,
  });

  //Calculate Total amount
  String get totalAmount => (price * quantity).toStringAsFixed(2);

  //Empty Cart
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  //Convert to CartItem to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'Title': title,
      'Price': price,
      'Image': image,
      'Quantity': quantity,
      'VariationId': variationId,
      'BrandName': brandName,
      'SelectedVariation': selectedVariation,
    };
  }

  //Create a CartItem from a JSON Map
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
  print('🛒 Parsing cart item: $json');
  
  double price = 0.0;
  if (json.containsKey('Price')) { // Note: Capital 'P'
    final priceData = json['Price'];
    if (priceData is int) {
      price = priceData.toDouble();
    } else if (priceData is double) {
      price = priceData;
    } else if (priceData is String) {
      price = double.tryParse(priceData) ?? 0.0;
    }
    print('💵 Item Price: $price');
  }

  int quantity = json.containsKey('Quantity') ? json['Quantity'] as int : 1; // Note: Capital 'Q'
  print('🔢 Item Quantity: $quantity');

  // Parse selected variation
  Map<String, String>? selectedVariation;
  if (json.containsKey('SelectedVariation') && json['SelectedVariation'] is Map) { // Note: Capital 'S', capital 'V'
    selectedVariation = {};
    final variationMap = json['SelectedVariation'] as Map;
    variationMap.forEach((key, value) {
      if (value is String) {
        selectedVariation![key.toString()] = value;
      }
    });
    print('🎨 Selected Variation: $selectedVariation');
  }

  return CartItemModel(
    productId: json.containsKey('ProductId') ? json['ProductId'] as String : '', // Note: Capital 'P', capital 'I'
    title: json.containsKey('Title') ? json['Title'] as String : '', // Note: Capital 'T'
    price: price,
    quantity: quantity,
    image: json.containsKey('Image') ? json['Image'] as String? : null, // Note: Capital 'I'
    selectedVariation: selectedVariation,
    // Note: You have BrandName and VariationId in Firestore but not in CartItemModel
    // You might want to add these fields to your CartItemModel
  );
}

}
