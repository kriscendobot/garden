CI is GREEN (rc 0). The fix is pushed and CI passes. This is a design-only revision; no garden-side changes were needed.

## Completion report

**Job:** gauntlet FIX round 2 for endojs/endo-but-for-bots PR #695 (`design(sturdy-refs): agent provide/accept surface`).

**Re-derived state:** Fresh worktree after reaper requeue. PR head was at `2eab44c7d` (round-1 fix); the round-2 design-panel verdict (7 seats, all request-changes) was the latest review. No prior round-2 fix commit existed, so I did the work from scratch.

**What I did:** Applied every round-2 must-fix (and the aligned should-fix/decomplector items) to `designs/sturdy-refs-agent-surface.md` in one coherent revision, pushed as a review-feedback follow-up commit (`caf4eb64d`), and watched CI to green.

Key changes:
- **Naming/decomplection (ergonomist, decomplector):** replaced the overloaded `lookup(sturdyRef)` with a distinct `lookupBySturdyRef` daemon method (following the shipped `lookupById`/`lookupByLocator` convention); dropped `list(sturdyRef)`; a worker-facing facet is handed `enlivenSturdyRef` alone, not the whole association capability; reused the shipped `@endo/ocapn` spellings `makeSturdyRef`/`enlivenSturdyRef`.
- **Terminology (novice, ergonomist):** defined *locator*, *formula identifier*, and *swiss number* up front and disambiguated the "locator" collision; linked the sibling `sturdy-refs-endor-syscall` design.
- **Honest confinement claim (skeptic, critic):** stated the confinement property as a target contingent on Open-Question-1's transport rule (the OCapN codec still writes the swiss number on the wire); noted the confined facet is narrower than the shipped `EndoGuest` and added an explicit attenuation phase naming who builds it.
- **Dependencies/phasing (critic, skeptic):** added the CapTP box/unbox dependency and phase ahead of the admit phase; gated the surface to single-turn-only until the retention investigation lands; reordered Phased Work.
- **Admission table (critic, ergonomist):** made it per-method, added `has`, replaced the non-method `write` with `storeIdentifier`/`storeLocator`/`remove`/`move`/`copy`, named the reverse methods with explicit denies.
- **Escrow split (decomplector):** separated the tool-layer render map from the daemon-side retention set.
- **Prose (copyeditor, pedant, novice):** fixed the inverted causal sentence, resolved the holder/owner ambiguity, moved the revision narrative into a `## Status` section, restored the canonical `## What is the Problem Being Solved?` heading, lowercased `presence`, fixed number-agreement and the article/plural issues; added the bearer-vs-holder open question. Kept the doc ASCII-only and reflowed to ≤80 cols.

**CI:** all 5 checks green (`CI GREEN`, rc 0). PR remains draft; per the fix-stage contract I did not re-run the panel — the driver re-posts panel-3.

**Follow-ups:** none for this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 60 tokens (1957090 cached reads)
- Output: 27002 tokens
- Cost: $2.890439749999999
- Wall-clock: 883s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
