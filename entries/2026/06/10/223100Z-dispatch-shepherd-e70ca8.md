---
ts: 2026-06-10T22:31:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--e70ca8
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4675167395
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4675265878
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/222951Z-result-weaver-d3a4e9.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/181800Z-result-fixer-d6af77.md
---

# dispatch: shepherd — drive PR #5 CI to green after upstream-master rebase

Follow-on dispatch after weaver `d3a4e9` rebased
`mirror/12527-endo-sync-refresh` from `master-daf7a86` onto
`master-57c6564` (Agoric upstream master tip `57c65644e1`, 71
commits forward). Resolved one substantive conflict (PSM
removal cross-cut from upstream PR #11866); local
`yarn install --immutable` + `yarn build` clean. 13 CI checks
firing at handoff.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `02782246bb` (post-rebase, full SHA unspecified by weaver
  result — use `gh pr view 5 --json headRefOid` to confirm).
- **CI status**: 13 in-progress checks at weaver handoff.

## Task

In your `project/` worktree on the rebased head:

1. **Confirm the actual head SHA**:
   `gh pr view 5 --repo kriscendobot/agoric-sdk --json
   headRefOid`. The brief lists `02782246bb` as the prefix; use
   the full 40-char SHA.
2. **Watch CI to convergence** per
   `garden/skills/pr-ci-watch/SKILL.md`.
3. **Classify each terminal-state failure**:
   - **Flake-shaped** (timeout, runner died, network):
     `gh run rerun --failed` up to 2x.
   - **Environment-acknowledge** for the MAINTAINERS-documented
     `test-dapp (node-new)` expected-fail (re-verify it reaches
     the dapp-test logic, not an install gate).
   - **Substance, fix-in-scope**: small in-shepherd-budget edit;
     append-push.
   - **Substance, escalate** `next: fixer` if out-of-scope.
4. **The prior fixer d6af77's diagnosis** is the most relevant
   prior art: the `runnerChain` cascade was rooted in a hidden
   ava version downgrade. The weaver's rebase onto current
   upstream master picks up upstream's ava state directly, so
   the ava-restore commit `cf798d660e` may now be either:
   - a no-op (upstream caught up), OR
   - subtly different (upstream chose different versions).
   Verify if `runnerChain` failures resurface.
5. **Post a top-level convergence summary** on PR #5 listing
   per-check terminal state + classifications + any shepherd
   commits. End with: "CI in shape for review" if all-green
   plus the expected-fail acknowledge OR "Escalating
   `next: fixer` for <reason>".
6. **Reply on kriskowal's directive comment** (`4675167395`)
   with one-line convergence summary.

## Authorizations (per-action, forwarded by liaison)

- **Re-run failed CI jobs** up to 2x.
- **Push small in-scope fix commits** to
  `mirror/12527-endo-sync-refresh` via `git push bot
  HEAD:mirror/12527-endo-sync-refresh` (append push only;
  no amend; no force).
- **Top-level summary comment + directive reply** on PR #5.
- **Escalate `next: fixer`** if needed.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark ready.
- Do NOT amend builder, weaver, or prior fixer commits.

## Out of scope

- Do NOT rebase further.
- Do NOT attempt scope expansions (broader yarn-up walk,
  upstream cherry-picks beyond what the rebase already did).
- Do NOT touch the patch set unless a CI failure log
  specifically points there.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Pre/post head SHAs.
- Per-check terminal state.
- Per-failure classification.
- Re-runs issued (run-id + job + outcome).
- Shepherd-side commit SHAs (if any).
- Convergence-summary comment URL.
- Directive-reply comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if review-ready;
  `next: fixer` if escalation needed.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
