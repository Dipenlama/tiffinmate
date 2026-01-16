import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:tiffinmate/core/constants/hive_table_constant.dart';


part 'tiffin_booking_hive_model.g.dart'; // dart run build_runner build -d

@HiveType(typeId: HiveTableConstant.tiffinBookingTypeId)
class TiffinBookingHiveModel extends HiveObject {
  @HiveField(0)
  final String? bookingId;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final String tiffinType;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String? bookingStatus;

  TiffinBookingHiveModel({
    String? bookingId,
    required this.customerName,
    required this.tiffinType,
    required this.quantity,
    String? bookingStatus,
  })  : bookingId = bookingId ?? const Uuid().v4(),
        bookingStatus = bookingStatus ?? 'pending';

  // Convert Hive Model → Entity
  UserEntity toEntity() {
    return TiffinBookingEntity(
      bookingId: bookingId,
      customerName: customerName,
      tiffinType: tiffinType,
      quantity: quantity,
      bookingStatus: bookingStatus,
    );
  }

  // Convert Entity → Hive Model
  factory TiffinBookingHiveModel.fromEntity(
      TiffinBookingEntity entity) {
    return TiffinBookingHiveModel(
      bookingId: entity.bookingId,
      customerName: entity.customerName,
      tiffinType: entity.tiffinType,
      quantity: entity.quantity,
      bookingStatus: entity.bookingStatus,
    );
  }

  // Convert List of Models → List of Entities
  static List<TiffinBookingEntity> toEntityList(
      List<TiffinBookingHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
