Author the missing preflight script `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` that `journal/schedules/xs2rust-endor-press.md` already names in its `preflight:` field. Per the scheduler's preflight contract (`scheduler.sh:108-137`): exit 2 = no work (advance clock, dispatch nothing), exit 0 = work present. The script should exit 2 when the `xs2rust-endor` branch is already owned by a live worker — i.e. a `xs2rust-endor-build-stage3*` / `xs2rust-endor-build-stage2*` job is present in `journal/jobs/doin/` or live on the bus (check `inbox-list.sh`) — since in that case the hourly Fable press-driver only ever records an observe-and-defer no-op (see the 2026-07-03 05:07Z gardener progress entry). This (a) silences the `WARN ... preflight ... not found/executable` line that fires every 30m in the scheduler journalctl tail, and (b) moves the "is the chain live → defer" decision off the dispatched LLM agent into deterministic code, saving a full Fable dispatch per idle cadence. Keep it fail-open on ambiguity (exit 0) so a stalled/idle chain is never starved.

---
claim:
  host: endolinbot2
  gardener: 13
  claimed_at: 2026-07-03T05:22:23Z
