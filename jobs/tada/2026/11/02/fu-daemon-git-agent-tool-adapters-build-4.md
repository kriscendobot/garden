---
handed-off: fu-daemon-git-agent-tool-adapters-docs
deliverable-complete: false
---
**The docs are not updated, and no commits or PRs were made.** The job only applies after the PR from `daemon-git-agent-tool-adapters-build` lands, and that PR hasn't been opened. I handed the work to a parked successor job, `fu-daemon-git-agent-tool-adapters-docs`.

**Why it's blocked**
- No PR exists for head `build/daemon-git-tool-paths`.
- Its relay job, `daemon-git-agent-tool-adapters-build-open-pr`, is still in `todo` and pinned to `endolin-garden-ece02cb4`, because this host gets a 403 creating PRs at endojs.
- This job was posted without a `blocked_on`, so it could be claimed before the PR landed.

**Successor job**
- **Gate:** it's parked with `gate: blocked`, waiting on the relay job. I confirmed it's on `origin/journal2`.
- **When it's claimed:** the relay job only opens the PR, so the PR will probably still be unmerged. If so, the successor re-blocks on the PR URL with `block-job.sh`. If the PR closes without merging, it asks the maintainer whether to write the docs against `llm` as it stands.
- **Brief:** it names the stale passages to fix in both docs and what I read at `llm` 48d6f3e08:
  - `git-mount.js` returns only the `status` tool.
  - A comment in `types.ts` places the path-string forms of `add` and `checkoutConflict` in the `makeGitTool` slice. I didn't check that against `json-tools/git.js`, and the brief says so.
  - The PR at `be6462bc` changes neither of these two docs.

**Host pin doesn't work**
- My successor body includes a second frontmatter block with `requires: host=endolin…` and `tier:`, and the machinery ignores both. Any host can claim the job, at the default tier for its role.
- The body's Delivery line still says it's pinned, so I added a correction note. It tells a claimant that hits the 403 to push the branch and post a relay job pinned to endolin.

**Follow-ups**
- **`post-plan.sh`:** it has no way to set `requires:` on a parked job, and `promote-plan.sh` wouldn't carry that field over to `todo` anyway. A parked job therefore can't be pinned to a host.
- **Slow checkout:** `ensure-project-worktree.sh` failed once on the `llm` checkout. The retry with `GARDEN_REPO_GIT_TIMEOUT=900` succeeded, though the warm-cache fill alone took 382s. That worktree is no longer needed.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-daemon-git-agent-tool-adapters-build-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1245498 cached reads)
- Output: 14116 tokens
- Cost: $1.1611635999999999
- Wall-clock: 2723s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
