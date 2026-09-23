---
ts: 2026-05-23T00:13:01Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 356
    role: target
refs:
  - entries/2026/05/23/001000Z-result-solicitor-f4fcd9.md
---

# Dispatch: fixer cb859a — address 5 must-fix + 17 summary-fix on #356 (gateway packaging)

Solicitor-f4fcd9 verdict: 5 must-fix-loop:
1. gateway-package.md § Feature 1 complects Chat-hosting + resource-metering + payment-processor; ships ResourceLedger exo before trust model settled.
2. gateway-aws-attuned.md Nitro Enclave key custody inconsistent ephemeral-per-instance vs durable signing identity.
3. gateway-package.md § Feature 2 first-bind-wins virtual-host allocation race unsafe under multi-user threat model.
4. Dual-accept Git auth (HTTP Basic + Bearer "client chooses") inconsistent.
5. Two novice-bridge paragraphs needed.

Plus 17 summary-fix items.

Report to result-fixer-cb859a.md.
