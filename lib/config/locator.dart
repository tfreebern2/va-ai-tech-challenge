import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:semperMade/services/snackbar_service.dart';

final locator = GetIt.instance;
final firebaseAuth = FirebaseAuth.instance;

void setupLocator() {
  locator.registerLazySingleton(SnackBarService.new);
}
