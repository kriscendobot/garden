I ran panel round 4 on endojs/endo-but-for-bots#1431 and it came back **must-fix**.

**What I did**
- **Checkout:** got an isolated checkout of the PR head (`endojs`/`design/hardened-text-codecs-encapsulation`, head `32c1368078de`).
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's base, `llm-fda1ff5` (`fda1ff55233b`). It ran as a design panel. All 9 seats returned ok, and `panel.sh` exited 0 with disposition `must-fix`.
- **Review posted:** I posted the full aggregate to the PR. It went up as a COMMENTED review, not request-changes, because GitHub won't let the bot request changes on its own PR. The body's header line says "must-fix".

**Verdicts by seat**
- **Request changes:**
  - **novice** raised the two must-fix items:
    - Superseded and "Revised" notes are layered over the original text, which still reads as the main statement of the approach. It should be rewritten in place.
    - The adopted remedy only appears after about 100 lines of evidence and rejected alternatives. It should be summarized first.
  - **skeptic** wants the threat boundary for the "unreachable" claim stated, the cost of the unconditional replacement weighed, and Node's internal `.constructor` readers checked.
  - **decomplector** wants `encapsulateHostConstructor` split into a pure maker plus a codec-side installer that owns the `WeakSet` and the frozen-prototype throw.
  - **pedant** wants the `§` symbols replaced with plain ASCII.
- **Comment only:**
  - **critic** wants a test that the replacement has exactly the own keys `length`, `name` and `prototype`. It also flags the residual host-constructor exposure risk and questions shipping the codec change without the URL fix.
  - **ergonomist** wants SES's taming error messages to point at the docs, and the "Calling … as a function" message wording made consistent.
- **Approve:** copyeditor, orthographer, thesaurus.

**Follow-ups:** the gauntlet's next fix-loop stage should handle these findings, mainly the restructuring novice asked for. I didn't change any code in the PR or in the garden.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (496361 cached reads)
- Output: 3016 tokens
- Cost: $0.6036002
- Wall-clock: 192s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
