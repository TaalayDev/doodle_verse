// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_database.dart';

// ignore_for_file: type=lint
class $ProjectsTableTable extends ProjectsTable
    with TableInfo<$ProjectsTableTable, ProjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _canvasWidthMeta =
      const VerificationMeta('canvasWidth');
  @override
  late final GeneratedColumn<int> canvasWidth = GeneratedColumn<int>(
      'canvas_width', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1080));
  static const VerificationMeta _canvasHeightMeta =
      const VerificationMeta('canvasHeight');
  @override
  late final GeneratedColumn<int> canvasHeight = GeneratedColumn<int>(
      'canvas_height', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1920));
  static const VerificationMeta _zoomLevelMeta =
      const VerificationMeta('zoomLevel');
  @override
  late final GeneratedColumn<double> zoomLevel = GeneratedColumn<double>(
      'zoom_level', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _lastViewportXMeta =
      const VerificationMeta('lastViewportX');
  @override
  late final GeneratedColumn<double> lastViewportX = GeneratedColumn<double>(
      'last_viewport_x', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastViewportYMeta =
      const VerificationMeta('lastViewportY');
  @override
  late final GeneratedColumn<double> lastViewportY = GeneratedColumn<double>(
      'last_viewport_y', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cachedImageMeta =
      const VerificationMeta('cachedImage');
  @override
  late final GeneratedColumn<Uint8List> cachedImage =
      GeneratedColumn<Uint8List>('cached_image', aliasedName, true,
          type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<int> lastModified = GeneratedColumn<int>(
      'last_modified', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        canvasWidth,
        canvasHeight,
        zoomLevel,
        lastViewportX,
        lastViewportY,
        cachedImage,
        createdAt,
        lastModified
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects_table';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('canvas_width')) {
      context.handle(
          _canvasWidthMeta,
          canvasWidth.isAcceptableOrUnknown(
              data['canvas_width']!, _canvasWidthMeta));
    }
    if (data.containsKey('canvas_height')) {
      context.handle(
          _canvasHeightMeta,
          canvasHeight.isAcceptableOrUnknown(
              data['canvas_height']!, _canvasHeightMeta));
    }
    if (data.containsKey('zoom_level')) {
      context.handle(_zoomLevelMeta,
          zoomLevel.isAcceptableOrUnknown(data['zoom_level']!, _zoomLevelMeta));
    }
    if (data.containsKey('last_viewport_x')) {
      context.handle(
          _lastViewportXMeta,
          lastViewportX.isAcceptableOrUnknown(
              data['last_viewport_x']!, _lastViewportXMeta));
    }
    if (data.containsKey('last_viewport_y')) {
      context.handle(
          _lastViewportYMeta,
          lastViewportY.isAcceptableOrUnknown(
              data['last_viewport_y']!, _lastViewportYMeta));
    }
    if (data.containsKey('cached_image')) {
      context.handle(
          _cachedImageMeta,
          cachedImage.isAcceptableOrUnknown(
              data['cached_image']!, _cachedImageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      canvasWidth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}canvas_width'])!,
      canvasHeight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}canvas_height'])!,
      zoomLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}zoom_level'])!,
      lastViewportX: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}last_viewport_x']),
      lastViewportY: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}last_viewport_y']),
      cachedImage: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}cached_image']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      lastModified: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_modified'])!,
    );
  }

  @override
  $ProjectsTableTable createAlias(String alias) {
    return $ProjectsTableTable(attachedDatabase, alias);
  }
}

