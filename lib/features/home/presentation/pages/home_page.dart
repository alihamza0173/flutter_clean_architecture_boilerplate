import 'package:material_ui/material_ui.dart';

class HomePage extends StatelessWidget {
  static const ROUTE_PATH = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home — replace with your home page')),
    );
  }
}
