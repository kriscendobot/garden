**Viability gate for endojs/endo-but-for-bots PR #1097, gauntlet `endojs-endo-but-for-bots-pr1097-gauntlet-20260928`: proceed.** I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:**
- The PR is OPEN, still a draft and not merged. GitHub reports it as mergeable.
- Base is `llm-db664fa` (`db664fa119`); head is `4003abd2a1113c63b82f14403e634d64a4bb7590`.
- On 2026-09-22 the main range-attenuation delta was found to be already on `llm`. A peer then rebased and reduced the branch. What remains is two small changes:
  - `.changeset/readable-blob-declarations.md` (+3 −3): rewords the Git blob declaration note to name `sha256`/`size`/`bytes`/`byteRange`/`textRange` instead of the stale `getInfo`/`fetch` wording.
  - `packages/platform/test/cached-fs.test.js` (+29 −1): puts the order of the stream return and the watcher `events` call into a fixed form before the snapshot.

**Deciding question:** Is either of the two remaining changes (the changeset rewording and the cached-fs transcript fix) already on current `llm`, or has the maintainer stopped wanting the PR?

**Evidence (the answer is no):**
- `llm` is 40 commits past `llm-db664fa`, and none of those commits touch either file.
- The changeset on current `llm` still carries the stale text (`getInfo` and streaming `fetch`, plus `rangeRead`/`rangeReadText`). That text is out of line with the `sha256`/`size`/`byteRange` names that are now on `llm`, so the rewording is still needed.
- Current `llm`'s `cached-fs.test.js` still snapshots the raw `transcript` with no reordering, so the test fix has not landed either.
- The maintainer's own comment today shows the need still holds: kriskowal, 2026-09-28T20:51Z, "@kriscendobot Please run a gauntlet and retcon." A separate `endojs-endo-but-for-bots-pr1097-retcon` job was posted for the retcon half.
- The two earlier CHANGES_REQUESTED review asks (rebase/refresh, and aligning names with the `sha256`/`size` split) were answered at the current head on 2026-09-22.

Nothing on the board or upstream was changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-gauntlet-20260928-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (216911 cached reads)
- Output: 2192 tokens
- Cost: $0.43593419999999994
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
