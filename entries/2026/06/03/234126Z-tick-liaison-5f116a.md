---
ts: 2026-06-03T23:41:26Z
kind: tick
role: liaison
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Ferry of endo-but-for-bots#421 declined as a duplicate; bots#421 closed as superseded.

#421 "chore(ci): pin changesets/action comment to v1.8.0 (zizmor fix)" is a byte-identical fix to the already-open upstream **endojs/endo#3297** by **boneskull**: same `.github/workflows/release.yml` line 63, same 2-char change `changesets/action@63a615b9... # v1` -> `# v1.8.0`. boneskull's #3297 is OPEN/MERGEABLE. The bot independently reached the same defensive fix (keep the SHA pin, correct the comment) after the zizmor failure surfaced on #411's CI.

Maintainer chose: don't ferry, close #421. Posted a supersede comment on #421 (comment 4617618177) phrased WITHOUT the `endojs/endo#3297`/URL auto-link token so no cross-reference back-ref lands on boneskull's upstream PR (keeps bot-side activity invisible upstream per External-repo etiquette), and closed #421 under the authenticated identity (allowed on the garden's own repo). No upstream PR opened, no boatman dispatched.

Pattern: this is the second "ferry #N" this session that resolved to a coordination/duplication check rather than a ferry (cf. #411 vs naugtur's #3254). The pre-ferry upstream-overlap search (existing PR touching the same file/lines) is earning its keep; worth keeping as a standing pre-ferry step.
