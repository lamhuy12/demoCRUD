class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});


  //lấy dữ liệu từ database trả ra map qua object
  factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
    id: json['id'],
    name: json['name'],
  );

  //chuyển sang dạng json để đưa vào db theo dạng key - value
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}