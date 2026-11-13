---
handed-off: ironhorse-test262-ratchet-round3-floor-resolution-20261113
deliverable-complete: false
---
The round is not finished, so this attempt ends as a handoff. The maintainer still hasn't decided whether the historical floor may be re-pinned, and by the job's terms I can't waive that floor without an explicit yes. I did not change the branch, the PR or the floor.

**What happened**
- The weave job `weave-ironhorse-pr1359-20261113` finished just before I claimed this one. It moved https://github.com/endojs/endo-but-for-bots/pull/1359 off the frozen snapshot onto live `llm`; the new head is `5825b6c5667f`. The PR is still a draft and still carries the arc marker.
- `llm` already has the same engine fix (`25d95061b4`), so the PR now adds **0** coverage over its base. It carries only the regression test and the `refresh-20260928` evidence, and that evidence describes a branch point that no longer applies.
- Whole-corpus coverage on current `llm` is 39,860, up from 36,599 at the round-3 branch point. Nothing covered at the branch point or in round 3 was lost, and the move caused no new regressions.
- Of the 30,233 paths in the enforced `refresh-20260904` floor, **882 are still lost** (901 before; 19 have come back):

| Paths | Why they fail |
| ---: | --- |
| 443 | hit a resource limit |
| 410 | positive tests that abort on both engines |
| 19 | throw a TypeError where XS completes |
| 5 | accept strict code that XS rejects |
| 3 | script-eval declaration cases |
| 2 | Promise-finally async cases, now failing on `resolve.length` |

- The maintainer's 2026-11-13 directive ("ratchet must go up… improvement on the base, and the base may move") sets the merge rule but says nothing about that floor. The original question on #51 never got a direct answer.

**What I did**
- Posted one decision question on garden #51: https://github.com/kriscendobot/garden/issues/51#issuecomment-6850754867. The choices are:
  - **A:** re-pin the floor to a fresh `llm` measurement, recording what happened to each of the 882 paths.
  - **B:** keep the September 4 floor and first repair the real losses among the 882.
- Sent the maintainer the same summary through the liaison inbox.
- Parked the successor `ironhorse-test262-ratchet-round3-floor-resolution-20261113`, high priority, awaiting the maintainer's answer. It owns all the remaining work. It starts from the 882 paths and the new head and base, and leads with cheap fixes so the PR can show an actual gain over its base. It also covers both answers, the PR body and #51 updates, the handoff to the autopilot, and `ironhorse-ratchet.sh resume`.
- The message I sent to the weave job was dead-lettered because it had already finished. That is harmless: its report holds the information I needed.

**Still open:** the ratchet autopilot stays halted until someone runs `ironhorse-ratchet.sh resume`, and #1359 can't merge under the directive until it adds real coverage over `llm`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-round3-floor-resolution-20260928.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (836712 cached reads)
- Output: 9026 tokens
- Cost: $0.8669104000000001
- Wall-clock: 463s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
