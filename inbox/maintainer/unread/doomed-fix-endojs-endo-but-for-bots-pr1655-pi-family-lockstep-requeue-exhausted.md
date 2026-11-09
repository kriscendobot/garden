from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-09T02:23:50Z
doom_base: fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-09T02:23:50Z
last_seen: 2026-11-09T02:23:50Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep; it stays HELD until a human promotes it
(promote-plan.sh fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep) or removes it, so nothing is lost.
Original job base: fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep

--- original job body ---
---
posted_at: 2026-11-08T20:23:25Z
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# fixer: lockstep @earendil-works/pi-* family bump for endojs/endo-but-for-bots PR #1655

Repo: endojs/endo-but-for-bots (base `llm`). PR: https://github.com/endojs/endo-but-for-bots/pull/1655
(dependabot, `@earendil-works/pi-ai` 0.87.1 -> 1.4.0). Sibling: https://github.com/endojs/endo-but-for-bots/pull/1657
(dependabot, `@earendil-works/pi-coding-agent` 0.87.1 -> 1.4.0). Escalated by botanist job
`endojs-endo-but-for-bots-pr1655-dependabot` (next: fixer).

Diagnosis (already done, do not re-derive): #1655 moves only pi-ai, so `@earendil-works/pi-agent-core@0.87.1`
(still `^0.87.1` in agent-tools, agentry, lal) keeps its own nested pi-ai 0.87.1 copy. Lint fails in
`lint:types` for @endo/agentry, @endo/lal, @endo/daemon with TS2322 at
`packages/agentry/src/harness/pi-agent.js:82` (pi-ai 1.4.0 `streamSimple` not assignable to pi-agent-core
0.87.1 `StreamFn`), plus the same in `packages/lal/test/pi-agent-tools.test.js:204` and
`packages/lal/test/smallcaps-footgun.test.js:152,237,285,487`. Runtime is also at risk because agentry registers
providers into the 1.4.0 copy's registry while pi-agent-core holds 0.87.1 types/helpers.
CI run: https://github.com/endojs/endo-but-for-bots/actions/runs/42517897642

Task: move the pi family in lockstep so one pi-ai copy resolves: bump `@earendil-works/pi-agent-core` (1.4.0
pins `pi-ai: 1.4.0` exactly) and `@earendil-works/pi-coding-agent` to ^1.4.0 alongside pi-ai (pi-tui is already
^1.4.0 on llm). Absorb any pi-agent-core / pi-coding-agent 1.x API changes in agent-tools, agentry, and lal.
Decide whether to land it on #1655's head (then #1657 becomes REJECT-superseded) or as a combined PR. Run
`yarn lint:types` for agentry/lal/daemon plus their tests locally before pushing. Every new or moved version you
add must clear botanist diligence (maturity floor of 7 days past the freshest moved version, OSV/GHSA clean,
no install scripts). pi-agent-core 1.4.0 was published 2026-10-21T22:43Z. Optionally propose a dependabot
`groups:` entry for `@earendil-works/*` so the family is proposed together in future; that is a project
decision, so put it in a separate commit or comment.

On completion, notify the backstop recheck: the dependabotany daily sweep for endojs-endo-but-for-bots renders
the terminal verdict on #1655 after your repair lands.
