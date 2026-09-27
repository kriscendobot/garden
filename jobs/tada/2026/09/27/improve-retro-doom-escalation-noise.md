Job complete. Report follows.

---

## Completion report

**What the job asked:** Harden `reaper.sh`'s doom-disposition so `*-retro` telemetry jobs (best-effort review-retrospective second loops) that exhaust their retry budget are dropped/logged quietly instead of going through the full mark-split-eligible + held-plan-park + maintainer-inbox surfacing — the disposition that made 6 of 10 requeue-exhausted doom notices on 2026-09-17 retros. Keep the split-eligible parking path unchanged for every other job class.

**What I did (`scripts/jobs/reaper.sh`):**
- Added an early per-base `is_retro` flag (`case "$spine" in *-retro)`).
- In the doom disposition, added a leading **retro-drop branch** before the deadline-overrun/park branches: a **non-gauntlet** `*-retro` job whose signature is `requeue-exhausted` or `elapsed-constancy` (the split-eligible repeated-plain-exit family) is dropped — `git rm` of its `doin/`, `work/`, `inbox/` entries and one quiet `retro-drop:` log line, with **no** plan park, **no** split-eligible mark, and **no** maintainer notice.
- The drop is still recorded to the decision ledger (`decision: drop-retro-telemetry`) post-CAS, so it stays auditable off the inbox; terminal project worktrees are cleaned post-CAS like the doom path.
- Added a `dropped` counter, included it in the "nothing landed" push-failure guard (so a drop-only tick isn't misreported as a failed push) and the final summary log.
- Scoping is deliberate: a `-z gauntlet_base` guard excludes any gauntlet-retro, and only the generic-exhaustion signatures match — a retro deadline-overrun still splits, a retro policy-refusal still quarantines, a retro over-token-budget still holds, and every non-retro requeue-exhaustion still parks split-eligible + surfaces.

**Tests (`scripts/jobs/test/reaper-doom-park-test.sh`):** Added SUBTEST 6 asserting a `*-retro` job is dropped quietly (gone from all board locations, no notice, logged) while a non-retro sibling doomed in the same tick still parks split-eligible and surfaces, plus a decision-ledger audit assertion.

**Verification (run here):**
- `bash -n` + `shellcheck -S warning` on reaper.sh: clean.
- `reaper-doom-park-test.sh`: 10 passed, 2 failed — the 2 failures are SPOOL/DRAIN subtests that fail identically on the unmodified HEAD test in this sandbox because git refuses the fixture's `pre-receive` hook ("not set as executable"); they are environmental, not a regression (verified by running the original HEAD test → same 8/2 baseline, now 10/2 with my 2 new passing subtests).
- `reaper-requeue-cap-test` 5/0, `reaper-live-handler-guard-test` 3/0, `reaper-gauntlet-handoff-test` 5/0, `terminal-handler-failure-reap-test` 6/0, `defer-doomed-plan-test` PASS — all green.
- `outage-doom-pause-test` (8/3) and `productive-cycle-test` (12/2) failures are environmental: they assert the *gardener* stamps productive/outage markers via a handler stub the sandbox's agent-CLI health gate blocks ("does not apply") — that logic is in gardener.sh/common.sh, upstream of and untouched by this change.

**Committed & pushed:** `7a76bf7e05` on `origin/main2` (rebased once onto the moving tip, then landed).

**Follow-ups:** None required. Optional future consideration: the fixtures in this test suite hardcode `/home/kris` paths, which prevents them running unmodified outside a `kris` home — orthogonal to this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-retro-doom-escalation-noise.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 3 host(s) (2 unmetered)
- Input: 86 tokens (5512097 cached reads)
- Output: 36413 tokens
- Cost: $5.1357735 (2 engagement(s) unpriced)
- Wall-clock: 823s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
