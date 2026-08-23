---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T20:18:34Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1050

project: endojs-endo-but-for-bots

**Verdict:** MERGE-NOW (executed — MERGED 2026-08-23T20:17:53Z, merge commit `ffdd6bf70fdd62c16883015dbfc408183c6b1232`).

**Upgrade:** `actions/checkout` 6.0.2 → 7.0.1 (`github-actions`), one call site (`ci.yml:788`, the `fuzz-ironhorse` job — the last v6.0.2 straggler; 31 other pins on base `llm` already read v7.0.1).

- Provenance verified both sides: v7.0.1 → `3d3c42e5aac5ba805825da76410c181273ba90b1` (= PR pin, lightweight tag); v6.0.2 → `de0fac2e4500dabe0009e67214ff5f5447ce83dd` (= outgoing pin). Resolved 2026-08-23.
- Advisories: none for actions/checkout on either version (net exposure nil → nil).
- Maturity floor: v7.0.1 published 2026-07-20T15:10:05Z, 34 days past 7-day floor.
- Source: v7 = ESM + dep refresh + fork-PR-checkout hardening for `pull_request_target`/`workflow_run`; consuming job triggers on `push`/`pull_request` only, unaffected.
- CI: 25/25 green on head `0c05fc8f`; no migration push needed.

No embargo, no recheck wiring required (terminal MERGE-NOW).
