import 'package:supabase/supabase.dart';

void main() async {
  final supabase = SupabaseClient(
    'https://xxitbtifowhakxoypjfw.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4aXRidGlmb3doYWt4b3lwamZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg2MDY0NzksImV4cCI6MjA5NDE4MjQ3OX0._lX12Gcnp2JuWDFQNKF8dezgJAX0celScTD_U9mRkRI',
  );

  try {
    print('Intentando login...');
    final res = await supabase.auth.signInWithPassword(
      email: '75920737@surquillo.pe',
      password: '123456',
    );
    print('Login exitoso: \${res.user?.id}');
  } catch (e) {
    print('Error: \$e');
  }
}
