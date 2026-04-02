# Template Library — Premade Prompt Recommendations

A new **Templates** screen that gives users instant access to 80+ professionally crafted DSL prompts across every major use case. Users can browse by category, search by keyword, preview the DSL content, and load any template directly into the editor with one click.

---

## User Review Required

> [!IMPORTANT]
> This adds a new top-level navigation tab ("Templates") alongside the existing "Editor" and "Settings" tabs in the title bar. All three tabs will be accessible at all times.

> [!NOTE]
> All templates are stored as pure Dart data (no network, no files). The library loads instantly with zero I/O.

---

## Proposed Changes

### 1. Data Layer — Template Library

#### [NEW] `lib/data/template_library.dart`
A single file containing all template data. Each template has:
- `id` — unique string
- `title` — display name
- `description` — one-line summary
- `category` — one of 10+ categories
- `tags` — list of keywords for search
- `dsl` — the ready-to-use DSL content

**Categories & template count:**

| Category | Icon | Templates |
|---|---|---|
| 🖥️ Software Dev | `code` | 14 templates |
| 📱 Mobile | `phone_android` | 4 templates |
| 🌐 API Design | `api` | 5 templates |
| ✍️ Content & Writing | `edit_note` | 10 templates |
| 🤖 AI & Prompts | `auto_awesome` | 8 templates |
| 🚀 DevOps | `rocket_launch` | 7 templates |
| 📊 Data & ML | `bar_chart` | 7 templates |
| 💼 Business | `business_center` | 8 templates |
| 🎓 Education | `school` | 5 templates |
| 🎨 Creative | `palette` | 5 templates |
| ⚖️ Legal & HR | `gavel` | 6 templates |
| 🔬 Research | `science` | 4 templates |

**Sample templates in each category:**

*Software Dev:* Full-stack Web App, REST API, GraphQL API, Microservice, Database Schema, Auth System, Real-time Chat, Admin Dashboard, Browser Extension, CLI Tool, Desktop App, Data Dashboard, E-commerce Platform, SaaS Boilerplate

*Mobile:* Flutter App, React Native App, iOS App, Android App

*API Design:* REST CRUD API, GraphQL API, WebSocket Server, gRPC Service, OpenAPI Spec

*Content & Writing:* Blog Post, Technical Article, Newsletter, LinkedIn Post, Twitter/X Thread, YouTube Script, Product Description, Landing Page Copy, Press Release, White Paper

*AI & Prompts:* System Prompt, Code Review Bot, Research Assistant, Data Analyst, Tutor, Customer Support Bot, Sales Coach, Creative Writing Partner

*DevOps:* GitHub Actions CI/CD, Docker Setup, Kubernetes Manifests, Terraform IaC, Monitoring & Alerting, Security Audit, Database Migration

*Data & ML:* ML Pipeline, EDA Notebook, NLP Model, Computer Vision, Recommendation System, A/B Test Analysis, Data Cleaning Script

*Business:* Business Plan, Pitch Deck, Competitive Analysis, Go-to-Market Strategy, OKR Framework, Product Roadmap, SWOT Analysis, Project Brief

*Education:* Course Outline, Study Guide, Lesson Plan, Quiz Generator, Explainer Article

*Creative:* Short Story, World Building, Character Creation, Screenplay, Game Design Document

*Legal & HR:* Privacy Policy, Terms of Service, Job Description, Performance Review, Interview Questions, Meeting Agenda

*Research:* Literature Review, Research Proposal, Survey Design, Statistical Analysis

---

### 2. Provider — Nav Page Extension

#### [MODIFY] `lib/providers/dsl_providers.dart`
Add `templates` to the `NavPage` enum:
```dart
// Before:
enum NavPage { editor, settings }

// After:
enum NavPage { editor, templates, settings }
```

Also add a search query provider for the templates screen:
```dart
final templateSearchProvider = StateProvider<String>((ref) => '');
final templateCategoryProvider = StateProvider<String?>((ref) => null);
```

---

### 3. Templates Screen

#### [NEW] `lib/screens/templates_screen.dart`
A full-screen layout with:

**Left panel (220px)** — Category sidebar
- "All Templates" option at top (shows count)
- List of category items, each with icon, name, and template count badge
- Active category highlighted with accent border (same pattern as Settings sidebar)
- Smooth animated selection

**Right panel** — Template browser
- **Search bar** at top — filters by title, description, and tags in real time
- **Results count** label (e.g. "14 templates" or "3 results for 'auth'")
- **Card grid** (2 columns, responsive) — each card shows:
  - Category color accent bar on left edge
  - Template **title** (bold)
  - **Description** (1 line, muted)
  - **DSL preview** (first 3–4 lines, monospace, syntax-styled, truncated)
  - **"Use Template"** button on hover (slides up with animation)
- Clicking "Use Template" sets `dslInputProvider` to the template's DSL content, navigates to `NavPage.editor`, and shows a flash status "Template loaded"

**Empty state** — If search returns no results, a friendly message with a search icon.

**Performance**: All filtering is synchronous on `List<TemplateItem>` — no async, no jank.

---

### 4. Title Bar — Add Templates Tab

#### [MODIFY] `lib/widgets/title_bar.dart`
Add a "Templates" nav tab between "Editor" and "Settings":
```dart
_NavTab(
  label: 'Templates',
  icon: Icons.library_books_outlined,
  active: currentPage == NavPage.templates,
  onTap: () => ref.read(navPageProvider.notifier).state = NavPage.templates,
),
```

---

### 5. App Shell — Register Templates Screen

#### [MODIFY] `lib/main.dart`
Add `TemplatesScreen()` to the `IndexedStack`:
```dart
IndexedStack(
  index: page.index,
  children: const [
    HomeScreen(),
    TemplatesScreen(),  // NEW
    SettingsScreen(),
  ],
)
```
Also add the import for `templates_screen.dart`.

---

## Verification Plan

### Automated
- `flutter analyze` — no new errors or warnings
- `flutter test` — existing tests still pass (no logic changes)

### Manual Verification
1. Build and run: `flutter run -d windows`
2. Click "Templates" tab — full-screen library loads instantly
3. Click each category — card grid filters correctly
4. Type in search bar — results update in real time
5. Hover a card — "Use Template" button appears with animation
6. Click "Use Template" — editor is populated, nav switches to Editor tab, status shows "Template loaded"
7. Verify 80+ templates exist across all categories
8. Verify DSL content for each template is valid and generates output correctly
