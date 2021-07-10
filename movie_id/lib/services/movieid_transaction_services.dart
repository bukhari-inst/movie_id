part of 'services.dart';

class MovieidTransactionServices {
  // ada 2 buah service: untuk ngeset transaksi & ngegate transaksi
  static CollectionReference transactionCollection =
      Firestore.instance.collection('transaction');
  //set transaksi
  static Future<void> saveTransaction(
      MovieidTransaction movieidTransaction) async {
    await transactionCollection.document().setData({
      'userID': movieidTransaction.userID,
      'title': movieidTransaction.title,
      'subtitle': movieidTransaction.subtitle,
      'time': movieidTransaction.time.millisecondsSinceEpoch,
      'amount': movieidTransaction.amount,
      'picture': movieidTransaction.picture
    });
  }

  static Future<List<MovieidTransaction>> getTransaction(String userID) async {
    QuerySnapshot snapshot = await transactionCollection.getDocuments();

    // ambil documen sesuai userID
    var documents = snapshot.documents
        .where((document) => document.data['userID'] == userID);

    // dari tiap documen dimapping mnjadi MovieidTransaction kmudian diubah ke list
    return documents
        .map((e) => MovieidTransaction(
            userID: e.data['userID'],
            title: e.data['title'],
            subtitle: e.data['subtitle'],
            time: DateTime.fromMillisecondsSinceEpoch(e.data['time']),
            amount: e.data['amount'],
            picture: e.data['picture']))
        .toList();
  }
}
