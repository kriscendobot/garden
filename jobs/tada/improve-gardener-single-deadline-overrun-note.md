## Completion report

**Job:** `improve-gardener-single-deadline-overrun-note` — collapse the rc=124 deadline-overrun double-journal to one authoritative progress entry.

**Finding:** The requested fix was **already landed on `main2`** before I claimed this job, by commit `d71677bd2` ("gardener: collapse the deadline-overrun double-journal to one accurate entry", authored ~25 min before my claim). My worktree, checked out off `origin/main2` (HEAD `0bac3d4e5`), already contains it.

**Verification (no new changes needed):**
- `scripts/jobs/gardener.sh:604-609` — the generic transient `printf … journal-entry.sh progress` is gated behind `{ cycle-at-edge || constancy } && [ "${deadline_overrun:-0}" -ne 1 ]`, exactly as the spec asks. The plain `log` line and all other transient paths (external kill, plain timeout, empty-capture, transient-claude-signature) are untouched; the deadline-overrun branch (622-644) still emits its own single accurate note and preserves the stamping/poison behavior.
- Working tree is clean (`git status --short` empty) — nothing to commit or push.
- `scripts/jobs/test/timeout-classifier-test.sh` passes **36/0**, including the purpose-built **SUBTEST 6** which asserts, at cycle 4 / poison-threshold 5, that the generic "transient handler outage" note is suppressed and exactly one deadline-overrun note is emitted.
- Inbox drained — empty.

**Changes made:** none (job satisfied by pre-existing commit).

**Follow-ups:** none. This job was effectively a duplicate of already-merged work; no further action required.
