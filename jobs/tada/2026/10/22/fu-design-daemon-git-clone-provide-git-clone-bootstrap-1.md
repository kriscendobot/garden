---
handed-off: fu-design-daemon-git-clone-provide-git-clone-bootstrap-1-open-pr
deliverable-complete: false
---
The code is finished and pushed, but the draft PR is not open yet. This host's bot token is refused permission to create PRs on endojs (HTTP 403 on `createPullRequest`), so I posted a successor job, pinned to an endolin host, to open it.

**Branch:** `build/daemon-git-clone` (commit `eafcef12b`) in endojs/endo-but-for-bots, on the frozen base `llm-54d3d2a` (the current `llm` tip). It has two commits.

1. **`feat(daemon)`**, phases 1–4 of `designs/daemon-git-clone.md` (design PR #709):
   - **New signature.** `provideGitClone(destMount, petName, { endpoint, identity, origin })`, the same argument order as `provideGit`; the one-object form is removed.
     - `origin` carries the remote's policy plus an optional `petName`, and defaults to fetch-only. The old hardcoded fetch+push over `refs/heads/*` is gone.
     - `origin` cannot set the remote's name, url, credential or transport; the clone takes those from the endpoint.
     - A policy that `provideGitRemote` would reject is rejected before the clone starts.
     - `types.d.ts`, the `interfaces.js` guard and the type test are updated.
   - **Naming last.** Both names are stored only after the whole clone succeeds. Until then the new formulas are pinned so garbage collection can't take them.
   - **Cleanup on failure.** The host first checks the destination is empty itself. On any later failure it empties the destination, then rethrows the original error. Content the caller had before the call is never removed. Two new daemon-core helpers do the listing and emptying.
   - **Callers.** The floot bootstrap is now a single call; I also rewrote the prompt's instructions for re-creating the remote after a restart, since the separate `provideGitRemote` step they pointed to no longer exists. The daemon tests use the new form.
   - **Tests.** All five the design lists are in, plus one checking that a non-empty destination is refused and left untouched.
2. **`fix(git)`, a bug the rotation test exposed.** Aborting a credentialed https clone, fetch or push never finished. Only `git` itself got the kill signal; its `git-remote-https` child survived and kept the connection and output open. `git` now runs as a process-group leader and the whole group is signalled. Without this fix the new rotation test hangs; with it, it passes.

Changesets are added: `@endo/daemon` major (with migration notes), `@endo/git` patch.

**Checks:**
- All 51 tests in `git-remote.test.js` pass, as do the `@endo/git` tests and the two floot prompt test files.
- Typecheck is clean for daemon, git and exo-git; eslint shows no errors; prettier is clean.
- The pre-push gates pass, and the related-design check is clear for #709, #1367 and #988.
- `eslint --fix` stripped about 40 unrelated `eslint-disable` comments in `manager.js`; I restored them, so the diff holds only this change.

**PR body:** the phase-evidence gate refused the first body because it can't read the design file, which isn't on the base branch. That design's text doesn't trigger the gate's phase-ledger requirement, so I removed the ledger and named the design by PR #709 instead.

**Follow-ups:**
- Successor job `fu-design-daemon-git-clone-provide-git-clone-bootstrap-1-open-pr` is in `jobs/todo/`, pinned `requires: host=endolin-garden-ece02cb4`. It runs `ensure-pr.sh` with this job's base and the PR body embedded, so the PR carries this job's marker and the gauntlet stages when it opens. `ensure-pr.sh --find-only` confirms no PR exists yet.
- Design #709 is still open and unreviewed by the maintainer. If its review changes the surface, this branch needs updating.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-design-daemon-git-clone-provide-git-clone-bootstrap-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 4 tokens (455645 cached reads)
- Output: 1885 tokens
- Cost: $6.577271600000003 (1 engagement(s) unpriced)
- Wall-clock: 2458s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
