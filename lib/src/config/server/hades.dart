import 'package:supabase_flutter/supabase_flutter.dart';

class Hades {
  static final supabase = Supabase.instance.client;

  static init() async {
    await Supabase.initialize(
      url: 'https://jxnozurffwcpczekxpij.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp4bm96dXJmZndjcGN6ZWt4cGlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAxOTcwODAsImV4cCI6MjA0NTc3MzA4MH0.AS2s4iaBRxqIizu4diXHiZZOCCY35u2mwyL69sQzDZg',
    );
  }
}
