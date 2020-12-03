import 'dart:async';

import 'package:pradipassignment/src/models/user_model.dart';
import 'package:pradipassignment/src/repositories/user_repository.dart';
import 'package:pradipassignment/src/util/fields_controller.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';


import '../app_bloc.dart';
import '../app_module.dart';
import 'login_module.dart';

class LoginBloc extends BlocBase with ControllerFields {
  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  final _controllerLoading = BehaviorSubject<bool>.seeded(false);

  final _repo = LoginModule.to.getDependency<UserRepository>();
  final _appBloc = AppModule.to.getBloc<AppBloc>();
  UserModel _userCorrente;

  Stream<String> get username =>
      _usernameController.stream.transform(validateField);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get outLoading => _controllerLoading.stream;

  Stream<bool> get submitValid =>
      Observable.combineLatest2(username, password, (e, p) => true);

  Function(String) get changeUsername => _usernameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Future<String> login(String username, String password) async {
    _controllerLoading.add(true);
    try {
      _userCorrente = UserModel(username + '@reqres.in', password);
      var token = await _repo.login(_userCorrente);
      if (token != null) {
        _appBloc.inUser.add(_userCorrente);
      }
    } catch (e) {
      _controllerLoading.add(false);
      if (e.message.contains('Connection')) {
        return "Server connection failed.";
      } else {
        return "Username and password didn't match.";
      }
    }
    _controllerLoading.add(false);
    return "true";
  }

  submit() {
    final validUsername = _usernameController.value;
    final validPassword = _passwordController.value;

    return login(validUsername, validPassword);
  }

  @override
  dispose() {
    _usernameController.close();
    _passwordController.close();
    super.dispose();
  }
}
