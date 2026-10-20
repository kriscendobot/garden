**Shepherd report: endojs/endo-but-for-bots#1483 (heartbeat capability negotiation)**

#1483 is still a draft, CI is green and GitHub reports it mergeable. I moved it onto #1482's current head to clear a conflict GitHub wasn't showing.

**What I checked**
- The whole session-reconnect stack sits on the same frozen base, `llm-61cd656`: #1476 is based on it directly, and #1478, #1481, #1482 and #1483 each sit on a frozen copy of the PR below. All five were draft, open and showing clean.
- The stack had drifted. Each lower PR has picked up 10–15 review-fix commits since the copy above it was frozen, so the frozen copies are out of date.
- #1483 merged cleanly into its frozen base (`build/ocapn-noise-session-reconnect-crossed-hellos-9376e7e`). Against #1482's actual head (`acbaf002`) it conflicted in `packages/ocapn-noise/src/network.js`, because #1482's later crossed-hellos fixes touch the same code.

**What changed**
- I re-applied #1483's single commit on top of `acbaf002` and resolved the conflict. I kept #1482's `winsCrossedHellos` and deference logic, and added #1483's negotiated `sessionHeartbeat`. `deferenceLapsed` now reads `sessionHeartbeat` instead of `heartbeatSettings`.
- I pushed `acbaf002` as a new frozen copy, `build/ocapn-noise-session-reconnect-crossed-hellos-acbaf00`.
- The head branch was force-pushed with a lease from `9cc41693` to `362dd9ee`, and the PR's base now points at the new frozen copy.

**Checks**
- **Local:** all `@endo/ocapn-noise` tests passed under all three ses-ava configs (112 each). `tsc` was clean and eslint gave warnings only.
- **CI:** all checks pass on `362dd9ee` and GitHub shows it mergeable. The 30 "cancelled" entries come from a superseded run.
- **One flaky failure:** `test (24.x, macos-15)` failed once on the crossed-hellos test, which saw epoch `2n` instead of `1n`. I treated it as a timing flake: #1483 doesn't change that test's behaviour, it passed 15 times locally, and it passed when I re-ran it in CI.
- I left a comment on the PR explaining the restack: https://github.com/endojs/endo-but-for-bots/pull/1483#issuecomment-6281141062

**Follow-ups**
- #1478, #1481 and #1482 also sit on outdated frozen copies of the PR below them. GitHub can't show conflicts against the newer heads, so there may be hidden ones like #1483's. The stack will need restacking from the bottom up, either now or as each layer lands.
- The crossed-hellos epoch assertion in `reconnect.test.js` is timing-sensitive on loaded macOS runners. It belongs to #1482 and may be worth widening.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `9cc41693a645a3773f15eb1eaa156302430fc5a4`; this job presented `362dd9eea9adf244b0f078d33fbf63a4b6ad77ee`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endo-but-for-bots-pr1483-ocapn-noise-heartbeat-capability-negotiation-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2568536 cached reads)
- Output: 14245 tokens
- Cost: $1.4181831999999999
- Wall-clock: 3849s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
