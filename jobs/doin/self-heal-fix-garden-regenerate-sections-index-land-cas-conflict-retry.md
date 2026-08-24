---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/regenerate-sections-index.sh

Failure signature (hourly, both instances, `*:37`): `[land-journal-edit] REFUSING: the current tip's blob for library/sections/README.md differs from --base-blob` → exit 1 → `garden-regenerate-sections-index.service` Failed → self-heal responder burns a diagnosis cycle. Cause: two instances (`endolin-garden-ece02cb4` and `endolin-garden2-5bcdff64`) run the same timer at the same minute with no randomized delay; the loser's `BASE_BLOB` (line 346, read from its own clone at line 332) is stale by the time `land-journal-edit.sh` syncs the producer clone, and the base-blob guard (`scripts/jobs/land-journal-edit.sh:158-162`) refuses. Confirmed by `d5d239a72c` ("scholar wrote library/sections/README.md on endolin-garden-ece02cb4", 18:37) landing on top of the tip `52d8e8b650` this host composed against.

Two scoped changes:

1. **Compose-and-land retry loop in the `land)` branch** (lines 327-347). Wrap `sync_clone` → `generate_auto_index` → current-check → `land-journal-edit.sh` in a bounded loop (3-5 attempts, existing `backoff` helper between passes, as `land-journal-edit.sh:155` already does for push contention). On a conflict exit, re-sync and re-compose against the new tip rather than exiting 1; the second pass normally hits the `sections index already current; nothing to land` branch (line 342) and exits 0, because the peer landed the same deterministic projection. Only after the attempts are exhausted should it exit non-zero — a persistent conflict then means a genuine non-idempotent divergence worth a real alert. Distinguish the lander's conflict exit (1) from its other failures so a hard `die` (missing library, incomplete index, rc=2) is not swallowed by the retry; do **not** reach for `--force`, which would clobber a real concurrent edit.

2. **Kill the misleading broken-pipe line** at line 341. `diff -q` short-circuits at the first difference and leaves the `<(printf …)` substitution unread, so `printf` dies of SIGPIPE and logs `printf: write error: Broken pipe` on every stale run, above the real error. Write `$out` to a temp file once (reuse it for the diff, and pass it to the lander as the `<body-file>` argument instead of piping on stdin — `land-journal-edit.sh:139` accepts a body file, which also removes the second SIGPIPE when the lander refuses before draining stdin). Clean it up on exit alongside the other temps.

Optional hardening, not a substitute for (1): add `RandomizedDelaySec` to `scripts/systemd/garden-regenerate-sections-index.timer` to spread the fleet's `*:37` wakeups. It narrows the collision window but cannot close it — the compose-to-land gap is ~15 s of real work — so land the retry loop regardless. The timer's header comment explains why the `:37` anchor was chosen (clear of clone-keeper `:00/:30`, drift-scan `:07`, link-scan `:22`); keep that reasoning intact and note the randomization spread stays inside that gap.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-24T18:39:45Z
