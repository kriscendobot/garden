Panel round 4 on endojs/endo-but-for-bots#1397 came back **must-fix**, and the verdict is posted on the PR.

**What I did**
- Checked out the PR head `7af07e2320` (branch `build/sturdyref-ocapn-enliven` on endojs) in an isolated worktree, `scratch/project-wt-ebfb-st-39a187d6c397-b429abf3`.
- Ran `panel.sh` in single-round mode against the PR's actual base SHA `b0778fab75` (branch `build/sturdyref-captp-construct-b0778fa`). It exited 0 with disposition `must-fix`, and the run is recorded at `panel-runs/endojs-endo-but-for-bots-1397/8614798032c2.md`.
- Posted the verdict as review 5400040330 (https://github.com/endojs/endo-but-for-bots/pull/1397#pullrequestreview-5400040330). GitHub doesn't let the bot request changes on its own PR, so it went up as a COMMENTED review. Like rounds 1–3, it carries the `<!-- garden-panel-verdict: must-fix -->` marker so the next stage can find it.
- The full seat output came to about 75KB, over GitHub's review size limit. The posted review therefore has a summary, the full reports of the 7 seats that did not approve plus duality-auditor's, and a list of the approving seats by name.

**Verdict:** 33 seats ran. 26 approved, 5 left comments only, and 2 requested changes. The PR-body template check passed this round, and the code fix itself is sound.

**Blocking items**
- **archivist:** `enlivenAtHome` in `sturdyrefs.js` is missing a `@returns {Promise<unknown>}` tag.
- **engine-realist:** both packages turn off their XS tests with `"test:xs": "exit 0"`. That means the new `frozenBytes` → `decodeSwissnum` path is never tested on XS. The fix is either an XS-reachable unit test or a note in the changeset.

**Suggested for the same fix pass**
- **purist and integrator:** widen `NonceLocator.get` to accept `string | Uint8Array` and drop the new parallel `SecretLocator` type.
- **spec-keeper and assessor:** narrow the bare `catch` to `RangeError` and rethrow anything else.
- **corner-prober:** add three tests:
  - an unknown non-ASCII byte secret, checking the rejection message doesn't leak it;
  - an empty secret on the remote path;
  - a non-ASCII string secret at home.
- **stylist:** the two new helpers take `locator` in opposite argument positions.
- **fast-checker:** consider property-based tests for the ASCII boundary (would need `fast-check` as a devDependency).
- **integrator:** consider squashing the "Address the round-N panel" commits.

**Follow-ups:** none beyond the gauntlet's own fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1181713 cached reads)
- Output: 6647 tokens
- Cost: $0.9539945999999999
- Wall-clock: 661s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
