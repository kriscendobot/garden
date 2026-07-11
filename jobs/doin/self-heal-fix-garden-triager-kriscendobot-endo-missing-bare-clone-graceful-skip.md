In `scripts/jobs/triager.sh` line 32, the guard `[ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"` turns a per-host "this fork isn't cloned here" condition into a FATAL exit 1. Because triager instances are armed from the journal-shared `repos/` set (via `repo-watcher.sh`) while bare clones are host-local (`$GARDEN_ROOT/repos/<slug>.git`), every armed triager on a host that lacks the local clone dies every tick and trips the self-heal responder. On host `endolin-garden2-5bcdff64` the `repos/` dir is empty, so all 8 kriscendobot triagers (endo, agoric-3-proposals, agoric-sdk, cosgov, finbot, minion.town, ocapn, vattr97) are affected; failure signature: `FATAL: no bare clone at .../repos/kriscendobot-endo.git (clone the repo first)`.

Change the guard to a graceful skip that mirrors the sibling `comment-watcher.sh:312` pattern — log a clear note and `exit 0` instead of `die`, e.g.:
`[ -d "$BARE" ] || { log "no bare clone at $BARE on this host; nothing to triage here (skipping)"; exit 0; }`

Rationale: the triager cannot diff without the local clone, but that is a no-op, not an error — the same tradeoff `comment-watcher.sh` already accepts. This stops the every-tick FATAL / self-heal spam while leaving the triager to resume automatically if/when the bare clone is provisioned on this host. Keep the existing `fleet_draining` early-exit above it unchanged, and verify against `scripts/jobs/test/` (add/adjust a triager test asserting exit 0 + a logged skip when `$BARE` is absent).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  claimed_at: 2026-07-11T01:54:14Z
