import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/project_setup_screen.dart';
import '../screens/analysis_progress_screen.dart';
import '../screens/editor_timeline_screen.dart';
import '../screens/ai_explain_screen.dart';
import '../screens/ai_lab_settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/setup', builder: (context, state) => const ProjectSetupScreen()),
    GoRoute(path: '/analyzing', builder: (context, state) => const AnalysisProgressScreen()),
    GoRoute(path: '/editor', builder: (context, state) => const EditorTimelineScreen()),
    GoRoute(path: '/explain', builder: (context, state) => const AIExplainScreen()),
    GoRoute(path: '/lab', builder: (context, state) => const AILabSettingsScreen()),
  ],
);