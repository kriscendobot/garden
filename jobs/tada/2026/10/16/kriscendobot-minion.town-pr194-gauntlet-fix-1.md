# Gauntlet FIX round 1 for kriscendobot/minion.town#194

I applied the panel-1 must-fix items and the should-fix items in one follow-up commit, `74c521d`. CI is green: `ci-wait-merge` returned rc 0, and all three checks passed (test, Claude harness amd64, Claude harness arm64). I did not re-run the panel.

**Must-fix items applied:**
- **Dangling design citations and the stale design (archivist #1, integrator #1):** I rewrote § 3.1 of `designs/clip-shell-framework.md` as a recorded decision. Its parts use the names the code already cites: Half 1, Half 2, Shell side, Route admission and CORP/COEP. I also updated the Status, § 3, § 8 and Open questions #1 and #2, and removed the test header's citation of a "§ 3.7" that does not exist.
- **CORP/COEP left unexplained (integrator #2):** The design now explains why these headers stay strict. Browsers only check CORP on a framed page when the parent page requires COEP, and the shell sends no COEP. If the shell ever adopts `require-corp`, clips will need CORP `cross-origin`. That work, and checking the actual headers in a real browser, now belong to the § 6 follow-on that turns on live clips.
- **Admission guard only checked direct `handle` blocks (corner-prober #1):** One new test fails on any top-level directive on the apex outside the admitted shape. Another fails on a `handle`, `handle_path` or `route` nested inside an admitted route. I confirmed each one fails when I inject the defect it targets.

**Should-fix items applied:**
- **Parser (corner-prober #2):** The test's Caddyfile parser now strips trailing comments and ignores braces inside quoted strings. A fixture test covers both cases.
- **Deploy-order claim (archivist #3):** It now cites `.github/workflows/deploy.yml`, where the gateway step runs before `deploy-caddy.sh` in the same job.
- **Stale clip `'none'` references (integrator #3):** Fixed in `designs/vitals-clip.md` and `shell.js:15`.
- **Wording (integrator #4, pruner #2–6, typist):** I split the jumbled DEPLOYMENT.md paragraph and replaced repeated rules with pointers. I also removed comments that only narrated the change and replaced a `→` with plain text.
- **PR body (pruner #1, integrator #5):** Trimmed, and it now calls out that `www.minion.town` only 308-redirects to the apex.

**Declined, with reasons posted in a PR comment (issuecomment-6223804440):**
- **procurer:** The suggested `@endo/markmdown` `parseBlocks` parses Markdown, not Caddyfile, so it can't replace this parser.
- **corner-prober #6:** `content-server.test.ts` already checks the full header floor on 200, 304 and 404 responses.
- **corner-prober #3 and #4:** The real-Caddy transcript in the PR body covers these, and CI has no caddy binary.
- **pruner (transcript):** The real-Caddy transcript stays in the PR body, collapsed, rather than in an outside gist.

**Testing:** The targeted tests and `tsc` pass. The full local suite has 1 failing test, `test/git-remote/capability.test.ts`, which the PR already lists as unrelated. Two `tools/claude-harness/*.test.mjs` files also failed to run locally. This diff doesn't touch them, and I didn't check whether they also fail without it.

**Follow-ups:** None from this stage. Panel-2 re-reviews next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr194-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2422615 cached reads)
- Output: 19723 tokens
- Cost: $1.6953829999999996
- Wall-clock: 1011s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
