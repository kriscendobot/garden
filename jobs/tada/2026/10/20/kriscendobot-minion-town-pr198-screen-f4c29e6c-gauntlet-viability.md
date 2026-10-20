**Viability gate: kriscendobot/minion.town PR #198** ("feat(web): one landing at /, closed-beta splash and waitlist")

**Verdict:** proceed. The PR is still needed and nothing on main has replaced it.

**PR facts:** The PR is open, not merged, and not a draft. Head is `f4c29e6c`, base is `main` at `ea08cf05`, and GitHub reports it as mergeable.

**Deciding question:** Does current `main` still ship two separate public pages (`guest.html`/`guest.js` and `index.html`) with no waitlist or closed-beta splash, and has no newer PR or commit landed a single landing page or waitlist instead?

**Evidence:**
- **The premise still holds.** The `main` tree still has `deploy/aws/www/guest.html`, `guest.js` and `index.html` as separate files. It has no `src/waitlist`, no `designs/closed-beta-waitlist.md`, and no splash. So the "two different pages" problem the PR fixes is still there.
- **Nothing on main has displaced it.** The commits on `main` since 2026-10-17 cover deploy chunking and www staging (#206), CI harness gates (#204), git-remote design §7 (#203), a dependabot bump (#208), npm-registry disk headroom (#209), browser-gate test fixes (#207) and clip-live-frame (#197). None of them touch the landing page, the waitlist or the splash.
- **No other PR covers it.** Searching for waitlist or splash PRs finds only #198 itself and #200 (settings and logout), which is complementary. #199 is planned to rebase onto this PR (#198 merges first).
- **The original request still stands.** The work comes from the maintainer's closed-beta product pass (kriskowal, 2026-10-17). Nobody other than the bot has commented or reviewed, so nothing withdraws or reverses that request.
- **Earlier gauntlet runs:** Two previous gauntlets ended at `review-budget-reached` with CI green. The latest one (2026-10-19, head `5ea6269`) still listed 20 must-fix items as unaddressed, judged a "moving target". The head has moved on to `f4c29e6c` since then. This affects how much the review loop will cost, not whether the PR is still worth doing.

I spent no clean, panel, fix or CI-wait budget and made no changes to any repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr198-screen-f4c29e6c-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (241483 cached reads)
- Output: 2185 tokens
- Cost: $0.48194859999999995
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
