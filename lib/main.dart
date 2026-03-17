import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Importante!
import 'package:bulkingtracker/core/theme/app_theme.dart'; // Importando o arquivo do tema
import 'package:bulkingtracker/features/main/presentation/main_screen.dart'; // Importando a MainScreen
import 'package:bulkingtracker/features/tracking/providers/tracker_provider.dart'; // O nosso novo provider
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bulkingtracker/features/onboarding/onboarding_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Garante que o Flutter tá pronto antes de ler coisas de fora
  WidgetsFlutterBinding.ensureInitialized();

  // Trava a orientação em Portrait (Evita rejeição da Apple por quebra de layout)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Amortecedor: tenta carregar .env, se falhar continua sem travar
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Aviso: arquivo .env não encontrado ou erro ao carregar.');
  }

  // Cria o provider e aguarda o carregamento completo do SharedPreferences
  // antes de decidir qual tela mostrar — elimina a race condition!
  final tracker = TrackerProvider();
  await tracker.initFuture;

  // Verifica se já fez o onboarding (após os dados estarem carregados)
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => tracker),
      ],
      child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const MyApp({super.key, required this.hasSeenOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BulkingTracker',
      theme: AppTheme.darkTheme, // Chamando nosso tema personalizado aqui
      themeMode: ThemeMode.dark, // Forçando o Dark Mode
      home: hasSeenOnboarding ? const MainScreen() : const OnboardingScreen(),
    );
  }
}
