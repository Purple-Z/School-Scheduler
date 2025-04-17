class Booking {
  final int id;
  final DateTime start;
  final DateTime end;
  final int quantity;
  final String user_email;
  final String resource_name;
  final int status;
  final String place_name;
  final String activity_name;
  final String validator_email;
  final String invalidator_email;
  final bool is_resource_place;
  final bool is_resource_activity;

  Booking(this.id, this.start, this.end, this.quantity, this.user_email, this.resource_name, this.status, this.place_name, this.activity_name, this.validator_email, this.invalidator_email, this.is_resource_place, this.is_resource_activity);

  @override
  String toString() => (id.toString() + '+' + resource_name);
}