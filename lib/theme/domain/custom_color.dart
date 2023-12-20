import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const attack = Color(0xFFD3005A);
const defense = Color(0xFF005C76);

CustomColors lightCustomColors = const CustomColors(
  sourceAttack: Color(0xFFD3005A),
  attack: Color(0xFFBC004F),
  onAttack: Color(0xFFFFFFFF),
  attackContainer: Color(0xFFFFD9DE),
  onAttackContainer: Color(0xFF3F0016),
  sourceDefense: Color(0xFF005C76),
  defense: Color(0xFF006783),
  onDefense: Color(0xFFFFFFFF),
  defenseContainer: Color(0xFFBCE9FF),
  onDefenseContainer: Color(0xFF001F2A),
);

CustomColors darkCustomColors = const CustomColors(
  sourceAttack: Color(0xFFD3005A),
  attack: Color(0xFFFFB2BF),
  onAttack: Color(0xFF660028),
  attackContainer: Color(0xFF90003B),
  onAttackContainer: Color(0xFFFFD9DE),
  sourceDefense: Color(0xFF005C76),
  defense: Color(0xFF64D3FF),
  onDefense: Color(0xFF003546),
  defenseContainer: Color(0xFF004D63),
  onDefenseContainer: Color(0xFFBCE9FF),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceAttack,
    required this.attack,
    required this.onAttack,
    required this.attackContainer,
    required this.onAttackContainer,
    required this.sourceDefense,
    required this.defense,
    required this.onDefense,
    required this.defenseContainer,
    required this.onDefenseContainer,
  });

  final Color? sourceAttack;
  final Color? attack;
  final Color? onAttack;
  final Color? attackContainer;
  final Color? onAttackContainer;
  final Color? sourceDefense;
  final Color? defense;
  final Color? onDefense;
  final Color? defenseContainer;
  final Color? onDefenseContainer;

  @override
  CustomColors copyWith({
    Color? sourceAttack,
    Color? attack,
    Color? onAttack,
    Color? attackContainer,
    Color? onAttackContainer,
    Color? sourceDefense,
    Color? defense,
    Color? onDefense,
    Color? defenseContainer,
    Color? onDefenseContainer,
  }) {
    return CustomColors(
      sourceAttack: sourceAttack ?? this.sourceAttack,
      attack: attack ?? this.attack,
      onAttack: onAttack ?? this.onAttack,
      attackContainer: attackContainer ?? this.attackContainer,
      onAttackContainer: onAttackContainer ?? this.onAttackContainer,
      sourceDefense: sourceDefense ?? this.sourceDefense,
      defense: defense ?? this.defense,
      onDefense: onDefense ?? this.onDefense,
      defenseContainer: defenseContainer ?? this.defenseContainer,
      onDefenseContainer: onDefenseContainer ?? this.onDefenseContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceAttack: Color.lerp(sourceAttack, other.sourceAttack, t),
      attack: Color.lerp(attack, other.attack, t),
      onAttack: Color.lerp(onAttack, other.onAttack, t),
      attackContainer: Color.lerp(attackContainer, other.attackContainer, t),
      onAttackContainer:
          Color.lerp(onAttackContainer, other.onAttackContainer, t),
      sourceDefense: Color.lerp(sourceDefense, other.sourceDefense, t),
      defense: Color.lerp(defense, other.defense, t),
      onDefense: Color.lerp(onDefense, other.onDefense, t),
      defenseContainer: Color.lerp(defenseContainer, other.defenseContainer, t),
      onDefenseContainer:
          Color.lerp(onDefenseContainer, other.onDefenseContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [CustomColors.sourceAttack]
  ///   * [CustomColors.attack]
  ///   * [CustomColors.onAttack]
  ///   * [CustomColors.attackContainer]
  ///   * [CustomColors.onAttackContainer]
  ///   * [CustomColors.sourceDefense]
  ///   * [CustomColors.defense]
  ///   * [CustomColors.onDefense]
  ///   * [CustomColors.defenseContainer]
  ///   * [CustomColors.onDefenseContainer]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      sourceAttack: sourceAttack!.harmonizeWith(dynamic.primary),
      attack: attack!.harmonizeWith(dynamic.primary),
      onAttack: onAttack!.harmonizeWith(dynamic.primary),
      attackContainer: attackContainer!.harmonizeWith(dynamic.primary),
      onAttackContainer: onAttackContainer!.harmonizeWith(dynamic.primary),
      sourceDefense: sourceDefense!.harmonizeWith(dynamic.primary),
      defense: defense!.harmonizeWith(dynamic.primary),
      onDefense: onDefense!.harmonizeWith(dynamic.primary),
      defenseContainer: defenseContainer!.harmonizeWith(dynamic.primary),
      onDefenseContainer: onDefenseContainer!.harmonizeWith(dynamic.primary),
    );
  }
}
