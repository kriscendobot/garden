CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1016 gauntlet FIX round 4 — design doc `designs/ironhorse-rejection-handling.md`.

**Panel disposition addressed:** must-fix (request-changes from critic, ergonomist, pedant, novice; plus should-fix from skeptic and decomplector). This is a design/analysis PR (single markdown file), so all fixes are prose/structure.

**What I changed (one follow-up commit `251685d39`):**
- **critic 1** — Sharpened §1's lead example to the bare-variable `ReferenceError` case the mechanism actually resolves; flagged the property-typo variant (`config.tiemout` → `undefined`, raises nothing) as an acknowledged unaddressed gap.
- **critic 2 / skeptic 1 / novice 1** — Added a §2 clarification that *no* escalate-on-unhandled-rejection is live in Ironhorse to "retire": the always-on escalator is Node's; the project already runs report-only in two places (SES `makeRejectionHandlers` default `'report'`, and `packages/daemon/src/worker.js`'s `process.on('unhandledRejection')` that only records a trace). Reframed Recommendation 1 and the ordering caution as *preventive*, not a migration. Verified all four facts against the tree (no `--unhandled-rejections=throw` anywhere; SES default `'report'`; `Halt::Unsupported("promise:handler-throw")`).
- **skeptic 2** — Added `worker.js` as a second report-only prior-art row in §4.
- **ergonomist** — Open Question 1 now requires resolving the `unwatched`-vs-shipped-`unhandledRejectionTrapping` naming split, not just the tracking mechanism.
- **pedant** — Normalized cross-reference labels to `Recommendation N` / `Open Question N`; made Open Question 2's lead a question for list parallelism.
- **decomplector** — §3 now states panels are keyed by promise identity with creation-site as a label only; hands same-site sibling disambiguation to Open Question 2.
- **novice 2–4** — Glosses for or-pattern, activation record, operand stack, computron; walked the pipelining-ownership reasoning step.
- **copyeditor** — Tense/clarity edits; dropped unanchored "consensus-relevant."
- Kept the doc em-dash-free (house style; pedant praised it) — rewrote the 15 em-dashes my edits introduced into parens/colons/periods.

**Push & CI:** Pushed via `safe-push-pr-head.sh` (advance mode, `ecf5397f2..251685d39`). Bounded CI wait returned **GREEN** (5/5 checks, 0 failed).

Stopped here without re-running the panel, per stage instructions (the driver re-posts panel-5).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1016-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (4094362 cached reads)
- Output: 27102 tokens
- Cost: $3.6033340000000007
- Wall-clock: 822s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
