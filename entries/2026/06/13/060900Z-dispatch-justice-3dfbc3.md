---
ts: 2026-06-13T06:09:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: justice
dispatch_root: /home/kris/dispatches/justice--3dfbc3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697671329
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697694059
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/060622Z-result-fixer-6beb46.md
---

# dispatch: justice — re-run on #438 after Gap 1 + Gap 2 routing

Continuing the gamut on #438 after fixer `6beb46` applied
the panel-recommended routes per kriskowal directive
`4697671329`. Three new commits on the branch
(`a619bea05` → `4b2055c22`).

**Notable: the cascade was heterogeneous**, not single-root-
cause as the panel predicted. The fixer cleared 3 of 39
packages with the harden fix; 36 residuals remain with
diverse JSDoc precision issues. Gap 2 pin to
`7.0.0-dev.20260612.1` works — `typecheck-all` now
completes (1 unrelated TS1003 in ocapn).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#438`, DRAFT, base
  `master-4a04d07`, head `chore/tsgo-lint-types` at
  `4b2055c22...`. FETCH AND CHECKOUT before starting.

## Task

You are the **justice** (panel re-run). Discipline per
`garden/skills/panel-review/SKILL.md`. Compose your jury
per `garden/roles/justice/AGENT.md`.

Validate:

1. **Gap 1 harden fix** at commit `842dcae20`. The fix
   converted `isPrimitive` to a function-declaration shape;
   is that the correct shape for the predicate (vs the
   arrow-with-`@type` shape that didn't work)?
2. **Gap 2 tsgo pin** at commit `0202cefce` (+ lockfile
   `4b2055c22`). The pin forwards to
   `7.0.0-dev.20260612.1`. Is that the right shape?
3. **Cascade residual call**: with 36 of 39 packages still
   failing, the panel's "single root cause" framing was
   off. Decide:
   - **Acknowledge as documented residual** (panel option
     (b) — staged exclusion list). Maintainer has
     already routed (a); the partial result is what (a)
     could clear. The residuals are a follow-up.
   - **Re-escalate `next: fixer`** to do per-package
     residual fixes in this PR. Substantial scope.
   - **Re-escalate `next: liaison`** if the maintainer
     should re-route.
4. **CI shape**: `typecheck-all` now passes (1 unrelated
   TS1003); `typecheck-packages` should now have ~36
   failures across the listed packages. Verify.
5. **No regression** in any previously-clean area.

If clean enough to terminate (with acknowledged residual):
- Un-draft via `gh pr ready 438`.
- Re-request review from kriskowal.

If `next: fixer` is the call: don't un-draft, escalate with
specific scope.

## Authorizations

- **Compose jurors** via Agent tool (fall back to in-band).
- **Top-level verdict comment** on PR #438.
- **`gh pr ready 438`** ONLY on clean termination.
- **Re-request review** on clean termination.
- Do NOT push commits.

## Out of scope

- Do NOT touch source.
- Do NOT chase the 36 residuals yourself (verdict is the
  call).

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Panel composition.
- Per-juror verdict.
- Per-gap validation.
- Cascade residual disposition + recommendation.
- CI state.
- Consolidated verdict.
- PR comment URL.
- Termination state.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
