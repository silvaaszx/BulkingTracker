import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Definindo as cores principais para facilitar a manutenção
  static const Color _backgroundColor = Color(0xFF121212);
  static const Color _surfaceColor = Color(0xFF1E1E1E);
  static const Color _primaryPurple = Color(0xFF9C27B0); // Roxo principal
  static const Color _accentPurple = Color(0xFFE040FB); // Roxo vibrante para destaques

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _backgroundColor,
      primaryColor: _primaryPurple,
      
      // Configuração global de cores do Material 3
      colorScheme: const ColorScheme.dark(
        primary: _primaryPurple,
        secondary: _accentPurple,
        surface: _surfaceColor,
      ),

      // Tipografia limpa e moderna com Google Fonts
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ),

      // Estilo padrão dos Cards para criar profundidade sem bordas
      cardTheme: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      
      // Deixando o AppBar minimalista, sem sombra e combinando com o fundo
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
