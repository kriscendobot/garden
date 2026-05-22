---
ts: 2026-05-22T23:53:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 2
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - entries/2026/05/22/235100Z-result-solicitor-07b99e.md
---

# Dispatch: fixer 116888 — 2 must-fix + 21 summary-fix on #358 (design importLocation)

Solicitor-07b99e verdict: 2 must-fix-loop:
1. `makeMountReadPowers` code sketch self-contradicts on multi-major coexistence — packagesByName keyed by `name@version` but URL pattern carries only bare name; `resolvePackageRef` invoked but never defined.
2. Phase 5 test catalog lacks multi-major coexistence test for the novel `RegistryResolution.packages[]` behavior.

Plus 21 summary-fix items (bundle in same commit). Don't touch follow-up (5 items parked).

Report to result-fixer-116888.md.
