# book-ch7 completion report

Chapter 7, "Procedures and workflows", is written and landed on `origin/journal2` as `projects/garden-book/ch7-procedures-workflows.md` (938 lines). I landed it with `scripts/jobs/land-journal-edit.sh`, then fetched `journal2` and checked that the file is there. Nothing changed on `main2`.

**Contents:**
- **7.1 The supervised-script principle:** scripts handle control flow and the model is used only for judgment calls; `garden-pr.sh` and `sense.sh`.
- **7.2 The gauntlet, end to end:** a table mapping the skill's stages (build → assayer → cleaner → panel → fixer loop → appellate → un-draft) onto the real stage jobs run by `gauntlet.sh` (viability, clean, panel-k, fix-k, undraft). It also covers:
  - how `ensure-pr.sh` finds or creates the single PR, and why every PR opens as a draft;
  - the stage-result transition table and the three bounded retry limits;
  - variants, the next-stage-owed heuristic, and the terminal PR comment.
- **7.3 The panel:** how it tells code from design, the empty-diff short-circuit, the real seat lists, the per-seat verdict block and the rule that every finding must cite a rule or propose one, the buckets and five dispositions, the "no in-scope must-fix" exit condition, the appellate pass, and the durable `panel-runs/` record.
- **7.4 Orchestration:** when to use it instead of `blocked_on`, serial vs. parallel, the failure policy, and halts that resume themselves. The worked lifecycle example is this book's own `garden-book-orch` record, from parking children through to the `blocked_on` assemble/publish job.
- **7.5 Chained follow-ups:** the D→N→F pattern, anchoring choices, and why an orchestration can't express this case.
- **7.6 The ferry:** why it stays off the board, `scripts/ferry.sh` and the `jobs/ferry/` lifecycle, the maintainer-only `identity_switch_authorized` field, the host checks the boatman runs, and what the boatman does.
- **7.7** a decision table for choosing a procedure, plus a quick reference of the scripts.

**Where the chapter departs from the job brief:**
1. **The manual gauntlet trigger is no longer in force.** The brief describes `run the gauntlet #N` as the sole ordinary trigger. `designs/manual-gauntlet-trigger.md` was superseded on 2026-09-29 (commit `18df481c04b`), which restored the automatic handoff in a narrower form. The chapter tells that history (automatic → manual → narrower automatic), describes the guards that survived, and keeps `run the gauntlet #N` as the explicit trigger.
2. **Seat counts disagree between the docs and `panel.sh`.** The skill files give conflicting numbers (~29, 31 or 33 code seats; 7 or 9 design seats). The chapter uses `panel.sh`'s defaults, 33 code seats and 9 design seats, and says the prose has drifted.
3. **"Should-fix" is a bucket, not a disposition.** The chapter explains that `summary-fix` is that bucket's default disposition.
4. **The assayer has no separate stage in the staged driver.** It runs alongside the build by default, and the chapter says so.

**Follow-ups (not done here):**
- The seat counts in `skills/pr-creation-flow/SKILL.md`, `skills/panel/SKILL.md` and `skills/panel-review/SKILL.md` need correcting to 33 and 9.
- `designs/gardening-state-machine.md` § Build handoff invariant still names the builder gauntlet base `<build-base>-gauntlet` and says the hook "force-drafted" PRs. That wording is historical and could use a dated note.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-ch7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2749478 cached reads)
- Output: 28026 tokens
- Cost: $2.1748876000000004
- Wall-clock: 356s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
