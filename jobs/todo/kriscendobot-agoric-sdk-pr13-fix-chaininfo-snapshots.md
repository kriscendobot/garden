# fixer (shepherd→fixer auto-chain) on kriscendobot/agoric-sdk PR #13

A shepherd drove the tractable CI failures on PR #13 and reached an
environmental impasse on the remaining ones. This job regenerates the
chain-info-dependent snapshots. See roles/fixer/AGENT.md.

PR: https://github.com/kriscendobot/agoric-sdk/pull/13
Head branch: xst/integrate-variant-bump  (bot-pushable)
Head SHA at handoff: 151be9e70 (shepherd's eslint fix already pushed on top of 2dc7ed735)

## What the shepherd already fixed (landed, do NOT redo)
- **lint-primary / lint-rest** were failing with a Node heap OOM (ESLint
  killed by SIGABRT). Root cause: the PR added a from-source Moddable 5.5.0
  tree under `packages/xsnap/latest/{moddable,xsnap-native}/` and excluded it
  from prettier (`.prettierignore`) and typecheck (`tsconfig.build.json`,
  `tsconfig.quickcheck.json`) but NOT from ESLint, so repo-wide lint walked the
  vendored source and OOM'd. Shepherd added the two `latest/` paths to the
  `eslint.config.mjs` ignore list (commit 151be9e70) mirroring the existing
  `packages/xsnap/{moddable,xsnap-native}/` entries. Verify this cleared the
  lint OOM on the fresh run; no further lint action expected.

## What remains (the fixer's work): regenerate chain-info baggage/vstorage snapshots
Root cause: commit `333a12e52 chore(orchestration): refresh fetched-chain-info
from registry` (added by a peer to satisfy verify-codegen-idempotence) refreshed
`packages/orchestration/src/fetched-chain-info.js`, adding new IBC connections
(injective-1, cosmoshub-4, …). That data flows into every chainHub-using
contract's baggage, but the downstream AVA snapshots were not regenerated, so
they now diff (e.g. `- 'agoric-3_injective-1': Object {…}`).

Failing snapshot suites to regenerate (`yarn test --update-snapshots` in each,
then commit the updated `test/snapshots/*.md` + `*.snap`):
- packages/fast-usdc-contract — `fast-usdc.contract` (used/initial baggage)
- packages/portfolio-contract — `portfolio.contract` initial baggage (# fail 9)
- packages/orchestration (or the send-anywhere example pkg) — `send-anywhere › baggage`
- packages/boot — `vstorage-chain-info › config` (test-boot node-old shard 2/4)
Re-grep the live run for the full list; there may be more shards/packages once
`build` re-runs on 151be9e70.

Scope judgment to make (surface to liaison if unsure): the chain-info refresh is
"unrelated to the XS engine bump" by its own commit message. Either (a) keep it
and regenerate all downstream snapshots in this PR, or (b) split the chain-info
refresh + its snapshot regen into its own PR to keep this one focused on the
xsnap variant split. Default to (a) unless the maintainer prefers a split.

NOTE — out of scope, do NOT try to fix: **test-ymax-planner-build** fails with
`permission_denied: Invalid token` on `depot build` (missing DEPOT_TOKEN secret
on the fork). Fork infrastructure limitation, not PR-caused, expected-red on any
fork PR. Leave it.

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 3 -->
