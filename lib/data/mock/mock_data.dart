/// All seed data for demo screens. Nothing here is persisted — it's the
/// "mock-functional" layer so the client pitch looks complete without a
/// backend wired up yet.

class MockUser {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  const MockUser(this.id, this.name, this.role, this.avatarUrl);
}

class MockPost {
  final String id;
  final MockUser author;
  final String body;
  final String? imageUrl;
  final DateTime postedAt;
  int likes;
  final List<MockComment> comments;
  bool liked;
  MockPost({
    required this.id,
    required this.author,
    required this.body,
    this.imageUrl,
    required this.postedAt,
    this.likes = 0,
    this.liked = false,
    List<MockComment>? comments,
  }) : comments = comments ?? [];
}

class MockComment {
  final String id;
  final MockUser author;
  final String body;
  final DateTime postedAt;
  const MockComment({
    required this.id,
    required this.author,
    required this.body,
    required this.postedAt,
  });
}

class MockEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startsAt;
  final DateTime endsAt;
  final String location;
  final String? imageUrl;
  bool rsvpd;
  final int attendees;
  MockEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startsAt,
    required this.endsAt,
    required this.location,
    this.imageUrl,
    this.rsvpd = false,
    this.attendees = 0,
  });
}

class MockConversation {
  final String id;
  final String name;
  final bool isGroup;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unread;
  final String? avatarUrl;
  final List<MockUser> participants;
  const MockConversation({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unread = 0,
    this.avatarUrl,
    this.participants = const [],
  });
}

class MockMessage {
  final String id;
  final MockUser author;
  final String body;
  final DateTime sentAt;
  final bool fromMe;
  const MockMessage({
    required this.id,
    required this.author,
    required this.body,
    required this.sentAt,
    required this.fromMe,
  });
}

class MockNote {
  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;
  final String? sermonRef;
  const MockNote({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    this.sermonRef,
  });
}

class MockSermon {
  final String id;
  final String title;
  final String speaker;
  final String thumbnailUrl;
  final String duration;
  final DateTime date;
  final String series;
  const MockSermon({
    required this.id,
    required this.title,
    required this.speaker,
    required this.thumbnailUrl,
    required this.duration,
    required this.date,
    required this.series,
  });
}

class MockMediaItem {
  final String id;
  final String url;
  final String caption;
  final bool isVideo;
  const MockMediaItem({
    required this.id,
    required this.url,
    required this.caption,
    required this.isVideo,
  });
}

class MockSponsor {
  final String id;
  final String name;
  final String logoUrl;
  final String tagline;
  final String website;
  const MockSponsor({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.tagline,
    required this.website,
  });
}

class MockData {
  static final users = <MockUser>[
    const MockUser('u1', 'Pastor Keith', 'Lead Pastor', _avatar1),
    const MockUser('u2', 'Sarah Mitchell', 'Worship Team', _avatar2),
    const MockUser('u3', 'David Chen', 'Youth Leader', _avatar3),
    const MockUser('u4', 'Maria Santos', 'Small Groups', _avatar4),
    const MockUser('u5', 'James Wilson', 'Member', _avatar5),
    const MockUser('u6', 'Grace Thompson', 'Member', _avatar6),
  ];

  static final me = users[4];

