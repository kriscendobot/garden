**Viability gate, endojs/endo-but-for-bots#1594 (refactor(daemon): rename Daemon/Mignonic to Manager/Worker): proceed.**

This was a read-only check. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

Deciding question: Does live `llm` still use the old Daemon/Mignonic identifiers in `packages/daemon/src/manager.js`, with no newer implementation or design replacing this rename?

Evidence:
- **PR state:** open, unmerged, draft, mergeable. Head is `d948eea21f`. The latest bot comment (2026-11-17T02:33Z) reports CI green after the Node 26 Hardened262 fix.
- **Base:** the PR's base `llm-48d6f3e` is 15 commits behind `llm` and has nothing `llm` lacks. None of those 15 commits does the rename; the newest commits touching `manager.js` are unrelated daemon and captp fixes.
- **Need still holds:** on `llm`, `manager.js` still contains about 49 old identifier lines, including 43 `DaemonCore`, 20 `DaemonFacet`, 13 `DaemonNode` and 5 `DaemonicPowers`. The design `designs/daemon-rename-to-manager.md` on `llm` still says Status: Not Started. The file renames from the design's first phase already landed in #598, so this PR is the remaining identifier work.
- **Not displaced:** the only other open PRs on this rename are older and stale.
  - #780 (identifier rename, phase 2) is a draft last updated 2026-07-17.
  - #593 is an earlier attempt at the phase 1 file renames that #598 already merged.

  #1594 covers all of #780's scope and more, so #1594 is the current one. Nothing newer replaces it.

Follow-up: since #1594 covers #780 and #593, the maintainer may want to close both as superseded by #1594. I took no action on them.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-r2-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (318544 cached reads)
- Output: 2015 tokens
- Cost: $0.5115128
- Wall-clock: 55s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
