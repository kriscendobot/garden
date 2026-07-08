All directives in the review are resolved. Here is my completion report.

---

**Job: review directive on endojs/endo-but-for-bots PR #631 (erights review 4650709899)**

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved it).

**What the review asked (both inline comments by erights, on `designs/thesis-translation.md`, treated as untrusted data):**
1. *(figures line)* Miller believes he can grant permission for Ka-Ping Yee figures in texts he co-authored (IANAL); if a problem remains, ask Ping directly rather than "iterate on something that's clearly worse." He asked *which* Yee diagrams we mean.
2. *(the "otherwise attributed → redraw/describe, never reproduce" text)* "If these translations are clearly worse, then we should get the permissions we need (ask Ping) rather than reduce quality because of reluctance to ask permission."

Both are one directive: **don't degrade figure quality to avoid asking permission.**

**Research (to answer his question authoritatively):** extracted the thesis acknowledgements from the source PDF. Ka-Ping Yee is credited with exactly **Figures 14.2 (p. 107), 14.3 (p. 108), 16.1 (p. 118), and 17.1 (p. 124)** "with input from the e-lang community." Figure 9.3 (the membrane) is **Marc Stiegler's** example, not Yee's — a latent misattribution in the prior draft, now corrected.

**Changes (commit `d5bf9acbd`, pushed to `design/thesis-translation`):**
- **§ Docs structure, Figures:** named the four Yee figures; corrected 9.3 to Stiegler; replaced the blanket "redraw or describe, never reproduce" rule with **quality-first**: redraw first, reproduce the original under confirmed permission where a redraw is clearly worse, describe-with-PDF-link only as an interim measure. Recorded Miller's offered grant and the ask-Ping fallback.
- **§ Provenance:** rewrote the Yee-figures bullet to the same stance, dropping "never reproduction."
- **Alternatives item 8:** updated; added "considered and rejected: redraw-or-describe unconditionally to sidestep asking."
- **Open questions:** added item 7 scoping the permission question to **phase 4** (chapters 14/16/17, where all four figures live), so it does not block phase 1.

**Reviewer replies posted** to both threads (`discussion_r3541082663`, `discussion_r3541082998`) — answering the "which figures" question and confirming the quality-first change, each citing the commit.

**Verification:** docs-only change; Prettier config uses default `proseWrap: preserve`, so manual wrapping is format-safe; no trailing whitespace.

**Follow-up (deferred, not blocking):** the phase-4 builder either confirms the mermaid redraws of Figures 14.2/14.3/16.1/17.1 are adequate, or requests permission (Miller's grant, or Ka-Ping Yee's assent) before reproducing the originals.
