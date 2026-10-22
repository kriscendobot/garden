---
handed-off: endojs-endo-but-for-bots-pr709-retarget-frozen-base
deliverable-complete: false
---
# Completion report: design-daemon-git-clone-provide-git-clone-bootstrap

The design is written and pushed to draft PR https://github.com/endojs/endo-but-for-bots/pull/709. One step is still open: moving the PR's base off floating `llm` onto the frozen `llm-54d3d2a`. The bot token on this host got a 403 on that PR edit, so I handed the step to a job pinned to an endolin host. This is therefore a handoff, not a clean completion.

## What I did
- **Reused #709 instead of opening a duplicate.** A July draft of `daemon-git-clone.md` was already open as #709 on branch `design/daemon-git-clone`. It was written before #706 merged, it was against floating `llm`, and the design panel had asked for changes on it. `ensure-pr.sh` found it and recorded it as this job's PR.
- **Rewrote `designs/daemon-git-clone.md` (Proposed) against current `llm`.** It records what has shipped: the clone path from #538 and the formula-owned `identity` option from #706. It then specifies a revision that fixes the gaps the panel found and the floot caller works around. Floot currently clones, throws the result away, and builds `Git` and `origin` a second time.
  - **New signature:** `provideGitClone(destMount, petName, options)`, the same argument order as the other `provide*` methods. Pet names are bound only after every step succeeds.
  - **Narrower `origin`:** the remote takes `provideGitRemote`'s policy fields and defaults to fetch-only. The host opts into push, for example the Agent MVP Profile (push only to `refs/heads/agent/*`). The hardcoded fetch+push over `refs/heads/*` goes away.
  - **Cleanup on failure:** `provideGitClone` empties the destination mount so the caller can retry into it. Unnamed formulas are left for garbage collection.
  - **Identity as a capability shape:** the `Git` capability carries the identity, and whoever holds it can commit as that identity. The identity is kept separate from the push credential and is never used to decide whether an action is allowed. Changing it means minting a new `Git`. Rejected alternatives: a guest-visible `setIdentity()`, deriving identity from the credential, and a separate identity capability.
  - It also has an ownership map, a one-job build plan, and a test plan. The tests include the credential-rotation abort, which has no test today.
  - **Open questions:** whether commit signing should become a sealed key capability, and whether the clone should accept a `depth` / `singleBranch` bound.
- **Cross-links:** updated `daemon-git-remotes.md` and `daemon-git-next-steps.md` (which marks the #709 sequencing note resolved), plus `designs/README.md` (summary row, inventory row, dependency graph, totals note).
- **Checks:** every mermaid fence in the four touched files parses. The cliché and spelling greps found nothing.
- **Push:** commit `fa01c112f`, force-pushed with `safe-push-pr-head.sh --mode rewrite`. The old head `5724cc6e23` is still visible in the PR's history.

## What's left
- **Base retarget:** `gh pr edit` and the REST PATCH both returned 403 (`updatePullRequest`) from oros-studio. I posted `endojs-endo-but-for-bots-pr709-retarget-frozen-base`, pinned with `requires: host=endolin-garden-ece02cb4`. It checks the head, retargets the base to `llm-54d3d2a`, and replaces the title and body (the new body carries this job's `garden-job` marker). The PR stays in draft.
- **Memory:** I added this 403 to the existing bot-PAT memory.

## Follow-ups
- Build: `build-daemon-git-clone`. One builder job, rooted at `llm`, implementing phases 1–4 of `designs/daemon-git-clone.md`: the new signature with the `origin` policy record, cleanup on failure, moving the floot and test callers over, and the new tests.
- The design-panel gauntlet should run against the frozen base once the relay job has retargeted #709.


## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `5724cc6e`; this job presented `fa01c112f2c55301820ddfabdcd8dd203a7cafdd`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-daemon-git-clone-provide-git-clone-bootstrap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (4174870 cached reads)
- Output: 30159 tokens
- Cost: $2.486306000000001
- Wall-clock: 715s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
