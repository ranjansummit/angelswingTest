import 'package:angel_swing/persistence/angleswing_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../blocs/block_provider.dart';
import 'map_page_screen.dart';
import '../essential/notification_service.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.initialize();
  await NotificationService().init();
  await NotificationService().show();
  runApp(AngelSwing());
}



class AngelSwing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        child:
        MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xffffffff),
      ),
      home: MapPageScreen(),
    ));
  }
}
