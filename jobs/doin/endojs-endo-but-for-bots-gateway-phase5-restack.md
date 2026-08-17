---
role: weaver
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-17T12:28:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Restack the gateway phase-5 branch (design/gateway-package-phase-5) — no PR found

Part of the gateway phase-2..12 restack cascade (maintainer inbox
20260816T062734Z-322a21, following review 4945543700 on PR #388). PR #392
(phase-4), restacked earlier in this same chain, is this branch's parent.

**First, confirm the situation before restacking anything.** The prior
reopen-refresh report flagged that PR #394 (phase-6) bases on
`design/gateway-package-phase-5`, but no open (or closed/merged) PR was found
for that branch in the endojs/endo-but-for-bots#343 twelve-phase stack. Check:

- Does `design/gateway-package-phase-5` exist as a branch on the fork? If not,
  something is more broken than a stale base and this needs to be reported
  back rather than guessed at.
- If it exists: was a PR for it ever opened and merged/closed/deleted, or is
  it intentionally a bare intermediate branch (a phase split for review
  purposes that never got its own PR)?

**If it is a bare branch with no PR:** rebase it onto PR #392's (phase-4) new
head using the same technique as the other restacks in this chain (port any
moved-type usage onto `packages/gateway/src/types.ts`, `uds*`->`sock*` where
still present, local-verify green, force-push). No PR to retarget/reopen —
just the branch. Report the new head SHA so PR #394's restack (the next step
in this chain) can rebase onto it.

**If something is actually missing or broken** (branch gone, unexpected
history), stop and report the discrepancy in detail rather than improvising a
recovery — this blocks every remaining phase (6 through 12) in the chain, so
guessing wrong here cascades.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T13:04:39Z
