import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/symptoms_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/chat/ai_chat_screen.dart';
import 'presentation/screens/symptoms/symptoms_analysis_screen.dart';
import 'presentation/screens/diseases/disease_list_screen.dart';
import 'presentation/screens/diseases/disease_detail_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'data/models/disease_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedAssistApp());
}

class MedAssistApp extends StatelessWidget {
  const MedAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'MedAssist AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return _createRoute(const SplashScreen());
                case '/home':
                  return _createRoute(const HomeScreen());
                case '/chat':
                  return _createRoute(const AIChatScreen());
                case '/symptoms':
                  return _createRoute(const SymptomsAnalysisScreen());
                case '/diseases':
                  return _createRoute(const DiseaseListScreen());
                case '/disease-detail':
                  final disease = settings.arguments as Disease;
                  return _createRoute(DiseaseDetailScreen(disease: disease));
                case '/profile':
                  return _createRoute(const ProfileScreen());
                case '/settings':
                  return _createRoute(const SettingsScreen());
                default:
                  return _createRoute(const HomeScreen());
              }
            },
          );
        },
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
