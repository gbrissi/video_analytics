import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PathController extends ChangeNotifier {
  late BuildContext _context;
  GoRouter get router => GoRouter.of(_context);
  String? get _location => router.routeInformationProvider.value.location;
  late String? routerPath = _location;

  void _updatePathChanges() {
    routerPath = _location;
    print("Locação: $routerPath");
    notifyListeners();
  }

  void initializePathController(BuildContext context) {
    _context = context;
    router.routeInformationProvider.addListener(_updatePathChanges);
  }

  @override
  void dispose() {
    router.routeInformationProvider.removeListener(_updatePathChanges);
    super.dispose();
  }

  void setPath(String path) {
    routerPath = path;
    notifyListeners();
  }
}