class ProjectsTableData extends DataClass
    implements Insertable<ProjectsTableData> {
  final int id;
  final String name;
  final int canvasWidth;
  final int canvasHeight;
  final double zoomLevel;
  final double? lastViewportX;
  final double? lastViewportY;
  final Uint8List? cachedImage;
  final int createdAt;
  final int lastModified;
  const ProjectsTableData(
      {required this.id,
      required this.name,
      required this.canvasWidth,
      required this.canvasHeight,
      required this.zoomLevel,
      this.lastViewportX,
      this.lastViewportY,
      this.cachedImage,
      required this.createdAt,
      required this.lastModified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['canvas_width'] = Variable<int>(canvasWidth);
    map['canvas_height'] = Variable<int>(canvasHeight);
    map['zoom_level'] = Variable<double>(zoomLevel);
    if (!nullToAbsent || lastViewportX != null) {
      map['last_viewport_x'] = Variable<double>(lastViewportX);
    }
    if (!nullToAbsent || lastViewportY != null) {
      map['last_viewport_y'] = Variable<double>(lastViewportY);
    }
    if (!nullToAbsent || cachedImage != null) {
      map['cached_image'] = Variable<Uint8List>(cachedImage);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['last_modified'] = Variable<int>(lastModified);
    return map;
  }

  ProjectsTableCompanion toCompanion(bool nullToAbsent) {
    return ProjectsTableCompanion(
      id: Value(id),
      name: Value(name),
      canvasWidth: Value(canvasWidth),
      canvasHeight: Value(canvasHeight),
      zoomLevel: Value(zoomLevel),
      lastViewportX: lastViewportX == null && nullToAbsent
          ? const Value.absent()
          : Value(lastViewportX),
      lastViewportY: lastViewportY == null && nullToAbsent
          ? const Value.absent()
          : Value(lastViewportY),
      cachedImage: cachedImage == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedImage),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory ProjectsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      canvasWidth: serializer.fromJson<int>(json['canvasWidth']),
      canvasHeight: serializer.fromJson<int>(json['canvasHeight']),
      zoomLevel: serializer.fromJson<double>(json['zoomLevel']),
      lastViewportX: serializer.fromJson<double?>(json['lastViewportX']),
      lastViewportY: serializer.fromJson<double?>(json['lastViewportY']),
      cachedImage: serializer.fromJson<Uint8List?>(json['cachedImage']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastModified: serializer.fromJson<int>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'canvasWidth': serializer.toJson<int>(canvasWidth),
      'canvasHeight': serializer.toJson<int>(canvasHeight),
      'zoomLevel': serializer.toJson<double>(zoomLevel),
      'lastViewportX': serializer.toJson<double?>(lastViewportX),
      'lastViewportY': serializer.toJson<double?>(lastViewportY),
      'cachedImage': serializer.toJson<Uint8List?>(cachedImage),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastModified': serializer.toJson<int>(lastModified),
    };
  }

  ProjectsTableData copyWith(
          {int? id,
          String? name,
          int? canvasWidth,
          int? canvasHeight,
          double? zoomLevel,
          Value<double?> lastViewportX = const Value.absent(),
          Value<double?> lastViewportY = const Value.absent(),
          Value<Uint8List?> cachedImage = const Value.absent(),
          int? createdAt,
          int? lastModified}) =>
      ProjectsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        canvasWidth: canvasWidth ?? this.canvasWidth,
        canvasHeight: canvasHeight ?? this.canvasHeight,
        zoomLevel: zoomLevel ?? this.zoomLevel,
        lastViewportX:
            lastViewportX.present ? lastViewportX.value : this.lastViewportX,
        lastViewportY:
            lastViewportY.present ? lastViewportY.value : this.lastViewportY,
        cachedImage: cachedImage.present ? cachedImage.value : this.cachedImage,
        createdAt: createdAt ?? this.createdAt,
        lastModified: lastModified ?? this.lastModified,
      );
  ProjectsTableData copyWithCompanion(ProjectsTableCompanion data) {
    return ProjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      canvasWidth:
          data.canvasWidth.present ? data.canvasWidth.value : this.canvasWidth,
      canvasHeight: data.canvasHeight.present
          ? data.canvasHeight.value
          : this.canvasHeight,
      zoomLevel: data.zoomLevel.present ? data.zoomLevel.value : this.zoomLevel,
      lastViewportX: data.lastViewportX.present
          ? data.lastViewportX.value
          : this.lastViewportX,
      lastViewportY: data.lastViewportY.present
          ? data.lastViewportY.value
          : this.lastViewportY,
      cachedImage:
          data.cachedImage.present ? data.cachedImage.value : this.cachedImage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('canvasWidth: $canvasWidth, ')
          ..write('canvasHeight: $canvasHeight, ')
          ..write('zoomLevel: $zoomLevel, ')
          ..write('lastViewportX: $lastViewportX, ')
          ..write('lastViewportY: $lastViewportY, ')
          ..write('cachedImage: $cachedImage, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      canvasWidth,
      canvasHeight,
      zoomLevel,
      lastViewportX,
      lastViewportY,
      $driftBlobEquality.hash(cachedImage),
      createdAt,
      lastModified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.canvasWidth == this.canvasWidth &&
          other.canvasHeight == this.canvasHeight &&
          other.zoomLevel == this.zoomLevel &&
          other.lastViewportX == this.lastViewportX &&
          other.lastViewportY == this.lastViewportY &&
          $driftBlobEquality.equals(other.cachedImage, this.cachedImage) &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class ProjectsTableCompanion extends UpdateCompanion<ProjectsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> canvasWidth;
  final Value<int> canvasHeight;
  final Value<double> zoomLevel;
  final Value<double?> lastViewportX;
  final Value<double?> lastViewportY;
  final Value<Uint8List?> cachedImage;
  final Value<int> createdAt;
  final Value<int> lastModified;
  const ProjectsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.canvasWidth = const Value.absent(),
    this.canvasHeight = const Value.absent(),
    this.zoomLevel = const Value.absent(),
    this.lastViewportX = const Value.absent(),
    this.lastViewportY = const Value.absent(),
    this.cachedImage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  ProjectsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.canvasWidth = const Value.absent(),
    this.canvasHeight = const Value.absent(),
    this.zoomLevel = const Value.absent(),
    this.lastViewportX = const Value.absent(),
    this.lastViewportY = const Value.absent(),
    this.cachedImage = const Value.absent(),
    required int createdAt,
    required int lastModified,
  })  : name = Value(name),
        createdAt = Value(createdAt),
        lastModified = Value(lastModified);
  static Insertable<ProjectsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? canvasWidth,
    Expression<int>? canvasHeight,
    Expression<double>? zoomLevel,
    Expression<double>? lastViewportX,
    Expression<double>? lastViewportY,
    Expression<Uint8List>? cachedImage,
    Expression<int>? createdAt,
    Expression<int>? lastModified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (canvasWidth != null) 'canvas_width': canvasWidth,
      if (canvasHeight != null) 'canvas_height': canvasHeight,
      if (zoomLevel != null) 'zoom_level': zoomLevel,
      if (lastViewportX != null) 'last_viewport_x': lastViewportX,
      if (lastViewportY != null) 'last_viewport_y': lastViewportY,
      if (cachedImage != null) 'cached_image': cachedImage,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
    });
  }

  ProjectsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? canvasWidth,
      Value<int>? canvasHeight,
      Value<double>? zoomLevel,
      Value<double?>? lastViewportX,
      Value<double?>? lastViewportY,
      Value<Uint8List?>? cachedImage,
      Value<int>? createdAt,
      Value<int>? lastModified}) {
    return ProjectsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      lastViewportX: lastViewportX ?? this.lastViewportX,
      lastViewportY: lastViewportY ?? this.lastViewportY,
      cachedImage: cachedImage ?? this.cachedImage,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (canvasWidth.present) {
      map['canvas_width'] = Variable<int>(canvasWidth.value);
    }
    if (canvasHeight.present) {
      map['canvas_height'] = Variable<int>(canvasHeight.value);
    }
    if (zoomLevel.present) {
      map['zoom_level'] = Variable<double>(zoomLevel.value);
    }
    if (lastViewportX.present) {
      map['last_viewport_x'] = Variable<double>(lastViewportX.value);
    }
    if (lastViewportY.present) {
      map['last_viewport_y'] = Variable<double>(lastViewportY.value);
    }
    if (cachedImage.present) {
      map['cached_image'] = Variable<Uint8List>(cachedImage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<int>(lastModified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('canvasWidth: $canvasWidth, ')
          ..write('canvasHeight: $canvasHeight, ')
          ..write('zoomLevel: $zoomLevel, ')
          ..write('lastViewportX: $lastViewportX, ')
          ..write('lastViewportY: $lastViewportY, ')
          ..write('cachedImage: $cachedImage, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }
}

class $LayersTableTable extends LayersTable
    with TableInfo<$LayersTableTable, LayersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects_table (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isVisibleMeta =
      const VerificationMeta('isVisible');
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
      'is_visible', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_visible" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isLockedMeta =
      const VerificationMeta('isLocked');
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
      'is_locked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_locked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isBackgroundMeta =
      const VerificationMeta('isBackground');
  @override
  late final GeneratedColumn<bool> isBackground = GeneratedColumn<bool>(
      'is_background', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_background" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _opacityMeta =
      const VerificationMeta('opacity');
  @override
  late final GeneratedColumn<double> opacity = GeneratedColumn<double>(
      'opacity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, name, isVisible, isLocked, isBackground, opacity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layers_table';
  @override
  VerificationContext validateIntegrity(Insertable<LayersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_visible')) {
      context.handle(_isVisibleMeta,
          isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta));
    }
    if (data.containsKey('is_locked')) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta));
    }
    if (data.containsKey('is_background')) {
      context.handle(
          _isBackgroundMeta,
          isBackground.isAcceptableOrUnknown(
              data['is_background']!, _isBackgroundMeta));
    }
    if (data.containsKey('opacity')) {
      context.handle(_opacityMeta,
          opacity.isAcceptableOrUnknown(data['opacity']!, _opacityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LayersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isVisible: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_visible'])!,
      isLocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_locked'])!,
      isBackground: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_background'])!,
      opacity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}opacity'])!,
    );
  }

  @override
  $LayersTableTable createAlias(String alias) {
    return $LayersTableTable(attachedDatabase, alias);
  }
}

class LayersTableData extends DataClass implements Insertable<LayersTableData> {
  final int id;
  final int projectId;
  final String name;
  final bool isVisible;
  final bool isLocked;
  final bool isBackground;
  final double opacity;
  const LayersTableData(
      {required this.id,
      required this.projectId,
      required this.name,
      required this.isVisible,
      required this.isLocked,
      required this.isBackground,
      required this.opacity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['name'] = Variable<String>(name);
    map['is_visible'] = Variable<bool>(isVisible);
    map['is_locked'] = Variable<bool>(isLocked);
    map['is_background'] = Variable<bool>(isBackground);
    map['opacity'] = Variable<double>(opacity);
    return map;
  }

  LayersTableCompanion toCompanion(bool nullToAbsent) {
    return LayersTableCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      isVisible: Value(isVisible),
      isLocked: Value(isLocked),
      isBackground: Value(isBackground),
      opacity: Value(opacity),
    );
  }

  factory LayersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayersTableData(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      isBackground: serializer.fromJson<bool>(json['isBackground']),
      opacity: serializer.fromJson<double>(json['opacity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'name': serializer.toJson<String>(name),
      'isVisible': serializer.toJson<bool>(isVisible),
      'isLocked': serializer.toJson<bool>(isLocked),
      'isBackground': serializer.toJson<bool>(isBackground),
      'opacity': serializer.toJson<double>(opacity),
    };
  }

  LayersTableData copyWith(
          {int? id,
          int? projectId,
          String? name,
          bool? isVisible,
          bool? isLocked,
          bool? isBackground,
          double? opacity}) =>
      LayersTableData(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        name: name ?? this.name,
        isVisible: isVisible ?? this.isVisible,
        isLocked: isLocked ?? this.isLocked,
        isBackground: isBackground ?? this.isBackground,
        opacity: opacity ?? this.opacity,
      );
  LayersTableData copyWithCompanion(LayersTableCompanion data) {
    return LayersTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      isBackground: data.isBackground.present
          ? data.isBackground.value
          : this.isBackground,
      opacity: data.opacity.present ? data.opacity.value : this.opacity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayersTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('isVisible: $isVisible, ')
          ..write('isLocked: $isLocked, ')
          ..write('isBackground: $isBackground, ')
          ..write('opacity: $opacity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, projectId, name, isVisible, isLocked, isBackground, opacity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayersTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.isVisible == this.isVisible &&
          other.isLocked == this.isLocked &&
          other.isBackground == this.isBackground &&
          other.opacity == this.opacity);
}

class LayersTableCompanion extends UpdateCompanion<LayersTableData> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> name;
  final Value<bool> isVisible;
  final Value<bool> isLocked;
  final Value<bool> isBackground;
  final Value<double> opacity;
  const LayersTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.isBackground = const Value.absent(),
    this.opacity = const Value.absent(),
  });
  LayersTableCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String name,
    this.isVisible = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.isBackground = const Value.absent(),
    this.opacity = const Value.absent(),
  })  : projectId = Value(projectId),
        name = Value(name);
  static Insertable<LayersTableData> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? name,
    Expression<bool>? isVisible,
    Expression<bool>? isLocked,
    Expression<bool>? isBackground,
    Expression<double>? opacity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (isVisible != null) 'is_visible': isVisible,
      if (isLocked != null) 'is_locked': isLocked,
      if (isBackground != null) 'is_background': isBackground,
      if (opacity != null) 'opacity': opacity,
    });
  }

  LayersTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? projectId,
      Value<String>? name,
      Value<bool>? isVisible,
      Value<bool>? isLocked,
      Value<bool>? isBackground,
      Value<double>? opacity}) {
    return LayersTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      isBackground: isBackground ?? this.isBackground,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (isBackground.present) {
      map['is_background'] = Variable<bool>(isBackground.value);
    }
    if (opacity.present) {
      map['opacity'] = Variable<double>(opacity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayersTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('isVisible: $isVisible, ')
          ..write('isLocked: $isLocked, ')
          ..write('isBackground: $isBackground, ')
          ..write('opacity: $opacity')
          ..write(')'))
        .toString();
  }
}

