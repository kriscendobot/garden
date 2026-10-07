---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1407-review-1d8c37a5
verdict: miss
category: process
pr: 1407
cluster: design-bespoke-mechanism-over-existing-path
review_at: 2026-10-05T04:36:27Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1407#pullrequestreview-5410056994
identity: endojs/endo-but-for-bots#1407:review:5410056994:retro
producing_role: builder
producing_job: build-endo-guest-scoped-daemon-bootstrap
missed_by: decomplector (category f, minimum viable abstraction) — not seated on the code panel; plus breaker/wire-watcher/corner-prober/purist, which patched the socket lifecycle across six code-panel rounds without questioning the mechanism
severity: moderate
grounds: |
  Maintainer CHANGES_REQUESTED (paraphrase): a per-guest Unix-domain socket
  is an odd direction whose lifecycle and collection are fraught for little
  gain; the stdio MCP is already confined by the harness under object-
  capability discipline, so it should connect to the Endo root, look up the
  guest by formula identifier once, and use only that facet. This is not new
  direction. (1) The same maintainer rejected a per-guest socket endpoint on
  the very same design (designs/endo-guest-stdio-mcp.md) in #1226 review
  5231787250 (2026-09-17), and the merged design adopted bootstrap-host
  lookupById; that is the first member of this cluster. #1407 rebuilt the
  rejected mechanism and edited that design to mark its scoped-bootstrap open
  question "resolved". (2) The builder's own completion report says the
  broker still narrowed a root connection with lookupById, so the existing
  path already provided the boundary. (3) The PR ran six code-panel rounds
  (reviews 5386654561..5400384875, 2026-10-01..03), every one must-fix, and
  the findings were exactly the lifecycle hazards the maintainer named:
  revocation on guest removal, ENDO_GC-gated revocation, cancellation noise,
  collect-vs-issue races, reincarnation mid-issue, silent host-authority
  fallback. Each round added mechanism; no seat asked whether it was needed.
  The decomplector's category (f) covers that question but the decomplector
  is seated only on the design panel, so a code PR that makes a design-level
  choice (and edits a design doc) never gets it. Origin: the build was a
  bot-authored follow-up item from #1371 that the #1371 review job read
  broadly as "build". Deliverable verified in the world: fix job
  fix-endo-pr1407-single-socket-guest-lookup stripped the socket machinery;
  #1407 merged 2026-10-05 (7a4e957410) as a design-doc-only diff
  (+39/-45), after a maintainer APPROVE.
---
Retro of kriskowal's CHANGES_REQUESTED review on #1407: a build re-introduced a
per-guest daemon socket the maintainer had already rejected on #1226 for the
same design, and six code-panel rounds hardened its lifecycle instead of asking
whether the existing root-connection + lookupById path made it unnecessary.
