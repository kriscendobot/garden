The work is complete. Both journal writes are gated, syntax verified, logic tested, and the change is pushed to `main2`.

## Completion report

**What the job asked:** `gardener.sh` wrote a `kind:progress` entry to the shared journal on *every* exit-0-unsatisfying requeue cycle (and its sibling transient-outage path), producing 20+ near-identical "handler exited 0 … requeueing … (no escalation)" digests for the same handful of PRs — the silent-until-error violation the mentor brief flags. Escalation is already owned by the reaper (poison at `GARDEN_REAP_POISON_THRESHOLD`, default 5), so the per-cycle journal notes are pure duplication of routine self-healing.

**What I changed** (`scripts/jobs/gardener.sh`, one commit, pushed to `main2` as `8728deb3a`):
- **Exit-0-unsatisfying branch:** kept the local `log` (stderr/systemd), gated the shared-journal write behind `cycle >= poison_threshold - 1`. The reaper computes `count = cycle+1` and poisons at `count >= threshold`, so `threshold-1` is the last requeue before poison — the note now fires exactly once, right as the job is about to escalate, instead of every cycle.
- **Transient-outage branch (rc=124 and the other signal/empty/transient-signature requeues):** same gate.
- Both read `GARDEN_REAP_POISON_THRESHOLD` with a `:-5` default and a non-integer guard (falls back to 5), so a missing/misconfigured env value can't crash the loop or over-fire.

**Interaction I had to preserve (not in the job spec, but load-bearing):** the transient note is the *input* to the elapsed-constancy early-escalation check further down — `prior_transient_elapsed_series` greps these exact notes out of the journal to reconstruct the per-cycle elapsed series. Blindly gating them would have silently disabled that (default-on) early-escalation. So the transient gate has an OR clause that still writes the note for exactly the subset the constancy check watches (a claude-signature/bare claude failure *with* output — not an external kill, wall-timeout, or empty blip). The routine noise the task complains about (deploy-drain SIGTERMs, shepherd rc=124 wall-timeouts, empty-output blips) is what gets quieted; none of it feeds a downstream check.

**Untouched (correctly):** the deadline-overrun note and the elapsed-constancy `kind:error` escalation are distinct, bounded escalation signals (overrun threshold 2), not routine progress, so they still fire on their own cadence.

**Verification:** `bash -n` passes; the threshold arithmetic was table-tested across cycles 0–5 for thresholds 5, empty, non-integer, and 1 (degenerate) — all coherent. Net effect: the shared journal shows the escalation, not each self-healing retry.

**Follow-ups:** none required. One latent design note for the maintainer: the elapsed-constancy check reconstructs its input from journal progress notes; a cleaner long-term shape would give it a dedicated per-claim elapsed store so it doesn't depend on progress-note verbosity at all — but that's a larger refactor deliberately out of scope here.
