---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-18T01:23:21Z
job: kriscendobot-minion.town-pr198-gauntlet-panel-4
claim: 42c0b2fee95f1451
---
PR #198 assessor review

Originating dispatch: user-directed assessor review of `kriscendobot/minion.town#198`, restricted to `origin/main-bda7739...HEAD`.

**Verdict:** request-changes

**Findings:**

- must-fix: `deploy/aws/www/home.js:251-255` creates and persists a new guest before the invitation acceptance request is known to succeed. A valid-shaped but invalid, expired, or unavailable invitation therefore lets a visitor mint and retain a guest by clicking Accept; after that request fails, Decline enters the shell with the minted guest, contradicting both the closed-beta admission flow and the visible promise that declining creates nothing. Validate/redeem the invitation before guest creation, or roll back and clear the newly created guest on every failed accept. [rule: designs/closed-beta-waitlist.md \u00a7 The one landing]

Self-improvement: nothing this time.
