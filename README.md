# Task App — Social Feed

A Flutter social feed app with comments, likes, replies, image viewing, and full RTL/Arabic localization.

---

## Features

### 1. Feed Screen
Scrollable feed with a post card and threaded comments. Pull-to-refresh isn't needed because data loads from a local SQLite database that persists across sessions.

### 2. Post Display
- **User header**: Avatar, username (`johndoe`), formatted date+time (e.g., "July 6, 2026 3:30 PM") and a **Public** badge.
- **Text body**: Post description.
- **Image**: Rounded corners, fade-in on load, tap to open fullscreen.
- **Action row**: Like (animated heart), Comment count, Share.

### 3. Like Post (Animated)
Bouncy heart icon with a scale animation (1.0 → 1.4 → 0.9 → 1.0). Count updates immediately. Persisted to SQLite.

### 4. Comments & Replies
- Add a comment via the bottom input bar.
- Tap **Reply** on any comment to reply — a banner appears showing "Reply to @username".
- Nested threading: replies are indented under their parent.

### 5. Like Comments (Animated Heart)
Each comment has a heart toggle. Tapping triggers a **pop + shake** animation (scale 1.0→1.35→0.9→1.0 + slight rotation). Toggles between filled heart (liked) and outline (not liked). Persisted to SQLite.

### 6. Delete Own Comments
A delete icon appears only on comments authored by the current user (`johndoe`). The icon is pushed to the far end of the row (away from the Reply button) to prevent accidental taps.

### 7. Share
- Share the post text via the native system share sheet.
- From the fullscreen image viewer, download the image to a temp file and share it.

### 8. Fullscreen Image Viewer
- Tap any post image to open a fullscreen viewer.
- **Pinch-to-zoom** (up to 5×).
- **Download & share** the image.
- Smooth fade transition.

### 9. Language Toggle (EN / AR)
Tap the globe icon in the AppBar to switch between English and Arabic instantly.
- **15 UI strings** fully translated.
- **Dates and times** formatted per locale (e.g., "July 6, 2026" vs "٦ يوليو ٢٠٢٦").
- **Relative timestamps** localized ("3 min ago" / "منذ ٣ د").
- **RTL layout** applied automatically when switching to Arabic.

### 10. Animations
- **Comment entrance**: Each top-level comment slides up + fades in (220ms).
- **Post like**: Bouncy scale animation (300ms).
- **Comment heart**: Scale + rotation shake (400ms).
- **Image fade-in**: 300ms opacity transition on first frame.
- **Fullscreen transition**: 250ms fade.
- **Delete icon**: Spacer pushes it to the far end.

### 11. Error & Loading States
- **Loading**: Centered spinner while fetching data.
- **Error**: Icon + message + **Retry** button.

### 12. Responsive Design
All sizes use `flutter_screenutil` (design base: 390×844) — works on phones, tablets, and various screen sizes.

### 13. Local Persistence (SQLite)
- `posts` and `comments` tables with foreign keys and cascading deletes.
- Auto-seeds a sample post about **Cristiano Ronaldo** on first launch (142 likes, 18 comments).
- Migrates old data automatically.

---

## Data Flow

```
UI (Widgets) → Cubit (State) → Repository → SQLite (sqflite)
     ↑                          │
     └─────── BlocBuilder ──────┘
```

- **FeedCubit** manages loading, liking, commenting, and deleting.
- **LocaleCubit** manages language toggling.
- Repositories abstract all database operations.

---

## Tech Stack

| Category | Choice |
|---|---|
| Framework | Flutter |
| State Management | flutter_bloc (Cubit) |
| Database | sqflite (SQLite) |
| Responsive Sizing | flutter_screenutil |
| Localization | intl + manual map |
| Image Viewing | InteractiveViewer |
| Sharing | share_plus |
| Value Equality | equatable |

---

<br>

# تطبيق المهمة — فيد اجتماعي

تطبيق فيد اجتماعي مكتوب بـ Flutter مع تعليقات، إعجابات، ردود، عرض صور، ودعم كامل للغة العربية والـ RTL.

---

## المميزات

### 1. شاشة الفيد
فيد قابل للتمرير مع بطاقة منشور وتعليقات متسلسلة. البيانات محفوظة محليًا في SQLite وتستمر بعد إعادة تشغيل التطبيق.

