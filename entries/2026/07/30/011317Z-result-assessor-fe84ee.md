---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-07-30T01:13:20Z
---
Assessor seat block for the gauntlet panel round on endojs/endo-but-for-bots PR #857 (dispatch root `gardener-wt-endojs-endo-but-for-bots-pr857-gauntlet-panel-1`; project worktree `project-wt-endojs-endo-but-for-bots-pr857-gauntlet-panel-1-c6f249cd` at c174de482). Scope: correctness and control flow in `rust/endo/src/npm_resolve.rs`, `rust/endo/src/assemble.rs`, `rust/endo/src/semver.rs`, `rust/endo/src/bin/endor.rs`.

### assessor

**Verdict:** request-changes

**Findings:**
- (must-fix) `rust/endo/src/npm_resolve.rs:456-459` feeds constrain-only `conditional` ranges into `select_for_package` as anchoring ranges (`npm_resolve.rs:541-549`), falsifying the invariant the module doc publishes at `npm_resolve.rs:48-50` and the design repeats ("their range applies when the package is activated by some other edge, and never activates it"). Two happy-path falsifications, no attack needed. (a) App on `react@^19` plus a library's optional peer `react@^16.8 || ^17 || ^18`: the conditional range anchors major 16, so react@16.14.0 is selected, fetched, expanded, and bound with no activating edge. (b) App on `redux@^4`, optional peer `redux@^5`, registry serving only 4.x: the conditional range matches nothing, the `?` at `npm_resolve.rs:547` returns None, and the required name hard-fails `NoMatchingVersion`; npm proceeds. Constrain-only ranges should filter the groups activating ranges anchor (dropped when unsatisfiable there), never anchor groups or fail a selection on their own. [rule: roles/jurors/assessor/AGENT.md § Operating norms, secondary surface]
- (should-fix) `rust/endo/src/npm_resolve.rs:371`: `read_dep_edges(...)?` propagates `BadPackageJson` fatally even for optional packages. The new skip arm covers selection (`npm_resolve.rs:515-526`) and fetch (`npm_resolve.rs:364-368`) but not the manifest read one statement later, so an optional package with a malformed `package.json` fails the whole resolution where npm skips it. [proposed-rule: a skip boundary for attempted (optional) work must cover every failure mode of the attempt, not stop at fetch]
- (should-fix) `rust/endo/src/npm_resolve.rs:474-483`: an unparseable constrain-only range hard-fails a required name with `BadRange` (and mis-skips an optional name whose activating ranges parsed fine). Severity attaches to the target name's requiredness rather than to the edge that declared the range, so one package's exotic optional-peer range (`workspace:`, git URL) poisons every consumer. Constrain-only ranges never activate; dropping an unparseable one is safe. [proposed-rule: range-parse failure severity attaches to the declaring edge's class, not the target name's requiredness]
- (should-fix) `rust/endo/src/assemble.rs:133-136`: `resolve_dependency`'s doc comment ("in practice exactly one candidate matches") is falsified by this PR's own `||` semantics: with react@16.14.0 and 18.3.1 co-resolved (the design's react-redux example), an edge `^16.8 || ^17 || ^18` matches both and `max_by` (`assemble.rs:144`) silently binds the greatest, orphaning the major the resolver co-selected for that edge's anchor group. The greatest-satisfying bind is defensible (npm-like dedup) but must be decided and documented. [rule: roles/jurors/assessor/AGENT.md § Operating norms, secondary surface]
- (comment-only) `rust/endo/src/assemble.rs:226-229`: `edge_maps` inserts `optional` then `optional_peers` into one map, so a name in both has its `optionalDependencies` range silently overwritten by the peer range. Benign today (the selection satisfies both ranges) but order-dependent and undocumented. [proposed-rule: when two classified edge lists merge into one map, document the precedence at the merge point]

**Notes (out of scope but worth flagging):**
- `rust/endo/src/semver.rs:143-151`: `Range::parse` silently drops tokens that fail `parse_comparator`, so `^17 || ^18-beta` parses as `^17`. Pre-existing looseness the new `||` support amplifies. [proposed-rule: a range alternative whose tokens fail to parse should fail the whole range, not vanish]

Self-improvement: when a PR pipes a new constraint channel into an existing selection loop, check first whether the new channel can create selections or failures on its own; that is where this PR's invariant break lived. No structural role/skill change to route.
