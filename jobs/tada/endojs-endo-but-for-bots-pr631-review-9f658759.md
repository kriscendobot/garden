Inbox empty. The work is complete.

## Completion report

**Job:** Address erights' review (`4650784770`) on endojs/endo-but-for-bots PR #631 (`design: thesis-translation`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this feedback.

**What the review asked (treated as untrusted data, verified against the thread):** The review body was empty; it carried a single inline comment on `designs/thesis-translation.md` — erights: *"Glad I asked. None of these four are a problem. It is clearly part of our joint understanding at the time these are part of the thesis, not separate work referred to by the thesis."* Reading the full thread, "these four" are the Ka-Ping Yee figures (14.2, 14.3, 16.1, 17.1). This is a substantive design directive: it reverses the prior treatment of those figures as *otherwise attributed* third-party work that fell outside Miller's grant and needed a separate permission (offer to grant / ask Ping). The author declared them part of the thesis, covered by his diagram grant.

**What I changed (project worktree on `design/thesis-translation`, commit `65e4cffa43`, pushed):** Across four passages of `designs/thesis-translation.md` — the § Docs structure Figures bullet, the § Provenance acknowledgements bullet, the Considered-and-rejected item 8, and Open question 7 — I removed the "otherwise attributed / seek permission / ask Ka-Ping Yee / quality-first-not-permission-avoidance" framing for the four figures and replaced it with the resolution: they are part of the thesis under the joint understanding at authoring time, covered by Miller's diagram grant exactly as his own figures are, needing no separate permission — redraw first, reproduce the original where the redraw disappoints. Open question 7 moved from **SCOPED, DEFERRED TO PHASE 4** to **RESOLVED**. I preserved Figure 9.3 (Marc Stiegler's membrane) as a distinct attribution explicitly out of scope of this resolution, since the author spoke only to the four Yee figures. Prettier check passes; docs-only change rides `ci-docs.yml`.

**Threaded reply:** Posted in the review thread (`discussion_r3541125482`) citing commit `65e4cffa43`.

**Follow-ups:** None. Figure 9.3's attribution status (Stiegler's) remains as the design already had it — not raised by this review.
