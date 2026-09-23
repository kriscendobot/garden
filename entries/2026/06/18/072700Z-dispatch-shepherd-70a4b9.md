---
ts: 2026-06-18T07:27:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--70a4b9
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 461
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/461
  - entries/2026/06/18/072300Z-dispatch-conductor-4a78b9.md
  - entries/2026/06/18/043500Z-result-builder-d056ac-orchestrator-writeback.md
---

# dispatch: shepherd — #461 exo-stream CI (post-approval, conductor-stalled)

kriskowal APPROVED PR #461 at 07:21Z; conductor 4a78b9 tried
to merge but stalled on red CI. The CI failures are
SUBSTANTIVE (in this PR's own domain, not pre-existing).

## Specific failure surfaced

**sandbox-drivers** job: `TypeError: target has no method "next"`.
Available methods on the target Exo:
`["__getInterfaceGuard__","__getMethodNames__","readReturnPattern","streamBase64"]`.

Diagnosis hint: something in this PR is calling `.next()` on a
new exo-stream interface that doesn't expose `next` — likely an
unmigrated consumer (some code is still iterating the old way),
OR the new `PassableReader` interface guard is missing the
`next` method that the legacy consumer pattern expected.

Other failing jobs: `cover`, `lint`, `test` — likely cascading
or related.

## Reference: WIP in builder--d056ac

The builder dispatch d056ac hit a rate-limit ceiling at 04:31Z
with ~15 files of WIP staged-but-not-committed. Per the
orchestrator writeback at
`entries/2026/06/18/043500Z-result-builder-d056ac-orchestrator-writeback.md`:

Staged WIP files include:
- `packages/chat/token-autocomplete.js`
- `packages/daemon/src/daemon.js`, `directory.js`, `mount.js`
- Several daemon and chat test files
- `packages/sandbox/src/factory.js`
- `packages/fae/endo-skill.js`

The `packages/sandbox/src/factory.js` WIP is highly likely to
be related to the sandbox-drivers CI failure (the builder noted
this as a "structural change" — `makeReaderExoFromAsyncIterable`
should vend `PassableBytesReader`).

The dispatch worktree at `/home/kris/dispatches/builder--d056ac/project`
is still PRESERVED. The shepherd can either:
- Diagnose from scratch in this fresh worktree (recommended for
  clean shape).
- Inspect the WIP at the preserved worktree as a reference
  (e.g., `git -C /home/kris/dispatches/builder--d056ac/project diff packages/sandbox/src/factory.js`).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#461`, DRAFT, reviewDecision
  APPROVED, base `llm-5be4392`, head `kriskowal-exo-stream-llm`
  at `93fa0d144`.
- **CI run** `27735265214` red.

## Task

In your `project/` worktree at `93fa0d144`:

1. Read `garden/roles/shepherd/AGENT.md` and
   `garden/skills/ci-failure-classification-loop/SKILL.md`.
2. Pull each failing job's log (sandbox-drivers, cover, lint,
   test).
3. Classify per the 4-class taxonomy (A/B/C/D).
4. **For the sandbox-drivers TypeError**:
   - Find where `.next()` is being called on the new
     `PassableReader` (or similar) Exo.
   - The fix may be either:
     (a) Update the consumer to use `iterateReader` / similar
         instead of calling `.next()` directly, OR
     (b) Add `next` to the interface guard on the Exo
         (if the protocol intends for `.next()` to be
         exposed).
   - Inspect the WIP at
     `/home/kris/dispatches/builder--d056ac/project` for
     reference, especially `packages/sandbox/src/factory.js`.
5. Apply minimal fixes per classification.
6. Run pre-push-gates after any commit.
7. Push.
8. Verify CI re-runs and the new state.
9. Post a top-level summary comment on PR #461 at-mentioning
   @kriskowal, citing the fix shape + CI state.

## Authorizations

- Push commits to `kriskowal-exo-stream-llm` (append only).
- Read access to the preserved `builder--d056ac` worktree.
- Top-level summary comment on PR #461.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT mark PR ready (still DRAFT; conductor handles that
  post-green).
- Do NOT merge (conductor's job after CI is green).
- Do NOT touch other PRs.

## Deliverable

A `result` entry per the standard shepherd shape:
- Pre/post head SHAs.
- Failure classifications per job.
- Fix substance.
- Pre-push-gates result.
- PR comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: conductor` (after CI is
  green) or `next: fixer` (if escalation needed).

End your turn with a concise summary back to the orchestrator.
