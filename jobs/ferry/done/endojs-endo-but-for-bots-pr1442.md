---
downstream: endojs/endo-but-for-bots#1442
downstream_branch: mirror/endo-3372-ses-frozen-null-pills
upstream: endojs/endo
upstream_base: master
upstream_pr:
human: Dan Finlay <namelessdan@gmail.com>
identity_switch_authorized: true
convention:
---
Ferry endojs/endo-but-for-bots#1442 upstream to endojs/endo (base master).

## Attribution — read carefully, this is NOT the usual ferry shape

This is the multi-author/salvage pattern (skills/pr-handoff/SKILL.md §
Multi-author case), explicitly directed by the maintainer, NOT the default
single-author ferry. The maintainer (kriskowal) was explicit, live in this
conversation: credit Dan Finlay as the author, eschewing BOTH the
maintainer's own contribution and Claude's, entirely.

- Preserve Dan Finlay as the commit AUTHOR (`dan <namelessdan@gmail.com>` on
  the source commit — use `Dan Finlay <namelessdan@gmail.com>` for the
  rewritten identity, matching his upstream GitHub account `danfinlay`).
  Do NOT `--reset-author`. Do NOT attribute any commit to Kris Kowal.
- Strip the `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>`
  trailer per the standing trailer-strip discipline — this is actually
  doubly-confirmed here, not a deviation: the maintainer separately asked
  that Claude's contribution be eschewed too.
- The committer field will mechanically carry the local push identity
  (kriskowal) from the amend — this is the skill's documented "asymmetry
  (author preserved, committer is kriskowal) is correct and standard" for
  the salvage case, and is a credentialing artifact, not a credit claim. The
  PR will likewise show as "opened by kriskowal" (unavoidable — opening a PR
  requires the authenticated account) but every commit's author and the PR
  body's substance must read as Dan Finlay's work.

## Why this is NOT a normal re-ferry, and why a NEW PR is required

`endojs/endo#3372` already exists: Dan Finlay (`danfinlay`) opened it
directly from his own fork (`Globo-Conglomo-Co/endo`, branch
`ses-tolerate-frozen-null-pills`). kriskowal already APPROVED it there.
`endo-but-for-bots#1442` is the garden's MIRROR of that upstream PR, pulled
in to run the gauntlet/CI infrastructure a public external PR can't
(hardened-mode yarn install fails on external fork PRs). The maintainer
directed the bot through gauntlet, a shepherd pass, an upstream-feedback
relay, and a rebase onto current master — all already complete; CI is green
on the fork mirror's current head.

Checked directly before staging this directive (2026-10-14/15):
- `#3372` is now `mergeable: CONFLICTING` (stale against current master —
  upstream master already merged the fix for the configstore/nconf
  resolution issue that #3372's second commit worked around, which is why
  the now-rebased fork mirror's diff dropped that commit entirely — see
  below).
- `#3372` has `maintainerCanModify: false` — Dan has not granted edit
  access.
- kriskowal has **no push permission** on `Globo-Conglomo-Co/endo`
  (confirmed via `gh api repos/Globo-Conglomo-Co/endo --jq .permissions` ->
  `push: false`).

There is therefore **no way to update #3372 in place**. Ferrying here means
opening a **NEW** PR directly on `endojs/endo` (kriskowal has push there)
carrying the rebased, CI-green content with Dan as author — which
functionally **supersedes #3372**, not updates it.

## Content to ferry

Ferry the fork mirror's CURRENT head (`mirror/endo-3372-ses-frozen-null-pills`
on `endo-but-for-bots`, currently ONE commit after the gauntlet's rebase/
squash), not `#3372`'s original two commits. The current fork diff is just:

- `.changeset/frozen-null-pills.md`
- `packages/ses/src/cauterize-property.js`
- `packages/ses/test/error/_lockdown-with-frozen-null-pills.js`
- `packages/ses/test/error/_prepare-with-frozen-null-pills.js`
- `packages/ses/test/error/frozen-null-pill-warnings-node.test.js`
- `packages/ses/test/error/frozen-null-pill-warnings.test.js`

`#3372`'s `package.json`/`yarn.lock` configstore/nconf resolution commit is
correctly ABSENT from this diff — it's redundant after the rebase (upstream
master already fixed the same underlying issue), not an accidental drop.
Carry only what the fork's current head actually has; do not re-add it.

## Upstream PR body

Reference `#3372` explicitly as the PR this supersedes and why (rebased onto
current master; the configstore/nconf workaround #3372 needed is no longer
necessary because master already carries an equivalent fix underneath this
change). Standard pr-formation discipline otherwise (What/Why/Attend-to/Out-
of-scope, no checklists, no file callouts, no garden-internal references).

## After the PR is open — DO NOT close #3372 yourself

Report the new PR's URL, number, and head SHA, and whether CI has gone green,
in the completion report. **Do not close `#3372` and do not comment on it.**
The maintainer will handle closing #3372 once the new PR is confirmed healthy
— this was discussed live with the maintainer and is being done separately
from this directive, not delegated to the boatman.

---
ferry_claim:
  host: kmkmbp2026
  claimed_at: 2026-10-15T02:48:56Z

---
ferry_done:
  completed_at: 2026-10-15T02:51:46Z
  exit: 0
  log: /Users/kris/garden/.garden-ferry/logs/endojs-endo-but-for-bots-pr1442.20261015T024859Z.log
