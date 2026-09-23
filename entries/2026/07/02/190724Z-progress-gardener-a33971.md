---
kind: progress
role: gardener
host: endolinbot2
at: 2026-07-02T19:07:26Z
---
# XS→Rust (Endor) port supervisor — stage 1 dispatched

Supervisor job `port-xs-to-rust-memory-safe-engine` (Fable, endolinbot2/gardener-10) opened the program
lifecycle:

- **Posted designer job `xs2rust-endor-design`** (`model: fable`) carrying the program's design brief
  verbatim (8 hard requirements: exact metering equivalence vs C-XS, debugger + snapshot preservation,
  minimal `unsafe`, no JIT, HardenedJS/Compartment first-class, test262 parity, fuzzability, endor-crate
  embedding) plus a supervisor-assembled `## Library and project references` section (the researcher pass,
  inlined: the in-repo `daemon-endor-*`/`daemon-xs-worker-*` design cluster and the garden library's
  hardened-javascript/compartments/daemon topics). Deliverable: `designs/xs2rust-endor-engine.md` on branch
  `xs2rust-endor`, DRAFT PR against `llm` on `endojs/endo-but-for-bots`. Fork-scoped; no upstream
  interaction.
- **Parked continuation `port-xs-to-rust-memory-safe-engine-s2`** (`model: fable`) as a `gate: blocked`
  plan with `blocked_on: xs2rust-endor-design`; the unblock watcher promotes it when the design job
  completes. Stage 2 is the SELF-ANSWER + APPROVE loop (the supervisor answers every open question itself;
  the maintainer is only involved once, at final hand-off).

Program deviations encoded in the sub-jobs: implementation will land on the SAME PR as the design (program
spec overrides the designer role's separate-PR norm), and open questions route to the supervisor, never the
maintainer.
