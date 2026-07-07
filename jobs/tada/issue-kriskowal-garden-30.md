Job complete.

## Completion report

**Job:** `issue-kriskowal-garden-30` — maintainer (kriskowal) asked, via issue #30, for a scholar to study https://taskpeace.com/, capture its gestalt and features, identify gaps against our Endo designs, and recommend design directions, reporting back on the issue.

**What I did:**
- Wore the scholar role. Fetched and analyzed the TaskPeace site (single marketing-site fetch, 2026-07-07; features treated as-advertised with an explicit provenance caveat) plus a web search.
- Grounded the "our designs" side against the garden library: the `daemon` and `capability-security` topics and the endo-but-for-bots design ingests (`daemon-capability-bank`, `daemon-agent-tools`, chat/capability-bus family, per-agent keypairs, OCapN/CapTP).
- Produced a structured report: gestalt, full feature inventory, a **two-way** gap analysis, and **eight concrete design directions (D1–D8)** for narrowing the gap by adding a TaskPeace-shaped coordination layer on top of the ocap substrate.

**Key finding:** TaskPeace and endo-but-for-bots solve adjacent, non-overlapping halves. TaskPeace ships the *coordination surface* (one ranked queue, `get_next_task`/`complete_task` agent loop, human-holds-priority, task leasing, broad MCP interop, project briefs, analytics) with essentially **no security model**. Our designs have the *security substrate* (daemon, Capability Bank, confinement, CapTP/OCapN, delegation/revocation, petnames) but **no first-class Task/Queue primitive or agent-loop protocol**. TaskPeace also validates the garden's own job-board bet. The moat to press is capability security + distributed multi-party operation, which TaskPeace cannot add without becoming Endo.

**What changed / deliverables:**
- Report posted as an issue comment: https://github.com/kriskowal/garden/issues/30#issuecomment-4898795049 (did **not** close the issue — submitter closes when satisfied).
- Durable journal capture landed on `journal2`: `journal/projects/endo-but-for-bots/taskpeace.md` (condensed study), plus a "Per-topic detail" index row in that project's `README.md` (also linked the two previously-unindexed topic files).
- `result` entry `entries/2026/07/07/001639Z-result-gardener-4c91cb.md`.

**Follow-ups:** None posted. Captured as a project topic rather than a library section (a marketing web page, not an upstream design doc, so full library-section ceremony did not apply). Inbox clean at start and end.

Self-improvement: For an issue-spine research request whose subject is a live web product rather than an upstream repo doc, the right durable home is a `journal/projects/<slug>/` topic file (light-weight, landed via `land-journal-edit.sh`), not a `library/sections/` ingest — the library idempotency/anchor machinery assumes a versioned source file. Worth encoding in the scholar brief as the "web-product study" variant if these recur.
