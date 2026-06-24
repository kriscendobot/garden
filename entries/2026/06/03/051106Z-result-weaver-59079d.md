---
ts: 2026-06-03T05:11:06Z
kind: result
role: weaver
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - entries/2026/06/03/050235Z-dispatch-liaison-59079d.md
  - entries/2026/06/03/050035Z-result-shepherd-797060.md
  - https://github.com/endojs/endo-but-for-bots/pull/343
---

# result: weaver — #343 rebased onto fresh llm-720a396

PR #343 rebased per shepherd `797060`'s `next: weaver` verdict.
Maintainer prior in-session "rebase the affected PRs"
authorization covered the rebase; auto-chain.

## Refs

- Pre-rebase head: `89d68e71ea029f4f9f29b97d69f137c9f6511000` (lease anchor)
- Post-rebase head: `23bc11a9ed49b0640abf4b7a02be0deb0aa03f3c`
- Old frozen base: `llm-b1c3f4d` (`b1c3f4dca97666b5dd975cc8640fe858a02be3a9`)
- New frozen base: `llm-720a396` (`720a39600f4ece6b731f7a989fc6ef004465dc71`)
- Commits replayed: 16 (all 16 original commits; none dropped, none added)

## Push and base-update results

- New frozen-base branch push (`720a39600 -> llm-720a396`): exit 0.
- Force-with-lease push of `design/gateway-package`: exit 0
  (`89d68e71e...23bc11a9e HEAD -> design/gateway-package (forced update)`).
- `gh pr edit 343 --base llm-720a396`: exit 0
  (PR base is now `llm-720a396`).

## Conflict-resolution summary

Shepherd's expectation ("clean replay; PR diff is design-doc
oriented, doesn't touch ocapn/benchmark") held for the
ocapn/benchmark side. However, three of the 16 commits did
conflict in `designs/README.md` because both sides edit that file's
"Last updated", "Recently added or revised" list, summary table,
totals narrative, dependency graph, M1 sizing tables, and M1
milestone roster. All three were resolved by reading both sides
and writing the woven third state per
`skills/conflict-resolution/SKILL.md`. No `--ours` / `--theirs`
used anywhere.

Conflict regions and resolutions:

1. Commit `41b1d400f design(gateway): overarching @endo/gateway package` (1/16):
   - **Region A (Last updated + Recently added list)**: kept new
     base's 2026-06-02 "Last updated" line (it supersedes the PR's
     2026-05-22), inserted the PR's `gateway-package` entry into
     the "Recently added" list alongside the new base's four
     2026-06-02 additions.
   - **Region B (Summary table)**: kept the new base's
     `endo-gateway-mcp` row (added 2026-05-29), updated
     `endo-gateway` row to Superseded per PR, added `gateway-package`
     row per PR.
   - **Region C (Totals)**: net effect of adding gateway-package
     (+1 Proposed, +1 design) and marking endo-gateway Superseded
     (-1 Proposed, +1 Superseded). Computed totals: 28 Proposed
     unchanged, Superseded 1→2, designs 134→135.

2. Commit `6fe0f04b8 clarify virtual hosting is not DNS-based` (2/16):
   - **Region B (Summary table)**: PR updates gateway-package
     Updated date 2026-05-22→2026-05-23. Kept endo-gateway-mcp row
     intact, applied the date bump.

3. Commit `adafd6f59 fold endo-gateway material into gateway-package and remove` (13/16):
   This commit is the cumulative removal of endo-gateway with
   four conflict regions:
   - **Region A (Last updated + Recently added)**: kept new base's
     2026-06-02 Last-updated; replaced the gateway-package entry
     in the "Recently added" list with the PR's revised wording
     ("added 2026-05-22, revised 2026-05-29 to absorb the prior
     endo-gateway material"); preserved the new base's other
     2026-06-02 / 2026-06-01 additions.
   - **Region B (Summary table)**: removed the endo-gateway row
     per PR's intent, kept endo-gateway-mcp row, updated
     gateway-package row to "2026-05-22 | 2026-05-29 | Proposed
     (absorbs the removed endo-gateway design)".
   - **Region C (Totals)**: applied PR's net delta (-1 design, -1
     Superseded) to new base's count: 135→134 designs, 2→1
     Superseded; preserved new base's 28 Proposed and the
     2026-06-02 / 2026-06-01 narrative.
   - **Region D (M1 milestone roster)**: kept new base's 14-item
     M1 list (which already includes the four 2026-06-02 layer-
     split designs and `daemon-worker-import-from-mount`),
     replaced `endo-gateway` with `gateway-package` per PR's
     consolidation. M1 count stayed 14.

The mermaid dependency-graph subgraph for Remote Access (which the
endo-gateway-removal commit modifies to drop the SUPERSEDED node
and `egw → gpkg` edge) applied without conflict because the prior
commit had already added the `egw[endo-gateway<br/><i>SUPERSEDED</i>]`
node, and this commit removes it; git's tree-merge resolved cleanly.

The intersection paths predicted before the rebase
(`designs/README.md`, `tsconfig.composite.json`, `yarn.lock`)
all materialized. `tsconfig.composite.json` and `yarn.lock`
applied cleanly via three-way merge (single non-overlapping
insertion in each).

## Syntactic sanity

`node --check` passed on `packages/gateway/index.js`,
`packages/gateway/src/config.js`, and `packages/gateway/src/vhost.js`.
`packages/gateway/package.json` parses as valid JSON. No conflict
markers remain in `designs/README.md`,
`designs/forge-gap-analysis.md`, or `designs/gateway-package.md`.
Full package tests not run (rebase crossed 233 upstream commits;
test-suite scope is the next stage's concern; CI will run on
push).

## Follow-up: cascade rebase of the gateway-package stack

PR #343 is the base of the gateway-package stack (phases 2-10).
The dependent PRs will need cascade-rebases per
`skills/frozen-base-branch/SKILL.md` § Stacked PRs: each
dependent PR's base is a snapshot of its parent's old head, so
moving #343's head from `89d68e71e` to `23bc11a9e` does not
auto-shift the dependents; the orchestrator should dispatch
weaver against each phase PR with a `<parent-head>-<short-sha>`
new dependent base computed from #343's new head. Surfacing
this here so the orchestrator can schedule the cascade rather
than rediscover it from CI failures on the phase PRs.

## Definition of done

- Branch on the named new base: yes (`llm-720a396` /
  `720a39600`). [done]
- Tree changes match the original PR's intent plus the
  designs/README.md conflict resolutions: yes (same 21 paths
  modified). [done]
- Tests in affected packages pass: not run; rebase merged via
  git tree-merge and PR-touched JS files pass `node --check`.
  [partial]
- `--force-with-lease` succeeded: yes. [done]
- PR base updated: yes (`gh pr edit 343 --base llm-720a396`
  exit 0). [done]
- Result journal entry: this entry. [done]

Self-improvement: the dispatch brief's "clean replay (PR #343's
diff is design-doc-oriented; shouldn't touch ocapn/benchmark)"
was right about the ocapn/benchmark axis but missed that
`designs/README.md` is itself a hotly-edited document on `llm`
(both the PR and the new base touch it across the same regions:
"Last updated", "Recently added", summary table, totals, M1
roster). When the shepherd or steward predicts conflict scope, a
fast `git diff --name-only origin/<old-base>..origin/<new-base>`
intersected with the PR's touched paths would have flagged
`designs/README.md` upfront. Worth adding to the shepherd's stale-
base classification checklist or to the weaver's pre-rebase
survey step. Marginal value (it would only have changed how the
brief read, not what the weaver did), so reportable here rather
than escalated to a message to liaison.
