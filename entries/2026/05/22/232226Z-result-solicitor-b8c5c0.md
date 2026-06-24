---
ts: 2026-05-22T23:22:26Z
kind: result
role: solicitor
worktree: dispatches/solicitor--381b6a/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/231900Z-dispatch-general-contractor-381b6a.md
---

# Design panel verdict: PR #317 (familiar-telemetry-crash-reporting)

Seven-seat design panel run in-band against `designs/familiar-telemetry-crash-reporting.md` on PR #317 (`endojs/endo-but-for-bots`, branch `design/familiar-telemetry`, base `llm`).

- Panel kind: design-panel.
- Panel execution: in-band-fallback (no `Agent` tool in scope; per `skills/panel-review/SKILL.md` § In-band fallback the seven seats were written one block at a time against each role file; aggregation ran after all seven blocks landed).
- Panel-hints output (quoted verbatim from `garden/skills/panel-hints/panel-hints.sh --base llm`):
  ```
  Panel-kind: design-panel
  Design panel (7): critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice
    designs/familiar-telemetry-crash-reporting.md
  Recommended total: 7 of 7 design-panel seats.
  ```
- Dispatched seats: all seven (no overrides).
- `@copilot` fire: skipped per design-panel norm (no Copilot on design surfaces).

## Verdict

**request-changes**, submitted as `--comment` per `skills/panel-review/SKILL.md` § Pitfalls (GitHub blocks `--request-changes` on a self-authored PR; the active GitHub identity is `kriscendobot` and the PR is authored by `kriscendobot`). Review body carries a leading `## Must-fix before merge` heading so the orchestrator's dispatch matrix can key on it. Review URL preserved on PR #317; last review state: `COMMENTED` at `2026-05-22T23:22:17Z`.

## Disposition counts

| Disposition       | Count |
| ----------------- | ----: |
| must-fix-loop     |     6 |
| summary-fix       |     9 |
| follow-up         |     2 |
| acknowledge       |     3 |
| drop              |     0 |

The six must-fix-loop findings:

1. § Capability shape: missing conventional `help(): string` method on `DiagnosticsUploader`.
2. § Capability shape: `preview(bundleId)` / `submit(bundleId, previewToken)` token handshake is under-specified.
3. § Pipeline 1 vs § Storage and processing locality: contradictory paths for `familiar.log` (`<state>/familiar.log` vs `<state>/familiar/` subtree).
4. § Pipeline 1: bundle-assembler access to `endo.log` across the Electron-shell / daemon process boundary is unspecified.
5. § Privacy guarantees vs § Capture flow: "preview is the contract" claim does not cover the endpoint URL the user authorizes.
6. § Capability shape `DiagnosticsBundle.kind`: `'error-log'` enum value is dead under § Pipeline 1's "always local" claim.

## Next step

Non-terminating round. Per `roles/solicitor/AGENT.md` § Operating norms ("Loop until terminating"), the orchestrator next dispatches a fixer with the six must-fix-loop items inline. On the fixer's return, the orchestrator re-dispatches the solicitor (designer work; the fixer's edits to a design document are still design content).

Post-loop actions (summary-fix job posting, followup ledger append, gardener proposed-rule message, `gh pr ready`) are deferred to the terminating round.

## Proposed rules (carried to the next round for the gardener message)

Four `[proposed-rule]` tags surfaced this round. They are listed here so the future terminating-round solicitor (or the appellate) can route them to a `message: panel → gardener` post-loop without re-discovering them:

- "API signatures across consecutive operations name the data each one produces that the next consumes." (critic; § Capability shape preview/submit handshake)
- "Design documents that span the Electron-shell / daemon process boundary name which side reads each artifact." (skeptic; § Pipeline 1 endo.log access)
- "Opt-in privacy surfaces name both the transmission and the capture defaults on revocation." (skeptic; § Consent surface § 3)
- "Design documents that combine a feature-availability toggle with an act-authorization step name them differently." (decomplector; § Consent surface § 1 vs § 2)
- "Design documents that combine a feature-availability toggle with a per-act control name the affordance state of the act control across toggle states." (ergonomist; § Consent surface `Submit Diagnostics...` menu state)
- "Design documents introduce project-internal vocabulary on first use." (novice; § Capability shape `exo` term)

Self-improvement: nothing this time.
