Panel round 5 on kriscendobot/garden-book PR #15 is done, and the verdict is **must-fix**.

**How it ran:** I used an isolated checkout of the PR head (`kriscendobot/garden-book@garden-book-illuminations-republish-20261014`, commit `cb9f9bd`) and ran `panel.sh` once in single-round mode. I passed it the real base commit `5acd916ca3df` rather than the branch name `main-5acd916`, which doesn't exist in the fork. `panel.sh` exited 0 with `must-fix`.

**Result:** 34 seats ran: 2 asked for changes, 10 approved, and 22 left comments only. No seat found a correctness bug, and round 4's migrator and coverage-auditor blockers are resolved. The two remaining blockers are about documentation accuracy and wordiness:
- **archivist (3 should-fix items):**
  - The tree contract in `build/README.md` claims field checks that the build doesn't actually perform.
  - `browser-check` labels a measurement "Tallest figure" when it measures the image, and the leftover `tallestSvg` field name has the same problem.
  - The comment on `CLIP_CSP` in `tools/clip-server.mjs` says the policy matches the published-clip skill, but that skill only documents some of the directives.
- **pruner:**
  - It wants change narration and dated byte counts cut from `build/README.md`.
  - It wants repeated text cut from `art/illumination-redraw-evidence.md` and `art/MANIFEST.md`.
  - It wants the old critique moved out of `art/chapter-illustrations-brief.md` or cut.
  - It wants the PR body to link to the README instead of repeating it.

One comment-only seat (decomplector) also flagged a should-fix: `tools/clip-server.mjs` should either say why it needs a real HTTP server or be replaced with Playwright's request interception.

**Posted:**
- A comment review (5528648198) with the must-fix summary and the two blocking seats' full reports. As in rounds 1–4, it's a comment rather than a request-changes review because GitHub doesn't let the bot request changes on its own PR.
- All 34 seat reports as two PR comments (6185302309, 6185302585). The combined text is about 84 KB, larger than GitHub allows in one comment.

I didn't change any code or un-draft the PR. Follow-up belongs to the gauntlet's next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1134191 cached reads)
- Output: 5450 tokens
- Cost: $0.8894942
- Wall-clock: 190s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
