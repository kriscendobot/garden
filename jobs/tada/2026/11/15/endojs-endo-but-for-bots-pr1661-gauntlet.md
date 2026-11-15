gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1661
# gauntlet endojs-endo-but-for-bots-pr1661-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1661 the only live implementation of its core change, which is adding HTTP tools to the agent workspace when an `http` grant is given? Answering yes would mean it is not superseded and its need is still open. Option: close as superseded.

## Viability report

I recommend not running the gauntlet on PR #1661 (`viability=overtaken`). An earlier PR, #1593, already does its core change. #1593 has passed its own gauntlet and is waiting for maintainer review.

**Deciding question:** Is #1661 the only live implementation of its core change, which is adding HTTP tools to the agent workspace when an `http` grant is given? Answering yes would mean it is not superseded and its need is still open.

**Answer:** No.

**Evidence:**
- **PR state:** #1661 is open, an unmerged draft opened 2026-11-15 by the build job `build-daemon-agent-tools-phase-eight-fetch-plugin`. Its base is `llm-48d6f3e`, and `llm` has no commits past that base. It has no reviews or comments yet.
- **The earlier PR:** #1593 "feat(agent-tools): compose HTTP workspace tools", opened 2026-10-31 by job `build-daemon-agent-tools-make-http-tool`, makes the same change and also refs #1497.
  - It is open and not a draft. GitHub reports it mergeable (`clean`). The garden's comment from 2026-10-31T19:47Z says "Gauntlet converged · CI green (36 checks) · next: maintainer review" at head `d1f1cc58d9`.
  - It edits the same files: `packages/agent-tools/src/workspace.js`, `src/types.ts`, `test/workspace.test.js`, the README, `.changeset/agent-tools-workspace-provisioning.md` and `designs/daemon-agent-tools.md`.
- **The two PRs conflict on design.** #1593 keeps name collisions between tools fail-closed: HTTP and Git-remote both offer `fetch`, and that pairing is refused on purpose. #1661 instead renames the clashing tools (`inspectShell`, `inspectGitRemote`, `fetchGitRemote`, `fetchHttp`), so the pairing works. Only one approach can land, and merging either one makes the other conflict.
- **What #1661 adds beyond #1593:**
  - Renaming the clashing tools, as above.
  - `@deprecated` tags on the daemon's `provideHttpClient`, `getHttpClientControl` and `http-client` formulas, a docs-only change.
  - Design notes that describe `@endo/fetch` as "the landed single-package plugin".
- **Weak footing for the extras:**
  - They follow a "Phase 8" scope from design PR #1497, which is still open and unmerged.
  - The "single-package plugin" claim is already contested: draft PR #1588 splits `@endo/fetch` into an unconfined base plus a separate `@endo/confined-fetch` plugin.
- **Cost:** a clean → panel → fix-loop pass on #1661 would duplicate work #1593 already finished, on the same files.

**Decision for you:**
- **Recommended:** close #1661 as superseded and review #1593. If you want the renaming or the deprecation tags, they can follow once #1593 merges and #1497 settles Phase 8.
- **Alternative:** if you prefer #1661's renaming to #1593's fail-closed rule, close #1593 instead, then re-run the gauntlet on #1661 with "run the gauntlet #1661".

This stage spent nothing on clean, panel, fix, CI-wait or un-draft, and I made no changes to the repo or the PRs.

Option: close as superseded

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1661-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (252144 cached reads)
- Output: 3073 tokens
- Cost: $0.5189448000000001
- Wall-clock: 58s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
