// lib/personal_data/portfolio_content.dart
//
// Everything in this file is your own editable content: contact links,
// projects, certificates, skills, and every piece of text shown on screen
// (hero, about, navbar, footer). Change values here to update the site -
// no need to touch any file outside this folder for content changes.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Project Model ---
class Project {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;

  Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
  });
}

// --- Certificate Model ---
class Certificate {
  final String title;
  final String imageAsset; // Local asset path to the certificate image
  final String issuer;
  final String issueDate;

  Certificate({
    required this.title,
    required this.imageAsset,
    required this.issuer,
    required this.issueDate,
  });
}

// --- Social Link Model ---
class SocialLink {
  final IconData icon;
  final String url;

  SocialLink({required this.icon, required this.url});
}

// --- Skill Model ---
class Skill {
  final String name;
  final IconData? icon;

  Skill({required this.name, this.icon});
}

// --- AppData (contains all static data for the portfolio) ---
class AppData {
  // --- NEW: Navigation Items (added to fix navbar error) ---
  static final List<String> navItems = [
    'Home',
    'About',
    'Skills',
    'Portfolio',
    'Contact',
  ];

  static final List<Project> projects = [
    Project(
      title: 'E-commerce Platform',
      description:
          'A full-stack e-commerce solution with user authentication, product listings, shopping cart, and checkout.',
      imageUrl:
          'https://placehold.co/600x400/AD343E/F3E9F4?text=E-Commerce', // Placeholder Image
      technologies: [
        'React',
        'Node.js',
        'Express',
        'MongoDB',
        'Redux',
        'Stripe',
      ],
      githubUrl: 'https://github.com/your-username/ecommerce-app',
      liveUrl: 'https://ecommerce.example.com',
    ),
    Project(
      title: 'Real-time Chat App',
      description:
          'A real-time chat application with group chats, private messaging, and notification features.',
      imageUrl:
          'https://placehold.co/600x400/50B2C0/F3E9F4?text=Chat+App', // Placeholder Image
      technologies: ['React', 'Socket.IO', 'Node.js', 'PostgreSQL'],
      githubUrl: 'https://github.com/your-username/chat-app',
      liveUrl: 'https://chat.example.com',
    ),
    Project(
      title: 'Portfolio Website',
      description:
          'My personal portfolio website showcasing my skills, projects, and contact information, built with modern web technologies.',
      imageUrl:
          'https://placehold.co/600x400/003C43/F3E9F4?text=Portfolio', // Placeholder Image
      technologies: ['Flutter', 'Dart', 'CustomPainter', 'Animations'],
      githubUrl: 'https://github.com/your-username/portfolio-website',
      liveUrl: 'https://portfolio.example.com',
    ),
    Project(
      title: 'Task Management API',
      description:
          'A robust RESTful API for managing tasks, including user authentication, task creation, and filtering.',
      imageUrl:
          'https://placehold.co/600x400/7469B6/F3E9F4?text=Task+API', // Placeholder Image
      technologies: ['Python', 'Django REST Framework', 'PostgreSQL'],
      githubUrl: 'https://github.com/your-username/task-api',
      // No live URL as it's an API
    ),
    Project(
      title: 'Mobile Recipe App',
      description:
          'A mobile application for discovering and saving recipes, with features like ingredient search and meal planning.',
      imageUrl:
          'https://placehold.co/600x400/96B4C4/F3E9F4?text=Recipe+App', // Placeholder Image
      technologies: ['React Native', 'Firebase', 'Redux'],
      githubUrl: 'https://github.com/your-username/recipe-app',
      // No live URL for a mobile app (unless deployed to stores)
    ),
    Project(
      title: 'Blog Content Management System',
      description:
          'A custom CMS for managing blog posts, categories, and users, with a rich text editor and media uploads.',
      imageUrl:
          'https://placehold.co/600x400/F15A59/F3E9F4?text=CMS', // Placeholder Image
      technologies: ['PHP', 'Laravel', 'MySQL', 'Blade Templates'],
      githubUrl: 'https://github.com/your-username/blog-cms',
      liveUrl: 'https://blogcms.example.com',
    ),
  ];

  // --- Certificates Data ---
  static final List<Certificate> certificates = [
    Certificate(
      title: 'AI-First Product Management',
      imageAsset: 'assets/certificates/ai-product-management-airtribe.png',
      issuer: 'Airtribe',
      issueDate: '19 May 2026',
    ),
    Certificate(
      title: 'Introduction to Figma',
      imageAsset: 'assets/certificates/figma-simplilearn.png',
      issuer: 'Simplilearn SkillUp',
      issueDate: '25 September 2026',
    ),
    Certificate(
      title: 'Generative AI Mastermind',
      imageAsset: 'assets/certificates/genai-mastermind-outskill.png',
      issuer: 'Outskill',
      // Not printed on the certificate itself; taken from the file's
      // creation date.
      issueDate: '28 August 2025',
    ),
    Certificate(
      title: 'Cyber Security and Forensics',
      imageAsset: 'assets/certificates/cybersecurity-ibm.png',
      issuer: 'IBM Skills Network',
      issueDate: '14 May 2025',
    ),
    Certificate(
      title: 'Flutter Industrial Training (90 Days)',
      imageAsset: 'assets/certificates/flutter-internship-hindtech.png',
      issuer: 'Hindtech IT Solutions',
      issueDate: '15 May 2025',
    ),
    Certificate(
      title: 'Marketing Internship',
      imageAsset: 'assets/certificates/marketing-internship-fuzemee.png',
      issuer: 'FuzeMee',
      issueDate: '10 December 2022',
    ),
  ];

