**Viability verdict for kriscendobot/minion.town PR #173: proceed**

PR #173 is an open, unmerged draft, opened today (2026-10-08). It adds one file, `designs/ocap-site-crawler-leak-rotation.md`, the design for job `design-minion-town-ocap-site-crawler-leak-rotation`. The PR has no comments and no reviews yet.

Deciding question: Does `main` already have a newer design or implementation of crawler detection or link rotation for `<hash>.ocap.site` clip origins, or has the per-clip ocap.site origin model it builds on been removed?

Answer: No on both counts.

Evidence:
- **Base is current:** the PR's base is the frozen `main-50aa690`. Its commit `50aa690f8` is still the tip of `main`, and everything since 2026-10-08 that predates it is the ci.minion.town runner work and the clip-gutter work from PR #143. None of it is about crawlers or link leaks.
- **Nothing competing:** searching PRs for "crawler", "leak" and "rotation" finds only #173. In `designs/`, the only related file on `main` is `ocap-site-clip-isolation.md`, which is the premise this design extends, not a replacement for it. A code search for "crawler" finds nothing else in the repo.
- **Dependency still live:** the design relies on endojs/endo-but-for-bots#1433 (making formula shares independently revocable). That PR is still open, and the design already covers this with a fallback mode until it lands.
- **Premise holds:** the maintainer asked for this on 2026-10-08, and `main` still uses the clip-origin model it assumes.

I spent no clean, panel, fix or CI budget and changed nothing in the garden repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (151695 cached reads)
- Output: 1432 tokens
- Cost: $0.354451
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
