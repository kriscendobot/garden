The viability gate passed: PR #163 should enter the gauntlet. Nothing has replaced it, and the problem it fixes still exists on `main`.

- **PR state:** open, unmerged and still a draft. Head is `80ca7dbb08` on `fix/caddy-restart-on-env-change`, against the pinned base `main-9ac858d`.
- **Deciding question:** Does current `main` still lack a way to restart caddy (the production web server) when its gate-token environment file changes? If so, the 2026-10-05 `/account/claude` → 403 "Forbidden" failure can come back, and the PR is still needed.
- **Evidence:**
  - Comparing the PR's base `9ac858d` with `main` returns `identical` (0 commits ahead). No newer base history could have overtaken it.
  - The PR adds `deploy/aws/scripts/lib/caddy-environment-sync.sh`. On `main`, `deploy/aws/scripts/lib` does not exist (404), so nothing like it has landed.
  - The motivating incident happened today (kriscendobot/garden#89). Production caddy had only been `systemctl reload`ed since 2026-08-12. A reload does not re-read the unit's `EnvironmentFile=`, so caddy sent an empty `X-Account-Gate-Token` and the app answered 403. The hotfix was a manual `systemctl restart caddy`, and nothing on `main` prevents a repeat.
  - The merged #159 (route `/account/claude` to the app) fixed routing, not the environment staleness. It is a companion fix, not a replacement.
  - No other caddy PR overlaps. #153 (convert the deploy scripts to JavaScript) is still open, so it may conflict with this PR later but does not replace it.
  - Earlier review: panel round 1 asked for changes. The main finding is that the two secret scripts restart caddy on every run, before the helper's own check decides whether a restart is needed. That is for the fix loop and does not affect viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (114623 cached reads)
- Output: 1286 tokens
- Cost: $0.3968366
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
