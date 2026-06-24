---
ts: 2026-06-10T22:09:23Z
kind: dispatch
role: liaison
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/05/12/193700Z-message-liaison-5f675d.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--f5b22f`) for the garden's **FIRST upstream ferry to agoric/agoric-sdk**: a multi-author re-ferry of kriscendobot/agoric-sdk#5 onto Agoric/agoric-sdk#12527 ("Sync Endo dependencies and refresh patch set"). Maintainer-confirmed (preserve original authors; accept likely turadg-approval dismissal).

Source: kriscendobot/agoric-sdk#5, head `b69f42641`, base frozen `master-daf7a86` (= agoric master ancestor `daf7a864c`, 2026-06-09), 13 commits, DRAFT. The mirror rebased #12527's 9 commits onto daf7a86 + added 4 endolinbot lockfile/dep-refresh commits. 98 files (same scope as #12527).

Upstream: Agoric/agoric-sdk#12527, head branch `copilot/update-endo-dependency-versions` (ON Agoric/agoric-sdk itself, head `a6212a802`), base master, **APPROVED by turadg**, CONFLICTING. kriskowal has push:true (not admin) on agoric/agoric-sdk; host precondition verified.

**Per-commit attribution (maintainer-confirmed):**
- PRESERVE original author on the 9 upstream commits: `2ae1c070d` copilot-swe-agent[bot], `95b650ce9` Turadg <turadg@agoric.com>, `d97baf380` Michael FIG <mfig@agoric.com>, `c3324ee14`/`1ebc4faac`/`7002322cd`/`f467ec846` Kris Kowal <kris@agoric.com>, `98c453e4c` Turadg, `962b1b5b9` Kris Kowal. (git cherry-pick preserves author by default — do NOT --reset-author these.)
- NORMALIZE the 4 endolinbot commits to author+committer `Kris Kowal <kris@agoric.com>`: `cc64691f7`, `cf798d660`, `c81cab79c`, `b69f42641`.
- Committer = `Kris Kowal <kris@agoric.com>` for ALL (set via -c override).

Approach: detach at daf7a86 (the mirror's base, an agoric-master ancestor); cherry-pick the 13 mirror commits in order; for the 4 endolinbot ones amend --author to kris@agoric.com; VERIFY HEAD tree == mirror tip tree (b69f42641^{tree}) so content is the mirror's exact resolved state (no re-rebase onto current master 57c65644e - preserve the maintainer's conflict resolution; do NOT run agoric-sdk yarn install). Trailer handling: agoric uses conventional commits, NO DCO sign-off. Do NOT blanket-strip trailers (upstream commits 1-9 may carry legitimate Co-Authored-By crediting real contributors - preserve those). ONLY strip `Co-Authored-By: Claude` / `Generated with Claude Code` if present (grep for Claude/anthropic specifically). Force-with-lease against `a6212a802` to `copilot/update-endo-dependency-versions`. Leave #12527 title/body unchanged. Do NOT route a re-review request (maintainer declined). Garden-side cross-link on kriscendobot/agoric-sdk#5 (--paginate search; create). `identity_switch_authorized: true`.

Expected report: new #12527 head, force-with-lease, per-commit author verification (the 9 originals intact incl. Turadg/Michael FIG/copilot; 4 endolinbot -> kriskowal), no-Claude-trailer confirmation, tree==mirror, post-push mergeable + turadg approval state (persisted or dismissed), CI, cross-link id.
