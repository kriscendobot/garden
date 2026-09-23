CI confirmed GREEN (rc 0). The fix stage is complete.

## Completion report — FIX round 1, endojs/endo-but-for-bots PR #695

**PR:** design(sturdy-refs): agent provide/accept surface — a design-doc PR editing `designs/sturdy-refs-agent-surface.md` (head branch `design/sturdy-refs-agent-surface`, owned by endojs).

**Panel disposition applied:** must-fix (posted as a comment review since request-changes isn't permitted on a self-authored PR). Applied the panel's must-fix and should-fix items once, in a single follow-up commit `2eab44c7db`:

- **critic (must-fix):** Reconciled the two contradictory rationales — added explicit weighing that dropping `SturdyRefToken` forgoes the remotable's GC-tied retention/revocation lifecycle, so that machinery must now be built by hand (Summary + Distributed-confinement + Retention sections).
- **critic / ergonomist:** Reconciled the `list` row — snippet marked "pending confirmation", table entry changed to "No, pending investigation", and a dedicated acceptance criterion added.
- **skeptic:** Flagged the #541 retention-free conflict in the Dependencies table and gated it on the retention investigation; repointed stale closed PR #521 to its successor #737.
- **decomplector:** Added the tool-layer-escrow-loss (restart/session-end) lifecycle question and named the authoritative-side/holderless-edge gap.
- **ergonomist:** Named the daemon `help.md` update in phase 2; renamed the snippet's `agent` variable to `workerFacet`.
- **critic (comment):** Cited `daemon-retention-paths.md`'s worker/petStore/retention edge taxonomy for the investigation.
- **copyeditor / pedant / novice:** Split tangled sentences, `either`→`any`, introduced "sturdyref" on first use, normalized to American spelling, added the revision-context pointer, defined "enliven" and "swiss number", added a lead-in for the identify/locate methods, and de-numericized the table alignment.

I also caught and removed 11 em-dashes I had introduced (the document/project uses none — pedant rule), before pushing.

**Push:** `f5df0a4c83 → 2eab44c7db` on `origin design/sturdy-refs-agent-surface` via `safe-push-pr-head.sh` (advance mode).

**CI:** all 5 checks (browser-tests, lint, build, zizmor, test) SUCCESS on head `2eab44c7db`; `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN).

**Follow-up:** none from this stage. Per the gauntlet contract I stopped after one fix pass; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 64 tokens (2056332 cached reads)
- Output: 18371 tokens
- Cost: $2.8902985000000005
- Wall-clock: 898s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
