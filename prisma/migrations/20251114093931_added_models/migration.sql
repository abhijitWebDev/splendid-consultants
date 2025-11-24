-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('admin', 'client_individual', 'client_corporate', 'guest');

-- CreateEnum
CREATE TYPE "ServiceCategory" AS ENUM ('personal_consulting', 'corporate_training', 'business_consulting');

-- CreateEnum
CREATE TYPE "InquiryType" AS ENUM ('personal_consulting', 'corporate_training', 'business_consulting');

-- CreateEnum
CREATE TYPE "InquiryStatus" AS ENUM ('new', 'contacted', 'qualified', 'converted', 'lost');

-- CreateEnum
CREATE TYPE "Priority" AS ENUM ('low', 'medium', 'high', 'urgent');

-- CreateEnum
CREATE TYPE "AppointmentStatus" AS ENUM ('scheduled', 'confirmed', 'completed', 'cancelled', 'rescheduled');

-- CreateEnum
CREATE TYPE "ConsultationType" AS ENUM ('initial', 'follow_up', 'final');

-- CreateEnum
CREATE TYPE "CorporateEngagementStatus" AS ENUM ('planning', 'active', 'completed', 'on_hold', 'cancelled');

-- CreateEnum
CREATE TYPE "TrainingSessionStatus" AS ENUM ('scheduled', 'confirmed', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('pending', 'processing', 'completed', 'failed', 'refunded');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('credit_card', 'debit_card', 'bank_transfer', 'upi', 'cash', 'other');

-- CreateEnum
CREATE TYPE "ActivityType" AS ENUM ('email', 'call', 'meeting', 'whatsapp', 'other');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('appointment_reminder', 'payment_confirmation', 'inquiry_update', 'general');

-- CreateEnum
CREATE TYPE "QuizType" AS ENUM ('style_assessment', 'personal_brand', 'corporate_culture', 'leadership_style');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT,
    "role" "UserRole" NOT NULL DEFAULT 'guest',
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone" TEXT,
    "profile_picture_url" TEXT,
    "date_of_birth" TIMESTAMP(3),
    "gender" TEXT,
    "profession" TEXT,
    "linkedin_url" TEXT,
    "company_name" TEXT,
    "industry" TEXT,
    "company_size" TEXT,
    "job_title" TEXT,
    "department" TEXT,
    "address_line1" TEXT,
    "address_line2" TEXT,
    "city" TEXT,
    "state" TEXT,
    "country" TEXT,
    "postal_code" TEXT,
    "communication_preference" TEXT,
    "timezone" TEXT,
    "language_preference" TEXT DEFAULT 'en',
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "email_verification_token" TEXT,
    "password_reset_token" TEXT,
    "password_reset_expires" TIMESTAMP(3),
    "last_login" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Service" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" "ServiceCategory" NOT NULL,
    "description" TEXT,
    "short_description" TEXT,
    "icon_url" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ServicePackage" (
    "id" TEXT NOT NULL,
    "service_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "base_price" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "discount_percentage" DECIMAL(5,2),
    "duration_hours" INTEGER,
    "duration_days" INTEGER,
    "session_count" INTEGER DEFAULT 1,
    "features" JSONB,
    "deliverables" JSONB,
    "min_participants" INTEGER,
    "max_participants" INTEGER,
    "is_popular" BOOLEAN NOT NULL DEFAULT false,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ServicePackage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatbotConversation" (
    "id" TEXT NOT NULL,
    "user_id" TEXT,
    "session_id" TEXT NOT NULL,
    "messages" JSONB NOT NULL,
    "extracted_info" JSONB,
    "recommended_services" JSONB,
    "sentiment_score" DOUBLE PRECISION,
    "lead_email" TEXT,
    "lead_name" TEXT,
    "lead_phone" TEXT,
    "inquiry_created" BOOLEAN NOT NULL DEFAULT false,
    "inquiry_id" TEXT,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_message_at" TIMESTAMP(3) NOT NULL,
    "ended_at" TIMESTAMP(3),

    CONSTRAINT "ChatbotConversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Quiz" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "quiz_type" "QuizType" NOT NULL,
    "questions" JSONB NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Quiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QuizResponse" (
    "id" TEXT NOT NULL,
    "quiz_id" TEXT NOT NULL,
    "user_id" TEXT,
    "answers" JSONB NOT NULL,
    "score" DOUBLE PRECISION,
    "ai_analysis" JSONB,
    "recommended_services" JSONB,
    "respondent_email" TEXT,
    "respondent_name" TEXT,
    "inquiry_created" BOOLEAN NOT NULL DEFAULT false,
    "inquiry_id" TEXT,
    "completed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "QuizResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Inquiry" (
    "id" TEXT NOT NULL,
    "user_id" TEXT,
    "inquiry_type" "InquiryType" NOT NULL,
    "status" "InquiryStatus" NOT NULL DEFAULT 'new',
    "priority" "Priority" NOT NULL DEFAULT 'medium',
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "company_name" TEXT,
    "subject" TEXT,
    "message" TEXT NOT NULL,
    "preferred_package_id" TEXT,
    "budget_range" TEXT,
    "preferred_date" TIMESTAMP(3),
    "how_heard_about" TEXT,
    "ai_assessment" JSONB,
    "source" TEXT,
    "referral_source" TEXT,
    "assigned_to" TEXT,
    "next_follow_up_date" TIMESTAMP(3),
    "converted_at" TIMESTAMP(3),
    "appointment_id" TEXT,
    "engagement_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Inquiry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InquiryActivity" (
    "id" TEXT NOT NULL,
    "inquiry_id" TEXT NOT NULL,
    "activity_type" "ActivityType" NOT NULL,
    "subject" TEXT,
    "notes" TEXT NOT NULL,
    "performed_by" TEXT,
    "is_follow_up" BOOLEAN NOT NULL DEFAULT false,
    "next_action" TEXT,
    "next_action_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InquiryActivity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Appointment" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "package_id" TEXT NOT NULL,
    "status" "AppointmentStatus" NOT NULL DEFAULT 'scheduled',
    "consultation_type" "ConsultationType" NOT NULL DEFAULT 'initial',
    "appointment_date" TIMESTAMP(3) NOT NULL,
    "appointment_time" TEXT NOT NULL,
    "duration_minutes" INTEGER NOT NULL,
    "timezone" TEXT,
    "location_type" TEXT NOT NULL,
    "location_address" TEXT,
    "meeting_url" TEXT,
    "meeting_platform" TEXT,
    "notes" TEXT,
    "special_requirements" TEXT,
    "confirmed_at" TIMESTAMP(3),
    "confirmation_sent" BOOLEAN NOT NULL DEFAULT false,
    "reminder_sent" BOOLEAN NOT NULL DEFAULT false,
    "completed_at" TIMESTAMP(3),
    "is_group_session" BOOLEAN NOT NULL DEFAULT false,
    "max_participants" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Appointment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AppointmentParticipant" (
    "id" TEXT NOT NULL,
    "appointment_id" TEXT NOT NULL,
    "user_id" TEXT,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "attended" BOOLEAN,
    "feedback" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppointmentParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ConsultationNote" (
    "id" TEXT NOT NULL,
    "appointment_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "attire_recommendations" TEXT,
    "behavior_attitude_notes" TEXT,
    "communication_analysis" TEXT,
    "digital_presence_feedback" TEXT,
    "self_image_assessment" TEXT,
    "strengths" TEXT,
    "areas_for_improvement" TEXT,
    "action_items" JSONB,
    "resources_shared" JSONB,
    "follow_up_required" BOOLEAN NOT NULL DEFAULT false,
    "follow_up_date" TIMESTAMP(3),
    "follow_up_notes" TEXT,
    "session_number" INTEGER,
    "overall_notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ConsultationNote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CorporateEngagement" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "package_id" TEXT NOT NULL,
    "project_name" TEXT NOT NULL,
    "company_name" TEXT NOT NULL,
    "industry" TEXT,
    "status" "CorporateEngagementStatus" NOT NULL DEFAULT 'planning',
    "objectives" TEXT NOT NULL,
    "challenges" TEXT,
    "expected_outcomes" TEXT,
    "departments" JSONB,
    "hierarchy_levels" JSONB,
    "employee_count" INTEGER,
    "participant_count" INTEGER,
    "survey_data" JSONB,
    "survey_completed_at" TIMESTAMP(3),
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "total_budget" DECIMAL(10,2),
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "completed_at" TIMESTAMP(3),
    "final_report_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CorporateEngagement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TrainingSession" (
    "id" TEXT NOT NULL,
    "engagement_id" TEXT NOT NULL,
    "session_title" TEXT NOT NULL,
    "session_number" INTEGER NOT NULL,
    "description" TEXT,
    "status" "TrainingSessionStatus" NOT NULL DEFAULT 'scheduled',
    "session_date" TIMESTAMP(3) NOT NULL,
    "session_time" TEXT NOT NULL,
    "duration_minutes" INTEGER NOT NULL,
    "location_type" TEXT NOT NULL,
    "location_address" TEXT,
    "meeting_url" TEXT,
    "topics_covered" JSONB,
    "materials_used" JSONB,
    "expected_participants" INTEGER,
    "actual_participants" INTEGER,
    "attendance_list" JSONB,
    "session_feedback" JSONB,
    "trainer_notes" TEXT,
    "completed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TrainingSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "appointment_id" TEXT,
    "engagement_id" TEXT,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "payment_method" "PaymentMethod" NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'pending',
    "transaction_id" TEXT,
    "payment_gateway" TEXT,
    "gateway_response" JSONB,
    "invoice_number" TEXT,
    "invoice_url" TEXT,
    "invoice_date" TIMESTAMP(3),
    "due_date" TIMESTAMP(3),
    "notes" TEXT,
    "paid_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuccessStory" (
    "id" TEXT NOT NULL,
    "user_id" TEXT,
    "client_name" TEXT NOT NULL,
    "client_title" TEXT,
    "client_company" TEXT,
    "client_photo_url" TEXT,
    "title" TEXT NOT NULL,
    "challenge" TEXT NOT NULL,
    "solution" TEXT NOT NULL,
    "results" TEXT NOT NULL,
    "before_image_url" TEXT,
    "after_image_url" TEXT,
    "metrics" JSONB,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "published_at" TIMESTAMP(3),
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "service_category" "ServiceCategory",
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SuccessStory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Testimonial" (
    "id" TEXT NOT NULL,
    "user_id" TEXT,
    "client_name" TEXT NOT NULL,
    "client_title" TEXT,
    "client_company" TEXT,
    "client_photo_url" TEXT,
    "content" TEXT NOT NULL,
    "rating" INTEGER,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "published_at" TIMESTAMP(3),
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "service_category" "ServiceCategory",
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Testimonial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "action_url" TEXT,
    "action_text" TEXT,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "read_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NewsletterSubscriber" (
    "id" TEXT NOT NULL,
    "user_id" TEXT,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "subscribed" BOOLEAN NOT NULL DEFAULT true,
    "interests" JSONB,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verification_token" TEXT,
    "subscribed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unsubscribed_at" TIMESTAMP(3),

    CONSTRAINT "NewsletterSubscriber_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PageView" (
    "id" TEXT NOT NULL,
    "page_url" TEXT NOT NULL,
    "page_title" TEXT,
    "referrer" TEXT,
    "user_id" TEXT,
    "session_id" TEXT,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "device_type" TEXT,
    "browser" TEXT,
    "os" TEXT,
    "time_on_page" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PageView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BlogPost" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "excerpt" TEXT,
    "content" TEXT NOT NULL,
    "featured_image_url" TEXT,
    "author_name" TEXT NOT NULL,
    "author_bio" TEXT,
    "author_photo_url" TEXT,
    "meta_title" TEXT,
    "meta_description" TEXT,
    "meta_keywords" JSONB,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "published_at" TIMESTAMP(3),
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "category" TEXT,
    "tags" JSONB,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BlogPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FAQ" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "answer" TEXT NOT NULL,
    "category" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "helpful_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FAQ_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_role_idx" ON "User"("role");

-- CreateIndex
CREATE INDEX "User_created_at_idx" ON "User"("created_at" DESC);

-- CreateIndex
CREATE INDEX "Service_category_idx" ON "Service"("category");

-- CreateIndex
CREATE INDEX "Service_is_active_idx" ON "Service"("is_active");

-- CreateIndex
CREATE INDEX "ServicePackage_service_id_idx" ON "ServicePackage"("service_id");

-- CreateIndex
CREATE INDEX "ServicePackage_is_active_idx" ON "ServicePackage"("is_active");

-- CreateIndex
CREATE UNIQUE INDEX "ChatbotConversation_session_id_key" ON "ChatbotConversation"("session_id");

-- CreateIndex
CREATE INDEX "ChatbotConversation_session_id_idx" ON "ChatbotConversation"("session_id");

-- CreateIndex
CREATE INDEX "ChatbotConversation_user_id_idx" ON "ChatbotConversation"("user_id");

-- CreateIndex
CREATE INDEX "ChatbotConversation_started_at_idx" ON "ChatbotConversation"("started_at" DESC);

-- CreateIndex
CREATE INDEX "Quiz_quiz_type_idx" ON "Quiz"("quiz_type");

-- CreateIndex
CREATE INDEX "Quiz_is_active_idx" ON "Quiz"("is_active");

-- CreateIndex
CREATE INDEX "QuizResponse_quiz_id_idx" ON "QuizResponse"("quiz_id");

-- CreateIndex
CREATE INDEX "QuizResponse_user_id_idx" ON "QuizResponse"("user_id");

-- CreateIndex
CREATE INDEX "QuizResponse_completed_at_idx" ON "QuizResponse"("completed_at" DESC);

-- CreateIndex
CREATE INDEX "Inquiry_user_id_idx" ON "Inquiry"("user_id");

-- CreateIndex
CREATE INDEX "Inquiry_status_idx" ON "Inquiry"("status");

-- CreateIndex
CREATE INDEX "Inquiry_priority_idx" ON "Inquiry"("priority");

-- CreateIndex
CREATE INDEX "Inquiry_inquiry_type_idx" ON "Inquiry"("inquiry_type");

-- CreateIndex
CREATE INDEX "Inquiry_created_at_idx" ON "Inquiry"("created_at" DESC);

-- CreateIndex
CREATE INDEX "Inquiry_email_idx" ON "Inquiry"("email");

-- CreateIndex
CREATE INDEX "InquiryActivity_inquiry_id_idx" ON "InquiryActivity"("inquiry_id");

-- CreateIndex
CREATE INDEX "InquiryActivity_created_at_idx" ON "InquiryActivity"("created_at" DESC);

-- CreateIndex
CREATE INDEX "Appointment_user_id_idx" ON "Appointment"("user_id");

-- CreateIndex
CREATE INDEX "Appointment_status_idx" ON "Appointment"("status");

-- CreateIndex
CREATE INDEX "Appointment_appointment_date_idx" ON "Appointment"("appointment_date");

-- CreateIndex
CREATE INDEX "Appointment_created_at_idx" ON "Appointment"("created_at" DESC);

-- CreateIndex
CREATE INDEX "AppointmentParticipant_appointment_id_idx" ON "AppointmentParticipant"("appointment_id");

-- CreateIndex
CREATE INDEX "AppointmentParticipant_user_id_idx" ON "AppointmentParticipant"("user_id");

-- CreateIndex
CREATE INDEX "ConsultationNote_appointment_id_idx" ON "ConsultationNote"("appointment_id");

-- CreateIndex
CREATE INDEX "ConsultationNote_user_id_idx" ON "ConsultationNote"("user_id");

-- CreateIndex
CREATE INDEX "ConsultationNote_created_at_idx" ON "ConsultationNote"("created_at" DESC);

-- CreateIndex
CREATE INDEX "CorporateEngagement_user_id_idx" ON "CorporateEngagement"("user_id");

-- CreateIndex
CREATE INDEX "CorporateEngagement_status_idx" ON "CorporateEngagement"("status");

-- CreateIndex
CREATE INDEX "CorporateEngagement_company_name_idx" ON "CorporateEngagement"("company_name");

-- CreateIndex
CREATE INDEX "CorporateEngagement_created_at_idx" ON "CorporateEngagement"("created_at" DESC);

-- CreateIndex
CREATE INDEX "TrainingSession_engagement_id_idx" ON "TrainingSession"("engagement_id");

-- CreateIndex
CREATE INDEX "TrainingSession_status_idx" ON "TrainingSession"("status");

-- CreateIndex
CREATE INDEX "TrainingSession_session_date_idx" ON "TrainingSession"("session_date");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_invoice_number_key" ON "Payment"("invoice_number");

-- CreateIndex
CREATE INDEX "Payment_user_id_idx" ON "Payment"("user_id");

-- CreateIndex
CREATE INDEX "Payment_status_idx" ON "Payment"("status");

-- CreateIndex
CREATE INDEX "Payment_appointment_id_idx" ON "Payment"("appointment_id");

-- CreateIndex
CREATE INDEX "Payment_engagement_id_idx" ON "Payment"("engagement_id");

-- CreateIndex
CREATE INDEX "Payment_created_at_idx" ON "Payment"("created_at" DESC);

-- CreateIndex
CREATE INDEX "Payment_invoice_number_idx" ON "Payment"("invoice_number");

-- CreateIndex
CREATE INDEX "SuccessStory_is_published_idx" ON "SuccessStory"("is_published");

-- CreateIndex
CREATE INDEX "SuccessStory_featured_idx" ON "SuccessStory"("featured");

-- CreateIndex
CREATE INDEX "SuccessStory_service_category_idx" ON "SuccessStory"("service_category");

-- CreateIndex
CREATE INDEX "Testimonial_is_published_idx" ON "Testimonial"("is_published");

-- CreateIndex
CREATE INDEX "Testimonial_featured_idx" ON "Testimonial"("featured");

-- CreateIndex
CREATE INDEX "Testimonial_rating_idx" ON "Testimonial"("rating");

-- CreateIndex
CREATE INDEX "Notification_user_id_idx" ON "Notification"("user_id");

-- CreateIndex
CREATE INDEX "Notification_is_read_idx" ON "Notification"("is_read");

-- CreateIndex
CREATE INDEX "Notification_created_at_idx" ON "Notification"("created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "NewsletterSubscriber_email_key" ON "NewsletterSubscriber"("email");

-- CreateIndex
CREATE INDEX "NewsletterSubscriber_email_idx" ON "NewsletterSubscriber"("email");

-- CreateIndex
CREATE INDEX "NewsletterSubscriber_subscribed_idx" ON "NewsletterSubscriber"("subscribed");

-- CreateIndex
CREATE INDEX "PageView_user_id_idx" ON "PageView"("user_id");

-- CreateIndex
CREATE INDEX "PageView_session_id_idx" ON "PageView"("session_id");

-- CreateIndex
CREATE INDEX "PageView_page_url_idx" ON "PageView"("page_url");

-- CreateIndex
CREATE INDEX "PageView_created_at_idx" ON "PageView"("created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "BlogPost_slug_key" ON "BlogPost"("slug");

-- CreateIndex
CREATE INDEX "BlogPost_slug_idx" ON "BlogPost"("slug");

-- CreateIndex
CREATE INDEX "BlogPost_is_published_idx" ON "BlogPost"("is_published");

-- CreateIndex
CREATE INDEX "BlogPost_published_at_idx" ON "BlogPost"("published_at" DESC);

-- CreateIndex
CREATE INDEX "BlogPost_category_idx" ON "BlogPost"("category");

-- CreateIndex
CREATE INDEX "FAQ_category_idx" ON "FAQ"("category");

-- CreateIndex
CREATE INDEX "FAQ_is_active_idx" ON "FAQ"("is_active");

-- CreateIndex
CREATE INDEX "FAQ_display_order_idx" ON "FAQ"("display_order");

-- AddForeignKey
ALTER TABLE "ServicePackage" ADD CONSTRAINT "ServicePackage_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "Service"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatbotConversation" ADD CONSTRAINT "ChatbotConversation_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatbotConversation" ADD CONSTRAINT "ChatbotConversation_inquiry_id_fkey" FOREIGN KEY ("inquiry_id") REFERENCES "Inquiry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizResponse" ADD CONSTRAINT "QuizResponse_quiz_id_fkey" FOREIGN KEY ("quiz_id") REFERENCES "Quiz"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizResponse" ADD CONSTRAINT "QuizResponse_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizResponse" ADD CONSTRAINT "QuizResponse_inquiry_id_fkey" FOREIGN KEY ("inquiry_id") REFERENCES "Inquiry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inquiry" ADD CONSTRAINT "Inquiry_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inquiry" ADD CONSTRAINT "Inquiry_preferred_package_id_fkey" FOREIGN KEY ("preferred_package_id") REFERENCES "ServicePackage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InquiryActivity" ADD CONSTRAINT "InquiryActivity_inquiry_id_fkey" FOREIGN KEY ("inquiry_id") REFERENCES "Inquiry"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "ServicePackage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AppointmentParticipant" ADD CONSTRAINT "AppointmentParticipant_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "Appointment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AppointmentParticipant" ADD CONSTRAINT "AppointmentParticipant_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConsultationNote" ADD CONSTRAINT "ConsultationNote_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "Appointment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConsultationNote" ADD CONSTRAINT "ConsultationNote_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CorporateEngagement" ADD CONSTRAINT "CorporateEngagement_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CorporateEngagement" ADD CONSTRAINT "CorporateEngagement_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "ServicePackage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingSession" ADD CONSTRAINT "TrainingSession_engagement_id_fkey" FOREIGN KEY ("engagement_id") REFERENCES "CorporateEngagement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "Appointment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_engagement_id_fkey" FOREIGN KEY ("engagement_id") REFERENCES "CorporateEngagement"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NewsletterSubscriber" ADD CONSTRAINT "NewsletterSubscriber_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
