The fix is pushed and CI is green (5/5 checks, 0 failed). Work is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1102 (`introduced-special-names` design). Applied the panel-4 must-fix items once, pushed as a follow-up commit to the PR head, watched CI to green, stopped. (This was already done in my pre-requeue session; on resume I verified the commit is the PR head and re-confirmed CI terminal-green.)

**Commit:** `84eb3ca6c` on `kriscendobot/endo-but-for-bots@design/claude-agents-capability`, touching `designs/introduced-special-names.md` and `designs/README.md`.

**What changed (per panel-4 verdict):**
- **critic (must-fix) + decomplector:** Dropped the mandatory `thisDiesIfThatDies` whole-agent kill switch from § Revocation. The mechanism now adds *no* agent-lifetime coupling, so it stays genuinely policy-neutral (an introduced name whose source is destroyed dangles like any other dangling capability rather than killing the agent). Stated the N-names shared-blast-radius consequence explicitly. Added **Security invariant 7** and **Design decision 6** documenting the no-coupling choice, resolving the "absent from the security list" complaint. The caretaker/forwarder escape hatch is now simpler (forwarder can be destroyed, not only neutered).
- **skeptic:** Added a Phase 1 test for the reservation assertion itself (constructing a daemon with an `@intro-`-prefixed `specials` key is rejected at construction); added a paragraph stating no in-tree caller or the named downstream consumer (Minion Town) uses the reserved prefix, and scoping the assertion to out-of-tree embedders.
- **copyeditor (must-fix + should-fix):** Dropped stray "worker"; `landed` → `specified here`; `flat reserved namespace` → `flat (non-reserved) validation list`; fixed the bare "invariant 2" cross-reference to a `§ Security invariants` link and dropped the misquote.
- **pedant (must-fix + should-fix):** `README.md` em-dash → colon; rejoined the recently-added list entry into one comma/semicolon clause matching its siblings.

**Deliberately not applied:** pedant should-fix #2 (retitle `## What is the Problem Being Solved?` to sentence case) — this is the standard house template heading present in 124 design docs, so it is a false positive, not a per-doc inconsistency. All comment-only/proposed-rule notes (ergonomist, novice, and the notes blocks) were advisory and left for the maintainer.

**Care taken:** verified my new prose introduced no em-dashes (garden `em-dash-style` rule; the original doc had zero) before committing.

**CI:** GREEN — 5/5 checks, 0 failed. No follow-ups. Per gauntlet contract I did not re-run the panel; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 72 tokens (2519101 cached reads)
- Output: 21712 tokens
- Cost: $3.4889335
- Wall-clock: 833s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
