---
role: web-builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Review queue clip for minion.town: what the maintainer should review, in priority order, to unblock progress

Maintainer request (kriscendobot's maintainer, liaison session 2026-10-19): post a clip with a review queue in priority order for unblocking progress on minion.town. Publishing is authorized by this request.

**What to rank.** Every open PR on https://github.com/kriscendobot/minion.town, plus the parked/waiting jobs that need a maintainer decision (inbox messages and `jobs/plan` go-ahead / awaiting-maintainer gates that name minion.town). Rank by **how much downstream progress each item unblocks**, not by age. Known dependency facts to start from (verify, they move): #144 (coupons design) must merge before #199 (coupons); #198 (landing + waitlist) and #199 are needed before the parked flip job `minion-town-coupon-admission-flip-20261019` can run; #200 (settings) needs `deploy-accounts-store.sh` run by the maintainer first; #201 (New Clip) and #202 (Chat) are leaves; all of #198..#202 have exhausted their gauntlet review budget, so each row needs a maintainer merge or revise decision. Use the PR dependency graph and topo-sort skills (pr-dependency-graph, pr-dependency-topo-sort) for the ordering and show the chain.

**Each row:** rank, PR or decision, one-line "unblocks: ...", the specific action asked of the maintainer (approve merge, run a command, answer a question, grant rounds), CI/draft/mergeable state, size of the diff, and the 2-3 things most worth a reviewer's attention (from the panel's own findings, summarized as topics). Include the exact command or link for the action. For gauntlets that stopped at "moving target", say whether the open findings look converging or churning.

**It is a snapshot** (a clip is immutable): put the generation time and the `main` commit on the page. Build it from a script checked into the job's report so the maintainer can ask for a fresh one; each refresh is a new hash.

**Privacy.** The repo is private and a clip is world-readable by anyone holding its URL; the hash is not access control. Publish: PR numbers and titles, state, dependency order, actions, and topic-level review hints. Do NOT publish: secrets, tokens, account ids, hostnames, vulnerability or exploit detail, unfixed security findings beyond their topic ("authority handling in the control plane"), maintainer-private matters, or text copied from comments by outside parties. Do a scrub pass and list what you checked.

**Publish** per skills/minion-town-clip-publishing: static only, sibling `styles.css`/JS (no inline), no `powers: "sites"` or `"@agent"`, inert pet name, publish from a script via the stdio bridge, `curl` and `cmp` the URL. Mobile-readable, light and dark. Pet names `minion-town-review-queue-*`; `unpublish` any smoke clip. Report the URL, the ranking with one-line reasons, and the scrub checklist to the maintainer inbox.
