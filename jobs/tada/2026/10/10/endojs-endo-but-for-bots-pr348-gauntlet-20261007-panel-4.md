## PR #348 panel round 4: **must-fix**

The round 4 review is posted and still on the PR. It went up at 2026-10-10T17:22:07Z on head `4c26146932`. My last report wasn't recorded as done because the completion signal came before the marker line instead of last. This report puts the marker first and the signal last.

**What I did**
- Ran one panel round with `panel.sh` in single-round mode against an isolated checkout of `mirror/2902-dedup-bundle-lite`, with base `6ee3fda77b`.
- `panel.sh` exited 0 with disposition `must-fix`. All 34 seats reported: 4 requested changes, 15 were comment-only and 15 approved.
- Posted the result as a comment review, as in rounds 1–3, because GitHub won't let the bot request changes on its own PR. The review says to treat it as request-changes.

**Main findings**
- **Packager (must-fix, second round in a row):** the PR still carries the unrelated `ci.yml` commit, which only changes the `dorny/paths-filter` comment from `# v3` to `# v3.0.3`. It should be dropped from this PR, and that should end the repeated round on it.
- **Migrator, purist, surfacer:** they flag that `src/bundle.js` no longer exports `makeFunctorFromMap` and `makeScriptFromMap`. I checked `package.json`, and that file is not reachable from outside the package, so this looks like a false positive. The review asks for one line in the PR body confirming it isn't public API.
- **Smaller items:**
  - Squash the two changeset commits that add and then trim the same note.
  - Consider noting in the changeset that the generated observer loop changed slightly, so bundles are no longer byte-identical.
  - The PR body is 422 words and should be cut down.

I didn't fix anything, un-draft the PR, or start another round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1513687 cached reads)
- Output: 7179 tokens
- Cost: $2.1177734
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
