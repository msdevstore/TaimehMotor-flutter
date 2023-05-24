class MotorCycleObject {
  final String id;
  final String frameNumber;
  final String productionYear;
  final String mainColor;
  final String status;
  final String featuredImage;
  MotorCycleObject(
      {this.id = '',
      this.frameNumber = '',
      this.productionYear = '',
      this.mainColor = '',
      this.status = '',
      this.featuredImage = ''});
}

class MotorInStoreObject {
  final String id;
  final String frameNumber;
  final String productionYear;
  final String mainColor;
  final String LastUpdate;
  final String status;
  final String featuredImage;
  final String rating;
  final String price;
  final String brand;
  final String loadCapacitor;
  final String type;
  final String EngineNumber;
  final String plate_number;
  final String location;
  bool like;
  bool cardAdded;
  MotorInStoreObject({
    this.like = false,
    this.cardAdded = false,
    this.loadCapacitor = '',
    this.brand = '',
    this.price = '',
    this.rating = '',
    this.id = '',
    this.frameNumber = '',
    this.productionYear = '',
    this.mainColor = '',
    this.LastUpdate = '',
    this.status = '',
    this.featuredImage = '',
    this.type = '',
    this.EngineNumber = '',
    this.plate_number = '',
    this.location = ''
  });
}

class MyMotorCycleObject {
  final String id;
  final String frameNumber;
  final String productionYear;
  final String mainColor;
  final String status;
  final String featuredImage;
  final String assignedDate;
  final String brand;
  final String price;
  final String rating;
  final String loadCapacitor;
  final String type;
  MyMotorCycleObject(
      {this.id = '',
      this.frameNumber = '',
      this.productionYear = '',
      this.mainColor = '',
      this.status = '',
      this.featuredImage = '',
      this.assignedDate = '',
      this.brand = '',
      this.price = '',
      this.rating = '',
      this.loadCapacitor = '',
      this.type = ''});
}

class ClickableMotorCycleObject {
  final String id;
  final String frameNumber;
  final String productionYear;
  final String mainColor;
  final String status;
  final String featuredImage;
  bool click;
  ClickableMotorCycleObject(
      {this.id = '',
      this.frameNumber = '',
      this.productionYear = '',
      this.mainColor = '',
      this.status = '',
      this.featuredImage = '',
      this.click = false});
}
