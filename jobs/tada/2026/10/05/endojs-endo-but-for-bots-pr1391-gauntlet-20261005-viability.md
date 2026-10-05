Verdict: PR #1391 should go ahead to the gauntlet. It hasn't been superseded and the maintainer's reason for it still holds. I used no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** endojs/endo-but-for-bots#1391, "feat(ses): permit and share a pre-lockdown SturdyRef shim". It is OPEN, a draft, not merged, and GitHub reports it MERGEABLE. The head is `14381fc8f5`. The base is the frozen `build/sturdyref-shim-first-wins-ef4662f`, a snapshot of layer 1 (#774). The PR was last updated 2026-10-05T10:36Z.

Deciding question: Is #1391 still the only, not-yet-landed implementation of item 2 (SES permits and shares a pre-lockdown `SturdyRef` global) in kriskowal's 2026-09-30 SturdyRef directive on #695, with that directive still standing?

Evidence:
- **Not on `llm` yet:** `packages/ses/src/permits.js` on `llm` has no `SturdyRef` entry. There is no `packages/sturdyref` on `llm`. No commit on `llm` since 2026-09-29 mentions SturdyRef or enliven.
- **No rival implementation:** a search of all SturdyRef PRs turns up no other PR that implements the SES permit. The open PRs are the nine-layer stack (#774 layer 1, #1391 layer 2, #1392–#1399 for layers 3–9 and a related fix), plus older pre-layering work (#695, #697, #698, #700–#704, #737, #871).
- **The directive still stands:** kriskowal's directive (https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512) asks for exactly this as item 2. They added nothing after it except a 2026-09-30 note asking to tie the effort to a garden arc. The work is organized as the serial orchestration `ebfb-sturdyref-layering-20260930`, tracked on kriscendobot/garden#47.
- **Still being worked:** the stack is active. #774 got fix round 2 today (head `63e488be40`). #1391 got a follow-up at 10:36Z today that fixed the `daemon-teardown` macOS race and confirmed the round-2 panel items are present.

Follow-ups:
- **Possible weave:** #774's head has moved from `ef4662f` to `63e488be40`, so #1391's frozen base may now lag layer 1. If the panel needs #774's latest commits underneath this PR, it will need a weave onto a new snapshot of #774. That concerns ordering, not viability.
- **Two halts already:** earlier gauntlets on this PR (2026-09-30 and 2026-10-03) both halted on a declined fix stage with CI red. Expect the maintainer may need to step in again if the same items come back.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (237963 cached reads)
- Output: 2392 tokens
- Cost: $0.5005605999999999
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
