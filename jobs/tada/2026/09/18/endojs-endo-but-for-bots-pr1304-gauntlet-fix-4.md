CI is GREEN — all 32 checks passed, 0 failed (rc 0). The work was already complete when I claimed this requeue.

## Completion report

**Job: gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1304**

I claimed this fix-4 job and discovered a prior claimant of the same job had already applied all of the panel-4 must-fix items and pushed them as review-feedback follow-up commit `c0a8d38146` (the current PR head, `origin/bot/build/1125-readonly-directory-attenuation`, pushed ~20 min before I claimed).

I verified that commit against the panel-4 verdict (the 86 KB `kriscendobot` COMMENTED review at 2026-09-18T05:23:18Z, the request-changes aggregate the panel-4 stage posted). It correctly covers every blocking must-fix item the panel raised:

- **onCancel liveness-gate race** (assessor, engine-realist — must-fix): `context.js` now fires a late-registered `onCancel` hook immediately (on a microtask) instead of dropping it when the context is already canceled — closing the window where cancellation during the pre-registration `await` could latch the read-only view's gate open forever. Covers all three `readOnly()` sites (directory, mailHub, messageHub) at the primitive, plus a new/updated `context.test.js` pinning the fire-on-microtask behavior and the throwing-late-hook case (engine-realist regression-evidence gap).
- **Changeset bump level** (packager, migrator, changeset-auditor, releaser — unanimous must-fix): `@endo/daemon` bumped `minor → major`, since adding an unconditional `readOnly` to the exported `DirectoryInterface` guard breaks out-of-tree `makeExo` consumers at construction.
- **mailHub/messageHub shallow-attenuation leak** (locksmith — must-fix): `manager.js` now documents that `readOnly()` lookup/maybeLookup can surface full-strength sender-supplied capabilities embedded in message payloads (`@slots`, `@value`, package-message names).
- **British→American spellings** (orthographer — request-changes): `canceled`/`behavioral` normalized in prose/comments/test titles; the change-owned `cancelled` identifier left as-is.
- **Changeset audience reorder** (releaser summary-fix): helpdown note reordered to foreground the observable effect.

Since the fixes were already applied and pushed, I did not re-apply. I ran the bounded CI watch (`GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh … --no-merge`): it reached terminal at **CI GREEN, 32/32 checks, 0 failed, rc 0** (the 22.x/24.x ubuntu+macos `test` jobs that were pending on claim all passed — no repeat of the ws-relay/better-sqlite3 flakes).

**Non-blocking follow-ups (not applied — summary-fix / should-fix, out of this stage's must-fix scope):** scribe flagged missing top-level completion-summary comments for round-2 and the maintainer-nit commit; integrator flagged commit-history churn (eval-formula create→delete cycle) as a should-fix reset/redistribute. None affect CI or merge-readiness.

The stray `packages/floot/package.json` modification in the worktree is a yarn-install unicode-normalization artifact, unrelated to the PR — left uncommitted, not pushed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 176 tokens (8821388 cached reads)
- Output: 44875 tokens
- Cost: $7.800952000000002
- Wall-clock: 1825s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
