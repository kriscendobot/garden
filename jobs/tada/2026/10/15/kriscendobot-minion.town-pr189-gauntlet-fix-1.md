## Fix round 1 completion report: kriscendobot/minion.town PR #189

I fixed the panel's four must-fix items in one follow-up commit, `df3f3e379ae`, on `design/clip-iframe-embedding`. The PR moved from `0e8fb71` to `df3f3e3`, pushed with `safe-push-pr-head.sh`. CI is **green**: `ci-wait-merge.sh --no-merge` returned rc=0, and the one Actions run "test (typecheck + vitest)" passed.

**Must-fix items and changes (all in `designs/clip-shell-framework.md`):**
1. **Skeptic #1 (CSP-over-XFO precedence was asserted, not checked):**
   - § 3.1 now says outright that this precedence has not been checked in any browser.
   - Approval now depends on a new **precedence gate** in § 3.7: a real-browser run on Chrome, Firefox and Safari. If any engine fails, the live-frame increment stops and the section is reopened.
   - § 3.1 also states what happens when a proxy or CDN strips the CSP: XFO DENY survives alone and the frame fails closed. The text names this as an accepted failure mode, with the top-level link as the fallback (critic's should-fix #1).
2. **Skeptic #2 (CORP/COEP reading not verified; the shell COEP invariant was not enforced):**
   - § 3.2 marks the CORP-on-navigation reading as not checked in any browser, and the § 3.7 gate now covers it too.
   - The header increment now adds a test that the shell's response has COEP `unsafe-none`. A later change that adds `require-corp` will fail that test.
3. **Pedant #1 (em-dashes):** I removed all five new em-dashes (lines 108/109, 124 and 219/220) and used parentheses instead.
4. **Pedant #2 / copyeditor #1 (arrows):** In the § 3.5 table, `→` is now `->`.

**One should-fix item I also handled:** § 3.7 now includes a negative test at the frame's `src` assignment, prompted by critic #3 and skeptic #4. A record or link whose host is not a valid `*.ocap.site` clip address never reaches `src` and shows the inert card instead.

**Not addressed (follow-ups):** These should-fix and comment-only items are left for panel-2 to judge:
- Decomplector: make the allowed ancestor a configuration value, and the selection/ownership ambiguity.
- Auditing the other pages served from the `minion.town` origin.
- Novice: explaining #88 where it is first mentioned.
- Ergonomist: an always-visible "open in new tab" link, and how the live-link entry works in the UI.
- Skeptic #5: gaps in the test list.

I did not re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (876213 cached reads)
- Output: 6589 tokens
- Cost: $0.7629986000000001
- Wall-clock: 974s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
