// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsHash() => r'022d2963f01df99eb960fed51e1f6a74491dfd28';

/// See also [Projects].
@ProviderFor(Projects)
final projectsProvider =
    AutoDisposeStreamNotifierProvider<Projects, List<ProjectModel>>.internal(
  Projects.new,
  name: r'projectsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$projectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Projects = AutoDisposeStreamNotifier<List<ProjectModel>>;
String _$projectHash() => r'2581ddac9a0a1a0294e6b715d27886b0f8539198';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Project
    extends BuildlessAutoDisposeAsyncNotifier<ProjectModel> {
  late final int projectId;

  FutureOr<ProjectModel> build(
    int projectId,
  );
}

/// See also [Project].
@ProviderFor(Project)
const projectProvider = ProjectFamily();

/// See also [Project].
class ProjectFamily extends Family<AsyncValue<ProjectModel>> {
  /// See also [Project].
  const ProjectFamily();

  /// See also [Project].
  ProjectProvider call(
    int projectId,
  ) {
    return ProjectProvider(
      projectId,
    );
  }

  @override
  ProjectProvider getProviderOverride(
    covariant ProjectProvider provider,
  ) {
    return call(
      provider.projectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectProvider';
}

/// See also [Project].
class ProjectProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Project, ProjectModel> {
  /// See also [Project].
  ProjectProvider(
    int projectId,
  ) : this._internal(
          () => Project()..projectId = projectId,
          from: projectProvider,
          name: r'projectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectHash,
          dependencies: ProjectFamily._dependencies,
          allTransitiveDependencies: ProjectFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final int projectId;

  @override
  FutureOr<ProjectModel> runNotifierBuild(
    covariant Project notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(Project Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProjectProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Project, ProjectModel>
      createElement() {
    return _ProjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProjectRef on AutoDisposeAsyncNotifierProviderRef<ProjectModel> {
  /// The parameter `projectId` of this provider.
  int get projectId;
}

class _ProjectProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Project, ProjectModel>
    with ProjectRef {
  _ProjectProviderElement(super.provider);

  @override
  int get projectId => (origin as ProjectProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
