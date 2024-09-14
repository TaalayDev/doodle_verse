import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('About DoodleVerse'),
              background: Image.network(
                'https://picsum.photos/200/300',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    context,
                    Icons.brush,
                    'Creative Freedom',
                    'Unleash your creativity with a wide range of brushes and tools.',
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    Icons.phone_android,
                    'Cross-Platform',
                    'Create on any device - mobile, tablet, or desktop.',
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    Icons.cloud_upload,
                    'Cloud Sync',
                    'Your creations are automatically saved and synced across devices.',
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    Icons.group,
                    'Community',
                    'Share your art and get inspired by others in the DoodleVerse community.',
                  ),
                  const SizedBox(height: 32),
                  _buildAuthorSection(context),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement opening of licenses page
                      },
                      child: const Text('View Licenses'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Author',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'DoodleVerse is created by TaalayDev, a passionate developer dedicated to creating innovative and user-friendly applications.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _buildLinkButton(
            context,
            'GitHub',
            'https://github.com/TaalayDev',
            Feather.github,
          ),
          const SizedBox(height: 8),
          _buildLinkButton(
            context,
            'Email',
            'mailto:a.u.taalay@gmail.com',
            Feather.mail,
          ),
          const SizedBox(height: 8),
          _buildLinkButton(
            context,
            'Website',
            'https://taalaydev.github.io',
            Feather.globe,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
      BuildContext context, String label, String url, IconData icon) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {}
}
