import 'package:flutter_test/flutter_test.dart';

import 'package:task/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskApp());
    await tester.pump();

    expect(find.byType(TaskApp), findsOneWidget);
  });
}
