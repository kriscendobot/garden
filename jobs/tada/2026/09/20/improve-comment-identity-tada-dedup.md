The fix is landed on `main2`. Inbox is empty.

## Completion report

**Job:** Keep completed comment/review directive identities terminal when a watcher replays the same GitHub comment after a cursor failure — no second job for an already-delivered directive — while preserving fresh directives keyed to distinct comment IDs.

**Root cause.** `scripts/jobs/post-job.sh`'s directive-identity dedup (the `jobs/index/<hash>` map) gated the "already owns a job" no-op on `job_is_active` (plan|todo|doin, **tada excluded**). That guard was introduced by `f8c053a02b` for the pr475 incident, where a genuinely new directive on the same identity under a **different** base needed to re-point past a completed owner. But it over-corrected: when a comment-watcher replays **one** GitHub comment after a cursor failure, it re-derives the **same** deterministic `(PR,verb)` base and passes the **same** identity. With the completed job in `tada/`, `job_is_active` returned false, so the replay re-minted a **second** job for work already delivered.

**Fix.** In `post-job.sh`, added one `elif` clause after the active-owner dedup: a **completed** (tada) owner is terminal **only when the requested base equals the owner base** (a true replay), and still falls through to post + re-point when the base differs (the pr475 path, untouched). This distinguishes the two by the requested base:
- active owner → dedup regardless of base (unchanged);
- completed owner, **same** base → terminal no-op (the fix);
- completed owner, **different** base → re-point + mint (pr475, unchanged).

Fresh directives on **distinct** comment IDs carry distinct identities → distinct index entries → never reach this same-identity branch, so the #671 fresh-directive guarantee is preserved. Updated the three affected design comments (header, base-check, dedup block) to state the same-base-terminal exception accurately.

**Files changed.**
- `scripts/jobs/post-job.sh` — the dedup clause + doc comments.
- `scripts/jobs/test/directive-identity-dedup-test.sh` — new regression test 10 (completed same-base replay is terminal; index unchanged).

**Verification.** `directive-identity-dedup-test.sh` passes 26/26, including new test 10, the pr475 re-point (test 9), and the #671 fresh-directive (test 8). `bash -n` clean; shellcheck shows only pre-existing info notes outside the changed lines. Landed as `b34f6fa02e` on `origin/main2`.

**Follow-ups.** None required. Note: the comment-watcher's own `base_live` pre-check (todo/doin only) remains correct as-is; this terminal guard lives one layer down in `post-job.sh` exactly where the watcher's comments already promised it did ("post-job.sh's identity index … collapses it") — that promise is now true again for the same-base replay case.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-identity-tada-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1864993 cached reads)
- Output: 17188 tokens
- Cost: $2.1517424999999997
- Wall-clock: 237s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
