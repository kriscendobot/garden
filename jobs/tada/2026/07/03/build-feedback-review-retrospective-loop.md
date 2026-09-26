The double loop is built, tested, and landed on `main2`.

## What I did

Built the review-retrospective double loop designed in `designs/review-retrospective-loop.md` — for every substantive PR comment, in addition to the existing "address the feedback" job, the gardener workflow now dispatches a second retrospective job that treats the comment as an indictment of the review process. Landed in three staged commits on `main2` (tip `510161529`).

**Stage 0 — restored the lost self-improvement skill.** `skills/self-improvement/SKILL.md` had been "fully adopted" per the v1 reference shelf but lost in the v2 migration, leaving `roles/COMMON.md` and `roles/mentor/AGENT.md` pointing at a missing path. Recovered it from history (commit `c169f4ac6`) with a v2 adaptation note and pointed the mentor's Skills list at it.

**Stage 1 — store, skill, role.**
- `scripts/jobs/review-miss-record.sh`: the deterministic store writer (CAS push, idempotency keyed on the primary base, member append, count bump, distinct-PR set, cluster status lifecycle with a double-dispatch guard, closed-cluster reopen-on-recurrence). The `review-misses/` tree + README self-seed on first write. The LLM decides; plain code writes.
- `scripts/jobs/test/review-miss-record-test.sh`: **22/22** — mint, join across distinct PRs to the K≥3/≥2-PR floor, idempotent re-record, dismissal mints no cluster, dispatch lifecycle + double-dispatch guard, recurrence reopens a closed cluster.
- `skills/review-retrospective/SKILL.md` (canonical playbook), `roles/prosecutor/AGENT.md`, and CLAUDE.md inventory.

**Stage 2 — comment-watcher wiring.** After a substantive-feedback primary post verifies, `mint_retro` parks a deferred `<primary-base>-retro` plan job (role `prosecutor`) via `post-plan.sh`, gated deterministically on the verb class (no LLM in the watcher). Only `review` and directive-reading `attention` qualify; branch ops, finalize, chatter-attention, and untrusted mint nothing. The retro is best-effort — a lost retro is a loud WARN, never a `fail_floor`, so it never freezes the primary's cursor. **comment-watcher-test 207/207** including 7 new `RETRO-*` cases proving exactly the required matrix: retro for review + directive-attention; none for branch ops / chatter / finalize / untrusted; idempotent re-poll; lost-retro WARN with the primary still landing.

**Stage 3** needs no new mechanical code beyond stage 1: the cluster lifecycle, double-dispatch guard, and recurrence-reopen are built and tested; the `review-improve-<slug>` dispatch (identity `review-cluster:<slug>`, board-index dedup) and the dual-deliverable + re-litigation contract are the prosecutor's runtime actions, fully specified in the skill and role.

## Verification (real runs)
- `bash scripts/jobs/test/review-miss-record-test.sh` → **22 passed, 0 failed**
- `bash scripts/jobs/test/comment-watcher-test.sh` → **207 passed, 0 failed**

This maps to the job's required repro: a simulated review-miss comment produces the retrospective record (and the primary is unaffected); a cluster crossing the floor is dispatchable and marked once (double-dispatch guarded); a new-direction/chatter comment does NOT spawn a retro (the deterministic gate + the discriminator's `not-a-miss` verdict gate it).

## Follow-ups
- **Stage 4 (observability)** — a bulletin line for clusters at K-1 and open improvement jobs — is the design's explicit nice-to-have and is deferred.
- The loop **activates on the running fleet only after a deploy** (the comment-watcher change and new scripts are on `main2`, not the deployed root).
- Journaled a `result` entry (`entries/2026/07/03/062408Z-result-builder-587324.md`).
