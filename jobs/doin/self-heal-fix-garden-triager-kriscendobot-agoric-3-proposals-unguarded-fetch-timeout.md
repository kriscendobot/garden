In `scripts/jobs/triager.sh`, the steady-state clone refresh at line 117 —
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` — is unguarded: no `timeout` and a hard `die` on any nonzero. Because git has no IO timeout of its own, a half-open SSH fetch to `ssh://git@github.com/kriscendobot/agoric-3-proposals.git` hangs until systemd's `TimeoutStartSec=900` (in `scripts/systemd/garden-triager@.service`) kills the git child, producing exactly the observed signature — a `Terminated` line followed by `FATAL: fetch failed for kriscendobot-agoric-3-proposals` and exit 1, which marks the unit Failed and triggers self-heal on every transient network/SSH blip.

Fix: bring line 117 in line with the rest of the fleet's bounded-fetch pattern and this script's own provisioning contract (see triager.sh header lines 63-65 and the provision path 96-104, which already treat an unreachable upstream as a clean exit-0 skip):
1. Wrap the fetch in `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` (the same helper vars used by `clone-keeper.sh:138`, `scheduler.sh:191`, `fork-watch-provisioner.sh:254`, `common.sh` `bounded_clone`), optionally with the same short backoff/retry loop.
2. On a transient/timeout failure (rc 124 from `timeout`, or a fetch that fails after retries), do NOT `die`. Instead `log` a WARN and `exit 0` so the next tick retries — no crash loop — and escalate only on persistence via the throttled `alert_maintainer` (dedup key e.g. `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`), mirroring the `triager-provision-failed-*` escalation at lines 96-104. Reserve a hard `die` for a genuinely non-transient fetch error if you can distinguish one, but the default for a network/SSH blip must be a clean skip.

Keep behavior identical on success. This is the last unbounded git fetch in the triager and the direct cause of the recurring `garden-triager@kriscendobot-agoric-3-proposals` Failed→restart flaps.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  worker_kind: gardener
  claimed_at: 2026-07-17T15:44:54Z
