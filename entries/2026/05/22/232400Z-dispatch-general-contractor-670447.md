---
ts: 2026-05-22T23:24:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 317
    role: target
refs:
  - entries/2026/05/22/232226Z-result-solicitor-b8c5c0.md
---

# Dispatch: fixer 670447 — address solicitor's 6 must-fix on #317 (familiar-telemetry design)

Solicitor-381b6a (review COMMENTED 2026-05-22T23:22:17Z) verdict: 6 must-fix-loop, 9 summary-fix, 2 follow-up, 3 acknowledge.

Six must-fix-loop items (from result entry):
1. Capability shape: missing conventional `help(): string` on `DiagnosticsUploader` (sibling endoclaw-network-fetch.md template has it).
2. Capability shape: `preview` returns no `previewToken` yet `submit` requires one; handshake unspecified.
3. Pipeline 1 vs Storage and processing locality: contradictory paths for `familiar.log`.
4. Pipeline 1: bundle-assembler access to `endo.log` across Electron-shell/daemon process boundary unspecified.
5. Privacy guarantees ("preview is the contract") doesn't cover endpoint URL.
6. Capability shape `DiagnosticsBundle.kind`: `'error-log'` enum value dead under pipeline 1.

Design-only PR — fixer edits the `designs/familiar-telemetry.md` file (or splits across siblings). Address all 6 must-fix + 9 summary-fix bundle.

After return, **solicitor re-runs** (design-work stays with solicitor across rounds; not justice).

Report to result-fixer-670447.md.
