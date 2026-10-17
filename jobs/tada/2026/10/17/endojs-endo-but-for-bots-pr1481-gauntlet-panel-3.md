**Panel round 3 on endojs/endo-but-for-bots #1481: must-fix**

- **Run:** I ran `panel.sh` once in single-round mode against an isolated checkout of the PR head (`d54a92677a`). For the base I passed the PR's real base SHA, `2a16357eaa`, which is the frozen base `build/ocapn-noise-session-queue-2a16357`. It exited 0 with disposition `must-fix`. All 34 seats returned `ok`.
- **Request-changes seats (6):**
  - **typist:** four multi-field typedefs are defined inline in `network.js` and should move to `types.d.ts`; `SessionHello` copies the codec's record shape by hand.
  - **archivist:** request-changes.
  - **pruner:** request-changes.
  - **corner-prober:** request-changes.
  - **coverage-auditor:** request-changes.
  - **decomplector:** the new `op:session-hello` wire record is sent unconditionally; the `op:session-end` rule covers only part of the case; and it is the same mechanism again after three rounds of patches.
- **Other seats:** 18 were comment-only and 10 approved. One comment-only note worth carrying into the fix: the assessor found that `redial`'s connect has no timeout and the reconnect outbound queue has no size limit (both should-fix).
- **Review posted:** review [5556186854](https://github.com/endojs/endo-but-for-bots/pull/1481#pullrequestreview-5556186854) on the PR, starting "Panel round 3 — must-fix". It went up as COMMENTED, not REQUEST_CHANGES, because GitHub won't let the bot request changes on its own PR; rounds 1 and 2 were posted the same way.
- **Trimmed to fit:** the full aggregate is about 96 KB, over GitHub's 65,536-character limit for a review body. The review includes every request-changes and approve seat in full, plus as many comment-only seats as fit. It lists the 10 comment-only seats that didn't fit (breaker, spec-keeper, wire-watcher, engine-realist, integrator, duality-auditor, changeset-auditor, scribe, fast-checker, releaser); their full text is in the panel record.

I made no fixes, didn't un-draft, and committed nothing to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (716296 cached reads)
- Output: 4553 tokens
- Cost: $0.6925592
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
