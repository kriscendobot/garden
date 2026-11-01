**Viability for endojs/endo-but-for-bots PR #1624: proceed.** I spent no clean, panel, fix or CI budget.

**PR facts:** The PR is open, unmerged and still a draft. It was opened at 2026-11-01T17:58Z. The head is `c3f37d9e` and the base is the pinned `llm-9a14ddf` (`9a14ddf6`). The title is "fix(ironhorse-regexp): catchable storage limits and clamped quantifier bounds (test262 ratchet: +2)".

**Deciding question:** Does live `llm` still halt the crank with `HeapExhausted` when a RegExp hits its match or compile limit, and still refuse quantifier bounds above 2^31-1, with nothing landed or newer that replaces the RGX-1 item of design #1622?

**Evidence:**
- **The problem still exists on `llm`.** `rust/engine/ironhorse-vm/src/interp/natives/regexp.rs` still returns `Err(Step::Host(Halt::HeapExhausted))` at lines 349 and 557. A code search finds no "exceeds implementation limit" message anywhere in the repo.
- **No one has changed the same code since.** `llm` has no commits to `natives/regexp.rs` or `ironhorse-regexp/src/compile.rs` since 2026-10-25.
- **The design it implements is current.** Design PR #1622 ("ironhorse in-crank string garbage and the chunk ceiling") is open and was written today. Its RGX-1 point is exactly this PR's scope. The safepoint-collection half is deliberately left out until the maintainer answers the design's open question.
- **The closest related PR does not replace it.** #1364 ("make resource-limit aborts configurable") is a different approach. It is an unmerged draft, last updated 2026-09-29, that adds a policy setting for turning all resource-limit halts into `RangeError`s. It does not clamp quantifier bounds or fix the `{m,n}` order SyntaxError. Searches for other RegExp limit or quantifier PRs found nothing besides #1624 and #1622.

Both claims hold: the PR has not been superseded, and the halting behavior that motivated it is still on `llm`.

**Follow-up:** #1364 and #1624 change the same behavior in different ways: #1364 makes it a policy setting, while #1624 makes the RegExp case always throw. Whichever lands second will need to be reconciled with the other. The panel should keep that in mind; it does not block starting the gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1624-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (240510 cached reads)
- Output: 2221 tokens
- Cost: $0.469738
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
