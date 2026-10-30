---
posted_at: 2026-10-30T03:24:41Z
role: builder
arc: minion-town-ui
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: https://github.com/kriscendobot/minion.town. Build **rung 0a** of the design `designs/clip-governor-column.md` on branch `design/clip-governor-column` (draft PR https://github.com/kriscendobot/minion.town/pull/230; read the file at commit 5816cf32 or later, plus the PR's comments). Maintainer: kriskowal, 2026-10-30, in a live liaison session; he said "go ahead" to this build.

Scope, exactly rung 0a and nothing more: the shell (chrome page, `deploy/aws/www/shell.js`) opens an authenticated CapTP session to an owner facet, with one trivial method `info()`.
- CSRF-checked `POST /account/shell-session` mints an expiring (12 h), revocable locator for one session in one tab.
- `wss://.../account/shell-captp` upgrade is refused unless the request Origin is exactly the shell origin and a valid login cookie is present.
- The session's first object is the door with one method `open(locator)`, which verifies the locator belongs to the cookie's user, and returns the facet with `info()`.
- Reconnect, revoke, expiry, and sign-out behaviors as the design specifies.
- Tests per the design, including unit tests for the endpoint and upgrade gate and Chromium coverage where a hostile clip (including one titled "Settings") cannot reach or observe the session. Follow the repo's existing browser-test recipe and CI checks; run CI-equivalent checks locally before pushing.
- Follow skills/api-transport-rubric/SKILL.md (CapTP by default, REST only for bootstrapping); this rung is the allowed REST bootstrap.

Out of scope: moving the clip list (rung 0b), the governor column (rung 1), clone, destroy, children. Do not deploy anything and do not touch prod config beyond what the feature needs behind an off-by-default gate if the repo's convention requires one; say which in the PR body. The base is the repository's current `main` pinned per frozen-base-branch; the PR is a DRAFT (the gauntlet follows automatically). Surface in the completion report any place where the design is wrong or underspecified once you meet the real code.

Open questions (j) per-tab vs per-browser session and (k) REST list retention are unanswered; this rung assumes one session per tab (as the locator is specified) and does not touch the REST clip list.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-30T03:25:11Z
