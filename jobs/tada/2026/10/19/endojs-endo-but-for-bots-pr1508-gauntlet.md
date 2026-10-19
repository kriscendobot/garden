gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1508
# gauntlet endojs-endo-but-for-bots-pr1508-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1508 still the only live implementation of Phase 1 of `designs/ocapn-noise-session-reconnect.md`, with nothing that already delivers `op:ping`/`op:pong` plus the heartbeat on a path to merge? **No.** Option: close as superseded.

## Viability report

**Viability result: overtaken.** PR #1508 is the third implementation of session-reconnect Phase 1, and an earlier implementation of that phase has already passed review. This check spent no budget on clean, panel, fix, CI-wait or un-draft.

**PR facts:** #1508 is open, unmerged and still a draft. It was opened 2026-10-19 at 21:08Z with base `llm-92b91a7` and head `88fb7ea1b9`. The job that built it is `build-ocapn-noise-session-reconnect-phase-one`, and its body describes it as "phase 1 of `designs/ocapn-noise-session-reconnect.md`". It has no reviews and no comments.

Deciding question: Is #1508 still the only live implementation of Phase 1 of `designs/ocapn-noise-session-reconnect.md`, with nothing that already delivers `op:ping`/`op:pong` plus the heartbeat on a path to merge? **No.**

Evidence:
- **#1476** (opened 2026-10-16, job `endo-but-for-bots-ocapn-noise-session-reconnect-build`) implements the same Phase 1. It adds the `op:ping`/`op:pong` operations in `packages/ocapn/src/codecs/operations.js` and a heartbeat in `@endo/ocapn-noise`.
  - It went through six garden panel rounds; round 6 passed with CI green.
  - Its gauntlet ended as `held-draft`: the code panel passed, but the phase ledger withheld un-draft.
- **The later phases build on #1476's line, not on #1508:**
  - #1478 is Phase 2, the session queue.
  - #1481 is Phase 3, reconnect with Rekey.
  - #1482 is Phase 5, crossed hellos.
  - #1483 negotiates the heartbeat capability and turns heartbeats on by default. It names #1476 in its Refs line, and its panel also passed (`held-draft`).
- **#1502** (opened 2026-10-19 at 11:57Z) is an earlier copy of this same approach: same title, same `heartbeat.js` and `Uint64Codec` files. Its gauntlet was already halted at this stage as overtaken.
- **#1508 duplicates #1502 file for file.** It adds an opt-in heartbeat in `packages/ocapn/src/client/heartbeat.js` that the existing Phase 2–5 stack and the capability PR do not use. Merging it would put a second, competing `op:ping`/`op:pong` wire definition alongside #1476's.
- **The underlying need does still hold.** The base branch `llm` has no `op:ping`/`op:pong` yet, and the design is still `Proposed`. That need is already met by #1476 and its stack, not by #1508.

Option: close as superseded

Nothing in the garden library changed and nothing was pushed. One follow-up for the maintainer: the build pipeline has now produced three Phase 1 PRs (#1476, #1502, #1508), so `build-ocapn-noise-session-reconnect-*` jobs may be getting re-posted under different basenames. #1502 is another candidate to close as superseded.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1508-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156105 cached reads)
- Output: 2276 tokens
- Cost: $0.42043699999999995
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
