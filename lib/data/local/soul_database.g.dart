// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soul_database.dart';

// ignore_for_file: type=lint
class $UserJourneysTable extends UserJourneys
    with TableInfo<$UserJourneysTable, UserJourneyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserJourneysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _journeyCodeMeta = const VerificationMeta(
    'journeyCode',
  );
  @override
  late final GeneratedColumn<String> journeyCode = GeneratedColumn<String>(
    'journey_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedOnMeta = const VerificationMeta(
    'startedOn',
  );
  @override
  late final GeneratedColumn<String> startedOn = GeneratedColumn<String>(
    'started_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journeyCode,
    locale,
    status,
    startedOn,
    timezone,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_journeys';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserJourneyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journey_code')) {
      context.handle(
        _journeyCodeMeta,
        journeyCode.isAcceptableOrUnknown(
          data['journey_code']!,
          _journeyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_journeyCodeMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_on')) {
      context.handle(
        _startedOnMeta,
        startedOn.isAcceptableOrUnknown(data['started_on']!, _startedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_startedOnMeta);
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserJourneyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserJourneyRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      journeyCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}journey_code'],
          )!,
      locale:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}locale'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      startedOn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}started_on'],
          )!,
      timezone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}timezone'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $UserJourneysTable createAlias(String alias) {
    return $UserJourneysTable(attachedDatabase, alias);
  }
}

class UserJourneyRow extends DataClass implements Insertable<UserJourneyRow> {
  final String id;
  final String journeyCode;
  final String locale;

  /// `active`, `completed` or `restarted`.
  final String status;

  /// Local calendar date (`yyyy-MM-dd`) of Day 1 in [timezone].
  final String startedOn;

