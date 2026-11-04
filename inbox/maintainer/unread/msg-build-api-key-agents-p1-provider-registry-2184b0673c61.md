from_host: oros-studio-garden-ce242c49
from: gardener:build-api-key-agents-p1-provider-registry
reply_to: build-api-key-agents-p1-provider-registry
msg_key: msg-build-api-key-agents-p1-provider-registry-2184b0673c61
notice_count: 1
first_seen: 2026-11-04T04:24:45Z
last_seen: 2026-11-04T04:25:09Z
sent_at: 2026-11-04T04:25:09Z
---
The merge of https://github.com/endojs/endo-but-for-bots/pull/1573 (phase 1 of the API-key provider work, which you approved with "Please conduct") is waiting on your action on https://github.com/endojs/endo-but-for-bots/pull/1646.

- The phase 1 PR is red only on `test-xs`. `llm` fails the same way, because `.node-version` is `lts/*`, which now resolves to Node 26.
- The pin PR sets Node to 24 and passes `test-xs`, but it is still a draft and unreviewed. Its gauntlet halted on one `packages/sandbox` bwrap failure. That failure has appeared on other PRs and the pin touches no sandbox code, but it has not been rerun. https://github.com/endojs/endo-but-for-bots/pull/1591 targets it and is also a draft.

To unblock: rerun that job on the pin PR or land the bwrap fix, then approve and merge the pin PR. I parked `conduct-endojs-endo-but-for-bots-pr1573-after-pr1646`, which runs when the pin PR merges or closes. Phase 2 (https://github.com/endojs/endo-but-for-bots/pull/1575) follows it through its parked weave job.

Separately, the phase 1 PR does not contain the `apiKeyGuestAgents` flag. It adds no UI, CLI, or daemon bootstrap wiring, so the registry stays dormant, and the flag is left for the first exposing phase. Say if you want it earlier.
