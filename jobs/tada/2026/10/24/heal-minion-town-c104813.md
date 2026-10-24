I opened a heal PR, kriscendobot/minion.town#222, that reverts merge c104813 (#218), and recorded its gauntlet. It is still a draft and has not merged yet. The gauntlet will run CI, the panel review and un-drafting, then the proxy screens and merges it.

**What broke:** In run 40135158359, the "Deploy app (minion-mcp)" step failed on a new check that #218 added. The check runs on the instance before the new release goes live, and it stopped the deploy with: `account store minion-town-accounts has no guest bond ledger provisioning marker; run deploy-accounts-store.sh before deploying`. #218 requires a one-time database setup step before deploying: running `deploy-accounts-store.sh` with `LEGACY_BOND_WRITERS=active`. Nobody ran it against production, and the CI deploy doesn't run it.

**Production state:** Because the check failed before the new release was promoted, the app currently running was not replaced. But the deploy steps after it were skipped: gateway, git remote, login gate, registry, Caddy and www. Every later deploy from `main` would fail at the same point.

**Why a revert:** A forward fix would mean running a required production DynamoDB migration and IAM change from CI, without the manual steps #218's DEPLOYMENT.md calls for. Reverting is the cheaper correct route.

**Changes:**
- **Revert branch:** `heal/revert-c104813` holds `git revert -m 1 c104813`, which touches 16 files (+87/−2467).
- **Base branch:** I created a frozen base branch `main-c104813`, pointing at the current tip of `main`, because `ensure-pr.sh` won't open a PR against a moving branch. The screener accepts this kind of base and switches the PR back to `main` before merging, so the revert lands on `main` through a PR. Nothing was pushed to `main` directly.
- **PR body:** It carries the marker `<!-- garden-heal: c104813b9c464ecf314e469a4456c72ec7cdeda9 -->`, the failing log line, and how to re-land #218.
- **Gauntlet record:** `kriscendobot-minion.town-pr222-gauntlet`.

**Follow-up for the maintainer:** To re-land #218, first run `deploy-accounts-store.sh` with `LEGACY_BOND_WRITERS=active` against production, as #218's DEPLOYMENT.md describes. Then revert #222.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/heal-minion-town-c104813.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (734002 cached reads)
- Output: 4172 tokens
- Cost: $0.6550804
- Wall-clock: 104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
