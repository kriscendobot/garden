# Viability verdict for kriscendobot/minion.town PR #239: proceed

PR #239 can enter the gauntlet. It is still open, still a draft, and has not been merged. Nothing newer has replaced it, and the problem it fixes is still in the code.

**Deciding question:** Does current `main` or a newer PR already let a person accept an invitation locator minted through `evaluate` from the web page?

**Answer:** No.

**Evidence:**
- **Base has not moved.** The PR's base, `main-9196892`, is the same commit as the current tip of `main` (`919689231`, the #234 merge). The comparison shows 0 new commits, so no newer base history covers this change. The last related merges, #233 (the `invite` and `cancelInvite` tools) and #234 (the invitation round-trip probe), are already in that base. Neither adds a locator path to `POST /api/guest/invitations/accept` or a `locator=` fragment to `home.js`.
- **PR #240 is the only candidate overlap, and it covers different ground.** It was opened 17 minutes later (https capability URLs at `/accept#…`). It defines the `locator=` URL grammar but says outright that "the landing page does not handle it yet." It also says its successor "must coordinate with" job `build-minion-town-tool-minimalism-20261104`, which is the job that produced #239. So #240 depends on #239's piece rather than replacing it. Both edit `deploy/aws/www/home.js` and `test/home-page.test.ts`, so whichever lands second will need a rebase.
- **The reason for the PR still applies.** Finding 2 in #235 is still unaddressed in the base: the web accept route only takes identifiers from the in-memory registry, which only the `invite` tool fills. Tracker #227 is still open, and removing `invite`/`cancelInvite` is still waiting on this change.
- **No review activity yet.** The PR has no comments or reviews. It was opened today, 2026-11-04 at 01:53Z.

I spent no clean, panel, fix, CI-wait, or un-draft budget, and made no commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (242638 cached reads)
- Output: 1734 tokens
- Cost: $0.47035960000000004
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
