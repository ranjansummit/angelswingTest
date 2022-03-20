import 'package:angel_swing/blocs/user_essential_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class BlocProvider extends StatelessWidget {
  final Widget child;
  const BlocProvider({ required this.child}) : super();
  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;

    return MultiProvider(
        providers: [
          Provider<UserEssentialBloc>.value(value: new UserEssentialBloc()),
        ], child: child);


  }
}