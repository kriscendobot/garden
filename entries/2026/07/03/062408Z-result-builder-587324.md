---
kind: result
role: builder
host: endolinbot2
at: 2026-07-03T06:24:09Z
---
# result: the review-retrospective double loop is live in the gardener workflow

Job `build-feedback-review-retrospective-loop` (builder, garden-infra on main2).
Built the mechanism designed in `designs/review-retrospective-loop.md`: every
substantive PR comment now gets two responses — the primary "address the
feedback" job (unchanged), and a second retrospective job that treats the
comment as an indictment of the review process.

Landed on main2 (3 commits):
- Stage 0: restored `skills/self-improvement/SKILL.md` (lost in the v2
  migration; roles/COMMON.md and roles/mentor pointed at a missing path).
- Stage 1: `scripts/jobs/review-miss-record.sh` deterministic store writer +
  test (22/22), `skills/review-retrospective/SKILL.md`,
  `roles/prosecutor/AGENT.md`, CLAUDE.md inventory.
- Stage 2: comment-watcher `mint_retro` after the primary post-verify, gated
  deterministically on the verb class; comment-watcher-test 207/207.

Stage 3 (threshold + improvement dispatch) needs no new mechanical code beyond
stage 1: the cluster-status lifecycle, double-dispatch guard, and
recurrence-reopen are built and tested in review-miss-record.sh; the
`review-improve-<slug>` post (identity `review-cluster:<slug>`, dedup via the
board index) and the dual-deliverable + re-litigation contract are the
prosecutor's runtime actions, fully specified in the skill and role.

Stage 4 (a bulletin line for clusters at K-1 + open improvement jobs) is the
design's nice-to-have and is deferred as a follow-on.

Activates on the running fleet only after a deploy (the comment-watcher change
and the new scripts are on main2, not the deployed root).

Verification (real runs):
- `bash scripts/jobs/test/review-miss-record-test.sh` → 22 passed, 0 failed.
- `bash scripts/jobs/test/comment-watcher-test.sh` → 207 passed, 0 failed.

Self-improvement: nothing this time.
