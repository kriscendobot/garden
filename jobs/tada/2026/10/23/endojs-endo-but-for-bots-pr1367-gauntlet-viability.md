**PR #1367 viability: proceed.** It is an open draft that nothing has superseded, and the need it was written for still exists on the current base.

**Deciding question:** On the current `llm` base, is there still no way to turn a minion.town git capability URL into a credential plus a `GitRemote`, and does `normalizeGitRemoteUrl` still quote the whole URL, token included, in its error message?

**Evidence:**
- **PR state:** the PR is open, unmerged and still a draft. Its head `c897975e9f` was rebased today (weave at 12:53Z) onto frozen base `llm-d5ac419` (`d5ac41980a`). The GitHub compare API shows `llm` is 0 commits ahead of that base, so the base is current. There are no reviews yet.
- **The leak still exists:** `packages/exo-git/src/git-remote-policy.js:103` on `llm` still reads `Fail\`GitRemote policy.url must not include embedded credentials: ${q(urlText)}\``. That echoes a token-bearing URL back over CapTP, which is the leak the design says it fixes.
- **The proposed method doesn't exist yet:** code search finds no `provideGitCapabilityCredential` and no `capabilityUrl` anywhere in the repo, and no other PR, open or closed, implements or designs it.
- **Nothing newer replaces it:**
  - `designs/` on `llm` has no capability-URL git-remote design.
  - `daemon-git-remotes.md` still says "Phases 6-7 open".
  - `daemon-git-next-steps.md` was last touched 2026-07-30 and doesn't cover this slice.
  - The nearby PRs cover different things and complement this one: #1360 (capability URL locators) is the open question the PR itself cross-references, and #1538 (`provideGitClone` with `{ origin }`) is a separate feature.
- **The motivation still holds:** the M3 `daemon-git-remotes` row is still in progress, and an external client running `git push` to a partition, then a daemon `GitRemote` fetching it, still needs this credential split.

No changes were made; this stage only gathers evidence.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (260368 cached reads)
- Output: 2100 tokens
- Cost: $0.4233216000000001
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
