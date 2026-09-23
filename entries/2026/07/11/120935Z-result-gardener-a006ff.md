---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-11T12:09:36Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - endojs/endo-but-for-bots#609

Fixer pass on endojs/endo-but-for-bots#609 (endoclaw-timer interval scheduler, base of the M3 scheduled-execution stack).

kriskowal's CHANGES_REQUESTED is a re-architecture: name/document it as a "message scheduler" (produces messages on schedules, not a general scheduler), push persistence down to the platform (virtual filesystem or database, not node:fs), and redraft it as a standalone unconfined plugin `@endo/reminder` out of @endo/daemon with a live-reference retention narrative (like @pins) handled out of band by an integration (Familiar / Gateway). That is designer+builder redraft work, beyond a fixer patch.

Delivered the in-scope slice: rebased endojs/endo-but-for-bots#609 onto current `llm` (had gone CONFLICTING after llm's makeMount->makeRevocableMount rename collided with this branch's daemon.js import), resolved by re-taking llm's rename and keeping this branch's interval-scheduler import; content-neutral otherwise. Head now e4fa36f0a; MERGEABLE confirmed. Verified locally in packages/daemon: ava interval-scheduler.test.js 13 passed, ava formula-type.test.js 5 passed, tsc clean (exit 0). Did NOT run booted-daemon e2e / full CI (better-sqlite3 native build fails in this environment).

Did NOT do a speculative in-place interval-scheduler->message-scheduler symbol rename (350+ sites) since the redraft relocates that code. Posted a PR comment to kriskowal acknowledging the redraft and asking supersede-or-keep, and messaged the maintainer recommending an `@endo/reminder` designer job. PR comment: https://github.com/endojs/endo-but-for-bots/pull/609#issuecomment-4945597370

Follow-ups: (1) `@endo/reminder` designer job (the redraft). (2) Re-base Phase 2/3 endojs/endo-but-for-bots#617 and endojs/endo-but-for-bots#619 onto the new endojs/endo-but-for-bots#609 head IF the daemon-integrated stack is kept alive during the redesign; moot if superseded.
