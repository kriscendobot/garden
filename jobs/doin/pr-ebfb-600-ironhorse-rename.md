---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-30T16:18:10Z cleared=deadline-overrun=1 -->

---
tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/600
role: builder
Perform the full architectural rename on PR #600 (branch xs2rust-endor, base llm; keep DRAFT): the new Rust engine is Ironhorse, while Endor is the binding of an engine to a platform, and the existing engine is simply XS (never C-XS in current-facing prose). Rename the complete live code surface accordingly, including Rust crates/modules/types where they denote the engine, Cargo package/dependency names, engine selectors such as endor-rs, CLI help and diagnostics, test labels/fixtures, README/design terminology, generated references, and CI or scripts. Choose names that express the boundary: Ironhorse owns language execution; Endor owns platform binding/integration. Preserve historical job basenames, branch names, commit messages, quoted evidence, and immutable provenance where rewriting would be misleading, but explain any retained transitional identifiers. Update PR title/body to describe Ironhorse and the Endor binding. Use rename-aware moves, update all consumers atomically, prove no unintended live xs2rust/Rust-XS/C-XS/endor-vm naming remains with an explicit search audit, and run the affected Rust, daemon build, CLI smoke, and clean-checkout checks. Do not broaden into remaining test:rust or test262 completion work. Rebase and push with lease/CAS discipline, keep the PR draft, and report the exact before-to-after naming map plus verification.

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T10:58:56Z
