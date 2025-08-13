import { serve } from "https://deno.land/std@0.192.0/http/server.ts";

serve(async (req) => {
  // ✅ CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*", // DO NOT CHANGE THIS
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "*" // DO NOT CHANGE THIS
      }
    });
  }

  try {
    const { type, to, recipients, data } = await req.json();
    const resendApiKey = Deno.env.get('RESEND_API_KEY');

    if (!resendApiKey) {
      throw new Error('RESEND_API_KEY not configured');
    }

    let emailContent: any = {
      from: "onboarding@resend.dev",
      to: recipients || [to],
      subject: getEmailSubject(type, data),
      html: getEmailTemplate(type, data)
    };

    // Send email via Resend API
    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${resendApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(emailContent)
    });

    const result = await response.json();

    if (!response.ok) {
      throw new Error(`Resend API error: ${result.message}`);
    }

    return new Response(JSON.stringify({
      success: true,
      messageId: result.id,
      type: type
    }), {
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*" // DO NOT CHANGE THIS
      }
    });
  } catch (error) {
    return new Response(JSON.stringify({
      error: error.message
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*" // DO NOT CHANGE THIS
      }
    });
  }
});

function getEmailSubject(type: string, data: any): string {
  switch (type) {
    case 'parent_invite':
      return `Welcome to ${data.school_name} - Parent Account Created`;
    case 'attendance_alert':
      return `Attendance Alert for ${data.student_name}`;
    case 'new_lesson':
      return `New Lesson Posted: ${data.subject}`;
    case 'photo_tagged':
      return `New Photos Available - ${data.student_name}`;
    case 'password_reset':
      return 'Password Reset Request - KoolConnect';
    case 'welcome':
      return `Welcome to ${data.school_name}`;
    case 'bulk_notification':
      return data.subject || 'Important School Notification';
    default:
      return 'KoolConnect Notification';
  }
}

function getEmailTemplate(type: string, data: any): string {
  const baseStyle = `
    <style>
      body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
      .container { max-width: 600px; margin: 0 auto; padding: 20px; }
      .header { background: #4F46E5; color: white; padding: 20px; border-radius: 8px 8px 0 0; }
      .content { background: #f9f9f9; padding: 20px; }
      .footer { background: #333; color: white; padding: 15px; text-align: center; border-radius: 0 0 8px 8px; }
      .button { display: inline-block; padding: 12px 24px; background: #4F46E5; color: white; text-decoration: none; border-radius: 5px; margin: 10px 0; }
    </style>
  `;

  switch (type) {
    case 'parent_invite':
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>Welcome to KoolConnect</h1>
          </div>
          <div class="content">
            <h2>Hello ${data.parent_name},</h2>
            <p>Your parent account has been created for <strong>${data.school_name}</strong>.</p>
            <p><strong>Login Details:</strong></p>
            <ul>
              <li>Email: Use the email this was sent to</li>
              <li>Temporary Password: ${data.temp_password}</li>
            </ul>
            <p>Please change your password after first login.</p>
            <a href="${data.login_url}" class="button">Login Now</a>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;

    case 'attendance_alert':
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>Attendance Alert</h1>
          </div>
          <div class="content">
            <h2>Hello ${data.parent_name},</h2>
            <p><strong>${data.student_name}</strong> was marked absent on <strong>${data.date}</strong>.</p>
            ${data.reason ? `<p><strong>Reason:</strong> ${data.reason}</p>` : ''}
            <p>If this is incorrect, please contact your child's teacher or school administration.</p>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;

    case 'new_lesson':
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>New Lesson Posted</h1>
          </div>
          <div class="content">
            <h2>New lesson for ${data.student_name}</h2>
            <p><strong>Subject:</strong> ${data.subject}</p>
            <p><strong>Teacher:</strong> ${data.teacher_name}</p>
            <div style="background: white; padding: 15px; border-radius: 5px; margin: 10px 0;">
              <h3>Lesson Content:</h3>
              <p>${data.lesson_content}</p>
            </div>
            <p>Login to KoolConnect to view full details and any attachments.</p>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;

    case 'photo_tagged':
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>New Photos Available</h1>
          </div>
          <div class="content">
            <h2>New photos of ${data.student_name}</h2>
            <p><strong>${data.photo_count}</strong> new photo${data.photo_count > 1 ? 's' : ''} ${data.photo_count > 1 ? 'have' : 'has'} been uploaded to ${data.school_name}.</p>
            <p>Login to KoolConnect to view and download the photos.</p>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;

    case 'password_reset':
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>Password Reset Request</h1>
          </div>
          <div class="content">
            <h2>Hello ${data.user_name},</h2>
            <p>You requested a password reset for your KoolConnect account.</p>
            <a href="${data.reset_url}" class="button">Reset Password</a>
            <p>This link will expire in 24 hours. If you didn't request this, please ignore this email.</p>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;

    case 'welcome':
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>Welcome to KoolConnect</h1>
          </div>
          <div class="content">
            <h2>Hello ${data.user_name},</h2>
            <p>Welcome to <strong>${data.school_name}</strong>'s KoolConnect system!</p>
            <p>You now have access to:</p>
            <ul>
              <li>Real-time attendance updates</li>
              <li>Daily lessons and assignments</li>
              <li>Photo galleries</li>
              <li>Direct messaging with teachers</li>
              <li>School announcements</li>
            </ul>
            <p>Login to get started and explore all the features.</p>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;

    default:
      return `
        ${baseStyle}
        <div class="container">
          <div class="header">
            <h1>KoolConnect Notification</h1>
          </div>
          <div class="content">
            <p>${data.message || 'You have a new notification from KoolConnect.'}</p>
          </div>
          <div class="footer">
            <p>© 2025 KoolConnect School Management System</p>
          </div>
        </div>
      `;
  }
}