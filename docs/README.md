# SoulApp documentation

This directory contains the implementation contract for the Flutter mobile application. The MVP is app-only: no backend, account, or sync (decision 2026-09-26, see `requirements.md` §0).

- [Product specification](product-spec.md): scope, user journeys, product rules, and acceptance criteria.
- [Normalized requirements](requirements.md): authoritative user stories, business rules, source precedence, and definition of done.
- [Architecture](architecture.md): Flutter boundaries, navigation, state, localization, audio, and testing approach.
- [Technology stack](tech-stack.md): selected packages, platform baseline, deferred dependencies, and exclusions.
- [Data and backend specification](data-backend-spec.md): deferred sync-backend design; reference for the on-device schema, content, privacy, and audio-locale rules.
- [Implementation plan](implementation-plan.md): phased delivery plan, dependencies, verification, and definition of done.
- [Delivery backlog](backlog.md): prioritized implementation tickets, dependencies, acceptance checks, and status tracking.
- [Normalized source specifications](source-specs/README.md): searchable Markdown conversions of the accepted DOCX and XLSX inputs.

## Source material

The original product datasets and prototype currently live one level above this repository in `/Users/hunglv/Desktop/An/Soul`. The prototype is the visual and interaction reference; normalized requirements define product behavior when implementation details are not visible in the prototype.

The Flutter application must consume the generated content bundle rather than parsing `.xlsx` or `.docx` files at runtime. Those files are authoring/import sources only.
