---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr807-review-ae1e614a
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T21:42:14Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/807#pullrequestreview-4976974870
identity: endojs/endo-but-for-bots#807:review:4976974870
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr807-c55523fb
---

Top-maintainer design direction on a docs-only design PR that exists precisely as
a review surface. #807 reconciles the `tree(ref)` / `filesystemAt(ref)` historical
-read vocabulary in two canonical design docs (no code). The review carries two
asks, both paraphrased here (untrusted text omitted): an inline note that the doc
need not carry a backward-compatibility framing and "can be a rename," and a body
question asking whether the design's "Git history" concept is real Git plumbing or
an invention for the daemon. Both are design-level judgments the design-PR-as-
review-surface carve-out exists to solicit, not review misses.

## Grounds

New direction, not a miss, on both asks.

1. "This can be a rename — no backward-compat contortion" is the maintainer
   RELAXING a constraint the design had carried at a *contributor's* earlier
   prescription. The PR's month-long thread (0xpatrickdev/0xpatrickbot, 07-22)
   iteratively steered the bot toward a careful two-projection migration story;
   the compat contortion is the residue of that steer. On 08-20 the same
   contributor explicitly apologized "for the misdirection… speak in problems
   instead of prescriptions" and revised the driving issue. A dropped-compat
   scope decision on a pre-release `llm`-branch design is a call only the
   maintainer can make, first stated in this review — nobody in the panel could
   have anticipated it, and a compat/migration window is ordinarily *good*
   practice a decomplector seat would not flag as wrong.

2. "Is 'history' a real Git concept?" questions a coined design-vocabulary term
   (`PinnedGitHistory` / `historyAt(ref)`) still under active negotiation. The bot
   conceded the point outright ("you're right, it was an invention for the
   daemon"). A design doc proposing new vocabulary and the maintainer weighing in
   on whether the coined term is apt IS the design review working as intended. It
   is a single occurrence, below any cluster floor, with no standing seat brief
   that binds "design vocabulary must map to the underlying system's real
   concepts."

Grounded in the world, not the primary report: the primary is not a false no-op —
commit `7f08e25870af` ("docs(designs): rename tree(ref)->filesystemAt; drop the
invented 'Git history'") exists on the head branch touching exactly the two design
docs, alongside an inline reply and a PR comment answering the vocabulary
question. The primary delivered both asks.

## Process observation — deliberately not recorded as a miss

The one process fact that could read as a miss: the design-panel gauntlet posted
its first verdict on #807 at 2026-08-19T23:00Z — AFTER kriskowal's 21:42 review —
so the maintainer engaged a design surface no panel had yet scored. That shape is
the CLOSED cluster `garden-design-pr-gauntlet-bypass` (members garden#7,
endo-but-for-bots#809, minion.town#41; improved by commit e1e2a3e467 on main2,
2026-08-14, which stages the design-panel gauntlet at design-PR creation). It is
deliberately NOT recorded as a fresh member of that cluster:

- #807 was created 2026-07-20, a month BEFORE that improvement landed (08-14), and
  went dormant after the 07-22 contributor iteration. The improvement's preventive
  hook fires at design-PR *creation* and its completion-time sensor rides a
  gardener job touching the PR; neither had a trigger point for a pre-existing,
  dormant PR. The fix structurally never applied to #807 — this is a legacy-PR
  coverage gap, not the improved-against pattern re-occurring on fresh work.
- Recording it would mislead the writer's mechanical recurrence test: `review_at`
  (08-19) postdates the improvement (08-14), so it would be scored a genuine
  post-fix recurrence and would reopen + escalate a correctly-closed cluster on a
  false signal. The § 6 mechanical rule assumes `review_at` tracks when work was
  produced; for a month-dormant PR reviewed long after creation it does not.
- Substantively, the panel would not have pre-empted either of kriskowal's asks:
  the compat drop and the vocabulary judgment are maintainer direction, not panel-
  detectable defects. When the panel DID run (08-19T23:00) its must-fix findings
  were about rename-sweep *completeness* (a builder could delete `tree(ref)` before
  its replacement exists) — a different, code-facing concern — confirming the seats
  cover rename consistency but not that they could have anticipated the maintainer's
  scope call.
