FIX round 3 complete. CI is GREEN.

**What I did:** Applied the round-3 design-panel must-fix items to PR #1116 (`designs/guest-native-invitations.md` + `designs/README.md`), pushed as follow-up commit `059f2bd989`, then unblocked CI (it was silently not running because base-`llm` drift had made the PR `CONFLICTING` on the README design index) by merging `origin/llm` into the head and resolving the conflict, pushed as `efca954f1d`.

**Substantive design fixes:**
- **Concurrency self-deadlock (critic must-fix):** rewrote §5/§6 to rest consume-once on an atomic pet-store compare-and-set (pet store's own single-writer queue), with controller cancellation moved *outside* any `formulaGraphJobs.enqueue` — `provideController` re-enters `withFormulaGraphLock` at depth 0 and would hang on the single token.
- **False `remove`/`rename` revocation claim (critic/skeptic/decomplector):** corrected; invitation identity is the formula id, not the mutable pet name. Recorded terminal disposition as a value; added `already-accepted` for idempotent self re-drive.
- **Phantom `handleNode` invitation-locator param (critic/skeptic/novice):** removed; fixed §4 conflation.
- **Per-direction security argument (skeptic/critic)** and **inject-only-narrowed-capabilities (decomplector/ergonomist)** rather than raw daemon-global writes.
- **Read affordance:** named `locate()`'s `?type=` instead of `followNameChanges`; introduced the two-node-key model before first use.
- **Rename `peerName`→`correspondentName`; converged the error contract across facets; enumerated help.md/help-text-data.js/CLI rename artifacts; qualified all citations as `packages/daemon/src/…`; editorial nits + README index entry.**

**What changed:** two design docs; `efca954f1d` is the PR head; all 5 checks (browser-tests, build, lint, test, zizmor) pass; PR is `CLEAN`/`MERGEABLE`.

**Follow-ups:** The head now carries a merge commit (`Merge remote-tracking branch 'origin/llm'`) from resolving the base-drift README conflict; a later weave/pin-the-merge-base can linearize history if the maintainer prefers. Panel round 4 is the driver's next stage (I did not re-run the panel, per the stage contract).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 156 tokens (10423073 cached reads)
- Output: 62532 tokens
- Cost: $8.436956499999999
- Wall-clock: 1072s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
