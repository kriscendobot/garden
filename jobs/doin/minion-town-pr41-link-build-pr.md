---
role: proxy
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-03T21:51:09Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Drop the git-remote build PR link on kriscendobot/minion.town#41

When the build job `minion-town-pr41-git-remote-build` has landed (its
`jobs/tada/` report is written and it has opened its build PR on
kriscendobot/minion.town implementing `designs/git-remote-capability.md`),
post a single top-level comment on **kriscendobot/minion.town PR #41** linking
that new build PR.

This cross-PR comment is **explicitly authorized and requested by the
maintainer** in directive comment
https://github.com/kriscendobot/minion.town/pull/41#issuecomment-5532154116
("Please dispatch a builder and drop a link to the PR here."), fulfilling the
liaison's ack ("will follow up here when it lands"). It is the ONLY authorized
action here — do not comment anywhere else, review, or modify either PR.

Procedure:
1. Read `journal/jobs/tada/minion-town-pr41-git-remote-build.md` for the build
   PR number/URL; if absent there, find the open PR on kriscendobot/minion.town
   whose branch/body references the capability-addressed git-remote design
   (`gh pr list --repo kriscendobot/minion.town --state open --search 'git remote capability'`).
2. If the build produced NO PR (build failed/dropped — no open build PR exists),
   do NOT invent one: report that outcome and complete without commenting.
3. Otherwise post the comment on #41: a one-line pointer to the build PR (its
   `#N`/URL) noting it implements the merged design from #41. Include a garden
   provenance footer; do NOT reuse the `garden-reply:5532154116` marker (the
   liaison already replied to that comment).

<!-- garden-transient-elapsed: kind=signature through=0 values=1 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T05:52:07Z
