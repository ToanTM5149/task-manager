import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.getUserData();
      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      print(e);
      emit(AuthInitial());
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print('AuthCubit: Starting signup');
      emit(AuthLoading());

      print('AuthCubit: Calling remote repository');
      final userModel = await authRemoteRepository.signUp(
        name: name,
        email: email,
        password: password,
      );

      print('AuthCubit: Signup successful');
      emit(AuthSignUp());
    } catch (e) {
      print('AuthCubit: Error during signup: $e');
      emit(AuthError(_formatErrorMessage(e.toString())));
    }
  }

  String _formatErrorMessage(String error) {
    if (error.contains('email already exists')) {
      return 'Email này đã được sử dụng';
    }
    if (error.contains('invalid email')) {
      return 'Email không hợp lệ';
    }
    return 'Có lỗi xảy ra, vui lòng thử lại';
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      await authLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
