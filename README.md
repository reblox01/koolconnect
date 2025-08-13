# KoolConnect - School Management System

A comprehensive Flutter application integrated with Supabase for school management, connecting teachers, parents, managers, and students.

## Features

### 🎯 Core Functionality
- **Multi-Role Authentication**: Manager, Teacher, Parent, Staff roles
- **Real-time Dashboard**: Role-based dashboards with live updates
- **Attendance Management**: Quick attendance marking and tracking
- **Lesson Creation**: Create and share lessons with attachments
- **Photo Gallery**: Upload and tag student photos with privacy controls
- **Messaging System**: Secure communication between teachers and parents
- **Email Notifications**: Automated email alerts for attendance, lessons, and photos

### 👥 Role-Based Access
- **Managers**: Full school administration and user management
- **Teachers**: Class management, attendance, lessons, and student communication
- **Parents**: View their children's attendance, lessons, photos, and messages
- **Staff**: Support role with limited access

### 📱 Technical Features
- **Flutter + Supabase**: Modern cross-platform app with powerful backend
- **Real-time Updates**: Live data synchronization across devices
- **File Storage**: Secure attachment and photo storage
- **Email Integration**: Resend email service for notifications
- **Row Level Security**: Database-level security for all data
- **Responsive Design**: Works on phones, tablets, and web

## Getting Started

### Prerequisites
- Flutter SDK 3.19.0 or higher
- Dart 3.6.0 or higher
- Supabase account
- Resend account (for email notifications)

### Environment Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd koolconnect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Supabase Configuration**
   
   Create a `.env` file or set environment variables:
   ```bash
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Email Configuration**
   
   Set up Resend for email notifications:
   ```bash
   RESEND_API_KEY=your_resend_api_key
   ```

### Running the App

#### Development Mode
```bash
flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

#### Production Build
```bash
# Android
flutter build apk --release --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key

# iOS
flutter build ios --release --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key

# Web
flutter build web --release --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

## Database Schema

The app uses a comprehensive Supabase PostgreSQL schema with the following main tables:

- **user_profiles**: User management with roles and permissions
- **schools**: School information and settings
- **classes**: Class management and teacher assignments
- **students**: Student information linked to classes and parents
- **lessons**: Daily lessons with attachments and visibility controls
- **absences**: Attendance tracking and absence records
- **photos**: Photo gallery with tagging and privacy settings
- **messages**: Messaging system between users
- **conversations**: Conversation management
- **notifications**: System notifications

### Row Level Security (RLS)
All tables implement RLS policies to ensure:
- Parents only see their children's data
- Teachers only access their assigned classes
- Managers have school-wide access
- Secure data isolation

## API Integration

### Supabase Services
- **AuthService**: User authentication and profile management
- **StudentService**: Student data management
- **LessonService**: Lesson creation and retrieval
- **AttendanceService**: Attendance tracking and statistics

### Email Notifications
The app includes a Supabase Edge Function for sending emails:
- Parent invitations
- Attendance alerts
- New lesson notifications
- Photo tagged notifications
- Password reset emails

## Demo Accounts

For testing, use these demo credentials:

- **Manager Demo**: manager@demo.com / demo123
- **Teacher Demo**: teacher@demo.com / demo123
- **Parent Demo**: parent@demo.com / demo123

## Architecture

### Project Structure
```
lib/
├── models/           # Data models
├── services/         # Business logic and API calls
├── presentation/     # UI screens and widgets
├── routes/          # Navigation routing
├── theme/           # App theming
└── widgets/         # Reusable widgets

supabase/
└── functions/       # Edge functions for email
```

### Key Dependencies
- `supabase_flutter: ^2.9.1` - Supabase integration
- `google_fonts: ^6.1.0` - Typography
- `sizer: ^2.0.15` - Responsive design
- `cached_network_image: ^3.3.1` - Image handling
- `image_picker: ^1.0.4` - Photo uploads
- `file_picker: ^8.1.7` - File attachments

## Security Features

- **Authentication**: Email/password with role-based access
- **Data Security**: Row Level Security on all database tables
- **File Security**: Secure file uploads to Supabase Storage
- **API Security**: Authenticated API calls with user context
- **Privacy Controls**: Parent-controlled photo visibility

## Deployment

### Supabase Setup
1. Create a new Supabase project
2. The database schema is already complete - no migrations needed
3. Deploy the email edge function:
   ```bash
   supabase functions deploy send-email
   ```
4. Configure storage buckets for photos and attachments

### App Deployment
- **Android**: Build APK and distribute via Google Play or direct download
- **iOS**: Build for App Store or TestFlight distribution
- **Web**: Deploy to Vercel, Netlify, or Firebase Hosting

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

For issues and feature requests, please create an issue in the repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**KoolConnect** - Connecting schools, teachers, parents, and students through technology.