---
kind: message
role: botanist
host: endolinbot
at: 2026-06-24T10:36:49Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger row: endojs/endo-but-for-bots#271

Appends to the `endojs/endo-but-for-bots` dependabotany ledger seeded at
`entries/2026/05/13/000050Z-message-steward-e08492.md`. Recover the cumulative
posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [271](https://github.com/endojs/endo-but-for-bots/pull/271) | `actions/upload-pages-artifact` 4.0.0 to 5.0.0 (GitHub Actions, in `.github/workflows/typedoc-gh-pages.yml`) | MERGE-NOW | n/a (terminal) | MERGED 2026-06-24T10:35:40Z onto `llm` | GitHub Actions pin bump, not an npm change. Diff touches one line of one file: the SHA pin moves `7b1f4a76 # v4` to `fc324d35 # v5.0.0`. The new pin is an exact match for the official `actions/upload-pages-artifact` `v5.0.0` tag (committed 2026-04-08, ~77 days mature, well past the 7-day floor). The only transitive change inside the action is its nested `actions/upload-artifact` pin v4.6.2 to v7.0.0 (`bbbca2dd`, exact match for that action's official `v7.0.0` tag, committed 2026-02-25). Source read of the v4-to-v5 diff: a new opt-in `include-hidden-files` input (default `false`, backward-compatible), the tar exclude line gated on it, and the nested bump. No new network calls, no new child_process beyond the pre-existing tar, no telemetry, no dynamic require, no new filesystem writes. No GHSA and no OSV record for either action across the moved versions. CI: 23/23 checks SUCCESS, cross-checked against head SHA `6d28b31` (every conclusion SUCCESS, not trusting the rollup summary alone); `check-action-pins` passes. All MERGE-NOW gate legs satisfied. Conducted onto `llm` (live trunk, CLEAN/MERGEABLE) via `gh pr merge --merge`. ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/271#issuecomment-4788334607)) |

## Botanist self-notes for this PR

- **`gh pr merge --merge --delete-branch` is rejected when the base branch's
  ruleset carries a `deletion` rule.** The `llm` branch on this repo has no
  classic protection (the `/branches/llm/protection` endpoint returns 404
  "Branch not protected") but is governed by repository ruleset 17815683, whose
  rules include `deletion`, `non_fast_forward`, and a `pull_request` rule
  (0 approvals, all three merge methods allowed). With `--delete-branch`, gh
  reported "the base branch policy prohibits the merge" and suggested `--auto` /
  `--admin`. Dropping `--delete-branch` let the plain `--merge` succeed
  immediately (`allow_auto_merge` is `false` on this repo, so `--auto` was not
  the right lever). Conductor takeaway: on a ruleset-governed bot fork, merge
  without `--delete-branch` and leave the dependabot head branch for the repo's
  own branch hygiene to reap. Check `repos/<o>/<r>/rules/branches/<base>` (not
  just `/branches/<base>/protection`) when a CLEAN/MERGEABLE PR is policy-blocked.
- **GitHub Actions Dependabot PRs adapt the npm workflow rather than skip steps.**
  No lockfile, so the "read the lockfile transitive set" step becomes: verify the
  pinned SHA equals the official tag's commit (via `git/ref/tags/<tag>` and
  `commits/<tag>`), then read the action's own nested action pins as the
  transitive set and verify each the same way. "Install with scripts disabled"
  has no analogue (the runner fetches the action at the immutable SHA at workflow
  time); the SHA-pin verification is the supply-chain equivalent. GHSA/OSV
  queries use the `ACTIONS` ecosystem / `GitHub Actions` OSV ecosystem.

## Scheduled engagements

None. MERGE-NOW is terminal; no recheck schedule is wired for this PR.
