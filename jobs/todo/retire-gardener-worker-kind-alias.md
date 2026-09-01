---
tier: mentor
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-01T20:54:13Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (2026-09-01, liaison session): retire the legacy `gardener`
worker-kind alias now that the Anthropic worker has been renamed to `monk`
fleet-wide.

Context: `designs/anthropic-worker-kind-monk.md` landed stage 0 (compatibility
release) and stage 1 (per-host cutover) via job `monk-finish-gardener-rename`.
Both fleet hosts (`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`) have
since cut over: `journal/hosts/<host>` declares `monks: N` on each, and on
`endolin-garden-ece02cb4` the legacy `garden-gardener@1.service` unit is
enabled but **inactive/dead** while `garden-monk@1..4` run live. Stage 2
(writer-default flip) and the alias retirement itself were explicitly deferred
in that job's report as "a still-later, separately-reviewed cleanup." This job
is that cleanup, now authorized.

The design gates retirement on five recorded facts (§ Staged, reversible
rollout, stage 2 "Canonical writes and cleanup"). Re-verify all five before
touching anything irreversible, since the liaison could only check the local
host directly:

1. All fleet inventory reports zero legacy units and state markers — confirmed
   on `endolin-garden-ece02cb4` (`garden-gardener@1` inactive, no
   `state/gardeners/` markers). **Re-check `endolin-garden2-5bcdff64` directly**
   (its `hosts/` file still carries a `gardeners: 1` mirror line, same shadowed
   shape presumed but not yet confirmed live).
2. No live `doin`, `work`, inbox, active worktree, or recent bid has a legacy
   (`gardener`-kind) owner — confirmed: the last ~15 `claim()` log entries
   fleet-wide are all `monk-N`/`cleric-N`. Note `complete-job.sh` always writes
   the commit-message label `gardener-$id` regardless of actual kind (that is
   the generic role label, not the worker-kind field — don't mistake it for a
   live legacy claim; verify by reading each `worker_kind:` field, not the
   commit subject).
3. All hosts have deployed the canonical release — the monk registry row is
   present in both hosts' currently-deployed checkouts (root repo tested
   directly on `endolin-garden-ece02cb4`; the leader's live `garden-monk@`
   pool being active is itself proof for that host).
4. No supported external script calls the alias — the internal compat shims
   (`GARDEN_GARDENER_CLONE` fallback, `set-gardeners.sh`, the
   `handlers/gardener-claude.sh` forwarder) are the alias implementation
   itself and are exactly what this job removes; they don't count against
   this gate. Do check `context/operations/starting.md`,
   `context/operations/scaling.md`, and `context/first-run/auth.md` (all
   currently mention `gardeners:`) and update them.
5. A rollback drill is no longer promised — this is the maintainer's call,
   given in this directive.

Do the removal by reversing each row of the design's inventory table (§
Boundary and inventory):

- `scripts/jobs/common.sh`: delete the `gardener` row from `worker_kind_field`
  and `worker_kinds()`; simplify `canonical_worker_kind` to a pure v2 decoder
  (reject a v1 `worker_kind: gardener` record as unknown/legacy rather than
  silently mapping it — decide and document whether historical read paths
  still need the v1 mapping for old journal artifacts, since journal history
  is append-only and must remain readable); remove `anthropic_active_kind`'s
  monk-vs-gardener selection now that only one Anthropic kind exists.
- Delete `scripts/jobs/handlers/gardener-claude.sh` (the forwarding wrapper);
  update `gardener.sh`/`claim-job.sh`/`complete-job.sh` to drop the
  `GARDEN_GARDENER_CLONE` legacy-env fallback (keep `GARDEN_WORKER_CLONE`
  only), checking every call site the grep in this job's originating session
  found across `common.sh`, `usage-meter.sh`, `usage-append.sh`,
  `regenerate-topics-counts.sh`, `regenerate-sections-index.sh`,
  `library-slug-prefix-check.sh`, `library-link-check.sh`, `auction.sh`.
- `scripts/jobs/set-gardeners.sh`: retire it (or turn it into a clear
  "renamed to set-monks.sh" error) — check callers first.
- `scripts/jobs/reputation-reduce.sh`: drop the dual projection; write only
  `reputation/arms/monk/...` going forward. Decide whether the historical
  `reputation/arms/gardener/...` tree is deleted, left as an inert archive, or
  migrated — do not silently lose auction history.
- `scripts/systemd/`/`install-units.sh`: stop rendering `garden-gardener@`
  units; disable and remove any enabled-but-inactive `garden-gardener@N` unit
  files on both hosts as part of this job's own host-side cleanup (not a
  separate deploy step, since disabling an already-inactive unit changes no
  running behavior).
- Journal state: clear the stale `gardeners: N` mirror line from
  `journal/hosts/endolin-garden-ece02cb4` and
  `journal/hosts/endolin-garden2-5bcdff64` (a plain journal edit, no deploy
  needed).
- Tests: remove/retarget `monk-worker-kind-compat-test.sh` and
  `monk-host-cutover-test.sh` assertions that specifically exercise the
  gardener alias/dual-pool exclusivity/rollback path (or convert them into
  regression coverage that a legacy `worker_kind: gardener` claim/env is now
  correctly rejected, per whatever decision you make on historical-read
  compatibility above); keep `worker-spine-kinds-test.sh` green for monk.
- Docs: update `CLAUDE.md`, `context/operations/starting.md`,
  `context/operations/scaling.md`, `context/first-run/auth.md`, and this
  design doc's own "Implementation status" section to record retirement as
  complete (stage 2/3), per house convention of updating the design doc's
  status alongside the landing commit.

Land directly on `main2` (no PR for the garden's own repo, per `CLAUDE.md` §
Conventions). Run the full regression sweep (scaler/deploy/reaper/handler/
health/worker-spine/auction-reputation suites) before pushing, and report
which of it needed updating versus already passed. If any of the five gate
facts above does NOT hold when you check it, stop and report back rather than
proceeding — this change forecloses rollback to the legacy pool.






<!-- garden-transient-elapsed: kind=signature through=2 values=1 -->

<!-- garden-reaped: 3 -->
