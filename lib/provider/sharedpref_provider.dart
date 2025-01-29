import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/sharedpref.dart';

final sharedPreferencesProvider = Provider((ref)  {
  return SharedPreferencesHelper();
});
