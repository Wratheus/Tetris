import 'package:flutter/material.dart';

@immutable
class Identica {
  const Identica({
    required this.icon,
    this.iconBackgroundColor = Colors.black,
    this.fill = 0.0,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double? fill;

  @override
  String toString() =>
      'Identica{icon: $icon, iconColor: $iconColor, iconBackgroundColor: $iconBackgroundColor, fill: $fill}';

  Identica copyWith({
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    double? fill,
  }) =>
      Identica(
        icon: icon ?? this.icon,
        fill: fill ?? this.fill,
        iconColor: iconColor ?? this.iconColor,
        iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      );

  /// all identicas for randomizing, is immutable list object.
  static List<Identica> allIdenticas = List.unmodifiable(
    [
      // Красная идентика с ромбом
      const Identica(
        icon: Icons.diamond,
        iconBackgroundColor: Color(0xFFE53935),
        fill: 0.8,
      ),
      // Синяя идентика с кругом
      const Identica(
        icon: Icons.circle,
        iconBackgroundColor: Color(0xFF1976D2),
        fill: 0.7,
      ),
      // Зеленая идентика с треугольником
      const Identica(
        icon: Icons.change_history,
        iconBackgroundColor: Color(0xFF388E3C),
        fill: 0.9,
      ),
      // Желтая идентика со звездой
      const Identica(
        icon: Icons.star,
        iconBackgroundColor: Color(0xFFFFD600),
        fill: 0.8,
      ),
      // Оранжевая идентика с квадратом
      const Identica(
        icon: Icons.square,
        iconBackgroundColor: Color(0xFFFF9800),
        fill: 0.9,
      ),
      // Фиолетовая идентика с сердцем
      const Identica(
        icon: Icons.favorite,
        iconBackgroundColor: Color(0xFF8E24AA),
        fill: 0.8,
      ),
      // Голубая идентика с каплей
      const Identica(
        icon: Icons.water_drop,
        iconBackgroundColor: Color(0xFF00BCD4),
        fill: 0.7,
      ),
      // Розовая идентика с цветком
      const Identica(
        icon: Icons.local_florist,
        iconBackgroundColor: Color(0xFFE91E63),
        fill: 0.8,
      ),
      // Коричневая идентика с листом
      const Identica(
        icon: Icons.eco,
        iconBackgroundColor: Color(0xFF795548),
        fill: 0.7,
      ),
      // Темно-зеленая идентика с деревом
      const Identica(
        icon: Icons.park,
        iconBackgroundColor: Color(0xFF00695C),
        fill: 0.8,
      ),
      // Индиго идентика с молнией
      const Identica(
        icon: Icons.flash_on,
        iconBackgroundColor: Color(0xFF3F51B5),
        fill: 0.9,
      ),
      // Лаймовая идентика с солнцем
      const Identica(
        icon: Icons.wb_sunny,
        iconBackgroundColor: Color(0xFFCDDC39),
        fill: 0.8,
      ),
      // Амбер идентика с огнем
      const Identica(
        icon: Icons.local_fire_department,
        iconBackgroundColor: Color(0xFFFFC107),
        fill: 0.7,
      ),
      // Сиреневый идентика с бабочкой
      const Identica(
        icon: Icons.air,
        iconBackgroundColor: Color(0xFF9C27B0),
        fill: 0.8,
      ),
      // Глубокий оранжевый идентика с ракетой
      const Identica(
        icon: Icons.rocket_launch,
        iconBackgroundColor: Color(0xFFFF5722),
        fill: 0.9,
      ),
      // Золотая идентика с короной
      const Identica(
        icon: Icons.workspace_premium,
        iconBackgroundColor: Color(0xFFFFD700),
        iconColor: Colors.black87,
        fill: 0.8,
      ),
      // Бирюзовая идентика с рыбой
      const Identica(
        icon: Icons.set_meal,
        iconBackgroundColor: Color(0xFF00CED1),
        fill: 0.7,
      ),
      // Малиновая идентика с музыкальной нотой
      const Identica(
        icon: Icons.music_note,
        iconBackgroundColor: Color(0xFFDC143C),
        fill: 0.8,
      ),
      // Лавандовая идентика с бабочкой
      const Identica(
        icon: Icons.auto_awesome,
        iconBackgroundColor: Color(0xFFE6E6FA),
        iconColor: Colors.black87,
        fill: 0.9,
      ),
      // Коралловая идентика с ракушкой
      const Identica(
        icon: Icons.beach_access,
        iconBackgroundColor: Color(0xFFFF7F50),
        fill: 0.7,
      ),
      // Салатовая идентика с яблоком
      const Identica(
        icon: Icons.apple,
        iconBackgroundColor: Color(0xFF7FFF00),
        iconColor: Colors.black87,
        fill: 0.8,
      ),
      // Персиковая идентика с облаком
      const Identica(
        icon: Icons.cloud,
        iconBackgroundColor: Color(0xFFFFCBA4),
        iconColor: Colors.black87,
        fill: 0.7,
      ),
      // Мятная идентика с листом клевера
      const Identica(
        icon: Icons.grass,
        iconBackgroundColor: Color(0xFF98FF98),
        iconColor: Colors.black87,
        fill: 0.8,
      ),
      // Песочная идентика с замком
      const Identica(
        icon: Icons.castle,
        iconBackgroundColor: Color(0xFFF4A460),
        fill: 0.9,
      ),
      // Небесно-голубая идентика с самолетом
      const Identica(
        icon: Icons.flight,
        iconBackgroundColor: Color(0xFF87CEEB),
        fill: 0.8,
      ),
      // Шоколадная идентика с чашкой кофе
      const Identica(
        icon: Icons.coffee,
        iconBackgroundColor: Color(0xFF8B4513),
        fill: 0.7,
      ),
      // Серебряная идентика с мечом
      const Identica(
        icon: Icons.sports_martial_arts,
        iconBackgroundColor: Color(0xFFC0C0C0),
        iconColor: Colors.black87,
        fill: 0.9,
      ),
      // Бронзовая идентика с щитом
      const Identica(
        icon: Icons.security,
        iconBackgroundColor: Color(0xFFCD7F32),
        fill: 0.8,
      ),
      // Платиновая идентика с драгоценным камнем
      const Identica(
        icon: Icons.workspace_premium,
        iconBackgroundColor: Color(0xFFE5E4E2),
        iconColor: Colors.black87,
        fill: 0.7,
      ),
      // Радужная идентика с призмой
      const Identica(
        icon: Icons.filter_vintage,
        iconBackgroundColor: Color(0xFF9370DB),
        fill: 0.9,
      ),
    ],
  );
}