  static final posts = <MockPost>[
    MockPost(
      id: 'p1',
      author: users[0],
      body:
          'Thank you to everyone who joined us Sunday. The Spirit moved in a powerful way. If you missed it, the sermon is available on-demand in the Watch tab.',
      imageUrl:
          'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=800',
      postedAt: DateTime.now().subtract(const Duration(hours: 3)),
      likes: 47,
      comments: [
        MockComment(
          id: 'c1',
          author: users[1],
          body: 'Amen, Pastor. The message on grace touched me deeply.',
          postedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        MockComment(
          id: 'c2',
          author: users[3],
          body: 'Sharing with my small group tonight.',
          postedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    MockPost(
      id: 'p2',
      author: users[2],
      body:
          'Youth Night this Friday — pizza, games, worship. Bring a friend! 7pm in the Fellowship Hall.',
      postedAt: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 23,
    ),
    MockPost(
      id: 'p3',
      author: users[3],
      body:
          'Small Groups sign-ups are open. Ten groups starting this week covering marriage, parenting, grief, and men/women studies. Link in More → Groups.',
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 31,
    ),
    MockPost(
      id: 'p4',
      author: users[1],
      body:
          'Choir rehearsal moved to Thursday 7pm this week only. Please make every effort to be there — Easter is coming!',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      likes: 15,
    ),
  ];

  static final events = <MockEvent>[
    MockEvent(
      id: 'e1',
      title: 'Sunday Service',
      description:
          'Join us for worship, communion, and Pastor Keith\'s continuing series in the Book of Romans.',
      startsAt: _nextSunday(hour: 10),
      endsAt: _nextSunday(hour: 11, minute: 30),
      location: 'Main Sanctuary',
      imageUrl:
          'https://images.unsplash.com/photo-1438032005730-c779502df39b?w=800',
      attendees: 284,
    ),
    MockEvent(
      id: 'e2',
      title: 'Youth Night',
      description: 'Pizza, games, worship, and a message from David. Grades 6-12.',
      startsAt: _thisWeek(weekday: DateTime.friday, hour: 19),
      endsAt: _thisWeek(weekday: DateTime.friday, hour: 21),
      location: 'Fellowship Hall',
      attendees: 42,
      rsvpd: true,
    ),
    MockEvent(
      id: 'e3',
      title: 'Womens Bible Study',
      description: 'A six-week study through Esther. All women welcome.',
      startsAt: _thisWeek(weekday: DateTime.wednesday, hour: 10),
      endsAt: _thisWeek(weekday: DateTime.wednesday, hour: 11, minute: 30),
      location: 'Room 204',
      attendees: 18,
    ),
    MockEvent(
      id: 'e4',
      title: 'Community Food Drive',
      description:
          'Partnering with the local food bank. Drop off non-perishables at the church office or volunteer to sort.',
      startsAt: DateTime.now().add(const Duration(days: 9, hours: 3)),
      endsAt: DateTime.now().add(const Duration(days: 9, hours: 6)),
      location: 'Church Parking Lot',
      imageUrl:
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
      attendees: 67,
    ),
    MockEvent(
      id: 'e5',
      title: 'Easter Sunrise Service',
      description: 'Outdoor sunrise service followed by brunch in Fellowship Hall.',
      startsAt: DateTime.now().add(const Duration(days: 21, hours: 6)),
      endsAt: DateTime.now().add(const Duration(days: 21, hours: 9)),
      location: 'Amphitheater',
      attendees: 412,
    ),
  ];

  static final conversations = <MockConversation>[
    MockConversation(
      id: 'conv1',
      name: 'Worship Team',
      isGroup: true,
      lastMessage: 'Sarah: See everyone at rehearsal Thursday!',
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 8)),
      unread: 3,
      participants: [users[0], users[1], users[2], users[3]],
    ),
    MockConversation(
      id: 'conv2',
      name: 'Pastor Keith',
      isGroup: false,
      lastMessage: 'Thanks for setting up the livestream last week.',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      avatarUrl: _avatar1,
      participants: [users[0]],
    ),
    MockConversation(
      id: 'conv3',
      name: 'Mens Group',
      isGroup: true,
      lastMessage: 'David: Breakfast moved to 7am Saturday.',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 5)),
      participants: [users[0], users[2], users[4]],
    ),
    MockConversation(
      id: 'conv4',
      name: 'Maria Santos',
      isGroup: false,
      lastMessage: 'Can you help with childcare Sunday?',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      unread: 1,
      avatarUrl: _avatar4,
      participants: [users[3]],
    ),
  ];

  static List<MockMessage> messagesFor(String conversationId) {
    switch (conversationId) {
      case 'conv1':
        return [
          MockMessage(
            id: 'm1',
            author: users[0],
            body: 'Great rehearsal last night, team.',
            sentAt: DateTime.now().subtract(const Duration(hours: 3)),
            fromMe: false,
          ),
          MockMessage(
            id: 'm2',
            author: users[1],
            body: 'Thanks Pastor! Song list for Sunday is in the shared folder.',
            sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
            fromMe: false,
          ),
          MockMessage(
            id: 'm3',
            author: MockData.me,
            body: 'On it. Ill have the slide deck ready Saturday.',
            sentAt: DateTime.now().subtract(const Duration(hours: 2)),
            fromMe: true,
          ),
          MockMessage(
            id: 'm4',
            author: users[1],
            body: 'See everyone at rehearsal Thursday!',
            sentAt: DateTime.now().subtract(const Duration(minutes: 8)),
            fromMe: false,
          ),
        ];
      case 'conv2':
        return [
          MockMessage(
            id: 'm1',
            author: users[0],
            body: 'Thanks for setting up the livestream last week.',
            sentAt: DateTime.now().subtract(const Duration(hours: 2)),
            fromMe: false,
          ),
        ];
      default:
        return [
          MockMessage(
            id: 'm1',
            author: users[3],
            body: 'Hey — got a minute?',
            sentAt: DateTime.now().subtract(const Duration(hours: 6)),
            fromMe: false,
          ),
        ];
    }
  }

