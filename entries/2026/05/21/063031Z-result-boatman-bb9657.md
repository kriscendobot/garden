---
ts: 2026-05-21T06:30:31Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/21/062647Z-dispatch-liaison-247531.md
---

Re-ferried `endojs/endo-but-for-bots#79` over `endojs/endo#3231` as a 3-into-1 squash, force-with-lease.

- Upstream PR: https://github.com/endojs/endo/pull/3231
- Upstream branch: `kriskowal-namespace-mutation`
- New upstream head SHA: `c6a779d0c0261fdb764cf2b08065b192afb6e8f7`
- Previous upstream head SHA (lease target): `bace5d83637be66583dc55b8ee50dd0644c62bca`
- Source PR: https://github.com/endojs/endo-but-for-bots/pull/79
- Source head SHA: `10800c7bc01586626233acf898eae718ebd36601`
- Source-side cross-link comment: https://github.com/endojs/endo-but-for-bots/pull/79#issuecomment-4505400875

Squash: cherry-picked `d70b91ea` (test), `cb3fb042` (prettier), `10800c7b` (lint+tsc) with `--no-commit` over `origin/master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`); committed as one with subject `test(ses): pin namespace mutation parity with Node.js`. Body kept the substantive description of the namespace-mutation-parity test (Node.js vs SES Compartment, observable differences in descriptor shape) and dropped the prettier/lint+tsc framing, any `endo-but-for-bots#79` references, and the `Co-Authored-By` trailer.

Tree-identity check: `git diff 10800c7b HEAD -- packages/ses/test/_namespace-mutation packages/ses/test/namespace-mutation.test.js` was empty. (The unrestricted `git diff 10800c7b HEAD -- .` is not meaningful here because commit `10800c7b` lives in the `endo-but-for-bots` repo, which has a different base than `endojs/endo` master; the tree-identity check is scoped to the test files the squash actually introduces.)

Trailer-strip discipline: `git interpret-trailers --parse` reported no trailers on the squashed commit.

Attribution: `git log origin/master..HEAD --pretty=fuller` shows one commit, author and committer both `Kris Kowal <kriskowal@kriskowal.com>`.

Pre-flight ancestor/lease check: refetched `origin/kriskowal-namespace-mutation` immediately before push; tip still at `bace5d83637be66583dc55b8ee50dd0644c62bca`. Lease honored.

Push mode: `git push origin HEAD:kriskowal-namespace-mutation --force-with-lease=kriskowal-namespace-mutation:bace5d83637be66583dc55b8ee50dd0644c62bca`. Remote reported `+ bace5d836...c6a779d0c HEAD -> kriskowal-namespace-mutation (forced update)`.

Post-push verification: `gh pr view 3231` reports `headRefOid=c6a779d0c0261fdb764cf2b08065b192afb6e8f7`, `state=OPEN`, `isDraft=false`, `reviewDecision=REVIEW_REQUIRED`, `title="test(ses): Verify namespace mutation parity with Node.js"` (untouched).

Out-of-scope items honored: no edits to PR #3231 title or body; no direct comments on #3231; no source-side changes.

Self-improvement: the dispatch's "Tree-identity check: `git diff 10800c7b HEAD -- .` must be empty" is misleading when source and upstream live in separate repos with divergent baselines; the check needs to be scoped to the paths the squash introduces, and the boatman role or a re-ferry skill should say so explicitly to spare the next ferry the head-scratch.
