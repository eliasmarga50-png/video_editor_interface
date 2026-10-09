import '../../domain/value_objects/vibe.dart';
import '../../domain/entities/grade_recipe.dart';

class ColorGrader {
  GradeRecipe recipeForVibe(Vibe vibe) {
    switch (vibe) {
      case Vibe.hype:
        return const GradeRecipe(vibe: Vibe.hype, lutPath: 'assets/luts/hype.cube', contrast: 1.25, saturation: 1.3, temperature: 5200, grainAmount: 0.1);
      case Vibe.chill:
        return const GradeRecipe(vibe: Vibe.chill, lutPath: 'assets/luts/chill.cube', contrast: 0.95, saturation: 0.9, temperature: 6100, grainAmount: 0.2);
      case Vibe.cinematic:
        return const GradeRecipe(vibe: Vibe.cinematic, lutPath: 'assets/luts/cinematic.cube', contrast: 1.3, saturation: 0.95, temperature: 4800, grainAmount: 0.35);
      default:
        return  GradeRecipe(vibe: vibe, lutPath: 'assets/luts/default.cube', contrast: 1.1, saturation: 1.0, temperature: 5500, grainAmount: 0.05);
    }
  }
}