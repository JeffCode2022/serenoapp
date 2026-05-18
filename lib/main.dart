import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/login_screen.dart';
import 'main_layout_screen.dart';
import 'features/reportes/presentation/formulario_reporte_screen.dart';
import 'features/muro/data/repositories/muro_repository.dart';
import 'features/muro/presentation/bloc/muro_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Evitar descargas dinámicas HTTP de tipografías en runtime (previene errores sin conexión / DNS SocketException)
  GoogleFonts.config.allowRuntimeFetching = false;
  
  // Inicialización de Supabase con las credenciales reales
  await Supabase.initialize(
    url: 'https://xxitbtifowhakxoypjfw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4aXRidGlmb3doYWt4b3lwamZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg2MDY0NzksImV4cCI6MjA5NDE4MjQ3OX0._lX12Gcnp2JuWDFQNKF8dezgJAX0celScTD_U9mRkRI',
  );

  runApp(const SerenazgoApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const MainLayoutScreen();
      },
    ),
    GoRoute(
      path: '/formulario',
      builder: (BuildContext context, GoRouterState state) {
        return const FormularioReporteScreen();
      },
    ),
  ],
);

class SerenazgoApp extends StatelessWidget {
  const SerenazgoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(supabase: Supabase.instance.client)..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => MuroBloc(
            repository: MuroRepository(supabase: Supabase.instance.client),
          )..add(LoadMuroPosts()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Serenazgo Surquillo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Tema para patrullaje de día
        darkTheme: AppTheme.darkTheme, // Tema para patrullaje de noche
        themeMode: ThemeMode.system, // Cambia automáticamente según el celular
        routerConfig: _router,
      ),
    );
  }
}
