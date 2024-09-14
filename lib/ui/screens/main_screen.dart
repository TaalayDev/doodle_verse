import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core.dart';
import '../../providers/projects.dart';
import '../widgets.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);

    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Feather.info),
            onPressed: () {
              const AboutAppRoute().push(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(projectsProvider.notifier).refresh();
        },
        child: Column(
          children: [
            Expanded(
              child: projectsState.when(
                data: (projects) {
                  if (projects.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey,
                        ),
                        Text(
                          'No projects found, '
                          '\ncreate one by clicking the button below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }

                  return GridView.count(
                    crossAxisCount: MediaQuery.sizeOf(context).adaptiveValue(
                      2,
                      {
                        ScreenSize.lg: 4,
                        ScreenSize.xl: 5,
                        ScreenSize.md: 3,
                      },
                    ),
                    childAspectRatio: 1.2,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: projects
                        .map(
                          (project) => ProjectCard(
                            title: project.name,
                            image: project.cachedImageFile,
                            onTap: () async {
                              await ProjectRoute(id: project.id).push(context);
                              ref.read(projectsProvider.notifier).refresh();
                            },
                          ),
                        )
                        .toList(),
                  );
                },
                error: (error, _) => Center(
                  child: Text('Error: $error'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            if (screenSize.width < 600)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create New Project'),
                    onPressed: () async {
                      final uuid =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      await ProjectRoute(id: uuid).push(context);
                      ref.read(projectsProvider.notifier).refresh();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: screenSize.width >= 600
          ? FloatingActionButton.extended(
              onPressed: () async {
                final uuid = DateTime.now().millisecondsSinceEpoch.toString();
                await ProjectRoute(id: uuid).push(context);
                ref.read(projectsProvider.notifier).refresh();
              },
              label: const Text('Create New Project'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  final String title;
  final File? image;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialInkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.white,
                child: image != null
                    ? Image.file(
                        image!,
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                      )
                    : const Center(
                        child: Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
