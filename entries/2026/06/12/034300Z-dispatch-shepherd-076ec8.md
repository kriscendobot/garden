---
ts: 2026-06-12T03:43:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--076ec8
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4686957752
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/11/201726Z-result-weaver-0207d5.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/181800Z-result-fixer-d6af77.md
---

# dispatch: shepherd — corroborate post-drop CI failures + drive to green per kriskowal directive

Maintainer directive on PR #5 (kriskowal at 2026-06-12T03:08:00Z,
issue comment `4686957752`):

> This change should not affect the pinned `ava` version.
> `ses-ava` allows a wide range of versions. Please corroborate
> CI failures and shepherd back to passing tests.

The 👀 reactji is on the directive comment
(`reactions/369054885`).

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `c81b03e62216edcbfc12809aefb91d029f7a20a5` (`c81b03e62`).
  Post-drop of ava-restore commit per weaver `0207d5`.
- **CI**: 28 SUCCESS, 14 FAILURE.
- **Maintainer's claim**: this PR's Endo-sync change shouldn't
  affect the pinned `ava` version. `@endo/ses-ava` allows a wide
  range. So the post-drop failures are NOT (per the maintainer)
  caused by the ava version mismatch.
- **Prior fixer `d6af77` diagnosis**: the 12 failures observed
  pre-drop were attributed to ava version mismatch (cherry-pick
  downgraded ava ^7→^6 across 29 package.json; the restore
  commit fixed it). After the weaver dropped that restore
  commit (per maintainer's prior directive `4684506028`), the
  cascade returned.

**Tension**: the maintainer is now saying the cascade is NOT
ava-related. The shepherd's job is to corroborate which view
holds — by reading the actual failure logs and matching against
the prior `runnerChain` signature.

## Task — corroborate, then act

In your `project/` worktree on
`mirror/12527-endo-sync-refresh` at `c81b03e62`:

### Phase 1 — Corroborate the failure signature

1. **Pick a representative failing job** (e.g.,
   `test-swingset (node-new, 0, 5)` since that's the
   shape the prior fixer diagnosed as the ava cascade).
2. **Pull the log**:
   `gh run view <run-id> --log-failed --repo
   kriscendobot/agoric-sdk`. Pre-count error lines.
3. **Match against the prior fixer's diagnosis**: the
   prior fixer at
   `journal/entries/2026/06/10/181800Z-result-fixer-d6af77.md`
   says:
   > Mixed ava 6/7 across workspaces means a worker's
   > `state.cjs` (where `runnerChain` is set) and the test
   > file's transitively-resolved `ava` module's
   > `state.cjs` are different physical files with separate
   > CJS module caches — the `null` runnerChain assertion
   > fires.
   
   Does the current failure log show `assert(refs.runnerChain)`
   falsy? If yes, the prior diagnosis is implicated.
4. **Check ava resolution**: `corepack yarn workspaces list
   --json` followed by inspecting each workspace's
   resolved `ava` version
   (`corepack yarn why ava` and similar). Compare against
   `ses-ava`'s peer-dependency range.
5. **Form a hypothesis**:
   - **If `runnerChain` cascade IS the cause AND the ava
     versions are genuinely incompatible**: the maintainer
     is incorrect about `ses-ava`'s range being sufficient.
     Document the evidence (specific version conflict)
     and escalate to `next: liaison` with that evidence.
   - **If `runnerChain` cascade IS the cause but the ava
     versions are within ses-ava's range**: there's a
     different root cause. Diagnose deeper.
   - **If the failure signature is something else
     entirely**: the prior fixer's diagnosis was wrong (or
     became wrong after the rebase + drop). Diagnose the
     new root cause.

### Phase 2 — Drive to green

Based on Phase 1's hypothesis:

- **If in-scope shepherd fix** (small, contained): apply,
  commit, push, re-watch CI.
- **If substance escalation** (`next: fixer`): name the
  scope and the suggested fixer hand-off.
- **If maintainer-routing escalation** (the ses-ava range
  claim doesn't hold): post a corroboration comment on PR
  #5 with the evidence and escalate `next: liaison`.

### Phase 3 — Iterate

If a fix lands, watch CI. If more failures need attention,
repeat.

## Authorizations (per-action, forwarded by liaison)

- **Re-run failed CI jobs** up to 2x per job.
- **Push small in-scope fix commits** to
  `mirror/12527-endo-sync-refresh` via `git push bot
  HEAD:mirror/12527-endo-sync-refresh` (append push only;
  no amend; no force).
- **Top-level corroboration comment** on PR #5 with the
  Phase 1 evidence regardless of outcome. The maintainer
  asked to "corroborate" — that's a positive ask for a
  reasoned report.
- **Reply on the directive comment** with the convergence
  summary.
- **Escalate `next: fixer`** OR **`next: liaison`** as
  warranted.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark ready.
- Do NOT amend prior commits.

## Out of scope

- Do NOT re-add the ava-restore commit (the maintainer's
  drop directive is explicit; if the corroboration shows
  it's needed, escalate via the corroboration comment with
  evidence — don't re-add it autonomously).
- Do NOT rebase or force-push.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Phase 1 corroboration: failure signature + ava resolution
  + hypothesis.
- Phase 2 actions: per-failure classification, any commits
  landed.
- Per-check terminal state.
- Re-runs issued.
- The corroboration comment URL.
- The convergence-summary or escalation comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if green;
  `next: fixer` with rationale; `next: liaison` with
  specific question + evidence.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
