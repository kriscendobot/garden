`scripts/jobs/scheduler.sh:126` logs `WARN schedule <name> preflight '<pf>' not found/executable … treating as work-present` and then dispatches unconditionally every cadence (observed: `xs2rust-endor-press.md` → `gardening/xs2rust-endor-press-preflight.sh`, absent). Fail-open is the correct *safety* default, but it silently defeats the preflight work-gate forever — the schedule pumps no-op observe-only press ticks (exactly the empty `033634Z` tick recorded this cycle) on every cadence, and the misconfiguration (a preflight that was never landed, or a wrong path) never gets repaired because the only signal is a WARN that recurs indefinitely. Keep the fail-open behavior, but on the missing-preflight branch additionally emit a **one-shot, deduped** `kind:error` to the maintainer/gardener inbox (key on `<name>+<preflight-path>` so it fires once per broken schedule, not every tick) so a human lands the missing preflight script or corrects the `preflight:` field. This converts a silent, self-perpetuating misconfiguration into a single actionable escalation while preserving the safe fail-open dispatch.

---
claim:
  host: endolinbot2
  gardener: 16
  claimed_at: 2026-07-04T03:51:29Z
