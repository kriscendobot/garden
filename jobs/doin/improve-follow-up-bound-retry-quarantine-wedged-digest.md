In `scripts/jobs/follow-up.sh`, the handler-failure branch (`die "follow-up handler failed; leaving markers so the next tick retries"`) has no upper bound: a digest that keeps failing re-runs `claude -p` every 10 min forever (the 07:53–08:44 episode, ~6 ticks of 200–370 MB each plus repeated self-heal-responder invocations). Add a consecutive-failure counter keyed off the unchanged set of new tada-report rel-paths (store a small state file beside `SEEN`, e.g. `$GARDEN_STATE/follow-up/fail-count` holding `<count> <sha-of-new-list>`): increment on each failed tick whose pending set is unchanged, reset to 0 on success or when the pending set changes. After a threshold (default `${GARDEN_FOLLOWUP_MAX_RETRIES:-5}`), escalate once to the maintainer inbox with the digest + last failure signature, advance the seen-marker to quarantine those reports, and exit 0 — so a wedged digest stops burning ticks/CPU/API spend and stops re-triggering the self-heal responder. Keep the existing leave-marker-and-retry behavior below the threshold so genuinely transient (rate-limit/usage-cap) windows still self-resolve.

---
claim:
  host: endolinbot
  gardener: 50
  claimed_at: 2026-06-27T09:06:06Z
