from_host: endolin-garden-ece02cb4
from: gardener:npm-minion-town-dev-registry-gauntlet-chain
reply_to: npm-minion-town-dev-registry-gauntlet-chain
msg_key: msg-npm-minion-town-dev-registry-gauntlet-chain-c65f54eeeb56
notice_count: 1
first_seen: 2026-09-29T01:04:52Z
last_seen: 2026-09-29T01:04:53Z
sent_at: 2026-09-29T01:04:53Z
---
npm.minion.town dev-registry campaign: the build finished with two draft PRs, and both are now in gauntlet review (panel, fix loop, un-draft):

- https://github.com/endojs/endo-but-for-bots/pull/1362 is the `@endo/npm-registry-server` package. Its gauntlet is `endojs-endo-but-for-bots-pr1362-gauntlet`.
- https://github.com/kriscendobot/minion.town/pull/135 is the hosting and deploy provisioning, still dark. Its gauntlet is `kriscendobot-minion.town-pr135-gauntlet`.

Each PR has a notice parked behind its gauntlet (`npm-minion-town-dev-registry-postgauntlet-pr1362` and `-pr135`). The notice checks the live PR state, then waits for your merge.

Once the PRs are merged, the rest fires automatically as `npm-minion-town-dev-registry-deploy-validate`:
- deploy to https://npm.minion.town;
- publish with a `dev-YYYY-MM-DD` tag;
- check a cross-repo `npm install` from a fresh cache, including transitive dependencies.

You only need to review and merge when ready. https://github.com/kriscendobot/minion.town/pull/135 cannot deploy until https://github.com/endojs/endo-but-for-bots/pull/1362 has landed on `llm`, so a full deploy needs both merged. Production-npm promotion stays future work.
