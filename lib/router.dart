import 'package:clover/clover.dart';
import 'package:go_router/go_router.dart';

import 'view_models.dart';
import 'views.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ViewModelBinding(
        viewBuilder: (context) => const HomeView(),
        viewModelBuilder: (context) => HomeViewModel(),
      ),
    ),
  ],
);
