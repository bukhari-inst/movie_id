part of 'services.dart';

class TicketServices {
  // ticket collection
  static CollectionReference ticketCollection =
      Firestore.instance.collection('tickets');
  static Future<void> saveTicket(String id, Ticket ticket) async {
    await ticketCollection.document().setData({
      'movieID': ticket.movieDetail.id ?? "",
      'userID': id ?? "",
      'theaterName': ticket.theater.name ?? 0,
      'time': ticket.time.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      'bookingCode': ticket.bookingCode,
      'seats': ticket.seatsInString,
      'name': ticket
          .name, //nma user disimpan disini agr tidak bolak balik ambil lgi dari data user
      'totalPrice': ticket.totalPrice
    });
  }

  // servis untuk get ticket
  static Future<List<Ticket>> getTicket(String userId) async {
    QuerySnapshot snapshot = await ticketCollection.getDocuments();
    var documents = snapshot.documents
        .where((document) => document.data['userID'] == userId);

    // ambil list ticket
    List<Ticket> tickets = [];
    for (var document in documents) {
      MovieDetail movieDetail = await MovieServices.getDetails(null,
          movieID: document.data['movieID']);
      tickets.add(Ticket(
          movieDetail,
          Theater(document.data['theaterName']),
          DateTime.fromMillisecondsSinceEpoch(document.data['time']),
          document.data['bookingCode'],
          document.data['seats'].toString().split(','),
          document.data['name'],
          document.data['totalPrice']));
    }

    return tickets;
  }
}
