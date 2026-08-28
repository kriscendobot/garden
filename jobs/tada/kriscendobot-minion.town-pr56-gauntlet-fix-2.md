CI is green (rc 0). The fix is pushed and CI passed.

## Completion report

**Job:** kriscendobot-minion.town-pr56-gauntlet-fix-2 — FIX round 2 of the staged gauntlet on PR #56 (a **design** PR: `designs/invitation-only-guest-onboarding.md`).

**What I did:** Read the panel-2 request-changes verdict (critic, skeptic, decomplector, ergonomist = must-fix; copyeditor/pedant/novice = comment-only), grounded each finding against the cited source (`src/endo/guest-control.ts` `assertValidPetName`), applied the must-fix items in one commit, pushed as a review-feedback follow-up, and watched CI green.

**Changes (`designs/invitation-only-guest-onboarding.md`, +113/−30):**
- **critic #1 / decomplector #2 / ergonomist #1** — replaced the invalid `c/` reserved pet-name prefix (the grammar rejects `/`) with the valid `c-`; named the enforcement point (tool-boundary rejection of `c-` writes in `guest_write_text`/`guest_remove`); specified that `guest_contacts`/`guest_list` strip the prefix for display.
- **critic #2** — corrected §4/§5: `host.accept` mints a fresh guest (`formulateGuest`) and registers a peer, not the identity's canonical `g-<hash>`; added an explicit reconciliation step (move handles into `g-<hash>` via the §7 `send`/`adopt` primitive) shown in the sequence diagram.
- **skeptic #1** — flagged same-daemon `invite`/`accept` as an unverified premise (retention tests cover only the two-daemon case), scoped the test citation to cross-daemon, and added a build-time spike + fallback (new §9 Q5).
- **decomplector #1** — scoped the "never a row without a handle" invariant with its grandfather exception inline.
- **ergonomist #2** — stated `guest_invite`'s own failure modes (invalid petName, daemon-unavailable, future cap-shaped withhold).
- **ergonomist #3** — added a distinct spent/expired/cancelled-token surface (§6, surface 4).
- **pedant** (cheap house-style) — `behaviour`/`favour` → `behavior`/`favor`.

**Push:** `f09527a → 5b21a64` on `design/invitation-only-guest-onboarding` (advance-mode safe push, rc 0). **CI:** GREEN (rollup total=1, failed=0, rc 0).

**Follow-ups:** none required by this stage; the driver re-posts panel-3. The design intentionally leaves the same-daemon-accept mechanism and canonical-guest reconciliation as build-time spikes (§9 Q5) — build-stage concerns, not design blockers.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr56-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2616232 cached reads)
- Output: 24864 tokens
- Cost: $2.7281139999999993
- Wall-clock: 429s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
