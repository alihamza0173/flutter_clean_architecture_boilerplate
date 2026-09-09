import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../injection_container.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';

class PostsPage extends StatelessWidget {
  static const ROUTE_PATH = '/posts';
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostsBloc>()..add(const PostsRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: const PostsBody(),
      ),
    );
  }
}

class PostsBody extends StatelessWidget {
  const PostsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          return switch (state) {
            PostsInitial() || PostsLoading() => const LoadingIndicator(),
            PostsError(:final message) => _PostsErrorView(message: message),
            PostsLoaded(:final posts) => ListView.separated(
              padding: const .all(16),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                  onTap: () => context.read<PostsBloc>().add(
                    PostDetailRequested(post.id),
                  ),
                );
              },
            ),
            PostDetailLoaded(:final post) => SingleChildScrollView(
              padding: const .all(24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(post.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(post.body),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () =>
                        context.read<PostsBloc>().add(const PostsRequested()),
                    child: const Text('Back to list'),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}

class _PostsErrorView extends StatelessWidget {
  final String message;

  const _PostsErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(24),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(message, textAlign: .center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.read<PostsBloc>().add(const PostsRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
