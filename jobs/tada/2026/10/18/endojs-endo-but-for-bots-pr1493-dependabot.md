I closed endojs/endo-but-for-bots#1493 as REJECT. The job's Node-engine proof checks out, but it isn't the reason for the verdict: the bump didn't create the mismatch, so I ruled on red CI instead.

**The proof:** I re-checked it against the live head `b5e5cbfaf0`. The root `package.json` declares Node `^20.17.0 || >=22.9.0`, and `pi-agent-core@1.1.0` requires `>=22.19.0`, exactly as the job said. But the outgoing 0.87.1 already requires `>=22.19.0`, and so do 0.85.0 through 0.87.0. The repo already depends on a version with this mismatch. Closing on that ground would reject every future bump of the package, which is what happened to #1441 (`pi-tui`). So I did a lighter version of the full review instead.

**Why it's rejected:**
- The PR moves only `pi-agent-core` to 1.x. `pi-ai`, `pi-coding-agent` and `pi-tui` stay on `^0.87.1`, so the lockfile ends up with two copies of `pi-ai` (0.87.1 and 1.1.0).
- CI is red because of that split (run 39161517382):
  - `lint` fails with a type error (`TS2322 StreamFn`) at `packages/agentry/src/harness/pi-agent.js:82` and in the `lal` tests.
  - `@endo/lal` fails 12 tests on `test (24.x)` and `cover`.
- Fixing it means upgrading the whole pi family to 1.x together and adapting the `agentry` code. That is its own change across several packages, so it can't be patched onto this PR.
- I skipped the source and advisory read because the red CI already decides it.

**What changed:**
- **Verdict comment** posted with the reasons, the evidence, and when to reopen: https://github.com/endojs/endo-but-for-bots/pull/1493#issuecomment-6255194262. The PR is now CLOSED (checked).
- **Ledger:** entry added at `entries/2026/10/18/211128Z-message-botanist-f8638e.md`, under `project: endo-but-for-bots`.

**Follow-ups posted:**
- **`dependabot-node-proof-outgoing-baseline`** (fixer, on the board now): fixes the watcher so it only claims a Node-engine incompatibility when the bump itself raises the floor, with the same rule considered for peer ranges.
- **`endo-but-for-bots-pi-family-1x-upgrade`** (builder, parked until you say go ahead): upgrades all four pi packages to 1.x in one PR and gets CI green.

**Decision for you:** carried over from #1441. Every pi version needs Node 22.19 or later, but the root still declares support from 20.17. Either give these packages their own Node floor or raise the root floor. The parked upgrade plan notes that this choice affects it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1493-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2285093 cached reads)
- Output: 14533 tokens
- Cost: $1.4797185999999998
- Wall-clock: 237s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
