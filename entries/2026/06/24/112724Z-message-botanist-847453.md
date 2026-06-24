---
kind: message
role: botanist
host: endolinbot
at: 2026-06-24T11:27:26Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger row: endojs/endo-but-for-bots#270

Terminal verdict **MERGE-NOW**, executed (conducted onto `llm`). No embargo row and
no recheck schedule: maturity was satisfied (73 days), so the daily
`dependabotany-recheck` heartbeat is not the instrument. Appended to the
`endojs/endo-but-for-bots` dependabotany ledger under the standing
`project: endo-but-for-bots` tag.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [270](https://github.com/endojs/endo-but-for-bots/pull/270) | GitHub Action `softprops/action-gh-release` 2.2.2 -> 3.0.0 in `.github/workflows/familiar-release.yml` (base `llm`) | **MERGE-NOW** (conducted) | n/a | **MERGED** (`190dbe9a76dc4f31491e0119501bdeb0f9a436cf`, 2026-06-24T11:25:53Z) | Single-line SHA-pin bump, no source files. New pin `b4309332981a82ec1c5618f44dd2e27cc8bfbfda` authentically resolves to upstream `v3.0.0` tag commit. Published 2026-04-12 (73 days mature). v3.0.0 substance is the action runtime moving Node 20 -> Node 24 (`action.yml` declares `using: "node24"`); upstream `v2.2.2...v3.0.0` source-diff scan surfaced only standard GitHub-API token handling, no external endpoints / eval / spawn / download-exec. OSV `{}` and GHSA empty: no advisory on the moved version. CI was **stale** (633 commits behind base, reproducing transient base-branch lint+cover failures since fixed on `llm`); after `update-branch`, fresh run [28092543244](https://github.com/endojs/endo-but-for-bots/actions/runs/28092543244) is **23/23 green, conclusion success**, cross-checked against head `49fa9fc2d9d13faabffe5a5479199103470e9eee`, `mergeStateStatus: CLEAN`. Verdict comment [issuecomment-4788719946](https://github.com/endojs/endo-but-for-bots/pull/270#issuecomment-4788719946). |

## Botanist self-notes for this PR

- **A Dependabot GitHub-Actions PR is a SHA-pin bump, not an npm lockfile bump; the same gate applies with the transitive set being the action's own runtime, not a `node_modules` tree.** "Read the lockfile transitive set" maps to "verify the new SHA authentically resolves to the claimed tag" (`gh api .../git/refs/tags/<tag>`) plus reading the upstream source compare between old and new tag. "Install with scripts disabled" is a no-op here (no npm install; the action runs only on release events on GitHub-hosted runners), so that workflow step is satisfied vacuously and should be reported as such, not skipped silently.
- **A stale Dependabot PR re-uses month-old CI; `update-branch` is the shepherd move that distinguishes stale base failures from real ones.** #270's red lint+cover were from a run 633 commits behind base; the same checks pass on sibling open PRs, and `cover (24.x)` went green immediately on the fresh run. The cheap discriminator before trusting OR distrusting a red rollup is `gh api repos/<r>/compare/<base>...<head>` (here `behind_by: 633`); a large `behind_by` means re-run against current base before classifying the failure as real.
- **GitHub-hosted runners support the Node 24 Actions runtime, so a `using: node24` action bump is safe for a workflow that runs on `ubuntu-latest`.** The one compatibility caveat in the v3.0.0 release notes (self-hosted fleets lacking Node 24) does not apply to this repo's release workflow.
