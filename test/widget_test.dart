import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// MUDANÇA AQUI: Importação relativa para garantir que o arquivo seja encontrado
import '../lib/main.dart'; 

void main() {
  testWidgets('App principal inicia e mostra o título', (WidgetTester tester) async {
    // Constrói o nosso app e dispara um frame.
    await tester.pumpWidget(const CookEasyApp());

    // Verifica se o título da Home está presente
    expect(find.text('CookEasy - Estrutura Limpa'), findsOneWidget);
    
    // Verifica se o botão de Login está presente
    expect(find.widgetWithText(ElevatedButton, 'Ir para Login'), findsOneWidget);
    
    // Verifica se o botão de Configurações está presente
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