### 2. عرض المنشور
- **ترويسة المستخدم**: صورة شخصية، اسم المستخدم (`johndoe`)، التاريخ والوقت (مثل "٦ يوليو ٢٠٢٦ ٣:٣٠ م") وشارة **عام**.
- **نص المنشور**: وصف المنشور.
- **الصورة**: زوايا دائرية، ظهور تدريجي (fade-in) عند التحميل، ضغط لفتح وضع ملء الشاشة.
- **أزرار التفاعل**: إعجاب (قلب متحرك)، عدد التعليقات، مشاركة.

### 3. الإعجاب بالمنشور (متحرك)
أيقونة قلب بنبض مع حركة تكبير (1.0 ← 1.4 ← 0.9 ← 1.0). العدد يتحدّث فورًا. يُحفظ في SQLite.

### 4. التعليقات والردود
- إضافة تعليق عبر شريط الإدخال السفلي.
- ضغط **رد** على أي تعليق لفتح الرد — يظهر بانر مكتوب عليه "الرد على @username".
- تسلسل هرمي: الردود تكون متباعدة تحت التعليق الأصلي.

### 5. الإعجاب بالتعليقات (قلب متحرك)
كل تعليق له زر قلب. الضغط يشغّل حركة **pop + shake** (تكبير 1.0←1.35←0.9←1.0 + دوران خفيف). يتبدّل بين قلب ممتلئ (معجب) وقلب فارغ (غير معجب). يُحفظ في SQLite.

### 6. حذف التعليقات الخاصة
أيقونة حذف تظهر فقط على تعليقات المستخدم الحالي (`johndoe`). الأيقونة موضوعة في أقصى نهاية الصف (بعيدة عن زر الرد) لمنع الضغط الخطأ.

### 7. المشاركة
- مشاركة نص المنشور عبر شاشة المشاركة في النظام.
- من وضع ملء الشاشة للصورة، تحميل الصورة إلى ملف مؤقت ومشاركتها.

### 8. عرض الصورة بملء الشاشة
- ضغط أي صورة منشور لفتحها بملء الشاشة.
- **تكبير بالقرص** (حتى 5 أضعاف).
- **تحميل ومشاركة** الصورة.
- انتقال سلس (fade transition).

### 9. تبديل اللغة (EN / AR)
ضغط أيقونة الكرة الأرضية في الـ AppBar للتبديل فورًا بين الإنجليزية والعربية.
- **15 نص واجهة** مترجم بالكامل.
- **التواريخ** منسقة حسب اللغة.
- **التوقيت النسبي** مترجم ("3 min ago" / "منذ ٣ د").
- **اتجاه RTL** يُطبّق تلقائيًا عند التبديل للعربية.

### 10. الرسوم المتحركة
- **ظهور التعليق**: ينزلق لأعلى مع fade-in (220ms).
- **إعجاب المنشور**: تكبير بنبض (300ms).
- **قلب التعليق**: تكبير + دوران اهتزازي (400ms).
- **ظهور الصورة**: 300ms fade-in عند أول إطار.
- **انتقال ملء الشاشة**: 250ms fade.
- **أيقونة الحذف**: Spacer يدفعها لنهاية الصف.

### 11. حالات الخطأ والتحميل
- **تحميل**: دائرة تحميل في المنتصف.
- **خطأ**: أيقونة + رسالة + زر **إعادة المحاولة**.

### 12. تصميم متجاوب
كل الأحجام تستخدم `flutter_screenutil` (أساس التصميم: 390×844) — يعمل على الهواتف والأجهزة اللوحية والأحجام المختلفة.

### 13. حفظ محلي (SQLite)
- جداول `posts` و `comments` مع مفاتيح خارجية وحذف متتالي.
- تلقائيًا ينشئ منشورًا نموذجيًا عن **كريستيانو رونالدو** عند التشغيل الأول (142 إعجاب، 18 تعليق).
- يهاجر البيانات القديمة تلقائيًا.

---

## تدفق البيانات

```
الواجهة (Widgets) ← Cubit (State) ← Repository ← SQLite (sqflite)
```

- **FeedCubit** يدير التحميل والإعجاب والتعليق والحذف.
- **LocaleCubit** يدير تبديل اللغة.
- الـ Repositories تخفي كل عمليات قاعدة البيانات.

---

## التقنيات المستخدمة

| التصنيف | الاختيار |
|---|---|
| الإطار | Flutter |
| إدارة الحالة | flutter_bloc (Cubit) |
| قاعدة البيانات | sqflite (SQLite) |
| الأحجام المتجاوبة | flutter_screenutil |
| الترجمة | intl + خريطة يدوية |
| عرض الصور | InteractiveViewer |
| المشاركة | share_plus |
| المساواة في القيم | equatable |
