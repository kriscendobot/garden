**PR #187 can go ahead: `viability=proceed`.** It's still needed and nothing newer has replaced it.

**PR facts:** kriscendobot/minion.town#187, "fix(deploy): install ACL tooling for content GC". It is OPEN, a draft, and not merged. It merges `heal/ad0257e-acl-package` (head `364e8e4a3`) into the frozen base `main-ad0257e` (`ad0257e18`). It has no comments or reviews yet. It is a heal PR from job `heal-minion-town-ad0257e`.

Deciding question: Is `main` still at `ad0257e`, with the content-GC deploy still failing on the missing `setfacl` and no other PR or commit installing the `acl` package?

Evidence:
- **`main` hasn't moved.** Its tip is `ad0257e18e2d050d2ed4b1728f8066f468357097`, which is the PR's base exactly; a compare of base against `main` shows it 0 commits ahead.
- **The deploy failure is still current.** The latest deploy run (run 38610358762, 2026-10-14) at `ad0257e` failed at "Deploy endo-gateway content GC timer" with `FATAL: setfacl missing — install the acl package`. That is the failure the PR fixes, and no deploy has run since.
- **No other fix exists.** Searching PRs for "acl", "setfacl" and "heal ad0257e" finds only #187 among open PRs. The only related merged PR is #93, which introduced the GC timer and caused this failure. On `main`, both installer scripts still stop with that FATAL message instead of installing the package.
- **The PR covers both installers.** It changes `deploy-endo-gateway-gc.sh` and `deploy-git-remote.sh` the same way: install `acl` with `apt-get` only when it is missing, then check `setfacl` again. It also adds a test assertion. CI (typecheck + vitest) passes on the head `364e8e4a3`.

I made no changes to the garden or the project and spent no clean, panel, fix, CI-wait or un-draft budget. The next step is the clean stage of the gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr187-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (252250 cached reads)
- Output: 2069 tokens
- Cost: $0.395918
- Wall-clock: 110s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
