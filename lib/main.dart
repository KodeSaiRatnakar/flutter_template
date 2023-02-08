import 'imports.dart';

const siteAddr = String.fromEnvironment(
  'SITE_ADDR',
  defaultValue: '1CWBVU1aQfgyeC4FULaJvkaxCUvzmfdNEH',
);

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample ZeroNet Site',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => uiController.currentRoute.value.routeWidget);
  }
}
