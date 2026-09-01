Completed draft PR https://github.com/kriscendobot/minion.town/pull/79 against `main`.

- Head: `1c92bb8ba1df75eeb200358d0baa3d9c2ce089f3`
- Added a maximal-surface MCP tool-name manifest, routed existing registrations through it, and added collision/prefix regression tests.
- Reserved `submit`, `invite`, `cancelInvite`, `request`, `identify`, `listReminders`, and `cancelReminder`.
- Coordinated ownership with:
  - `build-minion-town-claude-agents-capability`: `submit`
  - `minion-town-pr41-git-remote-build`: attachment-bearing `send`, non-awaiting create-only `request`, redacting `identify`
  - `minion-town-remote-guest-endo-cli-endo-invite-primitive`: invitation prerequisite and subsequent `invite`/`cancelInvite` wiring
- Reminder implementation has no active job; its known qualified names are reserved, while remaining method reconciliation stays with its eventual build.

Evidence:

- Related-design gate for PRs 37, 41, 60, 64, and 77: `related-design-verdict=clear`
- Targeted tests: 27 passed
- Regression mutation (`cancelInvite` to `cancel`): exact-name test failed as intended
- Full `npm test`: 300 passed, 5 gated daemon tests skipped
- `npm run typecheck`, `npm run build`, `git diff --check`: passed
- Pre-push gate: all 7 stages passed
- Local verification harness: exited 0
- GitHub Actions `test`: passed in 36 seconds

Follow-up: feature builders should import the manifest when mounting reserved tools. Invitation application work remains gated on the Endo primitive.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-pr77-tool-name-reconciliation-review5083753201.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 479s

<!-- garden-usage-end -->
