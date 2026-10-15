I've finished checking the PR, and the answer is `overtaken`: the unified-browser design it proposes was meant to land before any browser backend existed, and the Playwright backend has since shipped with a different shape.

# Viability gate: endojs/endo-but-for-bots PR #359

**Result: `viability=overtaken`.** I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** The PR is open, not merged and not a draft. Its title is "design(endoclaw): pinchtab plugin with coherent Exo interface alignment to endoclaw-browser". The head is `24e5fdf` (branch `design/endoclaw-pinchtab`) and the base is the frozen branch `llm-b1c3f4d`. It changes `designs/endoclaw-pinchtab.md`, `designs/endoclaw-browser-interfaces.md` and `designs/README.md`.

Deciding question: Is the Playwright `Browser` design (`endoclaw-browser.md`) still unbuilt, so that this PR's "agree one browser interface before either backend is built" proposal can still land first?

Evidence:
- **The PR depends on both backends being unbuilt.** Its "Decisions" section says to unify the `Browser` shape before either backend is implemented, because "Both designs are unimplemented; this is the cheapest moment to land the contract". `endoclaw-browser-interfaces.md` (lines 369 and 379) bases its "revise `endoclaw-browser.md`" recommendation on the same assumption.
- **That is no longer true.** PR #106, "feat(daemon): Browser exo with structural origin allowlist", merged into `llm` on 2026-06-15, about three weeks after #359 was opened on 2026-05-22. It shipped as the `@endo/exo-playwright` package (`packages/exo-playwright/src/browser.js`). On `llm`, `designs/endoclaw-browser.md` now has the status "PR #106 (`@endo/exo-playwright`)".
- **The shipped interfaces differ from the ones this PR proposes.** The shipped `Browser`, `Page` and `BrowserControl` Exos use CSS selectors (`textContent`, `fill`, `click` and `submit` take a selector string) and have no `setMaxConcurrentPages`. This PR's base interface assumes ref-based targeting and a page-cap control. So the interfaces doc would now be redesigning a released API, not settling a contract up front.
- **The PR's base is out of date.** The frozen base `b1c3f4d` predates the #106 merge and is 4,219 commits behind `llm`. Nobody has updated the PR since the round-1 gauntlet panel on 2026-09-27, where 7 of 8 seats requested changes (disposition must-fix). Those findings dealt with internal consistency and never examined the stale premise.
- **What still stands:** I found no other PR or design covering PinchTab, so wanting a PinchTab backend may still be valid. That idea would need a fresh design written against the shipped `@endo/exo-playwright` interfaces, not this PR's pre-implementation unified base.

Option: close as superseded

What changed: nothing. This was a read-only gate, with no commits, pushes or PR comments. If a PinchTab backend is still wanted, the follow-up would be a new design job that starts from the shipped `@endo/exo-playwright` interfaces.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr359-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (261788 cached reads)
- Output: 3565 tokens
- Cost: $0.4651136
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
