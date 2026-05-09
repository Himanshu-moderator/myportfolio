// lib/utils/data.dart

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
  final String imageUrl; // URL to the certificate image
  final String issuer;
  final String issueDate;
  final String? certificateUrl; // Link to verify the certificate online

  Certificate({
    required this.title,
    required this.imageUrl,
    required this.issuer,
    required this.issueDate,
    this.certificateUrl,
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
      description: 'A full-stack e-commerce solution with user authentication, product listings, shopping cart, and checkout.',
      imageUrl: 'https://placehold.co/600x400/AD343E/F3E9F4?text=E-Commerce', // Placeholder Image
      technologies: ['React', 'Node.js', 'Express', 'MongoDB', 'Redux', 'Stripe'],
      githubUrl: 'https://github.com/your-username/ecommerce-app',
      liveUrl: 'https://ecommerce.example.com',
    ),
    Project(
      title: 'Real-time Chat App',
      description: 'A real-time chat application with group chats, private messaging, and notification features.',
      imageUrl: 'https://placehold.co/600x400/50B2C0/F3E9F4?text=Chat+App', // Placeholder Image
      technologies: ['React', 'Socket.IO', 'Node.js', 'PostgreSQL'],
      githubUrl: 'https://github.com/your-username/chat-app',
      liveUrl: 'https://chat.example.com',
    ),
    Project(
      title: 'Portfolio Website',
      description: 'My personal portfolio website showcasing my skills, projects, and contact information, built with modern web technologies.',
      imageUrl: 'https://placehold.co/600x400/003C43/F3E9F4?text=Portfolio', // Placeholder Image
      technologies: ['Flutter', 'Dart', 'CustomPainter', 'Animations'],
      githubUrl: 'https://github.com/your-username/portfolio-website',
      liveUrl: 'https://portfolio.example.com',
    ),
    Project(
      title: 'Task Management API',
      description: 'A robust RESTful API for managing tasks, including user authentication, task creation, and filtering.',
      imageUrl: 'https://placehold.co/600x400/7469B6/F3E9F4?text=Task+API', // Placeholder Image
      technologies: ['Python', 'Django REST Framework', 'PostgreSQL'],
      githubUrl: 'https://github.com/your-username/task-api',
      // No live URL as it's an API
    ),
    Project(
      title: 'Mobile Recipe App',
      description: 'A mobile application for discovering and saving recipes, with features like ingredient search and meal planning.',
      imageUrl: 'https://placehold.co/600x400/96B4C4/F3E9F4?text=Recipe+App', // Placeholder Image
      technologies: ['React Native', 'Firebase', 'Redux'],
      githubUrl: 'https://github.com/your-username/recipe-app',
      // No live URL for a mobile app (unless deployed to stores)
    ),
    Project(
      title: 'Blog Content Management System',
      description: 'A custom CMS for managing blog posts, categories, and users, with a rich text editor and media uploads.',
      imageUrl: 'https://placehold.co/600x400/F15A59/F3E9F4?text=CMS', // Placeholder Image
      technologies: ['PHP', 'Laravel', 'MySQL', 'Blade Templates'],
      githubUrl: 'https://github.com/your-username/blog-cms',
      liveUrl: 'https://blogcms.example.com',
    ),
  ];

  // --- Certificates Data ---
  static final List<Certificate> certificates = [
    Certificate(
      title: 'Belajar Dasar Pemrograman JavaScript',
      imageUrl: 'https://placehold.co/600x400/800080/FFFFFF?text=Cert+JS', // Placeholder: Purple
      issuer: 'Dicoding',
      issueDate: '20 Desember 2023',
      certificateUrl: 'https://www.dicoding.com/certificates/EXAMPLE-JS-CERT',
    ),
    Certificate(
      title: 'Belajar Dasar Vaocloudx Data',
      imageUrl: 'https://placehold.co/600x400/FFA500/FFFFFF?text=Cert+Data', // Placeholder: Orange
      issuer: 'Dicoding',
      issueDate: '20 Agustus 2023',
      certificateUrl: 'https://www.dicoding.com/certificates/EXAMPLE-DATA-CERT',
    ),
    Certificate(
      title: 'Belajar Membuat Aplikasi Web dengan React',
      imageUrl: 'https://placehold.co/600x400/008080/FFFFFF?text=Cert+React', // Placeholder: Teal
      issuer: 'Dicoding',
      issueDate: '25 Desember 2023',
      certificateUrl: 'https://www.dicoding.com/certificates/EXAMPLE-REACT-CERT',
    ),
    Certificate(
      title: 'Cloud Computing Practitioner',
      imageUrl: 'https://placehold.co/600x400/FFD700/000000?text=Cert+Cloud', // Placeholder: Gold
      issuer: 'AWS Academy',
      issueDate: '15 Maret 2024',
      certificateUrl: 'https://www.aws.training/certificates/EXAMPLE-AWS-CERT',
    ),
    Certificate(
      title: 'Machine Learning Basics',
      imageUrl: 'https://placehold.co/600x400/4682B4/FFFFFF?text=Cert+ML', // Placeholder: SteelBlue
      issuer: 'Coursera',
      issueDate: '10 Januari 2024',
      certificateUrl: 'https://www.coursera.org/verify/EXAMPLE-ML-CERT',
    ),
    Certificate(
      title: 'Ethical Hacking Essentials',
      imageUrl: 'https://placehold.co/600x400/B22222/FFFFFF?text=Cert+Hacking', // Placeholder: FireBrick
      issuer: 'EC-Council',
      issueDate: '01 Juli 2023',
      certificateUrl: 'https://www.eccouncil.org/verify/EXAMPLE-EH-CERT',
    ),
  ];

  static final List<SocialLink> socialLinks = [
    SocialLink(icon: FontAwesomeIcons.linkedin, url: 'https://linkedin.com/in/ekizulfar'),
    SocialLink(icon: FontAwesomeIcons.instagram, url: 'https://instagram.com/ekizulfar'),
    SocialLink(icon: FontAwesomeIcons.github, url: 'https://github.com/ekizulfar'),
  ];

  static final List<Skill> skills = [
    Skill(name: 'HTML5', icon: FontAwesomeIcons.html5),
    Skill(name: 'CSS3', icon: FontAwesomeIcons.css3Alt),
    Skill(name: 'JavaScript', icon: FontAwesomeIcons.js),
    Skill(name: 'React.js', icon: FontAwesomeIcons.react),
    Skill(name: 'Node.js', icon: FontAwesomeIcons.nodeJs),
    Skill(name: 'Python', icon: FontAwesomeIcons.python),
    Skill(name: 'Flutter', icon: FontAwesomeIcons.mobileAlt), // Using mobileAlt as general icon for Flutter/Dart
    Skill(name: 'Dart', icon: FontAwesomeIcons.dartLang), // Custom or a placeholder icon
    Skill(name: 'SQL', icon: FontAwesomeIcons.database),
    Skill(name: 'MongoDB', icon: FontAwesomeIcons.leaf), // Icon for MongoDB
    Skill(name: 'Tailwind CSS', icon: FontAwesomeIcons.wind), // Icon for Tailwind
    Skill(name: 'Git', icon: FontAwesomeIcons.gitAlt),
  ];
}
