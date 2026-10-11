---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/166
priority: normal
posted_by: producer
posted_at: 2026-10-11T08:52:30Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave kriscendobot/minion.town#171 onto `main` once #166 lands

https://github.com/kriscendobot/minion.town/pull/171 (item 1's automatic production validation for arc
https://github.com/kriscendobot/garden/issues/89) is stacked on draft
https://github.com/kriscendobot/minion.town/pull/166 through the frozen base
`feat/prod-objectives-probe-7d7085c`. #166's head has since moved (`1b51f5b5`, fix round 6), and
the job that was to restack #171 when #166 lands (`resume-minion-town-pr171-after-pr166-20261010`)
has already completed, so nothing owned this step. This job is blocked on #166 and promotes when it
merges or closes.

Minion.town review is delegated to the garden (maintainer standing order 2026-10-07; journal
`entries/2026/10/07/203746Z-message-gardener-a253b1.md`). No escalation.

Do:
1. If #166 MERGED: weave #171 onto `main` (frozen-base-branch skill: snapshot `main`'s tip, rebase
   #171's single commit onto it, resolve conflicts, force-push, move #171's base). Wait for CI green.
2. If #166 CLOSED unmerged: decide whether #171 stands alone on `main`; if it does, weave as above;
   if it depended on #166's content, carry that content into #171 or close #171 naming what
   superseded it.
3. If #171's panel has not reviewed the woven head, resume its gauntlet
   (`scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet panel --add-rounds 1`,
   or a fresh gauntlet if that record cannot resume). Un-draft when the gauntlet is clean.
4. Leave the merge to the proxy screen (`scripts/jobs/minion-town-screening.sh status` must print
   `active`). Never merge by hand; never resume a `paused` delegation.
