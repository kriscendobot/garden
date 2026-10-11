Fix round 2 for kriscendobot/minion.town PR #177 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 on all 3 checks.

**The must-fix.** The latest panel review (5481767417, on head `d1ec29a`) had one must-fix, from the skeptic. The design said mixed-deployment loads were "prevented", but it doesn't deliver that for every kind of reference. One commit, `69dc617`, edits `designs/git-remote-served-clip.md` and was pushed with `safe-push-pr-head.sh` (`d1ec29a` → `69dc617`).

- **§ 5.1:**
  - Added a paragraph, *The coherence guarantee, at its true strength*. It says the guarantee covers only sub-resources named by a rewritten attribute. It names what is excluded: URLs built in script, import maps, SVG/MathML `href`s, anything in `<template>`/`<noscript>`, documents served raw by a fallback, caches that ignore `no-cache`, and pages that outlive retention. It also states where the design stands on `stale-while-revalidate` and `Vary`.
  - Widened the "remaining leaks" bullet to list the same reference kinds.
  - Import-map URLs and SVG/MathML `href`s are now listed explicitly as not rewritten.
- **§ 8 cost table:** the "Mixed-deployment loads" row now shows the narrowed claim and points to § 5.1.
- **§ 12 Q3:** the recommendation now depends on Q1 choosing Model S. It notes that the tier buys only a partial guarantee, and that shipping without the tier first is the honest alternative.

**Should-fix items folded in.** I also absorbed a few of the panel's smaller items:
- The § 10 test plan now checks that import maps and SVG `<use>`/`<image>` are left unrewritten.
- It also adds a real-browser test of the case where a push lands mid-page-load.

**Follow-ups.** The remaining should-fix items are not addressed; the panel-3 stage will see them:
- Novice: the opening needs more background for new readers.
- Decomplector: whether the intent markers and the full sweep overlap.
- Ergonomist: how a pusher learns that a push failed to serve, and naming.
- Critic: the retention cap versus the stated 24 h, and the `max-age` on purgeable roots.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr177-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (892910 cached reads)
- Output: 5730 tokens
- Cost: $0.8065179999999998
- Wall-clock: 909s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
