scripts/jobs/land-journal-edit.sh
Whole-file lands can semantically clobber a concurrent writer: two gardeners composing a body against different stale bases each land on the current tip via sync_clone's hard-reset, so git-level loss is prevented but the second land reverts the first writer's edits to a different part of the file (observed this tick: cycle-1's matrix/inconsistencies grounding was mutually clobbered across two hosts, requiring a manual merge-repair by a later scholar). Add the guard the scholar proposed: accept an optional caller-supplied read-base identifier (e.g. `--base-blob <sha>` — the git blob sha of the file content the caller read/composed against) and, after sync_clone reaches the tip but before staging, compare it to the tip's current blob for `rel`; if they differ, the file changed concurrently since the caller's read, so refuse the non-append whole-file replacement (nonzero rc) unless `--force` is passed, surfacing "you may be overwriting a concurrent edit" the way the sections/topics regenerators already detect drift. Keep it opt-in/back-compatible: with no `--base-blob` the current behavior is unchanged, so callers that can cheaply record their read-base (the scholar's landing path) get the guard without breaking append-only or first-write callers.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-17T15:21:59Z
