---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T09:28:15Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land on main2 (no PR — CLAUDE.md
§ Conventions).

# Build: the sysop local-model provisioning op

Implement the design produced by `design-sysop-local-model-op`. **Read that job's
`jobs/tada/` report and the landed design document in `designs/` before writing code** —
the design settles the async model, the trust gate, and the guards, and this job
implements what it decided rather than re-deciding it.

## Scope

- Extend `scripts/jobs/sysop.sh`'s closed op vocabulary with the designed op.
- Extend `scripts/jobs/send-host-op.sh` so an operator can address it to a named host.
- Preserve every existing sysop property: deterministic, no `claude`, no job claims,
  runs on every host, not leader-gated, still ticks under drain, host-scoped by
  construction, idempotent, logged to `sysop-log/<GARDEN>/<msgid>.md`, acked.
- Read the model to provision from the **corrected** `model-tier-inventory.tsv` `local`
  row. Do NOT hardcode a tag. Job `garden-heal-local-qwen36-routing` replaces the phantom
  `qwen3:0.6b` with the real `qwen3.6` tag; if that fix has not yet landed when you start,
  say so in your report and do not paper over it by inlining a literal.

## Verify

Hermetic tests for the op's state machine including the already-present no-op path, the
insufficient-disk refusal, the ollama-absent path, and the trust-gate refusal. Shell
syntax on every edited script. Do NOT trigger a real 22 GB pull from a test.

## Report

Name the landed main2 revision and the exact command an operator runs to provision a
named host, e.g. the `send-host-op.sh <GARDEN> op=... ` invocation for
`endolin-garden-ece02cb4`. State what still needs a human.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T09:32:27Z
