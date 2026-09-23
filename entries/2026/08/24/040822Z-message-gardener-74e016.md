---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-24T04:08:24Z
---
# Dependabotany ledger: endojs/endo-but-for-bots - 2026-08-24 daily backstop

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Recovered the cumulative ledger with the required case-insensitive heading
match, reconciled every live Dependabot PR and the explicitly named PR #923,
and recovered the two new reviews whose dedicated jobs had been parked as
doomed by the reaper.

## PR #1052 - MERGE-NOW executed

The 10-update `all-minor-patch` group was mature, advisory-clean across the
complete moved set on both sides, scripts-disabled installable, and source-read
clean. The freshest incoming version was
`eslint-plugin-eslint-plugin@7.6.2`, published 2026-08-16T08:53:51Z, with floor
2026-08-23T08:53:51Z. Full moved-set and source details are in the verdict at
https://github.com/endojs/endo-but-for-bots/pull/1052#issuecomment-5390180500.

The conductor rebased twice as `llm` moved. The first post-rebase coverage run
reached 530 passing tests but the thixotrope AVA worker failed to exit and was
terminated by SIGINT; the identical job passed on retry, classifying the event
as an operational flake. After PR #1056 moved the base, the conductor
invalidated that green evidence, rebased again, and observed 25/25 checks green
on exact head `7f053bdcbe605c80b4efa77cc425744e7c65c883` in run
https://github.com/endojs/endo-but-for-bots/actions/runs/32687108050. Merged at
2026-08-24T04:06:59Z as
`edb59f2eeeb7ebb4b3bac2ede431fe0aa8c98c9e`. Completion comment:
https://github.com/endojs/endo-but-for-bots/pull/1052#issuecomment-5390593999.

## PR #1056 - MERGE-NOW executed after mechanical migration

`@types/node` 25.6.2 -> 26.2.0 adds the 26.2.0 declaration resolution for the
root and gateway while the 25.6.2 resolution remains for other ranges; it uses
the already-present `undici-types@8.3.0`. Both packages are MIT, runtime-free,
install-script-free, mature (26.2.0 published 2026-08-07T17:52:06Z; floor
2026-08-14T17:52:06Z), and OSV/npm-audit clean.

The old head's only red check contained three real type errors from the Node 26
declarations. Commit `773df355cae423ec8b3b83892d91bf1c4bbe65ab`
mechanically replaced removed `InspectOptionsStylized` with `InspectContext`
and narrowed `ExecException.code` before its numeric mask. The two package type
programs, root type program, TypeDoc conversion, and all 3 rejection-trap AVA
tests passed locally. All 25 checks then passed on that exact head in
https://github.com/endojs/endo-but-for-bots/actions/runs/32685131840. The
conductor merged at 2026-08-24T03:32:37Z as
`bb51be3b9e9eef9e7737a64f04de5ad4d5dd12c3`. Verdict and completion comments:
https://github.com/endojs/endo-but-for-bots/pull/1056#issuecomment-5390222914 and
https://github.com/endojs/endo-but-for-bots/pull/1056#issuecomment-5390427542.

## Active row: PR #1051 remains escalated, not terminal

`changesets/action` 1.9.0 -> 2.1.0 remains OPEN at unchanged head
`11d27db0d8ec478adaa187bfd254b7628cabba30`, now behind live `llm`. Its 25
head-bound checks are green, maturity floor 2026-08-20 is past, OSV remains
empty, and the annotated v2.1.0 tag still dereferences to the pinned commit
`198f833dd7d863100ea6e28967bc9a9fdefadb0a` as of this sweep. Live base still
has the sole call site on v1.9.0 with v1-only inputs, so this remains a genuine
upgrade rather than a no-op.

No terminal verdict is available because the required release-workflow
migration still includes the maintainer-facing choice about token identity and
git-CLI versus GitHub-API push behavior. The earlier fixer orchestration halted
after its first child was reaper-doomed; its fixer and conduct jobs remain
parked. The daily backstop remains present to retain this active row.

## PR #923 - terminal re-confirmation

The job specification's named row remains CLOSED without merge since
2026-08-10T21:25:33Z at head
`d2635dcead1f15a4e3909a0559c0b01f9bc04b76`, under its existing REJECT
(stale group, base moved past it) verdict. No disposition or schedule residue
remains.

The live open Dependabot set is now exactly PR #1051. No new embargo or precise
one-shot was created; the project daily backstop remains active.

Self-improvement: nothing this time.
