import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_id/models/models.dart';
import 'package:movie_id/services/services.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUser) {
      User user = await UserServices.getUser(event.id);

      yield UserLoaded(user);
    } else if (event is SignOut) {
      yield UserInitial();
    } else if (event is UpdateData) {
      User updatedUser = (state as UserLoaded)
          // update profile picture di UI
          .user
          .copyWith(name: event.name, profilePicture: event.profileImage);
      // update profile picture in firebase
      await UserServices.updateUser(updatedUser);
      yield UserLoaded(updatedUser);
    } else if (event is TopUp) {
      // untuk topup
      // UserLoaded: kita pstikan sudah ada usernya
      if (state is UserLoaded) {
        try {
          User updateUser = (state as UserLoaded).user.copyWith(
              balance: (state as UserLoaded).user.balance + event.amount);

          await UserServices.updateUser(updateUser);

          yield UserLoaded(updateUser);
        } catch (e) {
          print(e);
        }
      }
    } else if (event is Purchase) {
      //untuk beli tiket
      // UserLoaded: kita pstikan sudah ada usernya
      if (state is UserLoaded) {
        try {
          User updateUser = (state as UserLoaded).user.copyWith(
              balance: (state as UserLoaded).user.balance - event.amount);

          await UserServices.updateUser(updateUser);

          yield UserLoaded(updateUser);
        } catch (e) {
          print(e);
        }
      }
    }
  }
}
