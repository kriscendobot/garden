**PR #1398 viability report: `viability=proceed`**

**PR facts:** endojs/endo-but-for-bots#1398, "feat(daemon): layer 8 — a SturdyRef for a formula without incarnation". It is OPEN, a draft and not merged. The head is `build/sturdyref-daemon-formula` @ `289b48d4`. The base is `build/sturdyref-ocapn-enliven-0e0b333`, a frozen snapshot of layer 7's head, at `0e0b333c`.

**Deciding question:** Is the daemon-side "mint a SturdyRef for a formula without incarnating it" layer still a live, unsuperseded part of the SturdyRef layering stack the maintainer asked for?

**Answer: yes.**

**Evidence:**
- **The maintainer still wants this stack.** On 2026-09-30, kriskowal commented on #695 asking to set that design aside until the SturdyRef layering progresses. They asked for a SturdyRef shim and the layers built on it, tied to a garden arc. #1398 is layer 8 of 9 in that orchestration (`ebfb-sturdyref-layering-20260930`). The arc, kriscendobot/garden#47, is still OPEN.
- **The surrounding stack is still open and active.** Layers 1 and 3–7 (#1389, #774, #1391–#1394, #1396, #1397) are all OPEN and were updated between 10-03 and 10-05. Layer 9 (#1399) is stacked directly on this PR's head (base `build/sturdyref-daemon-formula-8b57a39`).
- **Nothing has replaced it on `origin/llm`.** `packages/daemon/src/formula-sturdyref.js` does not exist on `llm`. The only `packages/daemon/src` commits on `llm` since 09-29 are unrelated `endo.pid` ready-signal fixes. The older SturdyRef PRs (#541, #701–#704) are cited in the PR body as prior art and are not merged, so they don't displace it.
- **Its premise still holds.** The layer is daemon-core-internal and deliberately avoids #695's open confinement and retention questions, which is consistent with the maintainer deferring #695.

**Earlier gauntlets didn't finish:**
- **First gauntlet (`…pr1398-20260930-gauntlet`):** halted at the clean stage.
- **Second gauntlet (`ebfb-sturdyref-layer8-…-20260930-gauntlet`):** ran one panel round, which returned a must-fix verdict. Its fix stage was then doom-parked with the failure classified as unknown. CI is red at head `289b48d4`.

Those are execution failures, not signs the work is obsolete. The new gauntlet should pick up from the round-1 must-fix findings.

I made no changes and spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (229459 cached reads)
- Output: 2450 tokens
- Cost: $0.47257180000000004
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
