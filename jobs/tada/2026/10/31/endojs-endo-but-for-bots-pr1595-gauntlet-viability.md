**Viability report: endojs/endo-but-for-bots PR #1595** ("feat(cli): provision bounded Git remote profiles")

Verdict: **proceed**. The PR is still needed and nothing has replaced it.

PR facts: open, draft, not merged. It was created 2026-10-31T16:30Z by job `build-daemon-git-remotes-interactive-provisioning`. Base is `llm-9a14ddf` and head is `82df84f4`.

Deciding question: Is Phase 6 (Interactive Provisioning) of `designs/daemon-git-remotes.md` still unbuilt on current `llm`, with no other PR or commit already providing CLI provisioning and inspection of Git remote profiles?

Evidence:
- **Base is current.** Comparing `llm-9a14ddf` with `llm` shows 0 commits ahead and 0 behind, so there is no newer base history that could have replaced it.
- **The design still lists this work as open.** In `designs/daemon-git-remotes.md` on `llm`, all three Phase 6 items are unchecked: CLI flows for common profiles, interactive endpoint approval, and inspection surfaces. That is exactly what this PR delivers.
- **The feature isn't on `llm` yet.** There is no `git-remote` command in `packages/cli/src/commands`, and `packages/cli/src/endo.js` has no git-related wiring.
- **No other PR does this work.** The other git-remote PRs touch different layers:
  - #538, #705, #734, #929 and #1145 are merged and cover the remote mechanics this PR builds on.
  - #1367 is an open design PR about adopting git capability URLs as GitRemotes. That is a separate design slice, not CLI provisioning.
  - #691, the design the PR refers to, is merged.
- **No reviews or comments yet**, so no one has pushed back on the premise.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178870 cached reads)
- Output: 1540 tokens
- Cost: $0.42606200000000005
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
