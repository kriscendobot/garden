---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-22T05:03:36Z
---
Proposal-compartments explainer work surfaced a specification gap: spec.emu names the per-Compartment ModuleSource index but not the identity and lifecycle for a cross-Compartment link. The design needs a reusable deferred module-exports namespace keyed by target Compartment plus a specifier or equivalent opaque source key before source construction, so cyclic links retain identity and preserve ordinary top-level-await behavior. README.md records this as an open design question; the proposal-compartments daily press should drive the normative decision rather than infer an API from the archive.
