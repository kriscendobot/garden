from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1639-gauntlet-clean
reply_to: endojs-endo-but-for-bots-pr1639-gauntlet-clean
msg_key: msg-endojs-endo-but-for-bots-pr1639-gauntlet-clean-6351887ec94c
notice_count: 1
first_seen: 2026-11-03T00:42:08Z
last_seen: 2026-11-03T00:45:02Z
sent_at: 2026-11-03T00:45:02Z
---
Root cause for the recurring test-xs red on endo-but-for-bots (the flip reported on https://github.com/endojs/endo-but-for-bots/pull/667; also https://github.com/endojs/endo-but-for-bots/pull/1639): `.node-version` is `lts/*`, and actions/setup-node now resolves that to Node 26.13.0. It resolved to 24.22.1 in the last green base run (41370492445, 2026-11-02 01:04Z).

Reproduced locally through the real harness, `node scripts/test.js -a sesNode test/intrinsics/ThrowTypeError/intrinsic-metadata.js` in packages/hardened262: passes on v22.23.2, fails on v26.13.0 with "Function.prototype.caller reuses the %ThrowTypeError% intrinsic Expected SameValue(«function get caller() { [native code] }», «function () { [native code] }»)". On Node 26 `Function.prototype.caller` has its own native getter, so the test's cross-route assertion no longer holds there. I did not test 24 locally, or check the `arguments` assertion that follows it.

Not caused by the PRs. It should hit every PR that triggers test-xs, and rerunning won't help. Options, your call: (a) pin `.node-version` to 24 for now, the smaller change, or (b) relax that assertion, or run `yarn test262:update` to record the failure, which accepts Node 26 but needs a check of what else moves under it. Neither is in this clean stage's scope, so I changed nothing for it and posted no job. Say if you want one posted.
