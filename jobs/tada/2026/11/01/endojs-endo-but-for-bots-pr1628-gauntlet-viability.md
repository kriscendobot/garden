PR #1628 can enter the gauntlet: it is open, has not been superseded, and the reason it was opened still holds.

**Deciding question:** Does the current stack or `llm` already test, on a real daemon, removal and revocation that a crash interrupts after the `Removing` / `Revoking` journal record, while design #1558 still requires that coverage?
**Answer:** No, nothing covers it yet, and the design still requires it.

**Evidence:**
- **PR state:** #1628 is OPEN, a draft, and not merged. It was opened 2026-11-01T18:50Z, changes one file (`packages/exo-agent-factory/test/daemon.test.js`, +123/−2), and has no comments or reviews yet.
- **Base:** it sits on the frozen base `build/exo-agent-factory-real-daemon-infer-crash-cut-a5b9c94` (the #1627 stack). It is 1 commit ahead and 0 behind, so it is not stale against its base.
- **Base coverage:** the base's `daemon.test.js` only covers revocation and removal that finished before a restart (lines 227 and 251) and the crash inside `infer` (line 376). It has no test where a crash interrupts `Removing` or `Revoking`, which is the gap this PR fills.
- **Design still asks for it:** `designs/endo-child-agent-factory.md` on the base still lists both rows under § Verification. Line 678 is the crash at each step of `revokeDerived`; line 683 is a runner restarted during a removal retry. Design PR #1558 is still open and not a draft.
- **No newer replacement:** the `exo-agent-factory` package isn't on `llm` yet (`daemon.test.js` returns 404 there). The whole stack (#1560–#1564, #1625–#1628) is still open, and none of the other PRs that matched a search for "exo-agent-factory crash" covers these two rows.
- **Stack note:** it depends on #1627, which is open and a draft. That is a merge-order dependency, not a reason it has been overtaken.

I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1628-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180433 cached reads)
- Output: 1883 tokens
- Cost: $0.4430026
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
