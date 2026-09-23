---
role: fixer
priority: high
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# CLIPOMETER: canonical REAL-guest publish + live validation (pinned to the host with the real-guest MCP)

Repo (PRIVATE): `kriscendobot/minion.town`, DRAFT PR https://github.com/kriscendobot/minion.town/pull/84, branch `clip-clipometer-esbuild`, validated head `723631d2c34730e7a1934d14dcf46405570bd4b2` (confirm the PR head is unchanged before publishing; if it moved, publish the current head and name it).

Handed off by `minion-town-clipometer-pr84-canonical-publish-validate`, which ran on `endolin-garden2-5bcdff64`: that host has NO `mcp__minion-town__*` tools and no `minion-town` MCP server. This job is pinned (`requires: host=`) to `endolin-garden-ece02cb4`, where `minion-town-clipometer-esbuild-validate` (2026-09-17) had an `mcp__minion-town__*` session bound to the REAL maintainer guest, which holds `odometer-visit-count` + `rt58-designated-power`. **First step:** confirm that your session exposes `mcp__minion-town__*` and that `list` shows those two names. If it does not, do NOT fall back to the disposable `minion-mcp-test-cc` client-credentials guest. Instead, message the maintainer (`message-user.sh`) that the real-guest MCP is unavailable to the fleet, and finish with the orchestration-failed signal. Never put credentials in the journal.

Already done by the predecessor: the rebase, the CI-workflow conflict resolution, the 2 MB `/mcp` limit, `engine-floor.js` moved out-of-line for `script-src 'self'`, CI green, and a test-cc diagnostic publish that passed. Cleanup is also done: the diagnostic sites `zpzug…eezq` and `j3u43…lmcq` are unpublished (404 verified), and pet name `clipometer-revalidate-count-20260923` is removed.

Work:
1. Build the exact PR head in an isolated checkout (`ensure-project-worktree.sh <this-base> kriscendobot/minion.town clip-clipometer-esbuild`; `npm install && npm run bundle`, or the package's own scripts; `GARDEN_YARN=npm`).
2. In the REAL guest, create a dedicated counter-only directory power (for example `clipometer-canonical-count-20260923`) and publish the built clip with `powers` = that directory, via `mcp__minion-town__publish` (or the package's `scripts/publish.mjs`, if it can use the real-guest session).
3. Verify in a real browser (Playwright, installed into a scratch dir; /tmp is noexec):
   a. HTTP 200, and the title/status show that bootstrap reaches `live` with zero console or page errors.
   b. The first window increments the durable counter.
   c. A second window increments it again, and the first window updates without a reload (`followNameChanges`).
4. Leave the PR DRAFT and do NOT unpublish the canonical result. Record the clip URL/hash, the counter values, and the console-error counts in the report, and optionally in a PR comment.

If it passes, report that parked child `minion-town-clipometer-primer-esbuild-update` should be promoted next (the issue-report child comes only after the primer). Do NOT promote either one yourself. If it fails, finish with the orchestration-failed signal and include the evidence.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T21:15:28Z
