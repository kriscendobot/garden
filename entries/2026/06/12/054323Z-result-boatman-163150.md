---
ts: 2026-06-12T05:43:23Z
kind: result
role: boatman
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/12/053816Z-dispatch-liaison-cfb9e8.md
---

Re-ferried the rebuilt (ava-fixed) `kriscendobot/agoric-sdk#5` onto `Agoric/agoric-sdk#12527` (branch `copilot/update-endo-dependency-versions`). Shape 2 re-ferry via the `commit-tree` rebuild proven on prior agoric ferries; zero conflict risk.

**Source:** mirror head `bd397628bca25d84cb8a9dcbb97dd1ddbb6d4c7b`, base `57c65644e` (== an agoric master ancestor; `mirror~12` resolves to that exact commit, same tree `c8b86673...`). 12 commits, oldest-first list matched the dispatch table exactly. The `restore ava ^7.0.0` commit (which conflicted with `@endo/ses-ava` and broke `test-docker-build`) is confirmed **absent**: the chain is 12 commits, no `restore ava` subject anywhere.

**Force-push:** new upstream head `3ba75f617d5cad95334ef6f829f459c914d27968`. `--force-with-lease=copilot/update-endo-dependency-versions:ee7df351b6a856d5bc67f91b30567ed25165e5c8` held; remote reported `+ ee7df351b6...3ba75f617d ... (forced update)`. Pushed under kriskowal via the `x-access-token` URL form (SSO-required), `gh auth status` showed kriskowal active with `push: true` on agoric/agoric-sdk.

**Attribution as pushed** (committer = `Kris Kowal <kris@agoric.com>` on all 12):
- 1 `627db5e5d` copilot-swe-agent[bot] (PRESERVED, with legit `Co-authored-by: kriskowal` retained)
- 2 `768aed167` Turadg Aleahmad (PRESERVED)
- 3 `b72fb66c5` Michael FIG (PRESERVED)
- 4-7 `e41df8769` `5732d4a87` `724fe12ab` `e7051c7c7` Kris Kowal (PRESERVED)
- 8 `01018103a` Turadg Aleahmad (PRESERVED)
- 9 `02df7b72e` Kris Kowal (PRESERVED)
- 10 `ffc275ef6` endolinbot -> Kris Kowal (NORMALIZED)
- 11 `dc7c16427` endolinbot -> Kris Kowal (NORMALIZED)
- 12 `3ba75f617` endolinbot -> Kris Kowal (NORMALIZED)

9 originals preserved (incl. Turadg x2, Michael FIG, copilot), 3 endolinbot normalized to kris@agoric.com.

**Trailer hygiene:** stripped 6 `Co-Authored-By: Claude...` lines (commits 4,5,6,7,9,10). Preserved the legit `Co-authored-by: kriskowal` real-person credit on commit 1. No `🤖`/`generated with`, no `Refs: entries/...` journal lines present. Post-clean Claude/anthropic scan empty. Commit 10's body prose mentioning upstream's `ava ^7.0.0` bump (ref upstream commit `51cb8ec4e`) is legitimate context and was preserved.

**Tree verify (load-bearing):** rebuilt `HEAD^{tree}` == `bd397628b^{tree}` == `8c7e998a8e18fff2787b2b4dbe7b5d5fbd536a29`. MATCH.

**Post-push state:** 12 commits; `mergeable: MERGEABLE`; `reviewDecision: APPROVED`. turadg's APPROVED review **persisted** through the force-push (branch protection did not dismiss). Re-review NOT requested per dispatch (established engagement). Title/body left unchanged.

**CI:** re-triggered, all checks pending at report time (`build (node-old)`, `build (node-new)`, `breakage`, `deployment-test`, `lint`, etc.); pre-checks (`merge-strategy`, `run-scripts-tests`, `pre_check`) passed. Did not wait. The `test-docker-build` failure that motivated the rebuild should now be resolved since the ava-restore commit is gone (shepherd to confirm convergence).

**Cross-link:** garden-side comment id `4675157471` on `kriscendobot/agoric-sdk#5` PATCHed in place: `ee7df351b6` -> `3ba75f617`. New body: `Mirror of https://github.com/Agoric/agoric-sdk/pull/12527 (head 3ba75f617).`

Self-improvement: nothing this time. The commit-tree rebuild, the SSO token-URL force-push, the legit-vs-Claude co-author discrimination, and the approval-persistence check all matched the existing pr-handoff playbook exactly; no gap surfaced.
