import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import '../../../posts/presentation/pages/posts_page.dart';

class HomePage extends StatelessWidget {
  static const ROUTE_PATH = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Home — replace with your home page'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(PostsPage.ROUTE_PATH),
              child: const Text('View posts'),
            ),
          ],
        ),
      ),
    );
  }
}
