import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://knmbgxidzvswsqfwltgy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtubWJneGlkenZzd3NxZndsdGd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE4MTk3MzMsImV4cCI6MjA2NzM5NTczM30.qp7u_IaGsHyTJlIUxAgdcCT_7gUNLGTq5uyp6se8gM0',
  );
}
