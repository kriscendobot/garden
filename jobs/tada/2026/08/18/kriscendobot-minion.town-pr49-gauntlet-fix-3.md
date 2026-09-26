CI is GREEN (rc 0). The fix is pushed. Per the stage instructions I stop here — the driver re-posts panel-4.

## Completion report — gauntlet FIX round 3, kriscendobot/minion.town PR #49

Applied the round-3 design-panel must-fix/should-fix items to the two reconciled design docs, pushed as a single review-feedback follow-up commit (`f2917bb`) to the PR head `design/vitals-weblet-reconciliation`, and watched CI to terminal: **GREEN** (rc 0).

**`designs/git-remote-capability.md`:**
- **§1 (skeptic):** flagged partition-identity *derivation* as unspecified and carried it as new **OQ 10**; the vitals design cites this identity, so it is now named as a dependency rather than an assumed mechanism.
- **§4 Strategy A (novice, copyeditor, pedant):** split the overloaded SHA-1/SHA-256 paragraph in two, deleted the strawman "reading the git oid as SHA-256-only" rebuttal, fixed the em-dash appositive run-on, and made prose `SHA-256` capitalization consistent (code-literal formulas left lowercase).
- **§7 + OQ 7 (decomplector):** promoted the structured attenuation field from fully-deferred to a **v1 precondition once a partition holds a second attenuation**; what stays open is only its `list` presentation. Also fixed "from each" → "from each attenuation" (copyeditor).
- **§9 (critic):** committed the crash-safety repair to the **serve-time check** (demoted the background sweep to a later optimization) instead of presenting two co-equal mechanisms; named the restricted **sub-resource manifest** as distinct from the full served tree.
- **§1 (copyeditor):** "is so that".

**`designs/vitals-weblet.md`:**
- **§6 / non-goals / DoD (ergonomist):** unified the origin term on the companion's `<hash>.ocap.site`, removing every `base32` spelling.
- **§1 / §4 (ergonomist):** adopted the companion-coined **push-publish** term.
- **§4 (skeptic):** stated the write capability must be **host-portable across a leader handoff** (no automatic failover), else vitals publishing silently stops on handoff.
- **§4 (decomplector):** marked cutover **option (i)** — one identity-minting scheme — as the preferred move.
- **Mandate (copyeditor):** added a bracketed editorial note reconciling the verbatim #39 quote with the #41 supersession.

Notes: the pedant's "define OQ at first use" was preserved by moving the `(OQ)` expansion to §1 (its new first occurrence) and making §4's mention bare. CI is code-only (typecheck + vitest); doc edits don't touch it. No re-run of the panel — stopped as instructed.

Follow-ups: none beyond the driver's panel-4 re-post.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr49-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 97 tokens (5607313 cached reads)
- Output: 34431 tokens
- Cost: $4.8851385 (1 engagement(s) unpriced)
- Wall-clock: 540s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
