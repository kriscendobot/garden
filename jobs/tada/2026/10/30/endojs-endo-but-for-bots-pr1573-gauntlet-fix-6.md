---
orchestration-failed: true
---
orchestration-failed: true

# Fix round 6 for endojs/endo-but-for-bots#1573: fixes pushed, CI red on one flaky leg

I applied the must-fix items from panel-6 (review 5713414212) and pushed them to the PR head, now `a70129db64`. CI on that head came back red on one leg, `test (22.x, macos-15)`, so this stage failed and I am not reporting `fix=done`.

The failing test is `@endo/floot` › `factory-system-prompt › createSession never infers a hosted backend from a colon in modelId`, which hit "Test timeout exceeded". The whole leg ran about 56 minutes. I think this is the known floot macOS flake and not caused by this round:
- this round changed only docs and comments;
- it did not touch the floot package;
- every other check passed, including both `ubuntu-latest` test legs;
- the previous head `10519bbc8f` was fully green.

I queued a rerun of the failed leg with `gh run rerun 41069130921 --failed`, so the next stage should find a fresh result.

## What changed (2 commits, pushed with `safe-push-pr-head.sh`)
- **`f94268482b` `docs(hosted-agent)`:**
  - **archivist must-fix:** the `types.ts` header called every record "non-secret". It now says key bytes never enter records or the journal, that `StableIds.grantId` is redeemable read authority, and that registry state, including `inspect()` output, is confidential.
  - **README:** added an "Inference provider registry" section to `packages/hosted-agent/README.md` (archivist 3, integrator 2).
  - **Comment cuts:** removed the comment before a `continue` and the two type-alias comments that only repeated the code (pruner 2 and 4).
- **`a70129db64` `docs(daemon)`:** the `provideBase64` JSDoc pointed at the changeset, which a release deletes. The retry contract itself is now in the JSDoc: resume behavior, `IDEMPOTENCY_CONFLICT`, `NAME_CONFLICT`, what `bytesBase64: undefined` means and when it returns `provisioning`, and that the first-written bytes are kept (archivist 2).
- **PR body:** cut the Compatibility, Upgrade, Security and `createBase64` rationale sections to about one sentence each (pruner 1). The per-phase ledger rows stay because the phase-evidence gate reads one row per phase.
- **Reply comment** (issuecomment-6524804289) answers the other must-fixes without code changes:
  - **integrator 1:** the governing design is #1543, which adds its own `designs/README.md` entry.
  - **decomplector 1:** a check on the name followed by `createBase64` is not enough. `createBase64` binds the pet name last, in a separate store, so a crash just before that step leaves an unnamed secret that still holds a live grant. A retry would then mint a second secret.
  - **Declined, with reasons:** the structural should-fix items are left for the maintainer, and there is no hosted-agent changeset because that package is private.

## Checks
- `yarn lint:types` passes in `packages/daemon` and `packages/hosted-agent`, and prettier is clean.
- `ci-wait-merge` returned rc 3 (red), after polling in chunks for the full 60-minute window.

## Follow-up for the driver or maintainer
- If the rerun of the macOS leg goes green, the PR is ready for panel-7.
- decomplector 1 is a real design question. If the maintainer wants `createBase64` to bind the name in the same atomic step instead of keeping `provideBase64`, that is a design change, not a fix-round change.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2391702 cached reads)
- Output: 13094 tokens
- Cost: $1.3912284
- Wall-clock: 3823s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
