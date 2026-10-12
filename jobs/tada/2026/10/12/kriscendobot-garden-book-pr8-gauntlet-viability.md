Viability verdict: **proceed**. PR #8 has not been superseded, and the problems it fixes are still present in the chapters on `main`. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

**PR facts:** kriscendobot/garden-book#8, "Copy-edit for reader exposure: introduce terms once, foreground consequences". It is open, unmerged and still a draft, with no comments or reviews. The head is `book-reader-exposure-copyedit` @ `2d0cc322`, on the frozen base `main-e6f2790`. It touches 9 chapter files and adds `editorial/reader-exposure-map.md`.

**Deciding question:** Do the chapters on `main` still use the backstory references and unexplained terms that this PR replaces, with no newer PR or commit having done the same reader-exposure edit?

**Evidence:**
- **Nothing newer replaces it.** `main` is 24 commits ahead of the base. Those are the illumination art and build work (PRs #7, #9, #11) and the ch8 § 8.8 review-economics material (PR #12). The only chapter they change is ch8, and only by adding text (+319/−2). No other open or merged PR does a reader-exposure copy-edit. The one closed PR, #10, was about wiring the illustrations.
- **The problems are still there on `main`:**
  - ch8 still has "(audit § 5.1)", the "Friday 21:00" anchor, and "On 2026-09-30 the maintainer directed".
  - ch7 still has "The rule came from the review of PR #75", the `endojs-endo-but-for-bots-pr395-weave` job name, and the dated Ironhorse autopilot passage.
  - ch1 still lacks the paragraph introducing the projects the examples come from (Endo, `endo-but-for-bots`, Ironhorse, minion.town).
- **The motivation still holds.** The audience PR #3 set (people using, adapting or studying the garden) is unchanged, and those passages still assume the reader is an insider.
- **One thing for later stages:** ch8 changed on `main` after the PR's base, so the rebase or merge will need to reconcile ch8. The PR's own description predicted that overlap. It is a cost for the clean stage, not a sign the PR is overtaken.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179142 cached reads)
- Output: 1693 tokens
- Cost: $0.4555684
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
