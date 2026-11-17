import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ijevo_mobile/main.dart';

void main() {
  testWidgets('Ijevo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: IjevoMobileApp(),
      ),
    );
    expect(find.byType(IjevoMobileApp), findsOneWidget);
  });
}
