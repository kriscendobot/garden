---
role: builder
tier: mentor
arc: minion-town-git-remote
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-17T05:38:22Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: headless-browser coherence run for the minion.town served clip (#181)

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/181
(served-clip build, head branch `git-remote-served-clip`; design #177,
`designs/git-remote-served-clip.md` § 10 "Coherence in a real browser").

§ 10 requires a headless-browser observation that #181 does not carry: load a
served-clip page whose script stalls until a second push lands, then assert that
every sub-resource came from the FIRST root (no mixed-root page). #181 covers the
straddling push only at the HTTP level. Add the browser run (the repo has no
browser dependency yet — pick the lightest viable one, e.g. Playwright chromium
as a devDependency, and wire it into CI), as a follow-up commit on #181's head
via safe-push-pr-head.sh or a stacked draft PR if #181 has merged. When it lands,
update #181's (or the successor PR's) Phase ledger to `deliverable`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T05:39:25Z
