part of 'extensions.dart';

extension StringExtension on String {
  //untuk mengecek apakah dlm karakter dlam sebuah string merupakan angka apa bukan
  bool isDigit(int index) =>
      this.codeUnitAt(index) >= 48 && this.codeUnitAt(index) <= 57;
  // code unit: code ascii 48-57: code ascii 0-9
}
