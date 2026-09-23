The design has landed on `origin/main2`. Job complete.

## Completion report — `design-quota-throttle`

**Status: clean start re-derived** — no prior attempt had committed anything (no `designs/quota-throttle.md` in history, no PR, nothing in the journal), so I produced the design from scratch.

**Deliverable:** `designs/quota-throttle.md`, committed directly to `main2` as `2616436b34` (garden-self change → no PR, per CLAUDE.md § Conventions and the job spec).

**What the design says** (grounded in an audit of the existing fleet, accept/reject/extend each):
- **Detection reuses everything, adds no parsing.** `common.sh` already classifies caps (`is_provider_quota_text`, `provider_quota_limit_type` → session/usage/weekly/5-hour) and captures the reset as a future epoch (`provider_quota_reset_epoch`). The `gardener.sh` cap branch already holds `quota_type`+`quota_reset_epoch` in hand — the design hangs a host-level reaction off that same point (react at first failure, not after 5 doom cycles).
- **Throttle mechanism = a self-expiring, per-(host,provider) journal marker** modeled on `brake-foreman.sh`/`foreman_braked` (journal-backed, existence-is-the-signal, fails-safe). A claim-time guard (`provider_quota_throttled`, parallel to the existing `fleet_draining` guard at `gardener.sh:283`) makes capped-provider workers idle immediately — no unit churn, no count to remember.
- **Restore needs no scheduled job.** The marker carries its own reset epoch; the `garden-scaler` reconcile applies an effective cap while unexpired and lifts it (deletes the marker, pool returns to the *declared* count) when `now ≥ reset_epoch`. Session vs weekly is handled by the captured epoch itself — one code path, right wall-clock time for each. I explicitly weighed and rejected `set-schedule-once.sh` / delayed `send-host-op.sh` as primary (they force mutating the declared count, reintroducing the toil being automated).
- **Provider tiers all named:** Claude+Codex get the full path; **Ollama (`hermit`, provider `local`) is an explicit exclusion** (it's the floor that keeps claiming); **manually-funded arms** (kimi/fireworks/paid codex) are split off by the existing discriminator — a cap match with *no parseable reset epoch* → maintainer inbox, no auto-restore.
- **Interactions addressed:** orthogonal to kimi-fallback (per-job model reroute vs. host pool sizing; no shared signal), models but doesn't depend on foreman-brake, and *reduces* how often the reaper's per-job backoff / outage doom-pause fire.

**Verification:** the one mermaid diagram parses (`flowchart-v2 OK` via parse-only validator). Pushed to `main2` first try (rebase-CAS), confirmed present on `origin/main2`.

**Open questions flagged for the build** (not blockers to the design): Codex CLI cap wording must be confirmed and, if different, added to the shared `GARDEN_PROVIDER_QUOTA_CAP_SIGNATURES` fragment (today only Claude-Code wording + a Fireworks 429/503 retry class are recognized — no Codex reset-time capture exists); confirm the reconciler folds cleanly into `garden-scaler`; optional deeper floor for weekly vs session.

**Follow-up:** a `build-quota-throttle` implementation job follows after maintainer review of this design — not posted by this job (design-only, per the spec).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-quota-throttle.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s) (5 unmetered)
- Input: 44 tokens (2050765 cached reads)
- Output: 26795 tokens
- Cost: $4.4852929999999995 (5 engagement(s) unpriced)
- Wall-clock: 432s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
