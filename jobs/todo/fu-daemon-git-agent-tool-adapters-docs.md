---
role: builder
tier: mentor
posted_at: 2026-11-02T14:55:38Z
handler-budget-role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-11-03T02:06:27Z cleared=none -->

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Successor to `fu-daemon-git-agent-tool-adapters-build-4`, which stopped because its precondition was not met. Docs only: do not touch code.

**Precondition.** In endojs/endo-but-for-bots, the PR from job `daemon-git-agent-tool-adapters-build` must have landed on `llm`. Its head is `build/daemon-git-tool-paths`, its title is `fix(exo-git): resolve diff and stash paths through the mount`, and its body carries `<!-- garden-job: daemon-git-agent-tool-adapters-build -->`. This job is blocked on the relay job that opens it, `daemon-git-agent-tool-adapters-build-open-pr`, so when you claim it the PR will probably be open but not merged. Look the PR up with `gh pr list -R endojs/endo-but-for-bots --head build/daemon-git-tool-paths --state all`, then:
- Open and not merged: run `scripts/jobs/block-job.sh <your-base> <full PR URL>` and stop. The job comes back when the PR merges or closes.
- Closed without merging, or never opened: ask the maintainer with `scripts/jobs/message-user.sh` whether to write the docs against `llm` as it stands.
- Merged: do the work below.

**Work.** Bring both roadmap docs in line with what that PR shipped and with `llm` at that point.
- `designs/daemon-git-next-steps.md` still lists the git agent-tool adapters as open work. Candidates: the "Agent tool layer partially landed" bullet (about line 84), Phase rows 1 and 3 of § Phased Build Plan (about lines 95 and 97), and the numbering notes around line 136.
- `designs/daemon-agent-tools.md` § Phase 3.5 (about line 493) lists `add` and `checkoutConflict` under `makeGitMountTools`. Also check the "remaining builder work" paragraph at about lines 411-415.

**Read at `llm` 48d6f3e08; re-verify after the merge.**
- `packages/agent-tools/src/json-tools/git-mount.js` returns only the `status` tool.
- The comment at `packages/agent-tools/src/types.ts:77-80` says the path-string forms of `add` and `checkoutConflict` belong to the `makeGitTool` slice. `status` stays in `makeGitMountTools` for its collapsed-untracked default. `git-mount.js` confirms the `status` half; the `makeGitTool` half was not checked against `json-tools/git.js`.
- `provisionWorkspaceTools` in `packages/agent-tools/src/workspace.js` composes the `gitMount` group.
- The PR's body says the adapters were already on `llm` (#523, #616, #705, #707) and that the PR adds only the path gap: `Git.diff` and `Git.stashPush` resolve `paths` through the mount, and the `diff` tool schema documents `cached`, `base`, `head`, and `paths`. At be6462bc, the PR changes `designs/daemon-git-capability.md` but neither of these two docs. Check any claim from that body against the code before writing it into a doc.

**Delivery.** Open a draft docs PR against a frozen base through `scripts/jobs/gardening/ensure-pr.sh`. This job is pinned to endolin because host `oros-studio-garden-ce242c49` gets 403 on PR creation at endojs.

<!-- garden-annotation: key=host-pin-correction by=gardener at=2026-11-02T15:04:03Z -->

Correction to **Delivery** and to the second frontmatter block above: that block is inert, so `requires: host=endolin-garden-ece02cb4` and `tier:` have no effect, and this job is NOT pinned to endolin. Any host may claim it. If `ensure-pr.sh` gets a 403 on PR creation at endojs (host `oros-studio-garden-ce242c49` does), push the branch and post a relay with `scripts/jobs/post-job.sh` whose leading frontmatter carries `requires: host=endolin-garden-ece02cb4`, as `daemon-git-agent-tool-adapters-build-open-pr` does.
