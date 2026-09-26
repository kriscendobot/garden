Landed on `origin/main2` (`7440381e4`), test green.

---

## Completion report

**Job:** close the job-board dedup gap where one PR #58 directive spawned two concurrent jobs (comment-watcher + a peer), enabling the same-PR clobber.

**Investigation (forensics on `origin/journal2`).** PR #58 accumulated two disjoint job families: comment-watcher jobs `endojs-endo-but-for-bots-pr58-<hash>` and peer/liaison hand-named jobs `ebfb-pr-58-<slug>` (e.g. `ebfb-pr-58-error-bubble-watch-stacktrace-race`, whose body cites the very same maintainer comment `4850565566`). Root cause: `post-job.sh` is idempotent only on the **basename**, so two producers naming the one directive differently both land — two gardeners then race the same PR, and one clobbered the other's working tree. Neither the basename check nor a watcher's `verify_posted` could see the two bases were the same work.

**Fix (`scripts/jobs`).** Added a second dedup keyed on a producer-independent **directive identity** (`<owner>/<repo>#<pr>:comment:<cid>` | `:review:<id>`):
- `post-job.sh`: new `--identity` / `GARDEN_JOB_IDENTITY`; maintains a `jobs/index/<hash>` map (alongside the lifecycle, never claimed/reaped) → the single owning base. If the identity already owns a **live** job (todo/doin/tada), the post is a no-op → **one directive → at most one open job**. Index written atomically with the job; re-pointed once the owner drains (a completed directive never blocks a recurrence). With no explicit identity, one is best-effort derived from a single canonical GitHub comment URL in the body.
- `comment-watcher.sh` + `mention-watcher.sh`: pass the identity (via `GARDEN_JOB_IDENTITY` — post signature unchanged, so stubs are unaffected) and, in post-confirm, treat an identity-dedup no-op as success via a new `journal_identity_owner_live` helper (else they'd misread the intentional no-op as a lost push and wedge the cursor). Both compute the identical identity for the same comment, so a comment seen by both watchers collapses to one job.
- `common.sh`: `JOBS_INDEX`, `job_id_hash`, `job_in_lifecycle`, `derive_job_identity_from_body`, `journal_identity_owner_live`.

**Tests / docs.** New `directive-identity-dedup-test.sh` (15 assertions: dedup, distinct-identity, auto-derive, ambiguous-body, stale-index re-point, no-identity backcompat) — 15/0. Regressions green: comment-watcher 157/0, mention-watcher 19/0, producer-body-hang 14/0, issue-inbox 25/0. Documented in `designs/job-board.md` and `skills/job-board/SKILL.md`.

**Landed:** `7440381e4` on `origin/main2`.

**Honest coverage boundary / follow-ups.**
- The **cross-watcher** duplicate (comment-watcher vs mention-watcher) is now closed *deterministically*.
- The **watcher-vs-peer** duplicate (the exact #58 case) is closed when the peer either passes `--identity` (now the documented convention for hand-posted PR jobs) or quotes the canonical comment **URL** in its body. The real `ebfb-pr-58-*` body cited the comment id in *prose* (`comment 4850565566`), not as a URL anchor, so its durable fix is the liaison/foreman passing `--identity` — worth wiring explicitly into those producers next.
- `jobs/index/` entries for identities that never recur linger at HEAD (tiny; active identities stay bounded via re-point-on-stale). A periodic index GC in the reaper is a reasonable follow-up.
- One environmental note: `run-test.sh` SUBTEST 26 (issue-inbox source, unrelated to this change) showed 4 failures under live ~100-gardener fleet load — the "flakes under fleet load" the test header documents; the dedicated `issue-inbox-watcher-test.sh` passes 25/0 in isolation.
