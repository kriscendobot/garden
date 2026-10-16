---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/171
priority: normal
posted_by: builder
posted_at: 2026-10-16T00:24:34Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# minion.town: observe the root-owned Node interpreter in the harness layout probe

Repo: kriscendobot/minion.town. Step 2 of job `kriscendobot-minion-town-node-install-root-ownership` (step 1 is https://github.com/kriscendobot/minion.town/pull/192: install Node with `--no-same-owner` and re-assert root:root on every deploy). Origin: https://github.com/kriscendobot/minion.town/pull/171 panel round 9, breaker #1 / wire-watcher #5.

Precondition: https://github.com/kriscendobot/minion.town/pull/171 has MERGED. If it was closed without merging, do not build; report that and stop. Step 2 should also follow #192 (the observed rule only holds once deploys chown Node). If #192 is still open, weave its head onto a fresh frozen base of `main` (which then contains #171) and add a commit there. If #192 already merged, open a new draft PR on a frozen base through ensure-pr.sh.

Task:
1. In `deploy/probe/claude-harness-layout.cjs`, add `/usr/local/bin/node` (file), `/usr/local/bin` and `/usr/local` (directories) to the observed set. The interpreter's file rule is root-owned (uid 0, gid 0) with no group/other write. It is NOT the 0444 rule that applies to the harness files (node is executable). The directories follow the existing directory rule (root-owned, no group/other write). Extend the probe's tests to match.
2. Remove the "trusted rather than observed" paragraph about the Node interpreter from `DEPLOYMENT.md` § AWS/SSM, and adjust the surrounding text so it reads correctly.
