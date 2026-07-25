---
kind: tick
role: liaison
host: kmkmbp2026
posture: liaison
short_id: c4e1a2
refs: [b2c7c1]
project: endo
upstream_pr: endojs/endo#3332
---

CI outcome for the #719 → #3332 ferry (follow-up to result b2c7c1).

**#3332 CI settled: tests all green, lint RED (known, deferred).**

- Green: full `ses` test matrix (22.x/24.x × ubuntu/macos), `test-xs`,
  `test262`, `test-hermes`, `cover`, `build`, `browser-tests`, `viable-release`,
  `zizmor`, `test-ocapn-python`.
- **`lint` failed: 3 errors**, all `no-redeclare` on `/* global globalThis */`
  in `packages/ses/test/url.test.js` (1:11), `url-blob-remove.test.js` (1:11),
  and `url-missing.test.js` (2:11). Upstream's eslint (post the
  eslint-plugin-jsdoc upgrade, #3325) already registers `globalThis` as a
  built-in global, so the directive — harmless under the bot fork's older
  frozen-base config, which is why bot-side #719 lint was green — is now a
  redundant-redeclare error. The other 53 lint items are pre-existing repo-wide
  warnings, not from this PR.

**Fix (known, not yet applied):** delete the three `/* global globalThis */`
directives. `globalThis` is a recognized global under both configs, so removal
is expected safe on the bot side too. Durable routing is fixer-on-#719 →
re-ferry (keeps source/upstream in sync so a future recompute doesn't
reintroduce it); an upstream-only boatman patch is the fast alternative.

**Maintainer decision (this session):** leave #3332's lint red for now; the PR
is open and MERGEABLE with tests green. No fixer/boatman dispatched. Whoever
picks this up next has the exact fix above.

No dispatch worktrees outstanding (b2c7c1 torn down). Orphan `boatman--ed1f4c`
(2026-06-07) still uncollected in `dispatches/` — noted in prior sessions.
