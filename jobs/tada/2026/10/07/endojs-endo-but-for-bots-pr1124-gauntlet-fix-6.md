I applied one of round 6's two must-fixes and pushed it to PR #1124 as `9df82807a`. CI is green (33/33 checks), but only after I reran one failed cell. The other must-fix, the decomplector's, is still waiting on a maintainer decision.

**Applied (breaker must-fix):**
- `makeFormulaNonceLocator` now takes an `isLocalNode(node)` predicate instead of `localNodeNumber`. Host and guest identifiers carry their agent's node number, not the daemon's, so the old equality check missed every real host or guest identifier. In the daemon the predicate would be `isLocalKey`. A predicate that returns anything other than `true`, or throws, counts as a miss.
- `provideLocalFormula` now takes only the identifier.
- New unit tests: an identifier under an agent node hits, and a throwing predicate is a uniform miss. The endpoint test's guest identifier now uses an agent node, and the README is updated to match.

**Should-fixes done:**
- The endpoint test's listeners shut down through `t.teardown`.
- Three near-miss identifiers (trailing `\n`, trailing `\0`, leading space) are added to the miss matrix.
- I dropped the `endo-bootstrap` exemption from the "never echoes the secret" check rather than commenting it. The rejection text (`Bootstrap fetch: secret not found`) never contains that word, so the exemption wasn't needed.
- The design note's date is corrected from 2026-09-05 to 2026-10-07.

Locally, `tsc` is clean, eslint shows no errors, and all 13 locator tests pass. I posted a summary comment on the PR.

**Not applied (decomplector must-fix):** the choice is between wiring the locator into `networks/ocapn.js` now and removing it or landing it unwired on purpose. That needs the maintainer's call. The round-5 fixer already asked (`inbox/maintainer/unread/msg-endojs-endo-but-for-bots-pr1124-gauntlet-fix-5-2beecd86454e.md`), and that message is still unread, so I didn't send another. If nobody answers, panel-7 will raise the same must-fix again.

**CI:** the first run failed only on `test (22.x, ubuntu-latest)`. The cause was an unhandled `Termination requested` rejection in the teardown of `test/endo.test.js` (the retention-table test), which this change doesn't touch. I treated it as a flake and reran the failed job instead of reporting the stage as failed. The rerun passed, and `ci-wait-merge` returned rc 0.

**Follow-ups:**
- The PR needs the maintainer's decision on wiring versus removing the locator.
- The teardown flake in `endo.test.js` may need its own fix if it keeps recurring.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2683204 cached reads)
- Output: 15274 tokens
- Cost: $1.5461128000000002
- Wall-clock: 4070s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
