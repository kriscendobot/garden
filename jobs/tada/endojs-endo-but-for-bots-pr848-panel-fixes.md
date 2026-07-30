# Fixer completion: panel verdict on endojs/endo-but-for-bots PR #848

## Situation

PR #848 ("chore: update Pi to 0.81.1") was **merge-committed into `llm`**
(merge commit `9c55cf468e`, merged 2026-07-30 00:37 UTC by kriscendobot)
**before** this fixer job ran. The head branch `build/pi-0.81.1-migration`
is deleted. kriskowal approved the PR on 2026-07-29 after the panel backfill
verdict (must-fix, posted 2026-07-28) was visible. The two history-cleanup
items are therefore no longer actionable without rewriting published `llm`
history (7 commits sit on top of the merge). The four content items land as
a single follow-up commit on a new PR.

## What I did

Opened follow-up PR **#898** (`fix/pi-0.81.1-panel-followup`, head
`f8c3923f4a`, base `llm`) with one commit addressing the still-actionable
panel items:

- **Item 3 (changeset):** Added `.changeset/pi-0.81.1-stream-function.md` —
  `minor` on `@endo/agent-tools` / `@endo/agentry` / `@endo/genie`, `patch`
  on `@endo/lal` — documenting the 0.81 stream-function constructor break
  and the disjoint peerDependency floor narrowing (`^0.80.3` → `^0.81.1` on
  0.x). `privatePackages: {tag: true, version: true}` with empty `ignore`
  means the private packages are not exempt.
- **Item 4 (comment corrections):** Both `makePiAgent` factories and the
  changeset now state the upstream break accurately: pi-agent-core 0.81
  evaluates `runtimeOptions.streamFn ?? getDefaultStreamFn()` in the `Agent`
  **constructor** (`dist/agent.js:118`), and `getDefaultStreamFn()` throws
  unconditionally (`dist/stream-fn.js:13`) because nothing calls
  `setDefaultStreamFn`. The failure is at construction, not "when a turn
  begins". Genie's comment no longer calls `streamSimple` "the fallback" —
  it is genie's sole stream function. Both comments name the upstream
  `setDefaultStreamFn` hook (ambient mutable module state) deliberately
  declined, so the next bump does not re-litigate it. Verified the claim
  against the actual 0.81.1 dist on disk.
- **Item 5 (genie streamFn seam):** `packages/genie/src/agent/index.js` now
  destructures `streamFn = streamSimple` (mirroring agentry's
  `streamFn ?? streamSimple`) and passes `streamFn` to the constructor, so
  a caller can override the stream function instead of the previous
  hardwired `streamFn: streamSimple`.
- **Item 6 (JSDoc):** `packages/agentry/src/harness/pi-agent.js` JSDoc now
  lists the `streamFn` default in the wrapper's ownership enumeration, and
  the `@param` describes it as a defaulted option two callers
  (`@endo/lal`'s worker loop and `define-agent.js`) rely on rather than a
  plain pass-through. Genie's JSDoc gains the matching
  `@param {StreamFn} [options.streamFn]`.

## Items not addressed (no longer actionable post-merge)

- **Item 1 (autosquash the fixup):** `6b3b71cbdf` is baked into `llm` via
  the merge commit; head branch deleted; rewriting would rebase 7 published
  commits.
- **Item 2 (split yarn.lock):** lockfile churn is in the merged
  `0d601ca3fc`; same post-merge constraint.

## Verification (real-execution evidence)

Run in an isolated project worktree off `origin/llm`
(`project-wt-...-8fb004ac`, branch `fix/pi-0.81.1-panel-followup`):

- `@endo/agentry` typecheck (`tsc -p packages/agentry/tsconfig.json`): clean
  (exit 0, no output).
- `@endo/agent-tools` typecheck (`tsc -p packages/agent-tools/tsconfig.json`):
  clean (exit 0).
- `@endo/agentry` lint (`eslint '**/*.js'`): 0 errors, 8 pre-existing
  warnings (none in edited files).
- `@endo/genie` lint (`eslint '**/*.js'`): 0 errors, 63 pre-existing
  warnings (none in edited files).
- `@endo/agentry` suite (`ava`): 108 passed, 1 failed — the pre-existing
  baseline `eval › conflict-rebase › outcome assertion fails when
  conflicted worktree is left mid-rebase` (global `rerere.enabled=true`
  leaking into the fixture; out-of-scope per the panel verdict). The panel
  documented this exact failure as a host-environment issue, and the
  108/109 count matches its baseline.
- `@endo/genie` suite (`ses-ava`): 446 passed, 0 failed (matches the
  panel's 446/446 baseline).
- `@endo/agent-tools` suite (`ava`): 150 passed, 0 failed.
- Prettier (`prettier --check`): all edited files pass.

The native better-sqlite3 module was provisioned from the warm dep cache
(the `yarn install` link step fails on the prebuild-install permission
denial in the pnpm store; the prebuilt `.node` was copied from the
`-native-builds` cache entry for this lockfile hash). This is a
worktree-provisioning workaround, not a source change.

## Follow-ups

- PR #898 needs review/merge into `llm`.
- The two history items (1, 2) are permanently unactionable; recorded in
  the PR #848 summary comment so the verdict is reconciled.
- Posted a completion summary comment on PR #848 mapping each panel item to
  its addressing commit (or its not-actionable rationale).
- The panel's out-of-scope follow-ups (genie/agentry harness divergence,
  named stream-function unit test, `/compat` import trend, rerere fixture
  pin) remain parked as described in the verdict.

## Outcome

The panel verdict's content must-fix (changeset) and all three should-fix
items (comment accuracy, genie streamFn seam, JSDoc) are addressed in
PR #898. The two history must-fix items are reconciled as no-longer-
actionable due to the merge. Not fully "done" in the sense that #898 still
needs maintainer merge, but the fixer work itself is complete.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr848-panel-fixes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2413s

<!-- garden-usage-end -->
