CI is fully **GREEN** — all 5 required checks SUCCESS, no pending, no failures, `mergeState: CLEAN`. The fix stage is complete.

---

## Completion report — FIX round 4, endojs/endo-but-for-bots PR #1116

**What I did:** Applied the panel-4 (`must-fix`) verdict to the `design/guest-native-invitations` design doc, pushed as review-feedback follow-up commits, and watched CI to a green terminal.

**Changes (commit `efe631f749`, "design: address panel round 4"):**
- **Consume-once serialization (critic/skeptic/decomplector/novice):** Replaced the nonexistent "pet-store single-writer job queue" with the real mechanism — a new synchronous compare-and-set (`storeLocatorIfMatches`), specified as new work at the pet-store layer (not the await-spanning `directory.js`), listed in the §9 artifacts, and kept a daemon-core capability rather than a third public guard.
- **Terminal disposition (critic/skeptic/decomplector/ergonomist/novice):** Dropped the perspective-relative `redeemed-by-me`/`-other` tags; `already-accepted` vs `already-consumed` now derive by comparing the committed bound handle id to the reader's own (stores the fact, not the relation).
- **Reciprocal `@nets` precondition (critic):** Stated per direction; §8 cross-daemon test now populates both guests' `@nets`.
- **Cross-daemon `locate()` type (skeptic):** Corrected to `?type=remote`; consumers check `type !== 'invitation'`.
- Added `peer-conflict` to the failure taxonomy and scoped the exhaustiveness claim (ergonomist).
- Dropped `registerPeer` from `invite` (no call site); passed it as a parameter into `acceptInvitation` (skeptic/decomplector/novice).
- §9: corrected `InvitationInterface.accept` guard to `LocatorShape`; "correct and rename" the wrong-arity `help.md` entry; added the new-primitive bullet (ergonomist).
- `designs/README.md` index: `inviting-agent-sourced` hints; corrected injected-capability list (copyeditor/novice/pedant).
- Numbered the Open Questions list and fixed every ordinal cross-reference (copyeditor/pedant).
- Copyedits: removed all "earlier draft" diffs, all 26 em-dashes, the `§` sign, bolded the run-in heading, fixed quotation punctuation, "purely additive".

**CI-unblock (merge commit `40fd08fcd6`):** The PR was `DIRTY` (conflicts with base `origin/llm`), so GitHub couldn't build the merge ref and no `pull_request` CI dispatched. I merged `origin/llm` forward (mirroring the prior head's pattern), resolving the two `designs/README.md` list conflicts by keeping both entries. Merge state → `CLEAN`; CI then ran and is green (browser-tests, lint, build, zizmor, test all SUCCESS).

**Result:** Fix pushed to head `40fd08fcd6`; CI terminal GREEN (rc 0 equivalent). Stopped without re-running the panel, per spec — the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 218 tokens (14409684 cached reads)
- Output: 78552 tokens
- Cost: $14.383363249999999
- Wall-clock: 2327s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
