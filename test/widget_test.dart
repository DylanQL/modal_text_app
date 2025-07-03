// Test básico para la aplicación de inventario
import 'package:flutter_test/flutter_test.dart';
import 'package:modal_text_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InventarioApp());

    // Verify that the app loads with the home screen
    expect(find.text('Sistema de Inventario'), findsOneWidget);
    
    // Wait for any async operations to complete
    await tester.pumpAndSettle();
  });
}
