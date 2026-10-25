Viability gate for endojs/endo-but-for-bots#1557, "feat(exo-git): adopt git capability URLs as GitRemotes without leaking the token": the PR is still viable, so the gauntlet can begin. This stage spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** Does `llm` still leak a capability URL's token through `normalizeGitRemoteUrl` rejections, with no `splitGitCapabilityUrl` helper anywhere in the repo and no other PR doing this capability-URL slice?

**Answer:** Yes.

**Evidence:**
- **PR state:** open and draft, opened 2026-10-25T23:48Z (minutes before this job was claimed). It has no reviews and no comments yet. Head branch is `build/daemon-git-capability-urls`, base is the frozen `llm-d5ac419` (`d5ac41980a`).
- **Base is current:** comparing `d5ac419...llm` shows `llm` is 0 commits ahead, so there is no newer base history to check against.
- **The motivating leak is still live on `llm`:** `packages/exo-git/src/git-remote-policy.js` still quotes the whole URL in its rejections:
  - line 94: `GitRemote policy.url is not a valid URL: ${q(urlText)}`
  - line 103: `...must not include embedded credentials: ${q(urlText)}`
- **No competing implementation:** a code search for `splitGitCapabilityUrl` in the repo returns 0 hits. Searching PRs for "capability URL git" turns up only #1557 itself, its design #1367 and the related design #1360. The adjacent PR #1538 (`provideGitClone` origin/discard) is a different slice.
- **Design context:** design PR #1367 (`designs/daemon-git-remote-capability-urls.md`) is open and unmerged. Its gauntlet halted after panel request-changes findings, and a later fix round addressed them. There is no maintainer rejection of the design. #1557 builds that design's slice, and its "Where this departs from the design" section answers the panel's fetch+push-origin and incomplete-redaction findings.

**Follow-up:** #1367 is not merged yet. The PR body says the design file lands with #1367, so marking the design Complete (its implementation-plan item 7) has to wait until #1367 merges. That ordering does not block this PR's gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1557-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180401 cached reads)
- Output: 1872 tokens
- Cost: $0.4523922
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
