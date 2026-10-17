## PR #1482, panel round 5: must-fix

I ran one single-round panel on endojs/endo-but-for-bots#1482 at head `e8832141bf`, against base `4d8b59b6ed` (the stacked base `build/ocapn-noise-session-reconnect-rekey-4d8b59b`). `panel.sh` exited 0, and all 34 seats ran without error. The verdict is must-fix.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1482#pullrequestreview-5557475322. It is a COMMENTED review, the same shape as rounds 1–4, and is 60.7k characters to stay under GitHub's size limit. To fit, the 10 approving seats' bodies were left out, and so were 5 comment-only seats (changeset-auditor, scribe, corner-prober, fast-checker, coverage-auditor). The review carries the marker `<!-- garden-panel-verdict: must-fix round=5 -->`.

**What drove must-fix:**
- **decomplector (request-changes):** The mechanism that makes the winning side wait for its own dial before accepting the peer's has drawn must-fix findings for three rounds running. It relies on mutable state plus a `Date.now()` time limit, and the decomplector says it should be removed. The base already had a simpler rule, where only the initiator redials (`if (isInitiator) scheduleRedial(0)`), and this PR deletes it. The decomplector also flagged, as should-fix:
  - The code and design § 3 now disagree, and the PR calls this a "deviation" rather than a design decision.
  - The responder now accepts any epoch above its own, so an authenticated peer sending a far-future epoch can stall its own session.
- **pruner (request-changes):** The new design-doc `## Status` section repeats what the README and code comments already say. The PR body is 333 words, over the 300-word limit.
- **Pre-checks:**
  - The phase/evidence check came back BLOCKED (`missing-design:designs/README.md`), which forces must-fix on its own.
  - The repeated-mechanism check fired on the earlier rounds at heads 6cace22a and 77b8ed83.

**Possible fault in the phase/evidence check:** while producing that BLOCKED result, `scripts/jobs/gardening/phase-evidence-gate.sh` logged `xargs: unmatched single quote`. Some of its `xargs` calls (lines 271, 273, 287, 289) don't suppress errors, so a quote character in the PR body or design text breaks the field parsing. The BLOCKED result may therefore be partly wrong. I noted this in the review but didn't open a fix job; it's worth one. The verdict would be must-fix either way, because two seats requested changes.

I didn't make any garden commits.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1482-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (923324 cached reads)
- Output: 6077 tokens
- Cost: $0.8511968
- Wall-clock: 205s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
