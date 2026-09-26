CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** FIX round 2 for endojs/endo-but-for-bots PR #1098 (`design(endo-claude): fold sibling provider-adapter lessons into residuals`), a design-doc PR editing `designs/endo-claude.md`.

**Panel round-2 verdict applied (two seats request-changes: skeptic, decomplector; plus should-fixes from ergonomist, critic, novice, copyeditor, pedant):**

1. **Unverifiable "peer provider adapter" citation (skeptic, critic, novice).** Dropped the anonymized, explicitly-unlinkable precedent entirely and restated each of its five load-bearing uses as the design's own first-principles reasoning: the argv/`E2BIG` mitigation, the fresh-process rule, the fail-open-onto-operator-credential framing, the multi-provider-router rejection, and the per-holder isolation caveat.
2. **Misattributed confinement mechanism (decomplector).** Rewrote the fresh-process paragraph to attribute cross-guest reuse prevention to fresh-process-per-call (the process is never reused, full stop), naming `sessionTag` as orthogonal credential/cancellation bookkeeping that does not itself prevent reuse.
3. **Argv-length invariant untracked (skeptic, critic, ergonomist, novice).** Mapped the spawn-refusal into the result taxonomy (a pre-spawn harness-invariant throw, consistent with the existing throw-vs-return rule at DD8), added a matching property-test checklist entry (argv-length ceiling), and promoted the section to its own `###` heading.
4. **Overclaimed test coverage (skeptic).** Softened the entitlement rationale so it no longer claims the live test structurally verifies cross-guest credential isolation; it now states that property is the still-open DD7 residual and the metering-invisibility hazard is a reason to close it, not evidence it is closed.
5. **Prose (copyeditor, pedant).** Coined `fail-open-onto-operator-credential` as one consistent label matching its later cross-references; removed the semicolon splice in the multi-provider aside; fixed the "genuine precedent" phrasing. Kept all added prose em-dash-free per repo style (`skills/em-dash-style`).

**Changed:** `designs/endo-claude.md`, one commit `70a7659d1`, pushed via `safe-push-pr-head.sh` (advance mode) to `origin/design/endo-claude-sibling-notes`.

**CI:** all 5 checks GREEN (lint, build, browser-tests, zizmor, test); `ci-wait-merge.sh` returned rc 0 (`--no-merge`).

**Notes:** Session was reaped mid-CI-watch and resumed; the fix was already pushed, CI completed green during the gap. No panel re-run performed (the driver re-posts panel-3). No follow-ups.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1098-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 200 tokens (9516336 cached reads)
- Output: 40446 tokens
- Cost: $6.906586000000001
- Wall-clock: 751s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
