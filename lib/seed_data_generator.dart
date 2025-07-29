import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Random _random = Random();

  // SVG Icons for different categories with soft, readable background colors
  static const Map<String, Map<String, String>> categoryIcons = {
    'Cardiology': {
      'svg':
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#FF6B6B"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>',
      'color': '#E9C6FF', // Light pink/red background
    },
    'Mental Health': {
      'svg':
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#9B59B6"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>',
      'color': '#C6D9FF', // Light purple background
    },
    'Nutrition': {
      'svg':
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#27AE60"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>',
      'color': '#FFD4C6', // Light green background
    },
    'Sleep Medicine': {
      'svg':
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#3498DB"><path d="M17.75 4.09L15.5 6.34l2.24 2.25-1.41 1.41L14.09 7.75L11.84 10l2.25 2.24-1.41 1.41L10.43 11.4L8.18 13.65l2.24 2.25-1.41 1.41L6.77 15.06L4.52 17.31c-1.17-1.17-1.17-3.07 0-4.24l4.69-4.69c1.17-1.17 3.07-1.17 4.24 0L17.75 4.09z"/></svg>',
      'color': '#E9C6FF', // Light blue background
    },
    'Fitness': {
      'svg':
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#E74C3C"><path d="M20.57 14.86L22 13.43 20.57 12 17 15.57 8.43 7 12 3.43 10.57 2 9.14 3.43 7.71 2 5.57 4.14 4.14 2.71 2.71 4.14l1.43 1.43L2 7.71l1.43 1.43L2 10.57 3.43 12 7 8.43 15.57 17 12 20.57 13.43 22l1.43-1.43L16.29 22l2.14-2.14 1.43 1.43 1.43-1.43-1.43-1.43L22 16.29l-1.43-1.43z"/></svg>',
      'color': '#C6D9FF', // Light red/pink background
    },
    'General Medicine': {
      'svg':
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#2C3E50"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>',
      'color': '#FFD4C6', // Light blue background
    },
  };

  // Base assessment templates
  static const List<Map<String, dynamic>> assessmentTemplates = [
    {
      'title': 'Cardiovascular Health Assessment',
      'description':
          'Comprehensive assessment to evaluate your heart health and cardiovascular fitness levels.',
      'category': 'Cardiology',
      'baseQuestions': 25,
      'baseDuration': 30,
      'tags': ['heart', 'fitness', 'cardio', 'health'],
    },
    {
      'title': 'Mental Health Screening',
      'description':
          'Quick screening tool to assess your mental wellbeing and identify areas for support.',
      'category': 'Mental Health',
      'baseQuestions': 15,
      'baseDuration': 15,
      'tags': ['mental', 'wellbeing', 'mood', 'stress'],
    },
    {
      'title': 'Nutrition & Diet Analysis',
      'description':
          'Evaluate your eating habits and receive personalized nutrition recommendations.',
      'category': 'Nutrition',
      'baseQuestions': 20,
      'baseDuration': 20,
      'tags': ['nutrition', 'diet', 'food', 'health'],
    },
    {
      'title': 'Sleep Quality Assessment',
      'description':
          'Comprehensive analysis of your sleep patterns and quality for better rest.',
      'category': 'Sleep Medicine',
      'baseQuestions': 22,
      'baseDuration': 25,
      'tags': ['sleep', 'rest', 'insomnia', 'health'],
    },
    {
      'title': 'Physical Fitness Evaluation',
      'description':
          'Complete fitness assessment including strength, endurance, and flexibility tests.',
      'category': 'Fitness',
      'baseQuestions': 35,
      'baseDuration': 45,
      'tags': ['fitness', 'strength', 'endurance', 'exercise'],
    },
  ];

  // Base appointment templates
  static const List<Map<String, dynamic>> appointmentTemplates = [
    {
      'title': 'General Health Consultation',
      'description':
          'Comprehensive health consultation with our experienced medical professionals.',
      'category': 'General Medicine',
      'baseDuration': 60,
      'basePrice': 150.00,
      'doctorSpecialty': 'General Practitioner',
      'location': 'Main Clinic',
    },
    {
      'title': 'Cardiology Consultation',
      'description':
          'Specialized cardiac assessment and consultation for heart-related concerns.',
      'category': 'Cardiology',
      'baseDuration': 45,
      'basePrice': 250.00,
      'doctorSpecialty': 'Cardiologist',
      'location': 'Cardiology Wing',
    },
    {
      'title': 'Mental Health Counseling',
      'description':
          'Professional mental health support and counseling services.',
      'category': 'Mental Health',
      'baseDuration': 50,
      'basePrice': 200.00,
      'doctorSpecialty': 'Psychiatrist',
      'location': 'Mental Health Center',
    },
    {
      'title': 'Nutrition Consultation',
      'description':
          'Expert nutrition guidance and personalized meal planning.',
      'category': 'Nutrition',
      'baseDuration': 40,
      'basePrice': 120.00,
      'doctorSpecialty': 'Nutritionist',
      'location': 'Wellness Center',
    },
    {
      'title': 'Sleep Disorder Treatment',
      'description':
          'Specialized treatment for sleep-related disorders and issues.',
      'category': 'Sleep Medicine',
      'baseDuration': 60,
      'basePrice': 300.00,
      'doctorSpecialty': 'Sleep Specialist',
      'location': 'Sleep Medicine Center',
    },
    {
      'title': 'Fitness Assessment',
      'description':
          'Professional fitness evaluation and exercise program planning.',
      'category': 'Fitness',
      'baseDuration': 75,
      'basePrice': 180.00,
      'doctorSpecialty': 'Exercise Physiologist',
      'location': 'Fitness Center',
    },
  ];

  static const List<String> firstNames = [
    'Sarah',
    'Michael',
    'Emma',
    'David',
    'Lisa',
    'John',
    'Maria',
    'Robert',
    'Jennifer',
    'William',
    'Jessica',
    'James',
    'Amanda',
    'Christopher',
    'Ashley',
    'Daniel',
    'Michelle',
    'Matthew',
    'Emily',
    'Andrew',
    'Kimberly',
    'Joshua',
    'Melissa',
    'Kenneth',
    'Donna',
    'Kevin',
    'Carol',
    'Brian',
    'Ruth',
    'George',
  ];

  static const List<String> lastNames = [
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzalez',
    'Wilson',
    'Anderson',
    'Thomas',
    'Taylor',
    'Moore',
    'Jackson',
    'Martin',
    'Lee',
    'Perez',
    'Thompson',
    'White',
    'Harris',
    'Sanchez',
    'Clark',
    'Ramirez',
    'Lewis',
    'Robinson',
    'Walker',
  ];

  static const List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  static const List<String> imageUrls = [
    'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
    'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=400',
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
    'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
    'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
  ];

  static const List<String> defaultAssessmentInstructions = [
    'Ensure that you are in a well-lit space',
    'Allow camera access and place your device against a stable object or wall',
    'Avoid wearing baggy clothes',
    'Make sure you exercise as per the instruction provided by the trainer',
  ];

  static Future<void> addSampleAssessments() async {
    final assessments = <Map<String, dynamic>>[];

    // Generate 75+ assessments
    for (int i = 0; i < 75; i++) {
      final template = assessmentTemplates[i % assessmentTemplates.length];
      final category = template['category'] as String;
      final categoryIcon = categoryIcons[category]!;

      final assessment = {
        'title': '${template['title']} ${i + 1}',
        'titleLower': ('${template['title']} ${i + 1}').toLowerCase(),
        'description': template['description'],
        'imageUrl': imageUrls[_random.nextInt(imageUrls.length)],
        'category': category,
        'duration':
            template['baseDuration'] + _random.nextInt(21) - 10, // ±10 minutes
        'difficulty': difficulties[_random.nextInt(difficulties.length)],
        'tags': template['tags'],
        'rating': 3.5 + _random.nextDouble() * 1.5, // 3.5 to 5.0
        'reviewCount': 20 + _random.nextInt(200), // 20 to 220
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'isActive': true,
        'iconSvg': 'assets/images/illustrations/${category.replaceAll(" ", "_").toLowerCase()}.svg',
        'backgroundColor': categoryIcon['color'],
        'metadata': {
          'questions':
              template['baseQuestions'] +
              _random.nextInt(11) -
              5, // ±5 questions
          'hasImages': _random.nextBool(),
          'confidential': category == 'Mental Health',
          'requiredEquipment': _getRandomEquipment(category),
          'hasVideoInstructions': _random.nextBool(),
          'includesFoodDiary': category == 'Nutrition'
              ? _random.nextBool()
              : false,
          'includesSleepDiary': category == 'Sleep Medicine'
              ? _random.nextBool()
              : false,
        },
        'instructions': defaultAssessmentInstructions,
      };

      assessments.add(assessment);
    }

    try {
      // Add assessments to Firestore
      for (int i = 0; i < assessments.length; i++) {
        await _firestore
            .collection('assessments')
            .doc('assessment_${(i + 1).toString().padLeft(3, '0')}')
            .set(assessments[i]);

        if (kDebugMode) {
          print('Added assessment ${i + 1}');
        }
      }

      if (kDebugMode) {
        print(
        '✅ All ${assessments.length} sample assessments added successfully!',
      );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding assessments: $e');
      }
    }
  }

  static Future<void> addSampleAppointments() async {
    final appointments = <Map<String, dynamic>>[];

    // Generate 50+ appointments
    for (int i = 0; i < 50; i++) {
      final template = appointmentTemplates[i % appointmentTemplates.length];
      final category = template['category'] as String;
      final categoryIcon = categoryIcons[category]!;

      final firstName = firstNames[_random.nextInt(firstNames.length)];
      final lastName = lastNames[_random.nextInt(lastNames.length)];

      final appointment = {
        'title': '${template['title']} ${i + 1}',
        'description': template['description'],
        'category': category,
        'duration':
            template['baseDuration'] + _random.nextInt(21) - 10, // ±10 minutes
        'price': (template['basePrice'] + _random.nextInt(101) - 50)
            .toDouble(), // ±50 price
        'availableSlots': _generateRandomSlots(),
        'doctorName': 'Dr. $firstName $lastName',
        'doctorSpecialty': template['doctorSpecialty'],
        'doctorImage': imageUrls[_random.nextInt(imageUrls.length)],
        'location':
            '${template['location']} - Room ${200 + _random.nextInt(200)}',
        'isOnline': _random.nextBool(),
        'isActive': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'iconSvg': 'assets/images/illustrations/appointment_${(i % 3) + 1}.svg',
        'backgroundColor': categoryIcon['color'],
        'rating': 4.0 + _random.nextDouble() * 1.0, // 4.0 to 5.0
        'totalAppointments': 50 + _random.nextInt(500), // 50 to 550
        'experience': 5 + _random.nextInt(26), // 5 to 30 years
      };

      appointments.add(appointment);
    }

    try {
      for (int i = 0; i < appointments.length; i++) {
        await _firestore
            .collection('appointments')
            .doc('appointment_${(i + 1).toString().padLeft(3, '0')}')
            .set(appointments[i]);

        if (kDebugMode) {
          print('Added appointment ${i + 1}');
        }
      }

      if (kDebugMode) {
        print(
        '✅ All ${appointments.length} sample appointments added successfully!',
      );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding appointments: $e');
      }
    }
  }

  static List<Timestamp> _generateRandomSlots() {
    final slots = <Timestamp>[];
    final now = DateTime.now();

    // Generate 3-6 random slots in the next 7 days
    final slotCount = 3 + _random.nextInt(4);

    for (int i = 0; i < slotCount; i++) {
      final randomDays = 1 + _random.nextInt(7);
      final randomHours = 9 + _random.nextInt(9); // 9 AM to 6 PM
      final randomMinutes = _random.nextInt(4) * 15; // 0, 15, 30, 45 minutes

      final slotDate = DateTime(
        now.year,
        now.month,
        now.day + randomDays,
        randomHours,
        randomMinutes,
      );

      slots.add(Timestamp.fromDate(slotDate));
    }

    return slots;
  }

  static List<String> _getRandomEquipment(String category) {
    final equipmentMap = {
      'Cardiology': ['stethoscope', 'blood_pressure_cuff', 'ecg_machine'],
      'Mental Health': ['questionnaire', 'assessment_tools'],
      'Nutrition': ['food_scale', 'measuring_cups', 'body_composition_scale'],
      'Sleep Medicine': ['sleep_tracker', 'questionnaire'],
      'Fitness': [
        'weights',
        'measuring_tape',
        'heart_rate_monitor',
        'stopwatch',
      ],
      'General Medicine': ['stethoscope', 'thermometer', 'scale'],
    };

    final available = equipmentMap[category] ?? [];
    if (available.isEmpty) return [];

    // Return 1-3 random equipment items
    final count = 1 + _random.nextInt(3);
    final shuffled = List<String>.from(available)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  // Helper method to add both assessments and appointments
  static Future<void> addAllSampleData() async {
    if (kDebugMode) {
      print('🚀 Starting to add sample data...');
    }

    await addSampleAssessments();
    await addSampleAppointments();

    if (kDebugMode) {
      print('🎉 All sample data added successfully!');
    }
  }
}
