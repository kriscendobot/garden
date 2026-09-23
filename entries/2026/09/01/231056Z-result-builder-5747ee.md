---
kind: result
role: builder
host: endolin-garden2-5bcdff64
at: 2026-09-01T23:10:59Z
---
Opened draft implementation PR https://github.com/kriscendobot/minion.town/pull/79 against `main` at head `1c92bb8ba1df75eeb200358d0baa3d9c2ce089f3`.

Implemented a source-level maximal MCP tool-name manifest, routed all currently registered guest/sites tools through it, reserved the approved proposed names, rejected maximal-surface duplicates at module load, and added regression coverage for uniqueness, exact names, collision qualification, and prefix removal.

Disposition: current `status`, interface-native baseline names, and `listSites` are wired through the manifest; `submit` is reserved and coordinated with active job `build-minion-town-claude-agents-capability`; attachment-bearing `send`, create-only non-awaiting `request`, and redacting `identify` are reserved/coordinated with `minion-town-pr41-git-remote-build`; `invite` and `cancelInvite` are reserved/coordinated with prerequisite job `minion-town-remote-guest-endo-cli-endo-invite-primitive`, while the minion.town feature remains behind that design's hard gate; `listReminders` and `cancelReminder` are reserved, while the unstarted reminder feature retains responsibility for its remaining method mirrors. Both coordination rounds landed in the owners' durable inboxes, including the PR URL and head SHA.

Executed evidence: `related-design-state.sh ... --related 37,41,60,64,77` returned `related-design-verdict=clear`; targeted Vitest reported 27 passing tests; an intentional `cancelInvite` -> `cancel` mutation made `test/endo-mcp-tool-names.test.ts` fail its exact-name assertion; restored full `npm test` reported 300 passed and 5 skipped gated daemon tests; `npm run typecheck` and `npm run build` exited 0; `GARDEN_YARN=npm pre-push-gates.sh --summary --base-ref origin/main ...` passed all 7 stages; `GARDEN_YARN=npm local-verify.sh ...` exited 0 silently; `git diff --check` exited 0; GitHub Actions `test` passed in 36 seconds at https://github.com/kriscendobot/minion.town/actions/runs/33569719853/job/100060804183.

Follow-up: each owning feature build should import the manifest when it mounts its reserved names; the invitation application feature remains blocked on the Endo primitive, and the reminder feature has no active implementation job.

Self-improvement: nothing this time.