  static final List<SocialLink> socialLinks = [
    SocialLink(
      icon: FontAwesomeIcons.linkedin,
      url: 'https://www.linkedin.com/in/himanshu-chatterjee-386684267',
    ),
    SocialLink(
      icon: FontAwesomeIcons.github,
      url: 'https://github.com/Himanshu-moderator',
    ),
    SocialLink(
      icon: FontAwesomeIcons.xTwitter,
      url: 'https://x.com/',
    ), // TODO: update once the X account is live
  ];

  static final List<Skill> skills = [
    Skill(name: 'Product Strategy', icon: FontAwesomeIcons.chessKnight),
    Skill(name: 'Agile / Scrum', icon: FontAwesomeIcons.arrowsSpin),
    Skill(name: 'SQL', icon: FontAwesomeIcons.database),
    Skill(name: 'Figma', icon: FontAwesomeIcons.figma),
    Skill(name: 'Jira', icon: FontAwesomeIcons.jira),
    Skill(name: 'Data Analytics', icon: FontAwesomeIcons.chartLine),
    Skill(name: 'Design Thinking', icon: FontAwesomeIcons.brain),
    Skill(name: 'Android Studio', icon: FontAwesomeIcons.android),
    Skill(name: 'Dart', icon: FontAwesomeIcons.dartLang),
    Skill(name: 'Flutter', icon: FontAwesomeIcons.flutter),
    Skill(name: 'Trello', icon: FontAwesomeIcons.trello),
    Skill(name: 'Google Analytics', icon: FontAwesomeIcons.google),
  ];
}

// --- Site branding: shown in the navbar and footer ---
class SiteBranding {
  // Short/stylized form - used for the desktop navbar brand and the footer
  static const String formalName = 'HC.';
  // Full name - used for the mobile navbar brand
  static const String informalName = 'Himanshu.';
  static const String footerTagline = 'Built with Flutter.';
}

// --- Hero section content ---
class HeroContent {
  static const String badgeText = 'Ready to Build';
  static const String titleLine1 = 'Product';
  static const String titleLine2 = 'Manager';

  // Rotates in the typewriter animation under the title
  static const List<String> roleTexts = [
    'Aspiring APM',
    'Strategic Thinker',
    'User-First Approach',
    'AI-Assisted Innovator',
  ];

  static const String description =
      'Turning user insights into products people actually want - passionate '
      'about strategy, execution, and solving real problems through '
      'thoughtful product decisions.';

  // Tool/skill chips shown under the description
  static const List<String> skillChips = [
    'Jira',
    'Trello',
    'Google Analytics',
    'Figma',
    'Android Studio',
  ];
}

// --- About section content ---
class AboutContent {
  static const String sectionTitle = 'About Me';
  static const String cardHeading = 'A Little Bit About Me';
  static const String profileImageAsset = 'assets/profile.webp';

  static const List<String> paragraphs = [
    "I'm Himanshu, an aspiring Associate Product Manager with a Product "
        "Management certification from Airtribe. I've been focused on turning "
        'that foundation into real-world impact, built on a genuine '
        'curiosity for how products work and why users behave the way they do.',
    "I'm especially drawn to fintech and fast commerce, where speed, trust, "
        'and user experience all have to work together under pressure. I '
        'focus on translating user needs into clear product decisions - from '
        'problem definition to roadmap prioritization - using tools like '
        'Jira, Figma, and SQL to stay close to both the user and the data.',
    'My interest in psychology shapes how I think about products - '
        'understanding why people behave the way they do is, to me, the real '
        "foundation of good product decisions. I'm a continuous learner, "
        'always exploring new frameworks for product thinking, and how AI '
        'can make both products and teams work smarter.',
    'Outside of product, I follow the forex markets, love traveling to new '
        "places, and enjoy photography along the way. I'm always open to new "
        "challenges and conversations - let's turn the next big idea into a "
        'product people love.',
  ];
}

// --- Skills section content ---
class SkillsContent {
  static const String sectionTitle = 'My Skills';
}

// --- Portfolio section content ---
class PortfolioContentText {
  static const String sectionTitle = 'Portfolio Showcase';
  static const String sectionSubtitle =
      'Explore my journey through projects, certifications, and technical '
      'expertise. Each section represents a milestone in my continuous '
      'learning path.';
}

// --- Contact section content ---
class ContactContent {
  static const String sectionTitle = 'Get In Touch';
  static const String introText =
      'Have a project in mind or just want to chat? Feel free to reach out!';
  static const String sendButtonLabel = 'Send Message';
  static const String socialPromptText = 'Or connect with me on social media:';
}

// --- Splash screen content ---
class SplashContent {
  static const String welcomeLine1 = 'Welcome To My';
  static const String welcomeLine2 = 'Portfolio Website';
  static const String typedTitle = "Himanshu's Portfolio";
}
