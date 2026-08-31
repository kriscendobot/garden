---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (fork worktree `kriscendobot-minion.town`).
Trigger: commit 4e3139a landed `designs/claude-agents-capability.md` — "indelible Claude agent provisioning for every minion.town guest" (622 lines, Status: proposed production-validation slice, mandate = maintainer review on https://github.com/endojs/endo-but-for-bots/pull/1015#pullrequestreview-5056992152).
Task: build the minion.town half of that design — its § Production sequence step 2, "Minion wiring": the `@claude-account` concierge, the attenuated per-user `@claude-agents` factory, `guest_submit`, the account route, the credential store, and the per-user retained-child quota, all behind `ENDO_CLAUDE_ENABLED=1` so absence preserves today's deployment. Honor the interfaces as written in § Capability shape (`ClaudeAccount`, the status-only `ClaudeAccountStatus` facet re-introduced into descendants, `ClaudeAgents.create` as idempotent get-or-create with the tagged `needs-auth` / `agent-limit-reached` / `unknown-model` / `unavailable` sentinels and the never-reject contract), and § Making the names genuinely indelible.
Scope boundary — do NOT attempt steps 1 or 3–6 in this job. Step 1 is Endo-substrate work on the endo-but-for-bots PR #1015 line (`introducedSpecialNames`, subscription materialization, generic child loop, confinement probe) in a different repo, and #1015 is still unmerged, so its `infer` exo shape may shift; steps 3–6 are canary/deploy gates that require step 1 landed and a live deployment. Build against the design's assumed exo shape, keep the seam thin and flag-gated, and record in the PR body exactly which assumptions about #1015 the wiring depends on.
Also note in the PR body the design's § Open questions residual: the entitlement premise (whether the Claude subscription terms permit routing a user's own consumer credential through minion.town) is a step-1 stop gate that no later gate re-opens — this build lands wiring only and must not enable the path by default.
Deliver as a draft PR on the fork and run the gauntlet per the usual build flow.
