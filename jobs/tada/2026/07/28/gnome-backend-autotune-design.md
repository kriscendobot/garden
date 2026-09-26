Inbox empty. Work complete.

---

**Job: design `designs/gnome-backend-verified-autotune.md` — done.**

**What I did.** Grounded the design in the real fleet code (`gardener-scaler.sh`, `set-workers.sh`, `install-units.sh scale`, the worker-kind registry in `common.sh`, and every existing backend preflight), then wrote and pushed the design doc to `main2` (commits `1be5450de3` + `7e57621dba`, confirmed on `origin/main2`).

**What the design covers (per the spec's six asks):**
- **No-LLM per-backend probe** — one `worker_backend_probe <kind>` dispatching on the registry `provider`, **reusing in-tree preflights verbatim**: `codex login status` (cleric), `codex_local_endpoint_ready`/`_model_present` (hermit), `kimi_provider_preflight` (mystic), `fireworks_provider_preflight` (fireworker). Only the **Claude** probe (`claude_auth_ok`) is new (CLI + `ANTHROPIC_API_KEY`/`.claude/.credentials.json`), since the gardener handler today checks only PATH. Each probe is `timeout`-bounded; a `GARDEN_PROBE_LIVE=1` mode bypasses the codex per-boot auth marker so a mid-boot logout is caught.
- **Effective vs declared** — journal `hosts/<host>` stays owner-declared; the scaler computes a per-host **runtime** effective count (local `$GARDEN_STATE`, no journal write) and passes it to `scale`. Hysteresis: ramp-up after 1 confirmed pass, ramp-down after 2 confirmed fails (protects against blips, since scale-0 defers mid-job workers). **Decision: sustained failure caps at runtime only, never down-declares** (rationale given: preserves intent, avoids journal thrash, enables auto-restore).
- **Provisioning gate** — `set-workers` refuses a non-gardener `n>0` until the kind's probe passes once (with `GARDEN_FORCE_DECLARE=1` override); gardener is exempt (baseline floor). Operator flow spelled out; ps23 (Claude-only) simply cannot declare clerics/hermits/mystics.
- **Auto-tune ramp** — pools seed at effective 0, ramp to declared on confirmed auth, drop back on loss; cold-start ramps automatically once the human finishes the device-login.
- **Leader/follower + invariants** — scaler is already per-host and does no journal write, so owning-host-only-writes holds; the gardeners≥1 floor stays on **declared** while **effective** may be 0 (the "no-Claude gnome sits at 0" case).
- **Observability** — log every transition; one deduped `alert_maintainer` when a declared kind is capped-degraded ~10 min; optional local status sidecar.
- Added **§ 0** positioning the design against the just-landed `worker_health_gate` (per-claim software-only backstop) — this layers the credential + effective-count/provisioning dimensions on top, no changes to it.

**Follow-ups (for a future build, not this job):** implement across `common.sh`, `codex-provider-common.sh`, `gardener-scaler.sh`, `set-workers.sh`, docs, and tests per the § 7 surface table; re-verify `codex login status` field surface on a host with `codex` installed (the CLI is server-resolved/living, per the handler's own TODO).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gnome-backend-autotune-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (1880617 cached reads)
- Output: 23350 tokens
- Cost: $2.3018834999999997
- Wall-clock: 396s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
