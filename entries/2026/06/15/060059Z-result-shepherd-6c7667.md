---
ts: 2026-06-15T06:00:59Z
kind: result
role: shepherd
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
dispatch_root: /home/kris/dispatches/shepherd--6c7667
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 2
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/2
  - https://github.com/kriscendobot/agoric-sdk/pull/2#issuecomment-4705002620
  - https://github.com/kriscendobot/agoric-sdk/actions/runs/25828059706
---

# result: shepherd (6c7667) — PR #2 CI explanation for maintainer

Maintainer asked 2026-05-18 "Please explain the failing CI checks", then
re-RSVP'd 2026-06-09T03:20:31Z. 6 days passed with no shepherd response
until this dispatch at 2026-06-15T05:57Z.

## PR state at dispatch

- `kriscendobot/agoric-sdk#2` "chore(xsnap): pin xsnap submodule at agoric-labs/xsnap-pub#50 mirror for evaluation"
- Branch: `integrate/xsnap-pub-pr-50` at `f2a3b6501a709c8e8d566207446a75ca5db1a69d`
- Base: `dev-upgrade-23`
- DRAFT, MERGEABLE, mergeStateStatus UNSTABLE
- Single CI run on the head: workflow "Test all Packages" (run id `25828059706`), event `pull_request`, run_started_at `2026-05-13T21:41:22Z`, conclusion CANCELLED, updated_at `2026-05-14T21:49:51Z`.

## Per-job diagnosis

Six jobs reported as failed in the rollup, all with duration 24h00m01s:

- `test-cosmic-swingset (node-new)` (job 75887417117)
- `test-cosmic-swingset (node-old)` (job 75887417087)
- `test-cosmic-swingset (xs)` (job 75887417169)
- `test-quick (node-new)` (job 75887417022)
- `test-quick (node-old)` (job 75887417018)
- `test-quick (xs)` (job 75887417008)

All six started 2026-05-13T21:49:49Z and cancelled 2026-05-14T21:49:50Z. Each job's API surface shows:

- `steps: []` (no step ever ran)
- `runner_id: 0`, `runner_name: ""`, `runner_group_name: ""`
- `labels: ["ubuntu-latest-16core"]`

For comparison, a successful sibling job (`test-codegen`, job 75887417015) shows `labels: ["ubuntu-latest"]`, `runner_id: 1000000048`, `runner_group_name: "GitHub Actions"`.

In `.github/workflows/test-all-packages.yml`:

- `test-quick` (line 182): `runs-on: ubuntu-latest-16core # avoid exit 129`
- `test-cosmic-swingset` (line 591): `runs-on: ubuntu-latest-16core # avoid exit 129`

Every other job in the workflow requests `runs-on: ubuntu-latest`.

`ubuntu-latest-16core` is a GitHub-hosted larger runner, provisioned at the **Agoric organization** level. The fork `kriscendobot/agoric-sdk` is a personal account (`owner_type: User`, confirmed via `gh api repos/kriscendobot/agoric-sdk`), so it has no access to that runner SKU. The six jobs queued waiting for a runner that does not exist for this fork, hit GitHub Actions' 24-hour max-queue-time, and were terminated. This is structural, not a flake.

Every other check in the rollup passed: build, test-codegen, check-lockfiles, dependency-graph, lint-primary, lint-rest, gotest, golangci-lint, Nix flake, Protobuf lint, Documentation, Pre-merge checks, all 3 `test-quick2` shards, `test-zoe-unit` x3, `test-zoe-swingset` x3, `test-fast-usdc-deploy` x2, `test-portfolio-contract` x2, `test-governance` x2, `test-solo` x2, `test-inter-protocol` x2, all 12 `test-boot` shards, all 15 `test-swingset` shards.

## Reruns

Attempted `gh run rerun 25828059706 --failed --repo kriscendobot/agoric-sdk`. Rejected: "Unable to retry this workflow run because it was created over a month ago." The original run is from 2026-05-13 (>30 days ago).

Did **not** push an empty commit. The 16-core gap is structural to the fork's owner type; a fresh push would produce another `pull_request` run that queues the same six jobs against an unavailable runner SKU and cancels them after 24 hours. The dispatch authorized the empty-commit option but explicitly conditioned it on "if appropriate"; reproducing the same outcome would burn maintainer cycles without new signal.

## PR comment

Posted top-level explanation @-mentioning @kriskowal:

https://github.com/kriscendobot/agoric-sdk/pull/2#issuecomment-4705002620

Two recommended paths offered in the comment body:

1. Treat the partial matrix as informative and proceed (every check that can run in the fork is green; the xsnap-pub pin under evaluation does not interact with the cosmic-swingset or fast-test paths).
2. Ferry upstream to `Agoric/agoric-sdk` where `ubuntu-latest-16core` is available; boatman path needing maintainer authorization.

The comment explicitly states the shepherd will not push, re-rerun, or change draft state without further instruction.

## Recommended next stage

`next: liaison`. The choice between the two paths is a maintainer decision (accept the partial CI signal vs. ferry upstream to obtain the full signal), not a fixer or weaver impasse. The liaison surfaces the comment to the maintainer when next engaged. Mechanically there is nothing left for a shepherd to do on this PR: the rollup is settled (terminal), the cause is identified and documented, and the only paths forward require maintainer authorization (either drop the gating on the unreachable jobs, or ferry).

Self-improvement: nothing this time. The diagnostic recipe (cancelled-after-24h + empty steps + null runner_id => unreachable runner SKU) is already a documented shape; the only novelty was the structural-vs-flake distinction on a personal fork, which the shepherd role file's existing "impasse" framing covers without needing a new skill entry.
