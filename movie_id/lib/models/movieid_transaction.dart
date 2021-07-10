part of 'models.dart';

class MovieidTransaction extends Equatable {
  // field yg dibutuhkan
  final String userID;
  final String title; //judul
  final String subtitle; //subjudul
  final int amount; // biaya dlm transaksi
  final DateTime time;
  final String picture; // picture dri film yg dibeli

  MovieidTransaction(
      {@required this.userID,
      @required this.title,
      @required this.subtitle,
      this.amount = 0,
      @required this.time,
      this.picture});

  @override
  List<Object> get props => [userID, title, subtitle, amount, time, picture];
}
