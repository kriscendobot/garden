---
kind: result
role: archivist
host: endolin-garden-ece02cb4
at: 2026-07-30T01:08:57Z
---
Archivist seat, gauntlet panel round 1 on endojs/endo-but-for-bots#857 (dispatch run: gardener-wt-endojs-endo-but-for-bots-pr857-gauntlet-panel-1; project worktree project-wt-endojs-endo-but-for-bots-pr857-gauntlet-panel-1-c6f249cd, head c174de482, base e2c6ff853c). Scope: docs and comment/JSDoc prose accuracy only. Per-juror block follows.

### archivist

**Verdict:** comment-only

**Findings:**
- (should-fix) `rust/endo/src/npm_resolve.rs:168-171`: the `dep_edges_from_manifest` docstring lists the "npm precedence rules" but omits the third overlap branch the peer loop implements at line 209: a peer also named in `optionalDependencies` is demoted to constrain-only (`optional_peers`), same as a peer beside a concrete dependency edge, not treated as an attempted optional. Add the third condition so the enumeration predicts every branch of the `if`. [rule: roles/jurors/archivist/AGENT.md]
- (should-fix) `rust/endo/src/npm_resolve.rs:22` and `designs/endor-npm-registry-proxy.md:39`: both fixpoint-walk descriptions still say the resolver folds a package's `dependencies` into the requirement set; since this PR it folds three edge classes (required, optional, constrain-only peers). Adjacent text already carries the full semantics (the module doc's new "Dependency-class semantics" list; the design's Known-gaps `[x]` entry at line 452), so a one-clause fix ("its dependency edges") suffices. [rule: roles/jurors/archivist/AGENT.md]
- (comment-only) `rust/endo/src/semver.rs:357-359`: the `select_versions` docstring describes a "(package_name, version_range)" input and a per-"(package_name, major_version)" result; the signature this PR rewraps takes `(available, ranges)` and returns `Vec<Version>`, with no names anywhere. Pre-existing drift, but in touching distance of the change. [rule: roles/jurors/archivist/AGENT.md]

Coverage behind the verdict: the new behavior is documented where the archivist looks for it. The module doc's "Dependency-class semantics" section matches the implementation branch by branch; the `DepEdges`, `SkippedOptional`, `ResolveOutcome`, `resolve_transitive_outcome`, `ResolvedCompartment.optional_edges`, and `bind_edges` docs describe the code they sit on; the stale `||` comment in `Range::parse` ("use the first set that matches", "union of all comparators") is replaced by prose matching the new union semantics; the test comments on anchor behavior match `select_for_package` (anchor is the major of the smallest satisfying release, `npm_resolve.rs:547`); the design's Known-gaps `[x]` entry and the new `process`-global `[ ]` gap are accurate; every rustdoc intra-doc link resolves; no banner comments were added; no autofix-generated doc lines.

**Notes (out of scope but worth flagging):**
- Behavior, not docs: an unparsable range string inside a constrain-only optional-peer range is fatal when the name is otherwise required (`select_all` parses activating and conditional strings together, `rust/endo/src/npm_resolve.rs:465`), even though the module doc says such ranges only constrain. Corner-prober surface. [rule: roles/jurors/corner-prober/AGENT.md]
- `select_versions` (`rust/endo/src/semver.rs:364`) has no production caller left; only its own tests call it. Pruner surface. [rule: roles/jurors/pruner/AGENT.md]

Self-improvement: nothing this time.
