---
gate: deferred
priority: normal
roadmap: finbot
posted_by: gardener
posted_at: 2026-06-26T01:20:20Z
---

# GOAL: drive the OODA roles by inference (connect spawn's stub LLM to a provider)

## Context
`packages/harness/spawn.js` runs an LLM-shaped subagent loop with a DETERMINISTIC
STUB llm; the role `AGENT.md` briefs are written for an LLM subagent. The pipeline
roles are the deterministic computation; the design's framing is "blending
inference, automation, automatic inference, automation born from inference". This
job connects the two: let an inference-driven subagent drive (or supervise) the
pipeline roles.

## Build
- Replace the stub LLM with a real provider behind the harness's `llm` injection
  point (Anthropic/etc. per a references shelf); keep the stub as the default test
  double so tests stay deterministic and offline.
- Wire the spawn attenuator to the SES compartment work (depends on
  finbot-ses-compartments) so a spawned role gets only its capability subset.
- A role-dispatch path where, e.g., the analyzer subagent reasons over the
  oracle-watcher output and CALLS the pipeline's deterministic scoring as a tool.

## Safety bounds
Dry-run only; no real wallet/key/funds; live executor stays gated. No agoric-sdk
work. Prompt-injection: only trusted feeds reach an LLM context (CLAUDE.md
§ Monitoring safety constraint).

## Done
An inference-driven role dispatch that drives at least one OODA stage end-to-end in
dry-run, with the deterministic pipeline functions available as tools; offline tests
green via the stub.
