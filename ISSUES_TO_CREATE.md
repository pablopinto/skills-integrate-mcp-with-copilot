# Issues to create: Extracurricular features

This file contains a set of proposed issues (title + body) inspired by open-source projects for managing extracurricular activities. You can create them manually or use the included script `scripts/create_issues.sh`.

---

Title: Add persistent database and migrations

Body:
We currently keep activities in memory. Add a proper persistent storage layer so data survives restarts and can scale beyond a demo dataset.

Why:
- Enables real usage, backups and reliable data for signups, attendance and reporting.

Acceptance criteria:
- Use SQLAlchemy or SQLModel with a SQLite default for dev and configurable DB URL for production.
- Add Alembic (or equivalent) migrations and at least one initial migration to create activities, users and signups tables.
- Update the API to read/write from the DB instead of the in-memory `activities` dict.

Notes/implementation hints:
- Keep the current API contract where possible; implement a thin repository layer.
- Add tests for DB CRUD operations.

Labels: enhancement, backend

---

Title: Add authentication and role-based access (student/admin)

Body:
Introduce authentication to identify students and admins. Students can sign up for activities; admins can create/edit/delete activities and view reports.

Acceptance criteria:
- Implement OAuth2 password (or JWT) auth for API endpoints.
- Add `User` model with roles (`student`, `admin`).
- Secure admin endpoints (activity create/edit/delete) and expose student-only endpoints where appropriate.
- Provide a simple seed command or fixture to create an admin user for local testing.

Labels: enhancement, security, backend

---

Title: Admin UI to create / edit activities

Body:
Add a minimal admin interface (single-page or server-side) that allows admins to create, update and delete activities, set capacity, schedule and description.

Acceptance criteria:
- New admin route(s) under `/admin` or a dedicated SPA that calls the secured admin API endpoints.
- Forms for activity fields (name, description, schedule, max participants, tags/category).
- Client-side validation and server-side validation.

Labels: enhancement, frontend, ux

---

Title: Activity search, categories/tags and filters

Body:
Improve discoverability by adding categories/tags and search/filter functionality in the UI and API.

Acceptance criteria:
- Add `category` and `tags` fields to activity model.
- API supports query params for `q` (text search), `category`, `tags` and `available=true` (has spots).
- UI adds a search box, category dropdown and tag filters.

Labels: enhancement, frontend, backend

---

Title: Calendar export and iCal / Google Calendar integration

Body:
Allow students to export activity schedules to iCal and optionally provide a one-click Google Calendar add.

Acceptance criteria:
- Endpoint to generate an `.ics` file for a given activity or for a student's signed-up activities.
- Frontend provides an "Add to calendar" button that triggers the iCal download and a Google Calendar redirect link.

Labels: feature, integration

---

Title: Email notifications and reminders

Body:
Send emails on signup/unregister and optional reminders before scheduled sessions.

Acceptance criteria:
- Integrate a mailer (SMTP config via env). Use background jobs for sending.
- Send confirmation emails on signup/unregister.
- Support scheduled reminder emails (configurable lead time) via background worker or scheduled task.

Labels: feature, backend, infra

---

Title: Waitlist support when activity is full

Body:
When an activity reaches its capacity, allow students to join a waitlist and automatically move them into participants if a spot opens.

Acceptance criteria:
- Waitlist model and endpoints to join/leave waitlist.
- Automatic promotion from waitlist when participants unregister (send notification to promoted student).

Labels: enhancement, backend

---

Title: Attendance tracking and check-in endpoint

Body:
Add attendance features so admins/teachers can mark participants present/absent for a session; expose a simple check-in endpoint.

Acceptance criteria:
- Models for events/sessions and attendance records.
- API endpoints for marking attendance and retrieving attendance reports per activity and student.

Labels: feature, backend

---

Title: Background job processing and scheduler (Celery / RQ)

Body:
Introduce a background worker for sending emails, processing waitlists, and running scheduled jobs (reminders, daily reports).

Acceptance criteria:
- Add a simple Redis-backed worker (Celery or RQ) and example tasks (send email, process waitlist).
- Document how to run worker locally and in production.

Labels: infra, backend

---

Title: Add tests, CI and Dockerfile

Body:
Add unit/integration tests, a CI workflow and a Dockerfile so the project can be run and validated in CI.

Acceptance criteria:
- Add pytest tests covering API endpoints and core logic.
- Add GitHub Actions workflow for running tests on push and pull request.
- Add a `Dockerfile` and `docker-compose.yml` for local development (API + DB + Redis worker).

Labels: test, ci, infra

---

