CI is green (rc 0). Fix stage complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1016-gauntlet-fix-3 — gauntlet FIX round 3 for PR #1016 (`designs/ironhorse-rejection-handling.md`, a design/analysis doc).

**What I did:** Read the panel round-3 verdict (disposition: must-fix) and applied all blocking and should-fix items in one follow-up commit (`ecf5397f2`) pushed to the endojs PR head via `safe-push-pr-head.sh`.

**Changes applied:**
- **critic (blocking):** The residual-gap argument was self-contradicting — §1's lead example is a *synchronous* `try/catch`, but recommendation 3's tracker accounts only for promise rejections and can never observe it. Rewrote §2's caveat to state honestly that the synchronous-swallow class has no always-on net today and never did (Node's timeout never saw it either), and that the always-on swap holds only for the *rejection* manifestation. The armed panic is honestly named as the only tool for the synchronous case.
- **ergonomist:** Added an up-front glossary mapping "unwatched" (this doc) to the sibling docs'/XS oracle "unhandled"; reworded §3's "does not cry wolf" from an accomplished property to an open requirement (ties to §5 OQ4).
- **novice:** Glossed CapTP / vat / far side at first use; split the dense recommendation-3 paragraph into four; removed the forward reference to "recommendation 3" by naming its substance inline.
- **skeptic:** Fixed the opcode match-arm identifiers (`XS_CODE_GET_VARIABLE | XS_CODE_GET_THIS_VARIABLE`, `XS_CODE_GET_LOCAL_1 | XS_CODE_GET_LOCAL_2`, verified against `interp.rs`); added reconciliation with existing SES prior art (`makeRejectionHandlers`, verified present and `lockdown`-wired) to Open Question 1 and the Dependencies table.
- **decomplector:** Encoded the tracker precondition into recommendation-1's list item itself; disambiguated the batch terminal-boundary report from the live debugger panel.
- **copyeditor:** Glossed "crank" at first use; clarified the `config.tiemout` example.
- **pedant:** Dropped the `designs/` prefix from the sibling `ironhorse-panic.md` cite.
- Cleared all 11 em-dashes I introduced (repo forbids them) back to periods/colons/parentheses per the em-dash-style rule.

**Result:** Pushed `0260a6fea → ecf5397f2`; CI terminal GREEN (5/5 checks, 0 failed). Stopped without re-running the panel (driver re-posts panel-4).

**Follow-ups:** none — the critic's out-of-scope "timer vs microtask-checkpoint" metaphor note was explicitly non-blocking and left for a follow-on design; the SES prior-art reconciliation and CapTP-handoff observability remain the follow-on `design-ironhorse-rejection-tracker`'s open questions, as documented in §5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1016-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 90 tokens (3529341 cached reads)
- Output: 28040 tokens
- Cost: $3.370570500000001
- Wall-clock: 863s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
