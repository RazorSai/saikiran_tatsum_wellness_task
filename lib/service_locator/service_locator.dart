import 'package:get_it/get_it.dart';
import 'package:tatsam_wellness_flutter_task/database/helper/database_helper.dart';

GetIt locator = GetIt.instance;

/*Here we create a singleton instance of Database Helper class*/
void setUpLocator() {
  locator.registerSingleton(DatabaseHelper());
}
