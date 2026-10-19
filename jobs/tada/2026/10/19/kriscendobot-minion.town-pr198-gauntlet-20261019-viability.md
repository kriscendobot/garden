Verdict: **proceed**. PR #198 is still open, nothing newer has replaced it, and the problem it fixes still exists on `main`. As the viability stage asks, I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

**What I did:** I read the PR facts, all its comments and reviews, and the 45 commits on `main` since the PR's base. I also searched for related PRs and checked whether the waitlist or a single landing page already exists on `main`.

**Deciding question:** Does `main` still lack a single public landing page with a closed-beta splash and waitlist (two pages, `guest.html` and `index.html`, and no `/api/waitlist`), with no other PR or commit providing it?

**Answer: yes.**

**Evidence:**
- **PR state:** open, unmerged, still a draft, head `c2484cc1`. It has been through six panel rounds and CI is green. The last gauntlet comment (2026-10-18T17:21Z) says the review budget ran out and it is awaiting the maintainer's merge, undraft or re-run decision. No human reviews are on it.
- **The problem still exists on `main`:** `main` still has both `deploy/aws/www/guest.html`/`guest.js` and `deploy/aws/www/index.html`, which is the two-page split the PR removes.
- **Nothing on `main` provides it:** a code search for "waitlist" in the repo returns 0 hits. `designs/closed-beta-waitlist.md` does not exist on `main`.
- **Recent `main` history is unrelated:** the 45 commits since base `bda7739` are clip-gutter order (#190), a prod-probe change (#196), Node install hardening (#192) and the live clip frame (#197). None touch the landing page, the splash or a waitlist.
- **No competing PR:** a search for related PRs turns up only #200 (settings and logout) and #206 (chunked landing-asset deploy). Both are related work, not replacements. The PR body names #199 as merging after this one and says #199 will rebase onto it.
- **The reason for it still holds:** the maintainer asked for this in the closed-beta product pass on 2026-10-17, two days ago, and nothing has reversed it.

**Follow-ups:** none from this stage. The PR body asks the maintainer to run `deploy-waitlist-store.sh` before merging.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (263970 cached reads)
- Output: 2192 tokens
- Cost: $0.45134599999999997
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