  static final notes = <MockNote>[
    MockNote(
      id: 'n1',
      title: 'Romans 8 — Life in the Spirit',
      body:
          'Key verse: "There is therefore now no condemnation for those who are in Christ Jesus."\n\nPastor walked through:\n- vs 1-4: freedom from condemnation\n- vs 5-11: life in the Spirit vs life in the flesh\n- vs 12-17: we are adopted as heirs\n\nReflection: what does it mean to set my mind on the things of the Spirit this week?',
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      sermonRef: 'Romans Series — Week 12',
    ),
    MockNote(
      id: 'n2',
      title: 'Small group prayer requests',
      body:
          '- Marks mom (hospital)\n- Jenn + Tim — new job decision\n- Davids son (college app season)\n- Church — Easter outreach',
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MockNote(
      id: 'n3',
      title: 'Grace — sermon takeaways',
      body:
          'Grace is not the absence of consequence; it is the presence of God in the middle of consequence.\n\nThree things to remember:\n1. Grace finds us where we are\n2. Grace moves us to where He is\n3. Grace holds us all the way home',
      updatedAt: DateTime.now().subtract(const Duration(days: 11)),
      sermonRef: 'Grace Greater Than — Week 3',
    ),
  ];

  static final sermons = <MockSermon>[
    MockSermon(
      id: 's1',
      title: 'No Condemnation',
      speaker: 'Pastor Keith',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=800',
      duration: '42:18',
      date: DateTime.now().subtract(const Duration(days: 3)),
      series: 'Romans',
    ),
    MockSermon(
      id: 's2',
      title: 'Grace Greater Than',
      speaker: 'Pastor Keith',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=800',
      duration: '38:02',
      date: DateTime.now().subtract(const Duration(days: 10)),
      series: 'Grace',
    ),
    MockSermon(
      id: 's3',
      title: 'When the Storm Comes',
      speaker: 'David Chen',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?w=800',
      duration: '29:45',
      date: DateTime.now().subtract(const Duration(days: 17)),
      series: 'Guest Speaker',
    ),
    MockSermon(
      id: 's4',
      title: 'The Parable of the Sower',
      speaker: 'Pastor Keith',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=800',
      duration: '45:11',
      date: DateTime.now().subtract(const Duration(days: 24)),
      series: 'Parables',
    ),
  ];

  static final photos = <MockMediaItem>[
    MockMediaItem(
      id: 'ph1',
      url: 'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=800',
      caption: 'Sunday service',
      isVideo: false,
    ),
    MockMediaItem(
      id: 'ph2',
      url: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
      caption: 'Small groups kickoff',
      isVideo: false,
    ),
    MockMediaItem(
      id: 'ph3',
      url: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
      caption: 'Food drive',
      isVideo: false,
    ),
    MockMediaItem(
      id: 'ph4',
      url: 'https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=800',
      caption: 'Baptism Sunday',
      isVideo: false,
    ),
    MockMediaItem(
      id: 'ph5',
      url: 'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=800',
      caption: 'Worship night',
      isVideo: false,
    ),
    MockMediaItem(
      id: 'ph6',
      url: 'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?w=800',
      caption: 'Youth retreat',
      isVideo: false,
    ),
  ];

  static final videos = <MockMediaItem>[
    MockMediaItem(
      id: 'v1',
      url: 'https://images.unsplash.com/photo-1438032005730-c779502df39b?w=800',
      caption: 'Service highlights',
      isVideo: true,
    ),
    MockMediaItem(
      id: 'v2',
      url: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=800',
      caption: 'Baptism testimonies',
      isVideo: true,
    ),
    MockMediaItem(
      id: 'v3',
      url: 'https://images.unsplash.com/photo-1464207687429-7505649dae38?w=800',
      caption: 'Youth retreat recap',
      isVideo: true,
    ),
  ];

  static final sponsors = <MockSponsor>[
    MockSponsor(
      id: 'sp1',
      name: 'Grace Family Dental',
      logoUrl:
          'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=400',
      tagline: 'Gentle care for the whole family',
      website: 'https://example.com',
    ),
    MockSponsor(
      id: 'sp2',
      name: 'Covenant Coffee Roasters',
      logoUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      tagline: 'Small-batch, fair trade',
      website: 'https://example.com',
    ),
    MockSponsor(
      id: 'sp3',
      name: 'Cornerstone Construction',
      logoUrl:
          'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400',
      tagline: 'Building on a solid foundation',
      website: 'https://example.com',
    ),
  ];
}

DateTime _nextSunday({int hour = 10, int minute = 0}) {
  final now = DateTime.now();
  int daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
  if (daysUntilSunday == 0 && now.hour >= hour) daysUntilSunday = 7;
  final target = DateTime(now.year, now.month, now.day, hour, minute)
      .add(Duration(days: daysUntilSunday));
  return target;
}

DateTime _thisWeek({required int weekday, int hour = 0, int minute = 0}) {
  final now = DateTime.now();
  int diff = (weekday - now.weekday) % 7;
  if (diff == 0 && now.hour >= hour) diff = 7;
  return DateTime(now.year, now.month, now.day, hour, minute)
      .add(Duration(days: diff));
}

const String _avatar1 =
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200';
const String _avatar2 =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200';
const String _avatar3 =
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200';
const String _avatar4 =
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200';
const String _avatar5 =
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200';
const String _avatar6 =
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200';
