import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts_event.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts_state.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/pages/posts_page.dart';
import 'package:flutter_clean_architecture/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsBloc extends MockBloc<PostsEvent, PostsState>
    implements PostsBloc {}

void main() {
  late MockPostsBloc postsBloc;

  setUp(() {
    postsBloc = MockPostsBloc();
    sl.registerFactory<PostsBloc>(() => postsBloc);
  });

  tearDown(() => sl.reset());

  Future<void> pumpPostsPage(WidgetTester tester) {
    return tester.pumpWidget(const MaterialApp(home: PostsPage()));
  }

  testWidgets('shows a loading indicator before the posts arrive', (
    tester,
  ) async {
    when(() => postsBloc.state).thenReturn(const PostsLoading());

    await pumpPostsPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders the loaded posts', (tester) async {
    when(() => postsBloc.state).thenReturn(
      const PostsLoaded([
        PostEntity(id: 1, userId: 7, title: 'First post', body: 'Body one'),
        PostEntity(id: 2, userId: 7, title: 'Second post', body: 'Body two'),
      ]),
    );

    await pumpPostsPage(tester);

    expect(find.text('First post'), findsOneWidget);
    expect(find.text('Second post'), findsOneWidget);
  });

  testWidgets('shows the failure message with a retry action', (tester) async {
    when(
      () => postsBloc.state,
    ).thenReturn(const PostsError('No internet connection'));

    await pumpPostsPage(tester);

    expect(find.text('No internet connection'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
