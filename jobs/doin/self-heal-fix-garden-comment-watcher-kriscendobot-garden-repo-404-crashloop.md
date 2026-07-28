The comment-watcher for `kriscendobot/garden` crash-loops (systemd restart forever) because the repo does not exist on GitHub (`gh api repos/kriscendobot/garden` → 404 under both default and `kriscendobot` identities), yet it was auto-armed into the comment-watch set.

Two-part fix:

1. **Immediate disarm of the nonexistent target.** On `journal2`, remove the auto-provisioned arming records for the dead fork and tombstone it so the provisioner never re-adds it: delete `comment-repos/kriscendobot-garden` (and any `repos/kriscendobot-garden` / `ci-repos/kriscendobot-garden` sibling entries), and add `watch-optout/kriscendobot-garden` (per `fork-watch-provisioner.sh` §"Unwatch stays meaningful", line ~151 `tip_has "watch-optout/$slug" && continue`). Push via the job-board CAS. Also flag the stale local bare clone `worktrees/kriscendobot-garden.git` whose `origin` 404s — it never corresponded to a real fork (kriscendobot never forked kriskowal/garden); recommend removing it or documenting why it exists, since it is what mis-triggered provisioning.

2. **Durable guard against a repo-level 404 crash-loop.** In `scripts/jobs/handlers/comment-source-gh.sh`, distinguish a *definitive repo-level 404* (the repo doesn't exist / no access — every surface returns the "(definitive, ...); not retrying: gh: Not Found (HTTP 404)" signature) from a *transient enumeration failure*. When the repo itself is gone, the current behavior (`note_fetch_failure` → `FETCH INCOMPLETE` → `exit 1` at lines 303–306) is wrong: freezing the cursor and exiting nonzero produces a perpetual systemd restart loop. Instead, on a definitive repo-not-found verdict, the source should deactivate the target gracefully — log it, `alert_maintainer` **once** (idempotent key like `comment-watch-repo-gone-<slug>`, mirroring `triager.sh:133`), and exit **0** (or auto-write the `watch-optout/<slug>` tombstone) — never crash-loop. Apply the same repo-existence preflight in `scripts/jobs/fork-watch-provisioner.sh` (it currently maps any local bare clone with a listed owner into the watch set with **no** `gh api repos/<repo>` existence check — see grep: no `exist`/`404` guard before arming), so a bare clone whose `origin` 404s is skipped with a warning rather than arming a doomed watcher. Cover with a case in `scripts/jobs/test/comment-watcher-test.sh` asserting a repo-level 404 exits 0 (deactivated) rather than 1 (crash-loop).

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-28T07:19:18Z
