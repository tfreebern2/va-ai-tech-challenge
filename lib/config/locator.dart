import 'package:get_it/get_it.dart';
import 'package:semperMade/services/snackbar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;
final supabase = Supabase.instance.client;

void setupLocator() {
  locator.registerLazySingleton(SnackBarService.new);
}
