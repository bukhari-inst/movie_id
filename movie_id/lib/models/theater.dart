part of 'models.dart';

class Theater extends Equatable {
  final String name;

  Theater(this.name);

  @override
  List<Object> get props => [name];
}

List<Theater> dummyTheater = [
  Theater("Kediri XXI. Ramayana Mall"),
  Theater("CGV KEDIRI MALL"),
  Theater("Golden Theater Kediri"),
  Theater("CGV Cinemas Blitar Square")
];