class $LayerStatesTableTable extends LayerStatesTable
    with TableInfo<$LayerStatesTableTable, LayerStatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayerStatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _layerIdMeta =
      const VerificationMeta('layerId');
  @override
  late final GeneratedColumn<int> layerId = GeneratedColumn<int>(
      'layer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES layers_table (id)'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects_table (id)'));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<String> points = GeneratedColumn<String>(
      'points', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brushIdMeta =
      const VerificationMeta('brushId');
  @override
  late final GeneratedColumn<int> brushId = GeneratedColumn<int>(
      'brush_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
      'width', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, layerId, projectId, order, points, brushId, colorValue, width];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layer_states_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LayerStatesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('layer_id')) {
      context.handle(_layerIdMeta,
          layerId.isAcceptableOrUnknown(data['layer_id']!, _layerIdMeta));
    } else if (isInserting) {
      context.missing(_layerIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('brush_id')) {
      context.handle(_brushIdMeta,
          brushId.isAcceptableOrUnknown(data['brush_id']!, _brushIdMeta));
    } else if (isInserting) {
      context.missing(_brushIdMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LayerStatesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayerStatesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      layerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}layer_id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order']),
      points: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}points'])!,
      brushId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}brush_id'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}width'])!,
    );
  }

  @override
  $LayerStatesTableTable createAlias(String alias) {
    return $LayerStatesTableTable(attachedDatabase, alias);
  }
}

