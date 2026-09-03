---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (fork worktree `kriscendobot-minion.town`).
Trigger: commit 4e3139a landed `designs/claude-agents-capability.md` — "indelible Claude agent provisioning for every minion.town guest" (622 lines, Status: proposed production-validation slice, mandate = maintainer review on https://github.com/endojs/endo-but-for-bots/pull/1015#pullrequestreview-5056992152).
Task: build the minion.town half of that design — its § Production sequence step 2, "Minion wiring": the `@claude-account` concierge, the attenuated per-user `@claude-agents` factory, `guest_submit`, the account route, the credential store, and the per-user retained-child quota, all behind `ENDO_CLAUDE_ENABLED=1` so absence preserves today's deployment. Honor the interfaces as written in § Capability shape (`ClaudeAccount`, the status-only `ClaudeAccountStatus` facet re-introduced into descendants, `ClaudeAgents.create` as idempotent get-or-create with the tagged `needs-auth` / `agent-limit-reached` / `unknown-model` / `unavailable` sentinels and the never-reject contract), and § Making the names genuinely indelible.

**MAINTAINER AMENDMENT (kriskowal, 2026-09-03, https://github.com/kriscendobot/minion.town/pull/64#issuecomment-5532147420):** "Please post a builder, but let's qualify that we only want the root user account to be endowed with the claude agent constructor, and they may then communicate that to connected guests." This narrows the design's own "every new guest" mandate: do **not** provision `@claude-agents` as an indelible special name on every newly-created minion.town guest. Only **one designated root/admin account** is endowed with the `@claude-agents` constructor by default. That root account may then **explicitly communicate** (grant/share, e.g. via the send-a-capability-as-mail path already used elsewhere in this repo's guest model, or an equivalent deliberate hand-off) the factory to specific connected guests it chooses — never an indelible default every guest is born with. The design doc's already-stated root-vs-descendant split for `ClaudeAccount` (full handle only on "the root user's own guest," status-only `ClaudeAccountStatus` on descendants) is the right shape to imitate for `ClaudeAgents` too: build the factory as a capability the root account holds and can deliberately extend outward, not as a name the daemon indelibly re-introduces into every guest tree. Land this narrower scope in the PR, and amend `designs/claude-agents-capability.md` itself (its title and § Problem/Capability-shape framing currently say "for every guest") to match, rather than building against the stale "every guest" premise and leaving the design doc contradicting what actually shipped. If any part of this qualification is ambiguous once you're reading the daemon-side code (e.g., exactly what "communicate that to connected guests" should mechanically be — a mail-borne capability grant vs. something else), say so in the PR body and pick the most conservative (least-indelible, most explicit-consent) reading rather than guessing toward more automatic propagation.

Scope boundary — do NOT attempt steps 1 or 3–6 in this job. Step 1 is Endo-substrate work on the endo-but-for-bots PR #1015 line (`introducedSpecialNames`, subscription materialization, generic child loop, confinement probe) in a different repo, and #1015 is still unmerged, so its `infer` exo shape may shift; steps 3–6 are canary/deploy gates that require step 1 landed and a live deployment. Build against the design's assumed exo shape, keep the seam thin and flag-gated, and record in the PR body exactly which assumptions about #1015 the wiring depends on.
Also note in the PR body the design's § Open questions residual: the entitlement premise (whether the Claude subscription terms permit routing a user's own consumer credential through minion.town) is a step-1 stop gate that no later gate re-opens — this build lands wiring only and must not enable the path by default.
Deliver as a draft PR on the fork and run the gauntlet per the usual build flow.



<!-- garden-transient-elapsed: kind=signature through=1 values=3,2 -->

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T21:52:06Z