  /// IANA timezone the run was started in.
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserJourneyRow({
    required this.id,
    required this.journeyCode,
    required this.locale,
    required this.status,
    required this.startedOn,
    required this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journey_code'] = Variable<String>(journeyCode);
    map['locale'] = Variable<String>(locale);
    map['status'] = Variable<String>(status);
    map['started_on'] = Variable<String>(startedOn);
    map['timezone'] = Variable<String>(timezone);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserJourneysCompanion toCompanion(bool nullToAbsent) {
    return UserJourneysCompanion(
      id: Value(id),
      journeyCode: Value(journeyCode),
      locale: Value(locale),
      status: Value(status),
      startedOn: Value(startedOn),
      timezone: Value(timezone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserJourneyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserJourneyRow(
      id: serializer.fromJson<String>(json['id']),
      journeyCode: serializer.fromJson<String>(json['journeyCode']),
      locale: serializer.fromJson<String>(json['locale']),
      status: serializer.fromJson<String>(json['status']),
      startedOn: serializer.fromJson<String>(json['startedOn']),
      timezone: serializer.fromJson<String>(json['timezone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journeyCode': serializer.toJson<String>(journeyCode),
      'locale': serializer.toJson<String>(locale),
      'status': serializer.toJson<String>(status),
      'startedOn': serializer.toJson<String>(startedOn),
      'timezone': serializer.toJson<String>(timezone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserJourneyRow copyWith({
    String? id,
    String? journeyCode,
    String? locale,
    String? status,
    String? startedOn,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserJourneyRow(
    id: id ?? this.id,
    journeyCode: journeyCode ?? this.journeyCode,
    locale: locale ?? this.locale,
    status: status ?? this.status,
    startedOn: startedOn ?? this.startedOn,
    timezone: timezone ?? this.timezone,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserJourneyRow copyWithCompanion(UserJourneysCompanion data) {
    return UserJourneyRow(
      id: data.id.present ? data.id.value : this.id,
      journeyCode:
          data.journeyCode.present ? data.journeyCode.value : this.journeyCode,
      locale: data.locale.present ? data.locale.value : this.locale,
      status: data.status.present ? data.status.value : this.status,
      startedOn: data.startedOn.present ? data.startedOn.value : this.startedOn,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserJourneyRow(')
          ..write('id: $id, ')
          ..write('journeyCode: $journeyCode, ')
          ..write('locale: $locale, ')
          ..write('status: $status, ')
          ..write('startedOn: $startedOn, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journeyCode,
    locale,
    status,
    startedOn,
    timezone,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserJourneyRow &&
          other.id == this.id &&
          other.journeyCode == this.journeyCode &&
          other.locale == this.locale &&
          other.status == this.status &&
          other.startedOn == this.startedOn &&
          other.timezone == this.timezone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserJourneysCompanion extends UpdateCompanion<UserJourneyRow> {
  final Value<String> id;
  final Value<String> journeyCode;
  final Value<String> locale;
  final Value<String> status;
  final Value<String> startedOn;
  final Value<String> timezone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserJourneysCompanion({
    this.id = const Value.absent(),
    this.journeyCode = const Value.absent(),
    this.locale = const Value.absent(),
    this.status = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.timezone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserJourneysCompanion.insert({
    required String id,
    required String journeyCode,
    required String locale,
    required String status,
    required String startedOn,
    required String timezone,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       journeyCode = Value(journeyCode),
       locale = Value(locale),
       status = Value(status),
       startedOn = Value(startedOn),
       timezone = Value(timezone),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserJourneyRow> custom({
    Expression<String>? id,
    Expression<String>? journeyCode,
    Expression<String>? locale,
    Expression<String>? status,
    Expression<String>? startedOn,
    Expression<String>? timezone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journeyCode != null) 'journey_code': journeyCode,
      if (locale != null) 'locale': locale,
      if (status != null) 'status': status,
      if (startedOn != null) 'started_on': startedOn,
      if (timezone != null) 'timezone': timezone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserJourneysCompanion copyWith({
    Value<String>? id,
    Value<String>? journeyCode,
    Value<String>? locale,
    Value<String>? status,
    Value<String>? startedOn,
    Value<String>? timezone,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserJourneysCompanion(
      id: id ?? this.id,
      journeyCode: journeyCode ?? this.journeyCode,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      startedOn: startedOn ?? this.startedOn,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journeyCode.present) {
      map['journey_code'] = Variable<String>(journeyCode.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedOn.present) {
      map['started_on'] = Variable<String>(startedOn.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserJourneysCompanion(')
          ..write('id: $id, ')
          ..write('journeyCode: $journeyCode, ')
          ..write('locale: $locale, ')
          ..write('status: $status, ')
          ..write('startedOn: $startedOn, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderPreferencesTable extends ReminderPreferences
    with TableInfo<$ReminderPreferencesTable, ReminderPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _minuteOfDayMeta = const VerificationMeta(
    'minuteOfDay',
  );
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
    'minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    kind,
    enabled,
    minuteOfDay,
    timezone,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
        _minuteOfDayMeta,
        minuteOfDay.isAcceptableOrUnknown(
          data['minute_of_day']!,
          _minuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind};
  @override
  ReminderPreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderPreferenceRow(
      kind:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}kind'],
          )!,
      enabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}enabled'],
          )!,
      minuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute_of_day'],
      ),
      timezone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}timezone'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ReminderPreferencesTable createAlias(String alias) {
    return $ReminderPreferencesTable(attachedDatabase, alias);
  }
}

class ReminderPreferenceRow extends DataClass
    implements Insertable<ReminderPreferenceRow> {
  /// `morning` or `evening`.
  final String kind;
  final bool enabled;

  /// Minutes after local midnight; required while [enabled].
  final int? minuteOfDay;
  final String timezone;
  final DateTime updatedAt;
  const ReminderPreferenceRow({
    required this.kind,
    required this.enabled,
    this.minuteOfDay,
    required this.timezone,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || minuteOfDay != null) {
      map['minute_of_day'] = Variable<int>(minuteOfDay);
    }
    map['timezone'] = Variable<String>(timezone);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReminderPreferencesCompanion toCompanion(bool nullToAbsent) {
    return ReminderPreferencesCompanion(
      kind: Value(kind),
      enabled: Value(enabled),
      minuteOfDay:
          minuteOfDay == null && nullToAbsent
              ? const Value.absent()
              : Value(minuteOfDay),
      timezone: Value(timezone),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderPreferenceRow(
      kind: serializer.fromJson<String>(json['kind']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      minuteOfDay: serializer.fromJson<int?>(json['minuteOfDay']),
      timezone: serializer.fromJson<String>(json['timezone']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'enabled': serializer.toJson<bool>(enabled),
      'minuteOfDay': serializer.toJson<int?>(minuteOfDay),
      'timezone': serializer.toJson<String>(timezone),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderPreferenceRow copyWith({
    String? kind,
    bool? enabled,
    Value<int?> minuteOfDay = const Value.absent(),
    String? timezone,
    DateTime? updatedAt,
  }) => ReminderPreferenceRow(
    kind: kind ?? this.kind,
    enabled: enabled ?? this.enabled,
    minuteOfDay: minuteOfDay.present ? minuteOfDay.value : this.minuteOfDay,
    timezone: timezone ?? this.timezone,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderPreferenceRow copyWithCompanion(ReminderPreferencesCompanion data) {
    return ReminderPreferenceRow(
      kind: data.kind.present ? data.kind.value : this.kind,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      minuteOfDay:
          data.minuteOfDay.present ? data.minuteOfDay.value : this.minuteOfDay,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderPreferenceRow(')
          ..write('kind: $kind, ')
          ..write('enabled: $enabled, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('timezone: $timezone, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(kind, enabled, minuteOfDay, timezone, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderPreferenceRow &&
          other.kind == this.kind &&
          other.enabled == this.enabled &&
          other.minuteOfDay == this.minuteOfDay &&
          other.timezone == this.timezone &&
          other.updatedAt == this.updatedAt);
}

class ReminderPreferencesCompanion
    extends UpdateCompanion<ReminderPreferenceRow> {
  final Value<String> kind;
  final Value<bool> enabled;
  final Value<int?> minuteOfDay;
  final Value<String> timezone;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReminderPreferencesCompanion({
    this.kind = const Value.absent(),
    this.enabled = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.timezone = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderPreferencesCompanion.insert({
    required String kind,
    required bool enabled,
    this.minuteOfDay = const Value.absent(),
    required String timezone,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       enabled = Value(enabled),
       timezone = Value(timezone),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderPreferenceRow> custom({
    Expression<String>? kind,
    Expression<bool>? enabled,
    Expression<int>? minuteOfDay,
    Expression<String>? timezone,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (enabled != null) 'enabled': enabled,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (timezone != null) 'timezone': timezone,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderPreferencesCompanion copyWith({
    Value<String>? kind,
    Value<bool>? enabled,
    Value<int?>? minuteOfDay,
    Value<String>? timezone,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReminderPreferencesCompanion(
      kind: kind ?? this.kind,
      enabled: enabled ?? this.enabled,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      timezone: timezone ?? this.timezone,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (minuteOfDay.present) {
      map['minute_of_day'] = Variable<int>(minuteOfDay.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderPreferencesCompanion(')
          ..write('kind: $kind, ')
          ..write('enabled: $enabled, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('timezone: $timezone, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisionsTable extends Visions with TableInfo<$VisionsTable, VisionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryCodeMeta = const VerificationMeta(
    'categoryCode',
  );
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
    'category_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMeta = const VerificationMeta(
    'statement',
  );
  @override
  late final GeneratedColumn<String> statement = GeneratedColumn<String>(
    'statement',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 2000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryCode,
    statement,
    imagePath,
    locale,
    status,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visions';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_code')) {
      context.handle(
        _categoryCodeMeta,
        categoryCode.isAcceptableOrUnknown(
          data['category_code']!,
          _categoryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryCodeMeta);
    }
    if (data.containsKey('statement')) {
      context.handle(
        _statementMeta,
        statement.isAcceptableOrUnknown(data['statement']!, _statementMeta),
      );
    } else if (isInserting) {
      context.missing(_statementMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisionRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      categoryCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category_code'],
          )!,
      statement:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}statement'],
          )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      locale:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}locale'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $VisionsTable createAlias(String alias) {
    return $VisionsTable(attachedDatabase, alias);
  }
}

class VisionRow extends DataClass implements Insertable<VisionRow> {
  final String id;
  final String categoryCode;
  final String statement;

  /// Image path relative to the app support directory.
  final String? imagePath;

  /// Locale of the statement and answers when written.
  final String locale;

  /// `active` or `archived`.
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const VisionRow({
    required this.id,
    required this.categoryCode,
    required this.statement,
    this.imagePath,
    required this.locale,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_code'] = Variable<String>(categoryCode);
    map['statement'] = Variable<String>(statement);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['locale'] = Variable<String>(locale);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  VisionsCompanion toCompanion(bool nullToAbsent) {
    return VisionsCompanion(
      id: Value(id),
      categoryCode: Value(categoryCode),
      statement: Value(statement),
      imagePath:
          imagePath == null && nullToAbsent
              ? const Value.absent()
              : Value(imagePath),
      locale: Value(locale),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt:
          archivedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(archivedAt),
    );
  }

  factory VisionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisionRow(
      id: serializer.fromJson<String>(json['id']),
      categoryCode: serializer.fromJson<String>(json['categoryCode']),
      statement: serializer.fromJson<String>(json['statement']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      locale: serializer.fromJson<String>(json['locale']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryCode': serializer.toJson<String>(categoryCode),
      'statement': serializer.toJson<String>(statement),
      'imagePath': serializer.toJson<String?>(imagePath),
      'locale': serializer.toJson<String>(locale),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  VisionRow copyWith({
    String? id,
    String? categoryCode,
    String? statement,
    Value<String?> imagePath = const Value.absent(),
    String? locale,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => VisionRow(
    id: id ?? this.id,
    categoryCode: categoryCode ?? this.categoryCode,
    statement: statement ?? this.statement,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    locale: locale ?? this.locale,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  VisionRow copyWithCompanion(VisionsCompanion data) {
    return VisionRow(
      id: data.id.present ? data.id.value : this.id,
      categoryCode:
          data.categoryCode.present
              ? data.categoryCode.value
              : this.categoryCode,
      statement: data.statement.present ? data.statement.value : this.statement,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      locale: data.locale.present ? data.locale.value : this.locale,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisionRow(')
          ..write('id: $id, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('statement: $statement, ')
          ..write('imagePath: $imagePath, ')
          ..write('locale: $locale, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryCode,
    statement,
    imagePath,
    locale,
    status,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisionRow &&
          other.id == this.id &&
          other.categoryCode == this.categoryCode &&
          other.statement == this.statement &&
          other.imagePath == this.imagePath &&
          other.locale == this.locale &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class VisionsCompanion extends UpdateCompanion<VisionRow> {
  final Value<String> id;
  final Value<String> categoryCode;
  final Value<String> statement;
  final Value<String?> imagePath;
  final Value<String> locale;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const VisionsCompanion({
    this.id = const Value.absent(),
    this.categoryCode = const Value.absent(),
    this.statement = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.locale = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisionsCompanion.insert({
    required String id,
    required String categoryCode,
    required String statement,
    this.imagePath = const Value.absent(),
    required String locale,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryCode = Value(categoryCode),
       statement = Value(statement),
       locale = Value(locale),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VisionRow> custom({
    Expression<String>? id,
    Expression<String>? categoryCode,
    Expression<String>? statement,
    Expression<String>? imagePath,
    Expression<String>? locale,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryCode != null) 'category_code': categoryCode,
      if (statement != null) 'statement': statement,
      if (imagePath != null) 'image_path': imagePath,
      if (locale != null) 'locale': locale,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisionsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryCode,
    Value<String>? statement,
    Value<String?>? imagePath,
    Value<String>? locale,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return VisionsCompanion(
      id: id ?? this.id,
      categoryCode: categoryCode ?? this.categoryCode,
      statement: statement ?? this.statement,
      imagePath: imagePath ?? this.imagePath,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (statement.present) {
      map['statement'] = Variable<String>(statement.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisionsCompanion(')
          ..write('id: $id, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('statement: $statement, ')
          ..write('imagePath: $imagePath, ')
          ..write('locale: $locale, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisionFeelingsTable extends VisionFeelings
    with TableInfo<$VisionFeelingsTable, VisionFeelingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisionFeelingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visionIdMeta = const VerificationMeta(
    'visionId',
  );
  @override
  late final GeneratedColumn<String> visionId = GeneratedColumn<String>(
    'vision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES visions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _feelingCodeMeta = const VerificationMeta(
    'feelingCode',
  );
  @override
  late final GeneratedColumn<String> feelingCode = GeneratedColumn<String>(
    'feeling_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [visionId, feelingCode, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vision_feelings';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisionFeelingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vision_id')) {
      context.handle(
        _visionIdMeta,
        visionId.isAcceptableOrUnknown(data['vision_id']!, _visionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visionIdMeta);
    }
    if (data.containsKey('feeling_code')) {
      context.handle(
        _feelingCodeMeta,
        feelingCode.isAcceptableOrUnknown(
          data['feeling_code']!,
          _feelingCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_feelingCodeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visionId, feelingCode};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {visionId, position},
  ];
  @override
  VisionFeelingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisionFeelingRow(
      visionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}vision_id'],
          )!,
      feelingCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}feeling_code'],
          )!,
      position:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}position'],
          )!,
    );
  }

  @override
  $VisionFeelingsTable createAlias(String alias) {
    return $VisionFeelingsTable(attachedDatabase, alias);
  }
}

class VisionFeelingRow extends DataClass
    implements Insertable<VisionFeelingRow> {
  final String visionId;
  final String feelingCode;
  final int position;
  const VisionFeelingRow({
    required this.visionId,
    required this.feelingCode,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vision_id'] = Variable<String>(visionId);
    map['feeling_code'] = Variable<String>(feelingCode);
    map['position'] = Variable<int>(position);
    return map;
  }

  VisionFeelingsCompanion toCompanion(bool nullToAbsent) {
    return VisionFeelingsCompanion(
      visionId: Value(visionId),
      feelingCode: Value(feelingCode),
      position: Value(position),
    );
  }

  factory VisionFeelingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisionFeelingRow(
      visionId: serializer.fromJson<String>(json['visionId']),
      feelingCode: serializer.fromJson<String>(json['feelingCode']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visionId': serializer.toJson<String>(visionId),
      'feelingCode': serializer.toJson<String>(feelingCode),
      'position': serializer.toJson<int>(position),
    };
  }

  VisionFeelingRow copyWith({
    String? visionId,
    String? feelingCode,
    int? position,
  }) => VisionFeelingRow(
    visionId: visionId ?? this.visionId,
    feelingCode: feelingCode ?? this.feelingCode,
    position: position ?? this.position,
  );
  VisionFeelingRow copyWithCompanion(VisionFeelingsCompanion data) {
    return VisionFeelingRow(
      visionId: data.visionId.present ? data.visionId.value : this.visionId,
      feelingCode:
          data.feelingCode.present ? data.feelingCode.value : this.feelingCode,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisionFeelingRow(')
          ..write('visionId: $visionId, ')
          ..write('feelingCode: $feelingCode, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(visionId, feelingCode, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisionFeelingRow &&
          other.visionId == this.visionId &&
          other.feelingCode == this.feelingCode &&
          other.position == this.position);
}

class VisionFeelingsCompanion extends UpdateCompanion<VisionFeelingRow> {
  final Value<String> visionId;
  final Value<String> feelingCode;
  final Value<int> position;
  final Value<int> rowid;
  const VisionFeelingsCompanion({
    this.visionId = const Value.absent(),
    this.feelingCode = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisionFeelingsCompanion.insert({
    required String visionId,
    required String feelingCode,
    required int position,
    this.rowid = const Value.absent(),
  }) : visionId = Value(visionId),
       feelingCode = Value(feelingCode),
       position = Value(position);
  static Insertable<VisionFeelingRow> custom({
    Expression<String>? visionId,
    Expression<String>? feelingCode,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visionId != null) 'vision_id': visionId,
      if (feelingCode != null) 'feeling_code': feelingCode,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisionFeelingsCompanion copyWith({
    Value<String>? visionId,
    Value<String>? feelingCode,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return VisionFeelingsCompanion(
      visionId: visionId ?? this.visionId,
      feelingCode: feelingCode ?? this.feelingCode,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visionId.present) {
      map['vision_id'] = Variable<String>(visionId.value);
    }
    if (feelingCode.present) {
      map['feeling_code'] = Variable<String>(feelingCode.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisionFeelingsCompanion(')
          ..write('visionId: $visionId, ')
          ..write('feelingCode: $feelingCode, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisionAnswersTable extends VisionAnswers
    with TableInfo<$VisionAnswersTable, VisionAnswerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisionAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visionIdMeta = const VerificationMeta(
    'visionId',
  );
  @override
  late final GeneratedColumn<String> visionId = GeneratedColumn<String>(
    'vision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES visions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _questionCodeMeta = const VerificationMeta(
    'questionCode',
  );
  @override
  late final GeneratedColumn<String> questionCode = GeneratedColumn<String>(
    'question_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueCodesMeta = const VerificationMeta(
    'valueCodes',
  );
  @override
  late final GeneratedColumn<String> valueCodes = GeneratedColumn<String>(
    'value_codes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customTextMeta = const VerificationMeta(
    'customText',
  );
  @override
  late final GeneratedColumn<String> customText = GeneratedColumn<String>(
    'custom_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    visionId,
    questionCode,
    valueCodes,
    customText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vision_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisionAnswerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vision_id')) {
      context.handle(
        _visionIdMeta,
        visionId.isAcceptableOrUnknown(data['vision_id']!, _visionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visionIdMeta);
    }
    if (data.containsKey('question_code')) {
      context.handle(
        _questionCodeMeta,
        questionCode.isAcceptableOrUnknown(
          data['question_code']!,
          _questionCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionCodeMeta);
    }
    if (data.containsKey('value_codes')) {
      context.handle(
        _valueCodesMeta,
        valueCodes.isAcceptableOrUnknown(data['value_codes']!, _valueCodesMeta),
      );
    } else if (isInserting) {
      context.missing(_valueCodesMeta);
    }
    if (data.containsKey('custom_text')) {
      context.handle(
        _customTextMeta,
        customText.isAcceptableOrUnknown(data['custom_text']!, _customTextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visionId, questionCode};
  @override
  VisionAnswerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisionAnswerRow(
      visionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}vision_id'],
          )!,
      questionCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}question_code'],
          )!,
      valueCodes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_codes'],
          )!,
      customText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_text'],
      ),
    );
  }

  @override
  $VisionAnswersTable createAlias(String alias) {
    return $VisionAnswersTable(attachedDatabase, alias);
  }
}

class VisionAnswerRow extends DataClass implements Insertable<VisionAnswerRow> {
  final String visionId;
  final String questionCode;

  /// JSON array of suggested-answer value codes.
  final String valueCodes;
  final String? customText;
  const VisionAnswerRow({
    required this.visionId,
    required this.questionCode,
    required this.valueCodes,
    this.customText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vision_id'] = Variable<String>(visionId);
    map['question_code'] = Variable<String>(questionCode);
    map['value_codes'] = Variable<String>(valueCodes);
    if (!nullToAbsent || customText != null) {
      map['custom_text'] = Variable<String>(customText);
    }
    return map;
  }

  VisionAnswersCompanion toCompanion(bool nullToAbsent) {
    return VisionAnswersCompanion(
      visionId: Value(visionId),
      questionCode: Value(questionCode),
      valueCodes: Value(valueCodes),
      customText:
          customText == null && nullToAbsent
              ? const Value.absent()
              : Value(customText),
    );
  }

  factory VisionAnswerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisionAnswerRow(
      visionId: serializer.fromJson<String>(json['visionId']),
      questionCode: serializer.fromJson<String>(json['questionCode']),
      valueCodes: serializer.fromJson<String>(json['valueCodes']),
      customText: serializer.fromJson<String?>(json['customText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visionId': serializer.toJson<String>(visionId),
      'questionCode': serializer.toJson<String>(questionCode),
      'valueCodes': serializer.toJson<String>(valueCodes),
      'customText': serializer.toJson<String?>(customText),
    };
  }

  VisionAnswerRow copyWith({
    String? visionId,
    String? questionCode,
    String? valueCodes,
    Value<String?> customText = const Value.absent(),
  }) => VisionAnswerRow(
    visionId: visionId ?? this.visionId,
    questionCode: questionCode ?? this.questionCode,
    valueCodes: valueCodes ?? this.valueCodes,
    customText: customText.present ? customText.value : this.customText,
  );
  VisionAnswerRow copyWithCompanion(VisionAnswersCompanion data) {
    return VisionAnswerRow(
      visionId: data.visionId.present ? data.visionId.value : this.visionId,
      questionCode:
          data.questionCode.present
              ? data.questionCode.value
              : this.questionCode,
      valueCodes:
          data.valueCodes.present ? data.valueCodes.value : this.valueCodes,
      customText:
          data.customText.present ? data.customText.value : this.customText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisionAnswerRow(')
          ..write('visionId: $visionId, ')
          ..write('questionCode: $questionCode, ')
          ..write('valueCodes: $valueCodes, ')
          ..write('customText: $customText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(visionId, questionCode, valueCodes, customText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisionAnswerRow &&
          other.visionId == this.visionId &&
          other.questionCode == this.questionCode &&
          other.valueCodes == this.valueCodes &&
          other.customText == this.customText);
}

class VisionAnswersCompanion extends UpdateCompanion<VisionAnswerRow> {
  final Value<String> visionId;
  final Value<String> questionCode;
  final Value<String> valueCodes;
  final Value<String?> customText;
  final Value<int> rowid;
  const VisionAnswersCompanion({
    this.visionId = const Value.absent(),
    this.questionCode = const Value.absent(),
    this.valueCodes = const Value.absent(),
    this.customText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisionAnswersCompanion.insert({
    required String visionId,
    required String questionCode,
    required String valueCodes,
    this.customText = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : visionId = Value(visionId),
       questionCode = Value(questionCode),
       valueCodes = Value(valueCodes);
  static Insertable<VisionAnswerRow> custom({
    Expression<String>? visionId,
    Expression<String>? questionCode,
    Expression<String>? valueCodes,
    Expression<String>? customText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visionId != null) 'vision_id': visionId,
      if (questionCode != null) 'question_code': questionCode,
      if (valueCodes != null) 'value_codes': valueCodes,
      if (customText != null) 'custom_text': customText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisionAnswersCompanion copyWith({
    Value<String>? visionId,
    Value<String>? questionCode,
    Value<String>? valueCodes,
    Value<String?>? customText,
    Value<int>? rowid,
  }) {
    return VisionAnswersCompanion(
      visionId: visionId ?? this.visionId,
      questionCode: questionCode ?? this.questionCode,
      valueCodes: valueCodes ?? this.valueCodes,
      customText: customText ?? this.customText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visionId.present) {
      map['vision_id'] = Variable<String>(visionId.value);
    }
    if (questionCode.present) {
      map['question_code'] = Variable<String>(questionCode.value);
    }
    if (valueCodes.present) {
      map['value_codes'] = Variable<String>(valueCodes.value);
    }
    if (customText.present) {
      map['custom_text'] = Variable<String>(customText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisionAnswersCompanion(')
          ..write('visionId: $visionId, ')
          ..write('questionCode: $questionCode, ')
          ..write('valueCodes: $valueCodes, ')
          ..write('customText: $customText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GratitudeEntriesTable extends GratitudeEntries
    with TableInfo<$GratitudeEntriesTable, GratitudeEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GratitudeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userJourneyIdMeta = const VerificationMeta(
    'userJourneyId',
  );
  @override
  late final GeneratedColumn<String> userJourneyId = GeneratedColumn<String>(
    'user_journey_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_journeys (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _journeyDayMeta = const VerificationMeta(
    'journeyDay',
  );
  @override
  late final GeneratedColumn<int> journeyDay = GeneratedColumn<int>(
    'journey_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gratitudeTextMeta = const VerificationMeta(
    'gratitudeText',
  );
  @override
  late final GeneratedColumn<String> gratitudeText = GeneratedColumn<String>(
    'gratitude_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonTextMeta = const VerificationMeta(
    'reasonText',
  );
  @override
  late final GeneratedColumn<String> reasonText = GeneratedColumn<String>(
    'reason_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userJourneyId,
    journeyDay,
    gratitudeText,
    reasonText,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gratitude_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<GratitudeEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_journey_id')) {
      context.handle(
        _userJourneyIdMeta,
        userJourneyId.isAcceptableOrUnknown(
          data['user_journey_id']!,
          _userJourneyIdMeta,
        ),
      );
    }
    if (data.containsKey('journey_day')) {
      context.handle(
        _journeyDayMeta,
        journeyDay.isAcceptableOrUnknown(data['journey_day']!, _journeyDayMeta),
      );
    }
    if (data.containsKey('gratitude_text')) {
      context.handle(
        _gratitudeTextMeta,
        gratitudeText.isAcceptableOrUnknown(
          data['gratitude_text']!,
          _gratitudeTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gratitudeTextMeta);
    }
    if (data.containsKey('reason_text')) {
      context.handle(
        _reasonTextMeta,
        reasonText.isAcceptableOrUnknown(data['reason_text']!, _reasonTextMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GratitudeEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GratitudeEntryRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userJourneyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_journey_id'],
      ),
      journeyDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journey_day'],
      ),
      gratitudeText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}gratitude_text'],
          )!,
      reasonText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}reason_text'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $GratitudeEntriesTable createAlias(String alias) {
    return $GratitudeEntriesTable(attachedDatabase, alias);
  }
}

class GratitudeEntryRow extends DataClass
    implements Insertable<GratitudeEntryRow> {
  final String id;
  final String? userJourneyId;
  final int? journeyDay;
  final String gratitudeText;
  final String reasonText;
  final DateTime createdAt;
  const GratitudeEntryRow({
    required this.id,
    this.userJourneyId,
    this.journeyDay,
    required this.gratitudeText,
    required this.reasonText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userJourneyId != null) {
      map['user_journey_id'] = Variable<String>(userJourneyId);
    }
    if (!nullToAbsent || journeyDay != null) {
      map['journey_day'] = Variable<int>(journeyDay);
    }
    map['gratitude_text'] = Variable<String>(gratitudeText);
    map['reason_text'] = Variable<String>(reasonText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GratitudeEntriesCompanion toCompanion(bool nullToAbsent) {
    return GratitudeEntriesCompanion(
      id: Value(id),
      userJourneyId:
          userJourneyId == null && nullToAbsent
              ? const Value.absent()
              : Value(userJourneyId),
      journeyDay:
          journeyDay == null && nullToAbsent
              ? const Value.absent()
              : Value(journeyDay),
      gratitudeText: Value(gratitudeText),
      reasonText: Value(reasonText),
      createdAt: Value(createdAt),
    );
  }

  factory GratitudeEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GratitudeEntryRow(
      id: serializer.fromJson<String>(json['id']),
      userJourneyId: serializer.fromJson<String?>(json['userJourneyId']),
      journeyDay: serializer.fromJson<int?>(json['journeyDay']),
      gratitudeText: serializer.fromJson<String>(json['gratitudeText']),
      reasonText: serializer.fromJson<String>(json['reasonText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userJourneyId': serializer.toJson<String?>(userJourneyId),
      'journeyDay': serializer.toJson<int?>(journeyDay),
      'gratitudeText': serializer.toJson<String>(gratitudeText),
      'reasonText': serializer.toJson<String>(reasonText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GratitudeEntryRow copyWith({
    String? id,
    Value<String?> userJourneyId = const Value.absent(),
    Value<int?> journeyDay = const Value.absent(),
    String? gratitudeText,
    String? reasonText,
    DateTime? createdAt,
  }) => GratitudeEntryRow(
    id: id ?? this.id,
    userJourneyId:
        userJourneyId.present ? userJourneyId.value : this.userJourneyId,
    journeyDay: journeyDay.present ? journeyDay.value : this.journeyDay,
    gratitudeText: gratitudeText ?? this.gratitudeText,
    reasonText: reasonText ?? this.reasonText,
    createdAt: createdAt ?? this.createdAt,
  );
  GratitudeEntryRow copyWithCompanion(GratitudeEntriesCompanion data) {
    return GratitudeEntryRow(
      id: data.id.present ? data.id.value : this.id,
      userJourneyId:
          data.userJourneyId.present
              ? data.userJourneyId.value
              : this.userJourneyId,
      journeyDay:
          data.journeyDay.present ? data.journeyDay.value : this.journeyDay,
      gratitudeText:
          data.gratitudeText.present
              ? data.gratitudeText.value
              : this.gratitudeText,
      reasonText:
          data.reasonText.present ? data.reasonText.value : this.reasonText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GratitudeEntryRow(')
          ..write('id: $id, ')
          ..write('userJourneyId: $userJourneyId, ')
          ..write('journeyDay: $journeyDay, ')
          ..write('gratitudeText: $gratitudeText, ')
          ..write('reasonText: $reasonText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userJourneyId,
    journeyDay,
    gratitudeText,
    reasonText,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GratitudeEntryRow &&
          other.id == this.id &&
          other.userJourneyId == this.userJourneyId &&
          other.journeyDay == this.journeyDay &&
          other.gratitudeText == this.gratitudeText &&
          other.reasonText == this.reasonText &&
          other.createdAt == this.createdAt);
}

class GratitudeEntriesCompanion extends UpdateCompanion<GratitudeEntryRow> {
  final Value<String> id;
  final Value<String?> userJourneyId;
  final Value<int?> journeyDay;
  final Value<String> gratitudeText;
  final Value<String> reasonText;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GratitudeEntriesCompanion({
    this.id = const Value.absent(),
    this.userJourneyId = const Value.absent(),
    this.journeyDay = const Value.absent(),
    this.gratitudeText = const Value.absent(),
    this.reasonText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GratitudeEntriesCompanion.insert({
    required String id,
    this.userJourneyId = const Value.absent(),
    this.journeyDay = const Value.absent(),
    required String gratitudeText,
    required String reasonText,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gratitudeText = Value(gratitudeText),
       reasonText = Value(reasonText),
       createdAt = Value(createdAt);
  static Insertable<GratitudeEntryRow> custom({
    Expression<String>? id,
    Expression<String>? userJourneyId,
    Expression<int>? journeyDay,
    Expression<String>? gratitudeText,
    Expression<String>? reasonText,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userJourneyId != null) 'user_journey_id': userJourneyId,
      if (journeyDay != null) 'journey_day': journeyDay,
      if (gratitudeText != null) 'gratitude_text': gratitudeText,
      if (reasonText != null) 'reason_text': reasonText,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GratitudeEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userJourneyId,
    Value<int?>? journeyDay,
    Value<String>? gratitudeText,
    Value<String>? reasonText,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GratitudeEntriesCompanion(
      id: id ?? this.id,
      userJourneyId: userJourneyId ?? this.userJourneyId,
      journeyDay: journeyDay ?? this.journeyDay,
      gratitudeText: gratitudeText ?? this.gratitudeText,
      reasonText: reasonText ?? this.reasonText,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userJourneyId.present) {
      map['user_journey_id'] = Variable<String>(userJourneyId.value);
    }
    if (journeyDay.present) {
      map['journey_day'] = Variable<int>(journeyDay.value);
    }
    if (gratitudeText.present) {
      map['gratitude_text'] = Variable<String>(gratitudeText.value);
    }
    if (reasonText.present) {
      map['reason_text'] = Variable<String>(reasonText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GratitudeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userJourneyId: $userJourneyId, ')
          ..write('journeyDay: $journeyDay, ')
          ..write('gratitudeText: $gratitudeText, ')
          ..write('reasonText: $reasonText, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SoulDatabase extends GeneratedDatabase {
  _$SoulDatabase(QueryExecutor e) : super(e);
  $SoulDatabaseManager get managers => $SoulDatabaseManager(this);
  late final $UserJourneysTable userJourneys = $UserJourneysTable(this);
  late final $ReminderPreferencesTable reminderPreferences =
      $ReminderPreferencesTable(this);
  late final $VisionsTable visions = $VisionsTable(this);
  late final $VisionFeelingsTable visionFeelings = $VisionFeelingsTable(this);
  late final $VisionAnswersTable visionAnswers = $VisionAnswersTable(this);
  late final $GratitudeEntriesTable gratitudeEntries = $GratitudeEntriesTable(
    this,
  );
  late final Index userJourneysOneActive = Index(
    'user_journeys_one_active',
    'CREATE UNIQUE INDEX user_journeys_one_active ON user_journeys (journey_code) WHERE status = \'active\'',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userJourneys,
    reminderPreferences,
    visions,
    visionFeelings,
    visionAnswers,
    gratitudeEntries,
    userJourneysOneActive,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'visions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vision_feelings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'visions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vision_answers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_journeys',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('gratitude_entries', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$UserJourneysTableCreateCompanionBuilder =
    UserJourneysCompanion Function({
      required String id,
      required String journeyCode,
      required String locale,
      required String status,
      required String startedOn,
      required String timezone,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserJourneysTableUpdateCompanionBuilder =
    UserJourneysCompanion Function({
      Value<String> id,
      Value<String> journeyCode,
      Value<String> locale,
      Value<String> status,
      Value<String> startedOn,
      Value<String> timezone,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UserJourneysTableReferences
    extends BaseReferences<_$SoulDatabase, $UserJourneysTable, UserJourneyRow> {
  $$UserJourneysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GratitudeEntriesTable, List<GratitudeEntryRow>>
  _gratitudeEntriesRefsTable(_$SoulDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gratitudeEntries,
        aliasName: 'user_journeys__id__gratitude_entries__user_journey_id',
      );

  $$GratitudeEntriesTableProcessedTableManager get gratitudeEntriesRefs {
    final manager = $$GratitudeEntriesTableTableManager(
      $_db,
      $_db.gratitudeEntries,
    ).filter((f) => f.userJourneyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gratitudeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserJourneysTableFilterComposer
    extends Composer<_$SoulDatabase, $UserJourneysTable> {
  $$UserJourneysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get journeyCode => $composableBuilder(
    column: $table.journeyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gratitudeEntriesRefs(
    Expression<bool> Function($$GratitudeEntriesTableFilterComposer f) f,
  ) {
    final $$GratitudeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gratitudeEntries,
      getReferencedColumn: (t) => t.userJourneyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GratitudeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.gratitudeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserJourneysTableOrderingComposer
    extends Composer<_$SoulDatabase, $UserJourneysTable> {
  $$UserJourneysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journeyCode => $composableBuilder(
    column: $table.journeyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserJourneysTableAnnotationComposer
    extends Composer<_$SoulDatabase, $UserJourneysTable> {
  $$UserJourneysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get journeyCode => $composableBuilder(
    column: $table.journeyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get startedOn =>
      $composableBuilder(column: $table.startedOn, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> gratitudeEntriesRefs<T extends Object>(
    Expression<T> Function($$GratitudeEntriesTableAnnotationComposer a) f,
  ) {
    final $$GratitudeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gratitudeEntries,
      getReferencedColumn: (t) => t.userJourneyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GratitudeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.gratitudeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserJourneysTableTableManager
    extends
        RootTableManager<
          _$SoulDatabase,
          $UserJourneysTable,
          UserJourneyRow,
          $$UserJourneysTableFilterComposer,
          $$UserJourneysTableOrderingComposer,
          $$UserJourneysTableAnnotationComposer,
          $$UserJourneysTableCreateCompanionBuilder,
          $$UserJourneysTableUpdateCompanionBuilder,
          (UserJourneyRow, $$UserJourneysTableReferences),
          UserJourneyRow,
          PrefetchHooks Function({bool gratitudeEntriesRefs})
        > {
  $$UserJourneysTableTableManager(_$SoulDatabase db, $UserJourneysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserJourneysTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserJourneysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$UserJourneysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> journeyCode = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> startedOn = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserJourneysCompanion(
                id: id,
                journeyCode: journeyCode,
                locale: locale,
                status: status,
                startedOn: startedOn,
                timezone: timezone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String journeyCode,
                required String locale,
                required String status,
                required String startedOn,
                required String timezone,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserJourneysCompanion.insert(
                id: id,
                journeyCode: journeyCode,
                locale: locale,
                status: status,
                startedOn: startedOn,
                timezone: timezone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$UserJourneysTable, UserJourneyRow>(
                            table,
                          ),
                          $$UserJourneysTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({gratitudeEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (gratitudeEntriesRefs) db.gratitudeEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gratitudeEntriesRefs)
                    await $_getPrefetchedData<
                      UserJourneyRow,
                      $UserJourneysTable,
                      GratitudeEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$UserJourneysTableReferences
                          ._gratitudeEntriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserJourneysTableReferences(
                                db,
                                table,
                                p0,
                              ).gratitudeEntriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.userJourneyId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserJourneysTableProcessedTableManager =
    ProcessedTableManager<
      _$SoulDatabase,
      $UserJourneysTable,
      UserJourneyRow,
      $$UserJourneysTableFilterComposer,
      $$UserJourneysTableOrderingComposer,
      $$UserJourneysTableAnnotationComposer,
      $$UserJourneysTableCreateCompanionBuilder,
      $$UserJourneysTableUpdateCompanionBuilder,
      (UserJourneyRow, $$UserJourneysTableReferences),
      UserJourneyRow,
      PrefetchHooks Function({bool gratitudeEntriesRefs})
    >;
typedef $$ReminderPreferencesTableCreateCompanionBuilder =
    ReminderPreferencesCompanion Function({
      required String kind,
      required bool enabled,
      Value<int?> minuteOfDay,
      required String timezone,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReminderPreferencesTableUpdateCompanionBuilder =
    ReminderPreferencesCompanion Function({
      Value<String> kind,
      Value<bool> enabled,
      Value<int?> minuteOfDay,
      Value<String> timezone,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ReminderPreferencesTableFilterComposer
    extends Composer<_$SoulDatabase, $ReminderPreferencesTable> {
  $$ReminderPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderPreferencesTableOrderingComposer
    extends Composer<_$SoulDatabase, $ReminderPreferencesTable> {
  $$ReminderPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderPreferencesTableAnnotationComposer
    extends Composer<_$SoulDatabase, $ReminderPreferencesTable> {
  $$ReminderPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReminderPreferencesTableTableManager
    extends
        RootTableManager<
          _$SoulDatabase,
          $ReminderPreferencesTable,
          ReminderPreferenceRow,
          $$ReminderPreferencesTableFilterComposer,
          $$ReminderPreferencesTableOrderingComposer,
          $$ReminderPreferencesTableAnnotationComposer,
          $$ReminderPreferencesTableCreateCompanionBuilder,
          $$ReminderPreferencesTableUpdateCompanionBuilder,
          (
            ReminderPreferenceRow,
            BaseReferences<
              _$SoulDatabase,
              $ReminderPreferencesTable,
              ReminderPreferenceRow
            >,
          ),
          ReminderPreferenceRow,
          PrefetchHooks Function()
        > {
  $$ReminderPreferencesTableTableManager(
    _$SoulDatabase db,
    $ReminderPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ReminderPreferencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ReminderPreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ReminderPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int?> minuteOfDay = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderPreferencesCompanion(
                kind: kind,
                enabled: enabled,
                minuteOfDay: minuteOfDay,
                timezone: timezone,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kind,
                required bool enabled,
                Value<int?> minuteOfDay = const Value.absent(),
                required String timezone,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderPreferencesCompanion.insert(
                kind: kind,
                enabled: enabled,
                minuteOfDay: minuteOfDay,
                timezone: timezone,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<
                            $ReminderPreferencesTable,
                            ReminderPreferenceRow
                          >(table),
                          BaseReferences<
                            _$SoulDatabase,
                            $ReminderPreferencesTable,
                            ReminderPreferenceRow
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$SoulDatabase,
      $ReminderPreferencesTable,
      ReminderPreferenceRow,
      $$ReminderPreferencesTableFilterComposer,
      $$ReminderPreferencesTableOrderingComposer,
      $$ReminderPreferencesTableAnnotationComposer,
      $$ReminderPreferencesTableCreateCompanionBuilder,
      $$ReminderPreferencesTableUpdateCompanionBuilder,
      (
        ReminderPreferenceRow,
        BaseReferences<
          _$SoulDatabase,
          $ReminderPreferencesTable,
          ReminderPreferenceRow
        >,
      ),
      ReminderPreferenceRow,
      PrefetchHooks Function()
    >;
typedef $$VisionsTableCreateCompanionBuilder =
    VisionsCompanion Function({
      required String id,
      required String categoryCode,
      required String statement,
      Value<String?> imagePath,
      required String locale,
      required String status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$VisionsTableUpdateCompanionBuilder =
    VisionsCompanion Function({
      Value<String> id,
      Value<String> categoryCode,
      Value<String> statement,
      Value<String?> imagePath,
      Value<String> locale,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$VisionsTableReferences
    extends BaseReferences<_$SoulDatabase, $VisionsTable, VisionRow> {
  $$VisionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VisionFeelingsTable, List<VisionFeelingRow>>
  _visionFeelingsRefsTable(_$SoulDatabase db) => MultiTypedResultKey.fromTable(
    db.visionFeelings,
    aliasName: 'visions__id__vision_feelings__vision_id',
  );

  $$VisionFeelingsTableProcessedTableManager get visionFeelingsRefs {
    final manager = $$VisionFeelingsTableTableManager(
      $_db,
      $_db.visionFeelings,
    ).filter((f) => f.visionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visionFeelingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VisionAnswersTable, List<VisionAnswerRow>>
  _visionAnswersRefsTable(_$SoulDatabase db) => MultiTypedResultKey.fromTable(
    db.visionAnswers,
    aliasName: 'visions__id__vision_answers__vision_id',
  );

  $$VisionAnswersTableProcessedTableManager get visionAnswersRefs {
    final manager = $$VisionAnswersTableTableManager(
      $_db,
      $_db.visionAnswers,
    ).filter((f) => f.visionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visionAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VisionsTableFilterComposer
    extends Composer<_$SoulDatabase, $VisionsTable> {
  $$VisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> visionFeelingsRefs(
    Expression<bool> Function($$VisionFeelingsTableFilterComposer f) f,
  ) {
    final $$VisionFeelingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visionFeelings,
      getReferencedColumn: (t) => t.visionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionFeelingsTableFilterComposer(
            $db: $db,
            $table: $db.visionFeelings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> visionAnswersRefs(
    Expression<bool> Function($$VisionAnswersTableFilterComposer f) f,
  ) {
    final $$VisionAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visionAnswers,
      getReferencedColumn: (t) => t.visionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionAnswersTableFilterComposer(
            $db: $db,
            $table: $db.visionAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisionsTableOrderingComposer
    extends Composer<_$SoulDatabase, $VisionsTable> {
  $$VisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisionsTableAnnotationComposer
    extends Composer<_$SoulDatabase, $VisionsTable> {
  $$VisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statement =>
      $composableBuilder(column: $table.statement, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> visionFeelingsRefs<T extends Object>(
    Expression<T> Function($$VisionFeelingsTableAnnotationComposer a) f,
  ) {
    final $$VisionFeelingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visionFeelings,
      getReferencedColumn: (t) => t.visionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionFeelingsTableAnnotationComposer(
            $db: $db,
            $table: $db.visionFeelings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> visionAnswersRefs<T extends Object>(
    Expression<T> Function($$VisionAnswersTableAnnotationComposer a) f,
  ) {
    final $$VisionAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visionAnswers,
      getReferencedColumn: (t) => t.visionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.visionAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VisionsTableTableManager
    extends
        RootTableManager<
          _$SoulDatabase,
          $VisionsTable,
          VisionRow,
          $$VisionsTableFilterComposer,
          $$VisionsTableOrderingComposer,
          $$VisionsTableAnnotationComposer,
          $$VisionsTableCreateCompanionBuilder,
          $$VisionsTableUpdateCompanionBuilder,
          (VisionRow, $$VisionsTableReferences),
          VisionRow,
          PrefetchHooks Function({
            bool visionFeelingsRefs,
            bool visionAnswersRefs,
          })
        > {
  $$VisionsTableTableManager(_$SoulDatabase db, $VisionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$VisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$VisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryCode = const Value.absent(),
                Value<String> statement = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionsCompanion(
                id: id,
                categoryCode: categoryCode,
                statement: statement,
                imagePath: imagePath,
                locale: locale,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryCode,
                required String statement,
                Value<String?> imagePath = const Value.absent(),
                required String locale,
                required String status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionsCompanion.insert(
                id: id,
                categoryCode: categoryCode,
                statement: statement,
                imagePath: imagePath,
                locale: locale,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$VisionsTable, VisionRow>(table),
                          $$VisionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            visionFeelingsRefs = false,
            visionAnswersRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (visionFeelingsRefs) db.visionFeelings,
                if (visionAnswersRefs) db.visionAnswers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (visionFeelingsRefs)
                    await $_getPrefetchedData<
                      VisionRow,
                      $VisionsTable,
                      VisionFeelingRow
                    >(
                      currentTable: table,
                      referencedTable: $$VisionsTableReferences
                          ._visionFeelingsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$VisionsTableReferences(
                                db,
                                table,
                                p0,
                              ).visionFeelingsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.visionId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (visionAnswersRefs)
                    await $_getPrefetchedData<
                      VisionRow,
                      $VisionsTable,
                      VisionAnswerRow
                    >(
                      currentTable: table,
                      referencedTable: $$VisionsTableReferences
                          ._visionAnswersRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$VisionsTableReferences(
                                db,
                                table,
                                p0,
                              ).visionAnswersRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.visionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$SoulDatabase,
      $VisionsTable,
      VisionRow,
      $$VisionsTableFilterComposer,
      $$VisionsTableOrderingComposer,
      $$VisionsTableAnnotationComposer,
      $$VisionsTableCreateCompanionBuilder,
      $$VisionsTableUpdateCompanionBuilder,
      (VisionRow, $$VisionsTableReferences),
      VisionRow,
      PrefetchHooks Function({bool visionFeelingsRefs, bool visionAnswersRefs})
    >;
typedef $$VisionFeelingsTableCreateCompanionBuilder =
    VisionFeelingsCompanion Function({
      required String visionId,
      required String feelingCode,
      required int position,
      Value<int> rowid,
    });
typedef $$VisionFeelingsTableUpdateCompanionBuilder =
    VisionFeelingsCompanion Function({
      Value<String> visionId,
      Value<String> feelingCode,
      Value<int> position,
      Value<int> rowid,
    });

final class $$VisionFeelingsTableReferences
    extends
        BaseReferences<_$SoulDatabase, $VisionFeelingsTable, VisionFeelingRow> {
  $$VisionFeelingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VisionsTable _visionIdTable(_$SoulDatabase db) =>
      db.visions.createAlias('vision_feelings__vision_id__visions__id');

  $$VisionsTableProcessedTableManager get visionId {
    final $_column = $_itemColumn<String>('vision_id')!;

    final manager = $$VisionsTableTableManager(
      $_db,
      $_db.visions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisionFeelingsTableFilterComposer
    extends Composer<_$SoulDatabase, $VisionFeelingsTable> {
  $$VisionFeelingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get feelingCode => $composableBuilder(
    column: $table.feelingCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$VisionsTableFilterComposer get visionId {
    final $$VisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visionId,
      referencedTable: $db.visions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionsTableFilterComposer(
            $db: $db,
            $table: $db.visions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionFeelingsTableOrderingComposer
    extends Composer<_$SoulDatabase, $VisionFeelingsTable> {
  $$VisionFeelingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get feelingCode => $composableBuilder(
    column: $table.feelingCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$VisionsTableOrderingComposer get visionId {
    final $$VisionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visionId,
      referencedTable: $db.visions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionsTableOrderingComposer(
            $db: $db,
            $table: $db.visions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionFeelingsTableAnnotationComposer
    extends Composer<_$SoulDatabase, $VisionFeelingsTable> {
  $$VisionFeelingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get feelingCode => $composableBuilder(
    column: $table.feelingCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$VisionsTableAnnotationComposer get visionId {
    final $$VisionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visionId,
      referencedTable: $db.visions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionsTableAnnotationComposer(
            $db: $db,
            $table: $db.visions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionFeelingsTableTableManager
    extends
        RootTableManager<
          _$SoulDatabase,
          $VisionFeelingsTable,
          VisionFeelingRow,
          $$VisionFeelingsTableFilterComposer,
          $$VisionFeelingsTableOrderingComposer,
          $$VisionFeelingsTableAnnotationComposer,
          $$VisionFeelingsTableCreateCompanionBuilder,
          $$VisionFeelingsTableUpdateCompanionBuilder,
          (VisionFeelingRow, $$VisionFeelingsTableReferences),
          VisionFeelingRow,
          PrefetchHooks Function({bool visionId})
        > {
  $$VisionFeelingsTableTableManager(
    _$SoulDatabase db,
    $VisionFeelingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VisionFeelingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$VisionFeelingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$VisionFeelingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> visionId = const Value.absent(),
                Value<String> feelingCode = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionFeelingsCompanion(
                visionId: visionId,
                feelingCode: feelingCode,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String visionId,
                required String feelingCode,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => VisionFeelingsCompanion.insert(
                visionId: visionId,
                feelingCode: feelingCode,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$VisionFeelingsTable, VisionFeelingRow>(
                            table,
                          ),
                          $$VisionFeelingsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({visionId = false}) {
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
                  dynamic,
                  dynamic
                >
              >(state) {
                if (visionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.visionId,
                            referencedTable: $$VisionFeelingsTableReferences
                                ._visionIdTable(db),
                            referencedColumn:
                                $$VisionFeelingsTableReferences
                                    ._visionIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisionFeelingsTableProcessedTableManager =
    ProcessedTableManager<
      _$SoulDatabase,
      $VisionFeelingsTable,
      VisionFeelingRow,
      $$VisionFeelingsTableFilterComposer,
      $$VisionFeelingsTableOrderingComposer,
      $$VisionFeelingsTableAnnotationComposer,
      $$VisionFeelingsTableCreateCompanionBuilder,
      $$VisionFeelingsTableUpdateCompanionBuilder,
      (VisionFeelingRow, $$VisionFeelingsTableReferences),
      VisionFeelingRow,
      PrefetchHooks Function({bool visionId})
    >;
typedef $$VisionAnswersTableCreateCompanionBuilder =
    VisionAnswersCompanion Function({
      required String visionId,
      required String questionCode,
      required String valueCodes,
      Value<String?> customText,
      Value<int> rowid,
    });
typedef $$VisionAnswersTableUpdateCompanionBuilder =
    VisionAnswersCompanion Function({
      Value<String> visionId,
      Value<String> questionCode,
      Value<String> valueCodes,
      Value<String?> customText,
      Value<int> rowid,
    });

final class $$VisionAnswersTableReferences
    extends
        BaseReferences<_$SoulDatabase, $VisionAnswersTable, VisionAnswerRow> {
  $$VisionAnswersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VisionsTable _visionIdTable(_$SoulDatabase db) =>
      db.visions.createAlias('vision_answers__vision_id__visions__id');

  $$VisionsTableProcessedTableManager get visionId {
    final $_column = $_itemColumn<String>('vision_id')!;

    final manager = $$VisionsTableTableManager(
      $_db,
      $_db.visions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisionAnswersTableFilterComposer
    extends Composer<_$SoulDatabase, $VisionAnswersTable> {
  $$VisionAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questionCode => $composableBuilder(
    column: $table.questionCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueCodes => $composableBuilder(
    column: $table.valueCodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customText => $composableBuilder(
    column: $table.customText,
    builder: (column) => ColumnFilters(column),
  );

  $$VisionsTableFilterComposer get visionId {
    final $$VisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visionId,
      referencedTable: $db.visions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionsTableFilterComposer(
            $db: $db,
            $table: $db.visions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionAnswersTableOrderingComposer
    extends Composer<_$SoulDatabase, $VisionAnswersTable> {
  $$VisionAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questionCode => $composableBuilder(
    column: $table.questionCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueCodes => $composableBuilder(
    column: $table.valueCodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customText => $composableBuilder(
    column: $table.customText,
    builder: (column) => ColumnOrderings(column),
  );

  $$VisionsTableOrderingComposer get visionId {
    final $$VisionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visionId,
      referencedTable: $db.visions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionsTableOrderingComposer(
            $db: $db,
            $table: $db.visions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionAnswersTableAnnotationComposer
    extends Composer<_$SoulDatabase, $VisionAnswersTable> {
  $$VisionAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questionCode => $composableBuilder(
    column: $table.questionCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueCodes => $composableBuilder(
    column: $table.valueCodes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customText => $composableBuilder(
    column: $table.customText,
    builder: (column) => column,
  );

  $$VisionsTableAnnotationComposer get visionId {
    final $$VisionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.visionId,
      referencedTable: $db.visions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionsTableAnnotationComposer(
            $db: $db,
            $table: $db.visions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionAnswersTableTableManager
    extends
        RootTableManager<
          _$SoulDatabase,
          $VisionAnswersTable,
          VisionAnswerRow,
          $$VisionAnswersTableFilterComposer,
          $$VisionAnswersTableOrderingComposer,
          $$VisionAnswersTableAnnotationComposer,
          $$VisionAnswersTableCreateCompanionBuilder,
          $$VisionAnswersTableUpdateCompanionBuilder,
          (VisionAnswerRow, $$VisionAnswersTableReferences),
          VisionAnswerRow,
          PrefetchHooks Function({bool visionId})
        > {
  $$VisionAnswersTableTableManager(_$SoulDatabase db, $VisionAnswersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$VisionAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$VisionAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$VisionAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> visionId = const Value.absent(),
                Value<String> questionCode = const Value.absent(),
                Value<String> valueCodes = const Value.absent(),
                Value<String?> customText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionAnswersCompanion(
                visionId: visionId,
                questionCode: questionCode,
                valueCodes: valueCodes,
                customText: customText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String visionId,
                required String questionCode,
                required String valueCodes,
                Value<String?> customText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionAnswersCompanion.insert(
                visionId: visionId,
                questionCode: questionCode,
                valueCodes: valueCodes,
                customText: customText,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$VisionAnswersTable, VisionAnswerRow>(
                            table,
                          ),
                          $$VisionAnswersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({visionId = false}) {
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
                  dynamic,
                  dynamic
                >
              >(state) {
                if (visionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.visionId,
                            referencedTable: $$VisionAnswersTableReferences
                                ._visionIdTable(db),
                            referencedColumn:
                                $$VisionAnswersTableReferences
                                    ._visionIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisionAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$SoulDatabase,
      $VisionAnswersTable,
      VisionAnswerRow,
      $$VisionAnswersTableFilterComposer,
      $$VisionAnswersTableOrderingComposer,
      $$VisionAnswersTableAnnotationComposer,
      $$VisionAnswersTableCreateCompanionBuilder,
      $$VisionAnswersTableUpdateCompanionBuilder,
      (VisionAnswerRow, $$VisionAnswersTableReferences),
      VisionAnswerRow,
      PrefetchHooks Function({bool visionId})
    >;
typedef $$GratitudeEntriesTableCreateCompanionBuilder =
    GratitudeEntriesCompanion Function({
      required String id,
      Value<String?> userJourneyId,
      Value<int?> journeyDay,
      required String gratitudeText,
      required String reasonText,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$GratitudeEntriesTableUpdateCompanionBuilder =
    GratitudeEntriesCompanion Function({
      Value<String> id,
      Value<String?> userJourneyId,
      Value<int?> journeyDay,
      Value<String> gratitudeText,
      Value<String> reasonText,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$GratitudeEntriesTableReferences
    extends
        BaseReferences<
          _$SoulDatabase,
          $GratitudeEntriesTable,
          GratitudeEntryRow
        > {
  $$GratitudeEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserJourneysTable _userJourneyIdTable(_$SoulDatabase db) => db
      .userJourneys
      .createAlias('gratitude_entries__user_journey_id__user_journeys__id');

  $$UserJourneysTableProcessedTableManager? get userJourneyId {
    final $_column = $_itemColumn<String>('user_journey_id');
    if ($_column == null) return null;
    final manager = $$UserJourneysTableTableManager(
      $_db,
      $_db.userJourneys,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userJourneyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GratitudeEntriesTableFilterComposer
    extends Composer<_$SoulDatabase, $GratitudeEntriesTable> {
  $$GratitudeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journeyDay => $composableBuilder(
    column: $table.journeyDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gratitudeText => $composableBuilder(
    column: $table.gratitudeText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserJourneysTableFilterComposer get userJourneyId {
    final $$UserJourneysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userJourneyId,
      referencedTable: $db.userJourneys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserJourneysTableFilterComposer(
            $db: $db,
            $table: $db.userJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GratitudeEntriesTableOrderingComposer
    extends Composer<_$SoulDatabase, $GratitudeEntriesTable> {
  $$GratitudeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journeyDay => $composableBuilder(
    column: $table.journeyDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gratitudeText => $composableBuilder(
    column: $table.gratitudeText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserJourneysTableOrderingComposer get userJourneyId {
    final $$UserJourneysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userJourneyId,
      referencedTable: $db.userJourneys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserJourneysTableOrderingComposer(
            $db: $db,
            $table: $db.userJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GratitudeEntriesTableAnnotationComposer
    extends Composer<_$SoulDatabase, $GratitudeEntriesTable> {
  $$GratitudeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get journeyDay => $composableBuilder(
    column: $table.journeyDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gratitudeText => $composableBuilder(
    column: $table.gratitudeText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserJourneysTableAnnotationComposer get userJourneyId {
    final $$UserJourneysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userJourneyId,
      referencedTable: $db.userJourneys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserJourneysTableAnnotationComposer(
            $db: $db,
            $table: $db.userJourneys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GratitudeEntriesTableTableManager
    extends
        RootTableManager<
          _$SoulDatabase,
          $GratitudeEntriesTable,
          GratitudeEntryRow,
          $$GratitudeEntriesTableFilterComposer,
          $$GratitudeEntriesTableOrderingComposer,
          $$GratitudeEntriesTableAnnotationComposer,
          $$GratitudeEntriesTableCreateCompanionBuilder,
          $$GratitudeEntriesTableUpdateCompanionBuilder,
          (GratitudeEntryRow, $$GratitudeEntriesTableReferences),
          GratitudeEntryRow,
          PrefetchHooks Function({bool userJourneyId})
        > {
  $$GratitudeEntriesTableTableManager(
    _$SoulDatabase db,
    $GratitudeEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$GratitudeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GratitudeEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$GratitudeEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userJourneyId = const Value.absent(),
                Value<int?> journeyDay = const Value.absent(),
                Value<String> gratitudeText = const Value.absent(),
                Value<String> reasonText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GratitudeEntriesCompanion(
                id: id,
                userJourneyId: userJourneyId,
                journeyDay: journeyDay,
                gratitudeText: gratitudeText,
                reasonText: reasonText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userJourneyId = const Value.absent(),
                Value<int?> journeyDay = const Value.absent(),
                required String gratitudeText,
                required String reasonText,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GratitudeEntriesCompanion.insert(
                id: id,
                userJourneyId: userJourneyId,
                journeyDay: journeyDay,
                gratitudeText: gratitudeText,
                reasonText: reasonText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<
                            $GratitudeEntriesTable,
                            GratitudeEntryRow
                          >(table),
                          $$GratitudeEntriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userJourneyId = false}) {
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
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userJourneyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userJourneyId,
                            referencedTable: $$GratitudeEntriesTableReferences
                                ._userJourneyIdTable(db),
                            referencedColumn:
                                $$GratitudeEntriesTableReferences
                                    ._userJourneyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GratitudeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$SoulDatabase,
      $GratitudeEntriesTable,
      GratitudeEntryRow,
      $$GratitudeEntriesTableFilterComposer,
      $$GratitudeEntriesTableOrderingComposer,
      $$GratitudeEntriesTableAnnotationComposer,
      $$GratitudeEntriesTableCreateCompanionBuilder,
      $$GratitudeEntriesTableUpdateCompanionBuilder,
      (GratitudeEntryRow, $$GratitudeEntriesTableReferences),
      GratitudeEntryRow,
      PrefetchHooks Function({bool userJourneyId})
    >;

class $SoulDatabaseManager {
  final _$SoulDatabase _db;
  $SoulDatabaseManager(this._db);
  $$UserJourneysTableTableManager get userJourneys =>
      $$UserJourneysTableTableManager(_db, _db.userJourneys);
  $$ReminderPreferencesTableTableManager get reminderPreferences =>
      $$ReminderPreferencesTableTableManager(_db, _db.reminderPreferences);
  $$VisionsTableTableManager get visions =>
      $$VisionsTableTableManager(_db, _db.visions);
  $$VisionFeelingsTableTableManager get visionFeelings =>
      $$VisionFeelingsTableTableManager(_db, _db.visionFeelings);
  $$VisionAnswersTableTableManager get visionAnswers =>
      $$VisionAnswersTableTableManager(_db, _db.visionAnswers);
  $$GratitudeEntriesTableTableManager get gratitudeEntries =>
      $$GratitudeEntriesTableTableManager(_db, _db.gratitudeEntries);
}
