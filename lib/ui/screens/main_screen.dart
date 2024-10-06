import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core.dart';
import '../../data.dart';
import '../../providers/projects.dart';
import '../widgets.dart';
import '../widgets/new_project_dialog.dart';
import '../widgets/overlay.dart';
import 'about_screen.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);
    final overlayLoader = useState<OverlayEntry?>(null);

    useEffect(() {
      return () {
        if (overlayLoader.value?.mounted == true) {
          overlayLoader.value?.remove();
        }
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: Row(
          children: [
            const SizedBox(width: 16),
            TextButton.icon(
              icon: const Icon(Feather.upload),
              label: const Text('Open'),
              onPressed: () async {},
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
        leadingWidth: 150,
        actions: [
          IconButton(
            icon: const Icon(Feather.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: const AboutScreen(),
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Feather.plus),
            onPressed: () => _navigateToNewProject(context, ref),
          ),
        ],
      ),
      body: projectsState.when(
        data: (projects) => AdaptiveProjectGrid(
          projects: projects,
          onCreateNew: () => _navigateToNewProject(context, ref),
          onTapProject: (project) {
            _openProject(context, ref, project.id);
          },
          onDeleteProject: (project) {
            ref.read(projectsProvider.notifier).deleteProject(project.id);
          },
          onEditProject: (project) {
            ref.read(projectsProvider.notifier).updateProjectName(
                  project.id,
                  project.name,
                );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Feather.alert_circle, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'An error occurred',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Feather.refresh_cw),
                label: const Text('Try Again'),
                onPressed: () => ref.refresh(projectsProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNewProject(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<({String name, int width, int height})>(
      context: context,
      builder: (BuildContext context) => const NewProjectDialog(),
    );

    if (result != null && context.mounted) {
      final project = ProjectModel(
        id: 0,
        name: result.name,
        layers: [
          const LayerModel(
            id: 0,
            name: 'Layer 1',
          ),
        ],
        createdAt: DateTime.now().millisecondsSinceEpoch,
        lastModified: DateTime.now().millisecondsSinceEpoch,
        canvasSize: Size(result.width.toDouble(), result.height.toDouble()),
      );

      final loader = showLoader(context, loadingText: 'Creating project...');
      final newProjectId =
          await ref.read(projectsProvider.notifier).addProject(project);

      if (context.mounted) {
        loader.remove();
        await ProjectRoute(id: newProjectId).push(context);
      }
    }
  }

  void _openProject(
    BuildContext context,
    WidgetRef ref,
    int projectId,
  ) {
    ProjectRoute(id: projectId).push(context);
  }
}

class AdaptiveProjectGrid extends StatelessWidget {
  final List<ProjectModel> projects;
  final Function()? onCreateNew;
  final Function(ProjectModel)? onTapProject;
  final Function(ProjectModel)? onDeleteProject;
  final Function(ProjectModel)? onEditProject;

  const AdaptiveProjectGrid({
    super.key,
    required this.projects,
    this.onCreateNew,
    this.onTapProject,
    this.onDeleteProject,
    this.onEditProject,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Feather.folder, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No projects found',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Feather.plus),
              label: const Text('Create New'),
              onPressed: onCreateNew,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < 600 ? 2 : (width < 1200 ? 3 : 4);

        return MasonryGridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ProjectCard(
              project: projects[index],
              onTapProject: onTapProject,
              onDeleteProject: onDeleteProject,
              onEditProject: onEditProject,
            );
          },
        );
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final Function(ProjectModel)? onTapProject;
  final Function(ProjectModel)? onDeleteProject;
  final Function(ProjectModel)? onEditProject;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTapProject,
    this.onDeleteProject,
    this.onEditProject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onTapProject?.call(project),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Feather.more_vertical),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Text('Rename'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'rename') {
                        showDialog(
                          context: context,
                          builder: (context) => RenameProjectDialog(
                            initialName: project.name,
                            onRename: (name) {
                              onEditProject?.call(project.copyWith(name: name));
                            },
                          ),
                        );
                      } else if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Project'),
                            content: const Text(
                                'Are you sure you want to delete this project?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onDeleteProject?.call(project);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: project.cachedImage != null
                    ? Image.memory(project.cachedImage!, fit: BoxFit.cover)
                    : const Center(child: Icon(Feather.image, size: 48)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    context,
                    icon: Feather.grid,
                    label:
                        '${project.canvasSize.width.toInt()}x${project.canvasSize.height.toInt()}',
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  _buildInfoChip(
                    context,
                    icon: Feather.clock,
                    label: _formatLastEdited(
                        DateTime.fromMillisecondsSinceEpoch(
                            project.lastModified)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatLastEdited(DateTime lastEdited) {
    final now = DateTime.now();
    final difference = now.difference(lastEdited);

    if (difference.inDays > 0) {
      return '${difference.inDays}d. ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h. ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m. ago';
    } else {
      return 'Just now';
    }
  }
}

class RenameProjectDialog extends HookWidget {
  const RenameProjectDialog({
    super.key,
    required this.initialName,
    this.onRename,
  });

  final String initialName;
  final Function(String name)? onRename;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialName);

    return AlertDialog(
      title: const Text('Rename Project'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Project Name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onRename?.call(controller.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Rename'),
        ),
      ],
    );
  }
}