class LayerStatesTableData extends DataClass
    implements Insertable<LayerStatesTableData> {
  final int id;
  final int layerId;
  final int projectId;
  final int? order;
  final String points;
  final int brushId;
  final int colorValue;
  final double width;
  const LayerStatesTableData(
      {required this.id,
      required this.layerId,
      required this.projectId,
      this.order,
      required this.points,
      required this.brushId,
      required this.colorValue,
      required this.width});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['layer_id'] = Variable<int>(layerId);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    map['points'] = Variable<String>(points);
    map['brush_id'] = Variable<int>(brushId);
    map['color_value'] = Variable<int>(colorValue);
    map['width'] = Variable<double>(width);
    return map;
  }

  LayerStatesTableCompanion toCompanion(bool nullToAbsent) {
    return LayerStatesTableCompanion(
      id: Value(id),
      layerId: Value(layerId),
      projectId: Value(projectId),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      points: Value(points),
      brushId: Value(brushId),
      colorValue: Value(colorValue),
      width: Value(width),
    );
  }

  factory LayerStatesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayerStatesTableData(
      id: serializer.fromJson<int>(json['id']),
      layerId: serializer.fromJson<int>(json['layerId']),
      projectId: serializer.fromJson<int>(json['projectId']),
      order: serializer.fromJson<int?>(json['order']),
      points: serializer.fromJson<String>(json['points']),
      brushId: serializer.fromJson<int>(json['brushId']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      width: serializer.fromJson<double>(json['width']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'layerId': serializer.toJson<int>(layerId),
      'projectId': serializer.toJson<int>(projectId),
      'order': serializer.toJson<int?>(order),
      'points': serializer.toJson<String>(points),
      'brushId': serializer.toJson<int>(brushId),
      'colorValue': serializer.toJson<int>(colorValue),
      'width': serializer.toJson<double>(width),
    };
  }

  LayerStatesTableData copyWith(
          {int? id,
          int? layerId,
          int? projectId,
          Value<int?> order = const Value.absent(),
          String? points,
          int? brushId,
          int? colorValue,
          double? width}) =>
      LayerStatesTableData(
        id: id ?? this.id,
        layerId: layerId ?? this.layerId,
        projectId: projectId ?? this.projectId,
        order: order.present ? order.value : this.order,
        points: points ?? this.points,
        brushId: brushId ?? this.brushId,
        colorValue: colorValue ?? this.colorValue,
        width: width ?? this.width,
      );
  LayerStatesTableData copyWithCompanion(LayerStatesTableCompanion data) {
    return LayerStatesTableData(
      id: data.id.present ? data.id.value : this.id,
      layerId: data.layerId.present ? data.layerId.value : this.layerId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      order: data.order.present ? data.order.value : this.order,
      points: data.points.present ? data.points.value : this.points,
      brushId: data.brushId.present ? data.brushId.value : this.brushId,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      width: data.width.present ? data.width.value : this.width,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayerStatesTableData(')
          ..write('id: $id, ')
          ..write('layerId: $layerId, ')
          ..write('projectId: $projectId, ')
          ..write('order: $order, ')
          ..write('points: $points, ')
          ..write('brushId: $brushId, ')
          ..write('colorValue: $colorValue, ')
          ..write('width: $width')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, layerId, projectId, order, points, brushId, colorValue, width);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayerStatesTableData &&
          other.id == this.id &&
          other.layerId == this.layerId &&
          other.projectId == this.projectId &&
          other.order == this.order &&
          other.points == this.points &&
          other.brushId == this.brushId &&
          other.colorValue == this.colorValue &&
          other.width == this.width);
}

class LayerStatesTableCompanion extends UpdateCompanion<LayerStatesTableData> {
  final Value<int> id;
  final Value<int> layerId;
  final Value<int> projectId;
  final Value<int?> order;
  final Value<String> points;
  final Value<int> brushId;
  final Value<int> colorValue;
  final Value<double> width;
  const LayerStatesTableCompanion({
    this.id = const Value.absent(),
    this.layerId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.order = const Value.absent(),
    this.points = const Value.absent(),
    this.brushId = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.width = const Value.absent(),
  });
  LayerStatesTableCompanion.insert({
    this.id = const Value.absent(),
    required int layerId,
    required int projectId,
    this.order = const Value.absent(),
    required String points,
    required int brushId,
    required int colorValue,
    required double width,
  })  : layerId = Value(layerId),
        projectId = Value(projectId),
        points = Value(points),
        brushId = Value(brushId),
        colorValue = Value(colorValue),
        width = Value(width);
  static Insertable<LayerStatesTableData> custom({
    Expression<int>? id,
    Expression<int>? layerId,
    Expression<int>? projectId,
    Expression<int>? order,
    Expression<String>? points,
    Expression<int>? brushId,
    Expression<int>? colorValue,
    Expression<double>? width,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (layerId != null) 'layer_id': layerId,
      if (projectId != null) 'project_id': projectId,
      if (order != null) 'order': order,
      if (points != null) 'points': points,
      if (brushId != null) 'brush_id': brushId,
      if (colorValue != null) 'color_value': colorValue,
      if (width != null) 'width': width,
    });
  }

  LayerStatesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? layerId,
      Value<int>? projectId,
      Value<int?>? order,
      Value<String>? points,
      Value<int>? brushId,
      Value<int>? colorValue,
      Value<double>? width}) {
    return LayerStatesTableCompanion(
      id: id ?? this.id,
      layerId: layerId ?? this.layerId,
      projectId: projectId ?? this.projectId,
      order: order ?? this.order,
      points: points ?? this.points,
      brushId: brushId ?? this.brushId,
      colorValue: colorValue ?? this.colorValue,
      width: width ?? this.width,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (layerId.present) {
      map['layer_id'] = Variable<int>(layerId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (points.present) {
      map['points'] = Variable<String>(points.value);
    }
    if (brushId.present) {
      map['brush_id'] = Variable<int>(brushId.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayerStatesTableCompanion(')
          ..write('id: $id, ')
          ..write('layerId: $layerId, ')
          ..write('projectId: $projectId, ')
          ..write('order: $order, ')
          ..write('points: $points, ')
          ..write('brushId: $brushId, ')
          ..write('colorValue: $colorValue, ')
          ..write('width: $width')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTableTable projectsTable = $ProjectsTableTable(this);
  late final $LayersTableTable layersTable = $LayersTableTable(this);
  late final $LayerStatesTableTable layerStatesTable =
      $LayerStatesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projectsTable, layersTable, layerStatesTable];
}

typedef $$ProjectsTableTableCreateCompanionBuilder = ProjectsTableCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int> canvasWidth,
  Value<int> canvasHeight,
  Value<double> zoomLevel,
  Value<double?> lastViewportX,
  Value<double?> lastViewportY,
  Value<Uint8List?> cachedImage,
  required int createdAt,
  required int lastModified,
});
typedef $$ProjectsTableTableUpdateCompanionBuilder = ProjectsTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> canvasWidth,
  Value<int> canvasHeight,
  Value<double> zoomLevel,
  Value<double?> lastViewportX,
  Value<double?> lastViewportY,
  Value<Uint8List?> cachedImage,
  Value<int> createdAt,
  Value<int> lastModified,
});

final class $$ProjectsTableTableReferences extends BaseReferences<_$AppDatabase,
    $ProjectsTableTable, ProjectsTableData> {
  $$ProjectsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LayersTableTable, List<LayersTableData>>
      _layersTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.layersTable,
              aliasName: $_aliasNameGenerator(
                  db.projectsTable.id, db.layersTable.projectId));

  $$LayersTableTableProcessedTableManager get layersTableRefs {
    final manager = $$LayersTableTableTableManager($_db, $_db.layersTable)
        .filter((f) => f.projectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_layersTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LayerStatesTableTable, List<LayerStatesTableData>>
      _layerStatesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.layerStatesTable,
              aliasName: $_aliasNameGenerator(
                  db.projectsTable.id, db.layerStatesTable.projectId));

  $$LayerStatesTableTableProcessedTableManager get layerStatesTableRefs {
    final manager =
        $$LayerStatesTableTableTableManager($_db, $_db.layerStatesTable)
            .filter((f) => f.projectId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_layerStatesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get canvasWidth => $state.composableBuilder(
      column: $state.table.canvasWidth,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get canvasHeight => $state.composableBuilder(
      column: $state.table.canvasHeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get zoomLevel => $state.composableBuilder(
      column: $state.table.zoomLevel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastViewportX => $state.composableBuilder(
      column: $state.table.lastViewportX,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastViewportY => $state.composableBuilder(
      column: $state.table.lastViewportY,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<Uint8List> get cachedImage => $state.composableBuilder(
      column: $state.table.cachedImage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastModified => $state.composableBuilder(
      column: $state.table.lastModified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter layersTableRefs(
      ComposableFilter Function($$LayersTableTableFilterComposer f) f) {
    final $$LayersTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.layersTable,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder, parentComposers) =>
            $$LayersTableTableFilterComposer(ComposerState($state.db,
                $state.db.layersTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter layerStatesTableRefs(
      ComposableFilter Function($$LayerStatesTableTableFilterComposer f) f) {
    final $$LayerStatesTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.layerStatesTable,
            getReferencedColumn: (t) => t.projectId,
            builder: (joinBuilder, parentComposers) =>
                $$LayerStatesTableTableFilterComposer(ComposerState($state.db,
                    $state.db.layerStatesTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProjectsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get canvasWidth => $state.composableBuilder(
      column: $state.table.canvasWidth,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get canvasHeight => $state.composableBuilder(
      column: $state.table.canvasHeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get zoomLevel => $state.composableBuilder(
      column: $state.table.zoomLevel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastViewportX => $state.composableBuilder(
      column: $state.table.lastViewportX,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastViewportY => $state.composableBuilder(
      column: $state.table.lastViewportY,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<Uint8List> get cachedImage => $state.composableBuilder(
      column: $state.table.cachedImage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastModified => $state.composableBuilder(
      column: $state.table.lastModified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ProjectsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTableTable,
    ProjectsTableData,
    $$ProjectsTableTableFilterComposer,
    $$ProjectsTableTableOrderingComposer,
    $$ProjectsTableTableCreateCompanionBuilder,
    $$ProjectsTableTableUpdateCompanionBuilder,
    (ProjectsTableData, $$ProjectsTableTableReferences),
    ProjectsTableData,
    PrefetchHooks Function({bool layersTableRefs, bool layerStatesTableRefs})> {
  $$ProjectsTableTableTableManager(_$AppDatabase db, $ProjectsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProjectsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProjectsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> canvasWidth = const Value.absent(),
            Value<int> canvasHeight = const Value.absent(),
            Value<double> zoomLevel = const Value.absent(),
            Value<double?> lastViewportX = const Value.absent(),
            Value<double?> lastViewportY = const Value.absent(),
            Value<Uint8List?> cachedImage = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> lastModified = const Value.absent(),
          }) =>
              ProjectsTableCompanion(
            id: id,
            name: name,
            canvasWidth: canvasWidth,
            canvasHeight: canvasHeight,
            zoomLevel: zoomLevel,
            lastViewportX: lastViewportX,
            lastViewportY: lastViewportY,
            cachedImage: cachedImage,
            createdAt: createdAt,
            lastModified: lastModified,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> canvasWidth = const Value.absent(),
            Value<int> canvasHeight = const Value.absent(),
            Value<double> zoomLevel = const Value.absent(),
            Value<double?> lastViewportX = const Value.absent(),
            Value<double?> lastViewportY = const Value.absent(),
            Value<Uint8List?> cachedImage = const Value.absent(),
            required int createdAt,
            required int lastModified,
          }) =>
              ProjectsTableCompanion.insert(
            id: id,
            name: name,
            canvasWidth: canvasWidth,
            canvasHeight: canvasHeight,
            zoomLevel: zoomLevel,
            lastViewportX: lastViewportX,
            lastViewportY: lastViewportY,
            cachedImage: cachedImage,
            createdAt: createdAt,
            lastModified: lastModified,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProjectsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {layersTableRefs = false, layerStatesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (layersTableRefs) db.layersTable,
                if (layerStatesTableRefs) db.layerStatesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (layersTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ProjectsTableTableReferences
                            ._layersTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableTableReferences(db, table, p0)
                                .layersTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (layerStatesTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ProjectsTableTableReferences
                            ._layerStatesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableTableReferences(db, table, p0)
                                .layerStatesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTableTable,
    ProjectsTableData,
    $$ProjectsTableTableFilterComposer,
    $$ProjectsTableTableOrderingComposer,
    $$ProjectsTableTableCreateCompanionBuilder,
    $$ProjectsTableTableUpdateCompanionBuilder,
    (ProjectsTableData, $$ProjectsTableTableReferences),
    ProjectsTableData,
    PrefetchHooks Function({bool layersTableRefs, bool layerStatesTableRefs})>;
typedef $$LayersTableTableCreateCompanionBuilder = LayersTableCompanion
    Function({
  Value<int> id,
  required int projectId,
  required String name,
  Value<bool> isVisible,
  Value<bool> isLocked,
  Value<bool> isBackground,
  Value<double> opacity,
});
typedef $$LayersTableTableUpdateCompanionBuilder = LayersTableCompanion
    Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> name,
  Value<bool> isVisible,
  Value<bool> isLocked,
  Value<bool> isBackground,
  Value<double> opacity,
});

final class $$LayersTableTableReferences
    extends BaseReferences<_$AppDatabase, $LayersTableTable, LayersTableData> {
  $$LayersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTableTable _projectIdTable(_$AppDatabase db) =>
      db.projectsTable.createAlias(
          $_aliasNameGenerator(db.layersTable.projectId, db.projectsTable.id));

  $$ProjectsTableTableProcessedTableManager? get projectId {
    if ($_item.projectId == null) return null;
    final manager = $$ProjectsTableTableTableManager($_db, $_db.projectsTable)
        .filter((f) => f.id($_item.projectId!));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LayerStatesTableTable, List<LayerStatesTableData>>
      _layerStatesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.layerStatesTable,
              aliasName: $_aliasNameGenerator(
                  db.layersTable.id, db.layerStatesTable.layerId));

  $$LayerStatesTableTableProcessedTableManager get layerStatesTableRefs {
    final manager =
        $$LayerStatesTableTableTableManager($_db, $_db.layerStatesTable)
            .filter((f) => f.layerId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_layerStatesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LayersTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LayersTableTable> {
  $$LayersTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isVisible => $state.composableBuilder(
      column: $state.table.isVisible,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isLocked => $state.composableBuilder(
      column: $state.table.isLocked,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isBackground => $state.composableBuilder(
      column: $state.table.isBackground,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get opacity => $state.composableBuilder(
      column: $state.table.opacity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProjectsTableTableFilterComposer get projectId {
    final $$ProjectsTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $state.db.projectsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProjectsTableTableFilterComposer(ComposerState($state.db,
                $state.db.projectsTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter layerStatesTableRefs(
      ComposableFilter Function($$LayerStatesTableTableFilterComposer f) f) {
    final $$LayerStatesTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.layerStatesTable,
            getReferencedColumn: (t) => t.layerId,
            builder: (joinBuilder, parentComposers) =>
                $$LayerStatesTableTableFilterComposer(ComposerState($state.db,
                    $state.db.layerStatesTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$LayersTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LayersTableTable> {
  $$LayersTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isVisible => $state.composableBuilder(
      column: $state.table.isVisible,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isLocked => $state.composableBuilder(
      column: $state.table.isLocked,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isBackground => $state.composableBuilder(
      column: $state.table.isBackground,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get opacity => $state.composableBuilder(
      column: $state.table.opacity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProjectsTableTableOrderingComposer get projectId {
    final $$ProjectsTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.projectId,
            referencedTable: $state.db.projectsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProjectsTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.projectsTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$LayersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LayersTableTable,
    LayersTableData,
    $$LayersTableTableFilterComposer,
    $$LayersTableTableOrderingComposer,
    $$LayersTableTableCreateCompanionBuilder,
    $$LayersTableTableUpdateCompanionBuilder,
    (LayersTableData, $$LayersTableTableReferences),
    LayersTableData,
    PrefetchHooks Function({bool projectId, bool layerStatesTableRefs})> {
  $$LayersTableTableTableManager(_$AppDatabase db, $LayersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LayersTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LayersTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> projectId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            Value<bool> isBackground = const Value.absent(),
            Value<double> opacity = const Value.absent(),
          }) =>
              LayersTableCompanion(
            id: id,
            projectId: projectId,
            name: name,
            isVisible: isVisible,
            isLocked: isLocked,
            isBackground: isBackground,
            opacity: opacity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int projectId,
            required String name,
            Value<bool> isVisible = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            Value<bool> isBackground = const Value.absent(),
            Value<double> opacity = const Value.absent(),
          }) =>
              LayersTableCompanion.insert(
            id: id,
            projectId: projectId,
            name: name,
            isVisible: isVisible,
            isLocked: isLocked,
            isBackground: isBackground,
            opacity: opacity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LayersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {projectId = false, layerStatesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (layerStatesTableRefs) db.layerStatesTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$LayersTableTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$LayersTableTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (layerStatesTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$LayersTableTableReferences
                            ._layerStatesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LayersTableTableReferences(db, table, p0)
                                .layerStatesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.layerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LayersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LayersTableTable,
    LayersTableData,
    $$LayersTableTableFilterComposer,
    $$LayersTableTableOrderingComposer,
    $$LayersTableTableCreateCompanionBuilder,
    $$LayersTableTableUpdateCompanionBuilder,
    (LayersTableData, $$LayersTableTableReferences),
    LayersTableData,
    PrefetchHooks Function({bool projectId, bool layerStatesTableRefs})>;
typedef $$LayerStatesTableTableCreateCompanionBuilder
    = LayerStatesTableCompanion Function({
  Value<int> id,
  required int layerId,
  required int projectId,
  Value<int?> order,
  required String points,
  required int brushId,
  required int colorValue,
  required double width,
});
typedef $$LayerStatesTableTableUpdateCompanionBuilder
    = LayerStatesTableCompanion Function({
  Value<int> id,
  Value<int> layerId,
  Value<int> projectId,
  Value<int?> order,
  Value<String> points,
  Value<int> brushId,
  Value<int> colorValue,
  Value<double> width,
});

final class $$LayerStatesTableTableReferences extends BaseReferences<
    _$AppDatabase, $LayerStatesTableTable, LayerStatesTableData> {
  $$LayerStatesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LayersTableTable _layerIdTable(_$AppDatabase db) =>
      db.layersTable.createAlias(
          $_aliasNameGenerator(db.layerStatesTable.layerId, db.layersTable.id));

  $$LayersTableTableProcessedTableManager? get layerId {
    if ($_item.layerId == null) return null;
    final manager = $$LayersTableTableTableManager($_db, $_db.layersTable)
        .filter((f) => f.id($_item.layerId!));
    final item = $_typedResult.readTableOrNull(_layerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProjectsTableTable _projectIdTable(_$AppDatabase db) =>
      db.projectsTable.createAlias($_aliasNameGenerator(
          db.layerStatesTable.projectId, db.projectsTable.id));

  $$ProjectsTableTableProcessedTableManager? get projectId {
    if ($_item.projectId == null) return null;
    final manager = $$ProjectsTableTableTableManager($_db, $_db.projectsTable)
        .filter((f) => f.id($_item.projectId!));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LayerStatesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LayerStatesTableTable> {
  $$LayerStatesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get order => $state.composableBuilder(
      column: $state.table.order,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get points => $state.composableBuilder(
      column: $state.table.points,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get brushId => $state.composableBuilder(
      column: $state.table.brushId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get colorValue => $state.composableBuilder(
      column: $state.table.colorValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get width => $state.composableBuilder(
      column: $state.table.width,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$LayersTableTableFilterComposer get layerId {
    final $$LayersTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.layerId,
        referencedTable: $state.db.layersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$LayersTableTableFilterComposer(ComposerState($state.db,
                $state.db.layersTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProjectsTableTableFilterComposer get projectId {
    final $$ProjectsTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $state.db.projectsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProjectsTableTableFilterComposer(ComposerState($state.db,
                $state.db.projectsTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$LayerStatesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LayerStatesTableTable> {
  $$LayerStatesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get order => $state.composableBuilder(
      column: $state.table.order,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get points => $state.composableBuilder(
      column: $state.table.points,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get brushId => $state.composableBuilder(
      column: $state.table.brushId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get colorValue => $state.composableBuilder(
      column: $state.table.colorValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get width => $state.composableBuilder(
      column: $state.table.width,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$LayersTableTableOrderingComposer get layerId {
    final $$LayersTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.layerId,
        referencedTable: $state.db.layersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$LayersTableTableOrderingComposer(ComposerState($state.db,
                $state.db.layersTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProjectsTableTableOrderingComposer get projectId {
    final $$ProjectsTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.projectId,
            referencedTable: $state.db.projectsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProjectsTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.projectsTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$LayerStatesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LayerStatesTableTable,
    LayerStatesTableData,
    $$LayerStatesTableTableFilterComposer,
    $$LayerStatesTableTableOrderingComposer,
    $$LayerStatesTableTableCreateCompanionBuilder,
    $$LayerStatesTableTableUpdateCompanionBuilder,
    (LayerStatesTableData, $$LayerStatesTableTableReferences),
    LayerStatesTableData,
    PrefetchHooks Function({bool layerId, bool projectId})> {
  $$LayerStatesTableTableTableManager(
      _$AppDatabase db, $LayerStatesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LayerStatesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LayerStatesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> layerId = const Value.absent(),
            Value<int> projectId = const Value.absent(),
            Value<int?> order = const Value.absent(),
            Value<String> points = const Value.absent(),
            Value<int> brushId = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<double> width = const Value.absent(),
          }) =>
              LayerStatesTableCompanion(
            id: id,
            layerId: layerId,
            projectId: projectId,
            order: order,
            points: points,
            brushId: brushId,
            colorValue: colorValue,
            width: width,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int layerId,
            required int projectId,
            Value<int?> order = const Value.absent(),
            required String points,
            required int brushId,
            required int colorValue,
            required double width,
          }) =>
              LayerStatesTableCompanion.insert(
            id: id,
            layerId: layerId,
            projectId: projectId,
            order: order,
            points: points,
            brushId: brushId,
            colorValue: colorValue,
            width: width,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LayerStatesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({layerId = false, projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (layerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.layerId,
                    referencedTable:
                        $$LayerStatesTableTableReferences._layerIdTable(db),
                    referencedColumn:
                        $$LayerStatesTableTableReferences._layerIdTable(db).id,
                  ) as T;
                }
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$LayerStatesTableTableReferences._projectIdTable(db),
                    referencedColumn: $$LayerStatesTableTableReferences
                        ._projectIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LayerStatesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LayerStatesTableTable,
    LayerStatesTableData,
    $$LayerStatesTableTableFilterComposer,
    $$LayerStatesTableTableOrderingComposer,
    $$LayerStatesTableTableCreateCompanionBuilder,
    $$LayerStatesTableTableUpdateCompanionBuilder,
    (LayerStatesTableData, $$LayerStatesTableTableReferences),
    LayerStatesTableData,
    PrefetchHooks Function({bool layerId, bool projectId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableTableManager get projectsTable =>
      $$ProjectsTableTableTableManager(_db, _db.projectsTable);
  $$LayersTableTableTableManager get layersTable =>
      $$LayersTableTableTableManager(_db, _db.layersTable);
  $$LayerStatesTableTableTableManager get layerStatesTable =>
      $$LayerStatesTableTableTableManager(_db, _db.layerStatesTable);
}
