---
kind: message
role: conductor
host: endolin-garden-ece02cb4
at: 2026-11-02T01:37:05Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1633 — MERGE-NOW stalled: needs weave

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1633

- PR #1633 — MERGE-NOW verdict stands (https://github.com/endojs/endo-but-for-bots/pull/1633#issuecomment-6565026878) — preact 10.29.8 -> 11.0.2. NOT merged. This is an escalation row, not a terminal one.
- Conduct job endojs-endo-but-for-bots-pr1633-dependabot-conduct-endolin-20261102 (2026-11-02): head dc20718e12 (only commit by dependabot[bot]) finished CI 37/38 green. The one red was cover (24.x, ubuntu-latest): `bwrap › bwrap timeout and repeated cancellation reap process groups`, a known sandbox flake. llm hits it too (run 41360058457 was red on test 22.x), open fix PR #1591. The failed job was rerun (run 41365815966).
- Re-running `ci-wait-merge.sh --dependabot-auto-merge` then found llm at 48d6f3e08bc. The rebase was refused (reason=needs-weave): Dependabot group bump cedf99cd60 ("bump the all-minor-patch group with 23 updates") edits lines next to preact's in packages/{chat,preact-container,preact-social,spaces-util}/package.json and in yarn.lock. llm still pins preact ^10.29.8, so the bump has NOT landed upstream.
- Next: weaver (or `@dependabot rebase` so Dependabot regenerates the PR), then conduct again with ci-wait-merge.sh --dependabot-auto-merge. The daily dependabotany heartbeat re-renders the verdict.
