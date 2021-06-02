class ParkingLot {
  String name;
  String address;
  String description;
  String dueno;
  double score;
  String image;
  Map<String, double> price;
  List<List<Map<String, String>>> comments;

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  String getAddress() {
    return address;
  }

  void setAddress(String address) {
    this.address = address;
  }

  String getDescription() {
    return name;
  }

  void setDescription(String description) {
    this.description = description;
  }

  String getDueno() {
    return name;
  }

  void setDueno(String name) {
    this.name = name;
  }

  String getImage() {
    return image;
  }

  void setImage(String image) {
    this.image = image;
  }

  double getScore() {
    return score;
  }

  void setScore(double score) {
    this.score = score;
  }

  Map<String, double> getPrecio() {
    return price;
  }

  void setPrecio(Map<String, double> price) {
    this.price = price;
  }

  List<List<Map<String, String>>> getComments() {
    return comments;
  }

  void setComments(List<List<Map<String, String>>> comments) {
    this.comments = comments;
  }

  ParkingLot();

  //Other functions

}
