---
tier: mentat
dispatch: manual
---
# Deploy and validate git.minion.town; carry kriscendobot/minion.town#86 to production

You have full authority to carry this PR forward through review, merge, and
deploy — act as the supervisor for the whole arc, not just one stage. Report
back when it's done (or when you hit a real blocker you cannot resolve
yourself); no intermediate check-in is required.

## Context

PR: https://github.com/kriscendobot/minion.town/pull/86 ("feat(git-remote):
capability-addressed smart-HTTP git remote, increment 1 (built, not
deployed)"), draft, base `main-b32291d`. Per its own title it is built but
not deployed. An outstanding review thread is waiting on you:
https://github.com/kriscendobot/minion.town/pull/86#discussion_r4127032558
— kriskowal asked "Please explain the Z in `/healthz`" on
`src/endo/git-remote/app.ts`. Reply on that thread (it's a quick one — the
`/healthz` spelling is the conventional Kubernetes-style health-check path
suffix, not a typo) before or as part of moving this forward, so it stops
sitting unacknowledged (it's been open a while and the comment-ack watchdog
has flagged it repeatedly).

## Task

1. Get the PR review-ready: run it through whatever gauntlet stages remain
   (`skills/pr-creation-flow/SKILL.md`), addressing the open review thread
   above and anything else review surfaces.
2. Once approved and green, merge it.
3. Get `git.minion.town` actually deployed and live — DNS/TLS, hosting,
   process supervision, whatever the merged change specifies as the
   deployment surface. If the PR's own content doesn't fully specify the
   subdomain wiring, figure out what minion.town's existing subdomain
   provisioning mechanism requires (check how other *.minion.town services
   are wired, e.g. the weblet-gateway increment) and do it.
4. Validate it live: confirm the smart-HTTP git-remote capability actually
   works end-to-end against the deployed git.minion.town (a real clone/push
   exercising the capability-addressed remote, not just a health check).
5. Report what's now live, what you validated, and how.

Production-npm-registry-style promotion concerns don't apply here — this is
a garden-owned service on garden-owned infrastructure (minion.town), so
"production" just means live and working at git.minion.town, not a
third-party release gate.
