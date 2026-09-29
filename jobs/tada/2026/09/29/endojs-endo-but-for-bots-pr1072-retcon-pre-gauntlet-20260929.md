## Retcon of PR #1072 before the gauntlet: no rewrite needed, history already canonical

The PR's history already had the shape a retcon produces, so I left it alone and did not force-push. I checked it rather than restaging it: restaging would only have created new commit SHAs for identical trees and reset CI. The one gap is the required summary comment on the PR: this host couldn't post it, so a follow-up job on the board will post it.

**Weave was done first.** Earlier today (06:39Z) the weave force-pushed the branch and moved the PR's base to `llm-1706e63`, which is still the current `llm` tip. The branch `fix/ocapn-noise-tcp-single-url-hint` sits on that base, head `ddf7dce22bb5`, with a clean worktree.

**The history, 3 commits covering all 17 changed files:**
- `4c49b832cc` `feat(ocapn-noise)`: the implementation, its tests, the README and the `.changeset` entry (15 files).
- `3dce7c1c41` `fix(daemon)`: `packages/daemon/src/networks/ocapn.js` (1 file). The PR adds no daemon tests, so there was nothing to move into this commit.
- `ddf7dce22b` `docs`: `designs/ocapn-noise-network.md` (1 file).

**Retcon checks, all passing:**
- Each commit touches exactly one package or one top-level group.
- No file appears in more than one commit.
- The files across the three commits exactly match the base-to-head diff (17 files).
- Every commit message uses the conventional-commit format.
- `yarn.lock` is unchanged, so no lockfile commit is needed.

Because nothing was rewritten, the PR's net diff is unchanged by definition. Nothing was pushed, and the PR was not merged or un-drafted; it is still a draft.

**The summary comment is still to be posted.**
- `gh pr comment` from this host (oros-studio-garden-ce242c49) failed with "Resource not accessible by personal access token". This matches the known gap: the bot's token here can't write comments on endojs PRs.
- I posted job `endojs-endo-but-for-bots-pr1072-retcon-pre-gauntlet-summary-20260929`, pinned to `endolin-garden-ece02cb4`, which can post there. It is confirmed in `jobs/todo/` on `journal2`. It carries the full comment text to post as written, and skips posting if the comment is already on the PR.

**Follow-ups:** resuming the gauntlet (the next step in this orchestration) can go ahead. The second retcon after the gauntlet stays in place as the directive asked.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-retcon-pre-gauntlet-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (915181 cached reads)
- Output: 6323 tokens
- Cost: $0.7446481999999999
- Wall-clock: 1344s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
