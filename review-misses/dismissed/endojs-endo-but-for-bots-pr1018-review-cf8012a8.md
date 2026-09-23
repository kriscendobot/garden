---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1018-review-cf8012a8
verdict: not-a-miss
category: new-direction
review_at: 2026-08-29T04:51:47Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1018#pullrequestreview-5056945078
identity: endojs/endo-but-for-bots#1018:review:5056945078
producing_role: designer
---

Maintainer architectural direction on a design document, not a review-process
miss. PR #1018 (`design(ironhorse): panic mechanism and message-embargo
contract`) is a docs-only design PR — it touches only `designs/ironhorse-panic.md`
and `designs/README.md`, no source packages (confirmed by the gauntlet-clean
stage report in journal/jobs/tada/). kriskowal's CHANGES_REQUESTED review
paraphrases to: because endor vats lack a transcript, the design must specify a
write-ahead log capturing messages sent/received since the last snapshot; because
some host calls hold open handles that do not survive a vat restart, those calls
must themselves be treated as captured transcript messages; the transcript may
live in the DB or an endo-directory log file, and using a DB eases transactional
consistency provided each worker gets a separate DB to avoid contention.

This is scope and architecture taste on a design — the maintainer deciding what
the system's durability/replay architecture ought to be — squarely "new
direction, a scope change, or a requirement first stated in the comment." It is
not a bug, spec violation, missed edge case, or a convention encoded in any seat
brief, skill, or standing instruction that a juror panel could have anticipated.
No panel seat's lens is "predict the maintainer's preferred WAL-transcript
architecture for a not-yet-built subsystem."

Timing settles it further, grounded in the board rather than the primary report.
The review is dated 2026-08-29T04:51:47Z; the design panel gauntlet ran later,
2026-08-30/31. panel-1's re-derived-state note records "No prior panel verdict
existed (only a human review from kriskowal)" — so the maintainer steered the
architecture BEFORE any panel had reviewed. This is not a case of the panel
reviewing and missing something the maintainer then caught. And when the design
panel did run it independently engaged the very topic (panel-1 verdict theme: "a
reversed 'defer to follow-on' decision (embargo/transcript WAL schema) now
asserted without restating why deferral no longer applies"), so the review
surface was not blind to the transcript question.

This is explicitly NOT the `garden-design-pr-gauntlet-bypass` evaluator-gaming
avoidance pattern: a design-panel gauntlet genuinely ran here (panel rounds 1–6
and fix rounds 1–6 are all present in journal/jobs/tada/; the gauntlet ultimately
HALTED on non-convergence at max_iterations=6, an automation outcome, not a
skipped evaluator).

The primary's deliverable was verified to exist in the world, not merely
asserted. The primary job report claims it "Added a per-worker SQLite WAL
transcript covering crank commits, messages, replay, host calls, and
restart-sensitive handles" — directly matching the maintainer's per-worker-DB /
messages / host-handle-as-message request — and PR #1018 is MERGED (2026-09-04
06:55:22Z, base `llm`). So the directed change was implemented and landed; this
is not a false no-op resolution. Recorded as a dismissal so the same architectural
directive is never re-litigated by a requeued retro; no cluster is minted and no
improvement job is warranted.
