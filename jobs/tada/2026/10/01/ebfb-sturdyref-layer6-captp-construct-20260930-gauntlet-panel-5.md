Panel round 5 on endojs/endo-but-for-bots#1396 at head `117fc06c07` came back **must-fix**. I posted the verdict as review [5378689003](https://github.com/endojs/endo-but-for-bots/pull/1396#pullrequestreview-5378689003) in the same COMMENTED form as rounds 1–4.

**What I did**
- Made an isolated checkout of `endojs/endo-but-for-bots@build/sturdyref-captp-construct`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the real merge base `2d2a656b84`. It exited 0 with disposition `must-fix`. 33 seats ran: 7 request-changes, 9 comment-only, 17 approve.
- Checked the integrator's main finding myself and it holds. The PR this one builds on (#1394, head `75167825`) is 8 commits past this PR's frozen base. One of those commits, `bca51127c3`, locks down the facet on the `s` target, and it is not in this PR's history.
- The review body has a must-fix / should-fix summary followed by the 16 request-changes and comment-only seat blocks. That came to about 54k characters, under GitHub's limit; the full aggregate was 82k.

**Must-fix items for the next fix stage**
1. Weave onto #1394's current head. Then give the new `l-0` `sturdyRefLocator` the same protection `bca51127c3` gave the `s` facet: answer only `locate`, accept exactly one string argument, and reject property gets.
2. In ocapn, `makeSturdyRef` keeps the caller's secret and `hints` by reference and copies them only when read. So changes the caller makes before the first `getSturdyRefData` show up in the returned data. The first read also freezes the caller's own `hints` object. Copy both when the ref is minted.
3. Forward the `SturdyRefData` type from `packages/ocapn/index.js`.
4. Rewrap the changeset to 80–100 columns.

**Should-fix**
- `hints` given as a `Map`, a `Set`, or an object with its data on the prototype is silently treated as empty.
- The ocapn `getSturdyRefData` parameter should be typed `unknown`.
- `getDetails` should be renamed so it isn't confused with `getSturdyRefDetails`.
- The PR body should be trimmed.
- The same validation is written twice, once in captp and once in ocapn.

**Follow-up for the garden itself:** the scribe seat has flagged the missing completion-summary comment for four rounds in a row. Its likely cause is that the single-seat demotion in `skills/panel-review/SKILL.md` turns this finding into an acknowledgment every round. That rule is worth revisiting, but I did not change it in this job.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1138086 cached reads)
- Output: 7856 tokens
- Cost: $1.0921691999999998
- Wall-clock: 688s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
