# Fix round 5 for endojs/endo-but-for-bots#1574 is pushed and CI is green

I applied the panel-5 review (review 5663313840) as one follow-up commit, `f5eb768836`, on `design/api-key-agent-workbench`, and refilled the PR body. CI finished green: all 30 checks passed and none failed. The job carried no pre-pass block, so I worked from that latest panel review.

**Must-fix items:**
- **Pause bound (critic 1, copyeditor 1):** the spend allowed after a default `pause` is now a formula, worked out per budget period. It is the sum over periods of `C_p - S_p` plus any upstream overrun:
  - `C_p` is the paused grant's effective cap at the last admission before the pause.
  - `S_p` is the spend already settled at that admission.

  The text also says exactly how `resize` and a period reset affect the bound. This removes the self-contradicting sentence.
- **Opening for new readers (novice 1):** added a "Terms, and the picture in five sentences" paragraph after the problem statement.
- **Reuse inventory (novice 2):** moved it after the capability graph. It now opens by naming the four rows the design rests on, and the graph has a caption saying how to read it.
- **Budget section (novice 3):** added a numeric walkthrough with a parent, two children, admissions, the reserve, a pause and a revoke. Serialization now has its own subsection, "Serialization and the broker lease".
- **PR body (integrator 1):** refilled section by section in template order, with Compatibility and Upgrade as separate sections. It also covers two should-fixes:
  - It states that the PR is stacked on #1543 and depends on two parts of that design: its usage ledger and its phase 5 responder.
  - It links the companion design through kriscendobot/minion.town#228. That file isn't on minion.town's `main` yet.

**Should-fix items also addressed:**
- **Broker lease (critic 3, skeptic 3):** it now names the daemon and vat incarnations. A lease left by a crashed daemon is taken over at once, with no timeout. The per-entry cost is stated, and the text says who lands the edit to #1543 and what happens if #1543 merges without it.
- **Parent reserve (critic 2, skeptic 2):**
  - When a descendant's spend overruns into an ancestor's reserve, the broker now pauses that subtree automatically (`pausedBy: 'reserve'`), so a runaway stops without anyone acting.
  - A reserve at or above the budget is refused with `reserve-exceeds-budget`, and the default reserve is capped at half the budget.
  - The doc now states that a grant's own turns are recorded under its own `grantPath`.
- **Forwarded authority (critic 4, novice 5):** the explanation of why there is no endowment filter moved after the budget mechanism. Whether one agent may spend another's grant by forwarding it is now open question 6.
- **Read-only child workbenches (critic 5):** a write-tier workbench now also gets a read-only companion facet, so a parent can always hand a child a read-only workbench.
- **Interface (ergonomist 1–5):**
  - `DelegationSummary` now has `limits` (as recorded) and `effectiveLimits`, plus `transient` and a precedence order for `blockedBy`. The `verbose` flag is gone.
  - Added `getControl(name)`.
  - A table of what each method does on a revoked delegation now goes into `help()`.
  - A second `grant-workbench` replaces the first; a second `grant-spawner` is refused with `spawner-exists`.
- **Prose (copyeditor 2–8):** fixed. Each design claim based only on reading the code is now marked unverified where it appears (skeptic 5).
- **Tests (skeptic 4, 7; copyeditor 6):** the W3 and W4 test lists are now bullets. New tests cover:
  - pause, then resize up, then resume;
  - a grandchild resize after a stale recorded limit;
  - lease takeover after a crash;
  - the reserve refusal and its cap;
  - the automatic pause on reserve overrun;
  - replacing a workbench grant;
  - `getControl`.

**Not changed:** comment-only items (splitting off W5, tool naming, scope) and skeptic 1. On skeptic 1, the integrator found that the README rows are already present.

**Follow-ups:**
- The automatic reserve pause and the read-only companion facet are new mechanisms added in this round, so the next panel should look at them.
- Panel-6 is re-posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2874230 cached reads)
- Output: 24576 tokens
- Cost: $1.9680220000000004
- Wall-clock: 684s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
