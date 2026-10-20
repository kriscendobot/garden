---
role: weaver
pr: https://github.com/kriscendobot/minion.town/pull/201
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Weave kriscendobot/minion.town#201 onto current main

https://github.com/kriscendobot/minion.town/pull/201 (head `feat/new-clip-inventory`, base `main`) is
mergeable=CONFLICTING since kriscendobot/minion.town#198 (beta home splash / waitlist) merged into
`main` at 2026-10-20T12:12:53Z (`6c66c2f`), so CI cannot run. Pin the merge base: snapshot main's
current tip to a frozen `main-<short-sha>`, rebase the head onto it, resolve conflicts, force-push
the head with `scripts/jobs/gardening/safe-push-pr-head.sh --mode rewrite`, and move the PR base.

Known conflict (merge-tree of head `34a4810` vs `6c66c2f`): `designs/clip-shell-framework.md`, the
shell-surface bullets near § "Deployment" (PR side lists the gated `@guestSelf` routes incl.
`POST /account/clips/new`; #198 rewrote the paragraph for the public landing + splash). Keep #198's
new framing and add `POST /account/clips/new` to its `@guestSelf` route list. Also check that the
Caddy `@guestSelf` route for `POST /account/clips/new` still sits behind `forward_auth` in #198's
reworked `minion-town.caddy`.

Do NOT merge, and do not touch the open maintainer ruling (#85 direction, `designs/new-clip.md`
Open questions). Watch CI to green with `scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 201 --no-merge`.
