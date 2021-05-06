// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Article extends DataClass implements Insertable<Article> {
  final int id;
  final int feedId;
  final String title;
  final int isStar;
  final int isRead;
  final String description;
  final String htmlContent;
  final String flavorImage;
  final String articleOriginLink;
  final int publishTime;
  Article(
      {@required this.id,
      @required this.feedId,
      @required this.title,
      @required this.isStar,
      @required this.isRead,
      @required this.description,
      @required this.htmlContent,
      @required this.flavorImage,
      @required this.articleOriginLink,
      @required this.publishTime});
  factory Article.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Article(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feedId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}feed_id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      isStar:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}is_star']),
      isRead:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}is_read']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      htmlContent:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      flavorImage: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}flavor_image']),
      articleOriginLink: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}article_origin_link']),
      publishTime: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}publish_time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || feedId != null) {
      map['feed_id'] = Variable<int>(feedId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || isStar != null) {
      map['is_star'] = Variable<int>(isStar);
    }
    if (!nullToAbsent || isRead != null) {
      map['is_read'] = Variable<int>(isRead);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || htmlContent != null) {
      map['body'] = Variable<String>(htmlContent);
    }
    if (!nullToAbsent || flavorImage != null) {
      map['flavor_image'] = Variable<String>(flavorImage);
    }
    if (!nullToAbsent || articleOriginLink != null) {
      map['article_origin_link'] = Variable<String>(articleOriginLink);
    }
    if (!nullToAbsent || publishTime != null) {
      map['publish_time'] = Variable<int>(publishTime);
    }
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feedId:
          feedId == null && nullToAbsent ? const Value.absent() : Value(feedId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      isStar:
          isStar == null && nullToAbsent ? const Value.absent() : Value(isStar),
      isRead:
          isRead == null && nullToAbsent ? const Value.absent() : Value(isRead),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      htmlContent: htmlContent == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlContent),
      flavorImage: flavorImage == null && nullToAbsent
          ? const Value.absent()
          : Value(flavorImage),
      articleOriginLink: articleOriginLink == null && nullToAbsent
          ? const Value.absent()
          : Value(articleOriginLink),
      publishTime: publishTime == null && nullToAbsent
          ? const Value.absent()
          : Value(publishTime),
    );
  }

  factory Article.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Article(
      id: serializer.fromJson<int>(json['id']),
      feedId: serializer.fromJson<int>(json['feedId']),
      title: serializer.fromJson<String>(json['title']),
      isStar: serializer.fromJson<int>(json['isStar']),
      isRead: serializer.fromJson<int>(json['isRead']),
      description: serializer.fromJson<String>(json['description']),
      htmlContent: serializer.fromJson<String>(json['htmlContent']),
      flavorImage: serializer.fromJson<String>(json['flavorImage']),
      articleOriginLink: serializer.fromJson<String>(json['articleOriginLink']),
      publishTime: serializer.fromJson<int>(json['publishTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feedId': serializer.toJson<int>(feedId),
      'title': serializer.toJson<String>(title),
      'isStar': serializer.toJson<int>(isStar),
      'isRead': serializer.toJson<int>(isRead),
      'description': serializer.toJson<String>(description),
      'htmlContent': serializer.toJson<String>(htmlContent),
      'flavorImage': serializer.toJson<String>(flavorImage),
      'articleOriginLink': serializer.toJson<String>(articleOriginLink),
      'publishTime': serializer.toJson<int>(publishTime),
    };
  }

  Article copyWith(
          {int id,
          int feedId,
          String title,
          int isStar,
          int isRead,
          String description,
          String htmlContent,
          String flavorImage,
          String articleOriginLink,
          int publishTime}) =>
      Article(
        id: id ?? this.id,
        feedId: feedId ?? this.feedId,
        title: title ?? this.title,
        isStar: isStar ?? this.isStar,
        isRead: isRead ?? this.isRead,
        description: description ?? this.description,
        htmlContent: htmlContent ?? this.htmlContent,
        flavorImage: flavorImage ?? this.flavorImage,
        articleOriginLink: articleOriginLink ?? this.articleOriginLink,
        publishTime: publishTime ?? this.publishTime,
      );
  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('id: $id, ')
          ..write('feedId: $feedId, ')
          ..write('title: $title, ')
          ..write('isStar: $isStar, ')
          ..write('isRead: $isRead, ')
          ..write('description: $description, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('flavorImage: $flavorImage, ')
          ..write('articleOriginLink: $articleOriginLink, ')
          ..write('publishTime: $publishTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feedId.hashCode,
          $mrjc(
              title.hashCode,
              $mrjc(
                  isStar.hashCode,
                  $mrjc(
                      isRead.hashCode,
                      $mrjc(
                          description.hashCode,
                          $mrjc(
                              htmlContent.hashCode,
                              $mrjc(
                                  flavorImage.hashCode,
                                  $mrjc(articleOriginLink.hashCode,
                                      publishTime.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Article &&
          other.id == this.id &&
          other.feedId == this.feedId &&
          other.title == this.title &&
          other.isStar == this.isStar &&
          other.isRead == this.isRead &&
          other.description == this.description &&
          other.htmlContent == this.htmlContent &&
          other.flavorImage == this.flavorImage &&
          other.articleOriginLink == this.articleOriginLink &&
          other.publishTime == this.publishTime);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<int> id;
  final Value<int> feedId;
  final Value<String> title;
  final Value<int> isStar;
  final Value<int> isRead;
  final Value<String> description;
  final Value<String> htmlContent;
  final Value<String> flavorImage;
  final Value<String> articleOriginLink;
  final Value<int> publishTime;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.feedId = const Value.absent(),
    this.title = const Value.absent(),
    this.isStar = const Value.absent(),
    this.isRead = const Value.absent(),
    this.description = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.flavorImage = const Value.absent(),
    this.articleOriginLink = const Value.absent(),
    this.publishTime = const Value.absent(),
  });
  ArticlesCompanion.insert({
    @required int id,
    @required int feedId,
    @required String title,
    @required int isStar,
    @required int isRead,
    @required String description,
    @required String htmlContent,
    @required String flavorImage,
    @required String articleOriginLink,
    @required int publishTime,
  })  : id = Value(id),
        feedId = Value(feedId),
        title = Value(title),
        isStar = Value(isStar),
        isRead = Value(isRead),
        description = Value(description),
        htmlContent = Value(htmlContent),
        flavorImage = Value(flavorImage),
        articleOriginLink = Value(articleOriginLink),
        publishTime = Value(publishTime);
  static Insertable<Article> custom({
    Expression<int> id,
    Expression<int> feedId,
    Expression<String> title,
    Expression<int> isStar,
    Expression<int> isRead,
    Expression<String> description,
    Expression<String> htmlContent,
    Expression<String> flavorImage,
    Expression<String> articleOriginLink,
    Expression<int> publishTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feedId != null) 'feed_id': feedId,
      if (title != null) 'title': title,
      if (isStar != null) 'is_star': isStar,
      if (isRead != null) 'is_read': isRead,
      if (description != null) 'description': description,
      if (htmlContent != null) 'body': htmlContent,
      if (flavorImage != null) 'flavor_image': flavorImage,
      if (articleOriginLink != null) 'article_origin_link': articleOriginLink,
      if (publishTime != null) 'publish_time': publishTime,
    });
  }

  ArticlesCompanion copyWith(
      {Value<int> id,
      Value<int> feedId,
      Value<String> title,
      Value<int> isStar,
      Value<int> isRead,
      Value<String> description,
      Value<String> htmlContent,
      Value<String> flavorImage,
      Value<String> articleOriginLink,
      Value<int> publishTime}) {
    return ArticlesCompanion(
      id: id ?? this.id,
      feedId: feedId ?? this.feedId,
      title: title ?? this.title,
      isStar: isStar ?? this.isStar,
      isRead: isRead ?? this.isRead,
      description: description ?? this.description,
      htmlContent: htmlContent ?? this.htmlContent,
      flavorImage: flavorImage ?? this.flavorImage,
      articleOriginLink: articleOriginLink ?? this.articleOriginLink,
      publishTime: publishTime ?? this.publishTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feedId.present) {
      map['feed_id'] = Variable<int>(feedId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isStar.present) {
      map['is_star'] = Variable<int>(isStar.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<int>(isRead.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (htmlContent.present) {
      map['body'] = Variable<String>(htmlContent.value);
    }
    if (flavorImage.present) {
      map['flavor_image'] = Variable<String>(flavorImage.value);
    }
    if (articleOriginLink.present) {
      map['article_origin_link'] = Variable<String>(articleOriginLink.value);
    }
    if (publishTime.present) {
      map['publish_time'] = Variable<int>(publishTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('feedId: $feedId, ')
          ..write('title: $title, ')
          ..write('isStar: $isStar, ')
          ..write('isRead: $isRead, ')
          ..write('description: $description, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('flavorImage: $flavorImage, ')
          ..write('articleOriginLink: $articleOriginLink, ')
          ..write('publishTime: $publishTime')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTable extends Articles with TableInfo<$ArticlesTable, Article> {
  final GeneratedDatabase _db;
  final String _alias;
  $ArticlesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _feedIdMeta = const VerificationMeta('feedId');
  GeneratedIntColumn _feedId;
  @override
  GeneratedIntColumn get feedId => _feedId ??= _constructFeedId();
  GeneratedIntColumn _constructFeedId() {
    return GeneratedIntColumn(
      'feed_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isStarMeta = const VerificationMeta('isStar');
  GeneratedIntColumn _isStar;
  @override
  GeneratedIntColumn get isStar => _isStar ??= _constructIsStar();
  GeneratedIntColumn _constructIsStar() {
    return GeneratedIntColumn(
      'is_star',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  GeneratedIntColumn _isRead;
  @override
  GeneratedIntColumn get isRead => _isRead ??= _constructIsRead();
  GeneratedIntColumn _constructIsRead() {
    return GeneratedIntColumn(
      'is_read',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _htmlContentMeta =
      const VerificationMeta('htmlContent');
  GeneratedTextColumn _htmlContent;
  @override
  GeneratedTextColumn get htmlContent =>
      _htmlContent ??= _constructHtmlContent();
  GeneratedTextColumn _constructHtmlContent() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  final VerificationMeta _flavorImageMeta =
      const VerificationMeta('flavorImage');
  GeneratedTextColumn _flavorImage;
  @override
  GeneratedTextColumn get flavorImage =>
      _flavorImage ??= _constructFlavorImage();
  GeneratedTextColumn _constructFlavorImage() {
    return GeneratedTextColumn(
      'flavor_image',
      $tableName,
      false,
    );
  }

  final VerificationMeta _articleOriginLinkMeta =
      const VerificationMeta('articleOriginLink');
  GeneratedTextColumn _articleOriginLink;
  @override
  GeneratedTextColumn get articleOriginLink =>
      _articleOriginLink ??= _constructArticleOriginLink();
  GeneratedTextColumn _constructArticleOriginLink() {
    return GeneratedTextColumn(
      'article_origin_link',
      $tableName,
      false,
    );
  }

  final VerificationMeta _publishTimeMeta =
      const VerificationMeta('publishTime');
  GeneratedIntColumn _publishTime;
  @override
  GeneratedIntColumn get publishTime =>
      _publishTime ??= _constructPublishTime();
  GeneratedIntColumn _constructPublishTime() {
    return GeneratedIntColumn(
      'publish_time',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        feedId,
        title,
        isStar,
        isRead,
        description,
        htmlContent,
        flavorImage,
        articleOriginLink,
        publishTime
      ];
  @override
  $ArticlesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'articles';
  @override
  final String actualTableName = 'articles';
  @override
  VerificationContext validateIntegrity(Insertable<Article> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feed_id')) {
      context.handle(_feedIdMeta,
          feedId.isAcceptableOrUnknown(data['feed_id'], _feedIdMeta));
    } else if (isInserting) {
      context.missing(_feedIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_star')) {
      context.handle(_isStarMeta,
          isStar.isAcceptableOrUnknown(data['is_star'], _isStarMeta));
    } else if (isInserting) {
      context.missing(_isStarMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read'], _isReadMeta));
    } else if (isInserting) {
      context.missing(_isReadMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_htmlContentMeta,
          htmlContent.isAcceptableOrUnknown(data['body'], _htmlContentMeta));
    } else if (isInserting) {
      context.missing(_htmlContentMeta);
    }
    if (data.containsKey('flavor_image')) {
      context.handle(
          _flavorImageMeta,
          flavorImage.isAcceptableOrUnknown(
              data['flavor_image'], _flavorImageMeta));
    } else if (isInserting) {
      context.missing(_flavorImageMeta);
    }
    if (data.containsKey('article_origin_link')) {
      context.handle(
          _articleOriginLinkMeta,
          articleOriginLink.isAcceptableOrUnknown(
              data['article_origin_link'], _articleOriginLinkMeta));
    } else if (isInserting) {
      context.missing(_articleOriginLinkMeta);
    }
    if (data.containsKey('publish_time')) {
      context.handle(
          _publishTimeMeta,
          publishTime.isAcceptableOrUnknown(
              data['publish_time'], _publishTimeMeta));
    } else if (isInserting) {
      context.missing(_publishTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, feedId};
  @override
  Article map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Article.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(_db, alias);
  }
}

class Feed extends DataClass implements Insertable<Feed> {
  final int id;
  final String feedTitle;
  final String feedIcon;
  final int categoryId;
  Feed(
      {@required this.id,
      @required this.feedTitle,
      @required this.feedIcon,
      @required this.categoryId});
  factory Feed.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Feed(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feedTitle: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}feed_title']),
      feedIcon: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}feed_icon']),
      categoryId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || feedTitle != null) {
      map['feed_title'] = Variable<String>(feedTitle);
    }
    if (!nullToAbsent || feedIcon != null) {
      map['feed_icon'] = Variable<String>(feedIcon);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    return map;
  }

  FeedsCompanion toCompanion(bool nullToAbsent) {
    return FeedsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feedTitle: feedTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(feedTitle),
      feedIcon: feedIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(feedIcon),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
    );
  }

  factory Feed.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Feed(
      id: serializer.fromJson<int>(json['id']),
      feedTitle: serializer.fromJson<String>(json['feedTitle']),
      feedIcon: serializer.fromJson<String>(json['feedIcon']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feedTitle': serializer.toJson<String>(feedTitle),
      'feedIcon': serializer.toJson<String>(feedIcon),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  Feed copyWith({int id, String feedTitle, String feedIcon, int categoryId}) =>
      Feed(
        id: id ?? this.id,
        feedTitle: feedTitle ?? this.feedTitle,
        feedIcon: feedIcon ?? this.feedIcon,
        categoryId: categoryId ?? this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('Feed(')
          ..write('id: $id, ')
          ..write('feedTitle: $feedTitle, ')
          ..write('feedIcon: $feedIcon, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feedTitle.hashCode, $mrjc(feedIcon.hashCode, categoryId.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Feed &&
          other.id == this.id &&
          other.feedTitle == this.feedTitle &&
          other.feedIcon == this.feedIcon &&
          other.categoryId == this.categoryId);
}

class FeedsCompanion extends UpdateCompanion<Feed> {
  final Value<int> id;
  final Value<String> feedTitle;
  final Value<String> feedIcon;
  final Value<int> categoryId;
  const FeedsCompanion({
    this.id = const Value.absent(),
    this.feedTitle = const Value.absent(),
    this.feedIcon = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  FeedsCompanion.insert({
    @required int id,
    @required String feedTitle,
    @required String feedIcon,
    @required int categoryId,
  })  : id = Value(id),
        feedTitle = Value(feedTitle),
        feedIcon = Value(feedIcon),
        categoryId = Value(categoryId);
  static Insertable<Feed> custom({
    Expression<int> id,
    Expression<String> feedTitle,
    Expression<String> feedIcon,
    Expression<int> categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feedTitle != null) 'feed_title': feedTitle,
      if (feedIcon != null) 'feed_icon': feedIcon,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  FeedsCompanion copyWith(
      {Value<int> id,
      Value<String> feedTitle,
      Value<String> feedIcon,
      Value<int> categoryId}) {
    return FeedsCompanion(
      id: id ?? this.id,
      feedTitle: feedTitle ?? this.feedTitle,
      feedIcon: feedIcon ?? this.feedIcon,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feedTitle.present) {
      map['feed_title'] = Variable<String>(feedTitle.value);
    }
    if (feedIcon.present) {
      map['feed_icon'] = Variable<String>(feedIcon.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedsCompanion(')
          ..write('id: $id, ')
          ..write('feedTitle: $feedTitle, ')
          ..write('feedIcon: $feedIcon, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $FeedsTable extends Feeds with TableInfo<$FeedsTable, Feed> {
  final GeneratedDatabase _db;
  final String _alias;
  $FeedsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _feedTitleMeta = const VerificationMeta('feedTitle');
  GeneratedTextColumn _feedTitle;
  @override
  GeneratedTextColumn get feedTitle => _feedTitle ??= _constructFeedTitle();
  GeneratedTextColumn _constructFeedTitle() {
    return GeneratedTextColumn(
      'feed_title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _feedIconMeta = const VerificationMeta('feedIcon');
  GeneratedTextColumn _feedIcon;
  @override
  GeneratedTextColumn get feedIcon => _feedIcon ??= _constructFeedIcon();
  GeneratedTextColumn _constructFeedIcon() {
    return GeneratedTextColumn(
      'feed_icon',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  GeneratedIntColumn _categoryId;
  @override
  GeneratedIntColumn get categoryId => _categoryId ??= _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn(
      'category_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, feedTitle, feedIcon, categoryId];
  @override
  $FeedsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'feeds';
  @override
  final String actualTableName = 'feeds';
  @override
  VerificationContext validateIntegrity(Insertable<Feed> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feed_title')) {
      context.handle(_feedTitleMeta,
          feedTitle.isAcceptableOrUnknown(data['feed_title'], _feedTitleMeta));
    } else if (isInserting) {
      context.missing(_feedTitleMeta);
    }
    if (data.containsKey('feed_icon')) {
      context.handle(_feedIconMeta,
          feedIcon.isAcceptableOrUnknown(data['feed_icon'], _feedIconMeta));
    } else if (isInserting) {
      context.missing(_feedIconMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id'], _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, categoryId};
  @override
  Feed map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Feed.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FeedsTable createAlias(String alias) {
    return $FeedsTable(_db, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String categoryName;
  Category({@required this.id, @required this.categoryName});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Category(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      categoryName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryName': serializer.toJson<String>(categoryName),
    };
  }

  Category copyWith({int id, String categoryName}) => Category(
        id: id ?? this.id,
        categoryName: categoryName ?? this.categoryName,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('categoryName: $categoryName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, categoryName.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.categoryName == this.categoryName);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> categoryName;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryName = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    @required String categoryName,
  }) : categoryName = Value(categoryName);
  static Insertable<Category> custom({
    Expression<int> id,
    Expression<String> categoryName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryName != null) 'category_name': categoryName,
    });
  }

  CategoriesCompanion copyWith({Value<int> id, Value<String> categoryName}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('categoryName: $categoryName')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String _alias;
  $CategoriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  GeneratedTextColumn _categoryName;
  @override
  GeneratedTextColumn get categoryName =>
      _categoryName ??= _constructCategoryName();
  GeneratedTextColumn _constructCategoryName() {
    return GeneratedTextColumn(
      'category_name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, categoryName];
  @override
  $CategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name'], _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Category.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ArticlesTable _articles;
  $ArticlesTable get articles => _articles ??= $ArticlesTable(this);
  $FeedsTable _feeds;
  $FeedsTable get feeds => _feeds ??= $FeedsTable(this);
  $CategoriesTable _categories;
  $CategoriesTable get categories => _categories ??= $CategoriesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [articles, feeds, categories];
}
