FIX round 1 complete for PR #1016.

**What I did:** Applied the design panel's round-1 review to `designs/ironhorse-rejection-handling.md` (a design-only doc PR), pushed one review-feedback follow-up commit (`0260a6fea`) to the PR head `endojs/endo-but-for-bots:design/ironhorse-rejection-handling`, and watched CI to terminal.

**Must-fix items applied:**
- **skeptic** — Added an explicit paragraph in section 2 stating plainly that panic-on-reference-error is opt-in/on-demand while the displaced unhandled-rejection timeout was always-on, so an unattended worker still swallows the bug when unarmed; the residual gap closes only via the recommended always-on tracker (scoped as load-bearing, not optional).
- **ergonomist** — Named the unwatched-rejections panel's attribution point (creation-site line/column, matching its pending-promises sibling); added guidance to Open Question 1 that the follow-on's report/API surface read "unwatched", not "unhandled".
- **pedant** — Full em-dash pass per the em-dash-style skill (verified zero `—` remain); replaced the U+2192/U+21D2 arrows with ASCII `->`/prose; numbered all top-level headings consistently (1–6); sentence-cased "Open questions".
- **novice** — Defined Ironhorse (Rust reimplementation of XS) in the intro, glossed `Halt` at first use, and named the XS/Ironhorse relationship where XS is first cited.

**Should-fix items applied:** decomplector (conceded recommendation 3's terminal-boundary criterion is still an inference, distinguished from Node's timer by degree + non-fatal consequence); copyeditor (reconciled "escalate-on-unobserved-rejection" → the single coined "escalate-on-unhandled-rejection"; introduced "TDZ" at first use; dropped the undefined "row" referent; recast the split distinguish-X/Y list as one clause).

**CI:** GREEN — all 5 checks pass (build, lint, test, browser-tests, zizmor); `ci-wait-merge.sh` returned rc 0.

**Follow-ups:** none for this stage — the driver re-posts panel-2. The doc itself names two future jobs (`design-ironhorse-rejection-tracker`, a debugger data-plumbing build job) as its own Open Questions; those are out of scope here.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1016-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 56 tokens (2221776 cached reads)
- Output: 30806 tokens
- Cost: $2.775877
- Wall-clock: 564s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
