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

abstract class _$SoulDatabase extends GeneratedDatabase {
  _$SoulDatabase(QueryExecutor e) : super(e);
  $SoulDatabaseManager get managers => $SoulDatabaseManager(this);
  late final $UserJourneysTable userJourneys = $UserJourneysTable(this);
  late final $ReminderPreferencesTable reminderPreferences =
      $ReminderPreferencesTable(this);
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
    userJourneysOneActive,
  ];
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
          (
            UserJourneyRow,
            BaseReferences<_$SoulDatabase, $UserJourneysTable, UserJourneyRow>,
          ),
          UserJourneyRow,
          PrefetchHooks Function()
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
                          BaseReferences<
                            _$SoulDatabase,
                            $UserJourneysTable,
                            UserJourneyRow
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
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
      (
        UserJourneyRow,
        BaseReferences<_$SoulDatabase, $UserJourneysTable, UserJourneyRow>,
      ),
      UserJourneyRow,
      PrefetchHooks Function()
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

class $SoulDatabaseManager {
  final _$SoulDatabase _db;
  $SoulDatabaseManager(this._db);
  $$UserJourneysTableTableManager get userJourneys =>
      $$UserJourneysTableTableManager(_db, _db.userJourneys);
  $$ReminderPreferencesTableTableManager get reminderPreferences =>
      $$ReminderPreferencesTableTableManager(_db, _db.reminderPreferences);
}
