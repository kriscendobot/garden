---
kind: result
role: spec-keeper
host: endolin-garden-ece02cb4
at: 2026-07-30T01:21:42Z
---
Spec-keeper seat, gauntlet panel round 1 on endojs/endo-but-for-bots PR #857 (feat/endor-npm-peer-optional-deps, base e2c6ff853c2c6a418e8566681a5b67155dc8bc45, head c174de482). Dispatched via kimi-panel-seat.sh; review done read-only against the project worktree. Per-juror block follows.

### spec-keeper

**Verdict:** request-changes

**Findings:**

- (should-fix) `rust/endo/src/semver.rs:144-151`: `Range::parse` silently drops any comparator token `parse_comparator` rejects. A hyphen range npm accepts (`1.2.3 - 2.3.4`) becomes `Exact(1.2.3) AND Exact(2.3.4)`, unsatisfiable; `>=1.0.0 oops` widens to `>=1.0.0`; `^1 || garbage` narrows to `^1`. node-semver invalidates the whole range on any bad token (https://github.com/npm/node-semver#ranges), and the module doc (`rust/endo/src/npm_resolve.rs:52-56`) promises unsupported grammar is "an error on a required edge and a skip on an optional one"; the code does neither. This PR rewrote the loop under a "correct union semantics" claim, so this is the round to fail the alternative or the range on an unparseable token. [proposed-rule: a range parser must reject the whole range when any comparator token fails to parse; silently dropping tokens turns typos into widened or emptied constraints]
- (should-fix) `rust/endo/src/npm_resolve.rs:371-397`: edges folded from a transiently selected version survive the fixpoint narrowing the selection (the `peer_range_constrains_the_shared_selection` test documents b 2.4.0 -> 2.2.0). A dependency only the deselected version declared still resolves, and fails the whole resolution when unfetchable on a required chain. Go MVS, cited at `npm_resolve.rs:13`, never un-selects, so its "folded edges come from a selected version" invariant does not hold here. Expunge on deselection, defer folding until a name stabilizes, or document and pin with a dep-bearing transient fixture. [proposed-rule: a fixpoint that can deselect a version must expunge requirements folded from it; monotonic MVS gets this by construction]
- (should-fix) `designs/endor-npm-registry-proxy.md`: "MVS unifies a peer with whatever version another edge selected" overstates. `select_for_package` (`rust/endo/src/npm_resolve.rs:547-548`) anchors each range at the smallest satisfying release, so the same bullet's react-redux evidence (react 18.3.1 plus 16.14.0 coexisting) is precisely non-unification; npm >= 7 installs one react, and dual react instances break hooks at runtime. Unify a peer edge against an already-selected satisfying version before anchoring, or correct the sentence. [proposed-rule: a peer edge satisfied by an already-selected version unifies with it rather than anchoring a new major, or the divergence is documented]
- (should-fix) The npm-semantics claims (`rust/endo/src/npm_resolve.rs:34-56`, `:168-172`) match npm's documented behavior but cite no section. Add the URLs: https://docs.npmjs.com/cli/v11/configuring-npm/package-json#optionaldependencies (optional overrides dependencies), #peerdependencies and #peerdependenciesmeta, plus the node-semver grammar link above. [proposed-rule: claims about npm or semver behavior in rust/endo module docs cite the docs.npmjs.com or node-semver section they rely on]
- (comment-only) `rust/endo/src/assemble.rs:223` `edge_maps`: a name in both `optionalDependencies` and optional peers lands in `edges.optional` and `edges.optional_peers`; the peer range overwrites the optional range in the map's `optional_edges` while the resolver constrained on the intersection. Deterministic but accidental; one comment naming the precedence. [proposed-rule: when two classified ranges merge into one map edge, the precedence order is named in a comment]

**Notes (out of scope but worth flagging):**

- The design doc's "Verified against the live registry" line records observed versions (18.3.1, 16.14.0); a live-registry observation is not reproducible evidence. Capture date and response, or label it an observation. [rule: roles/COMMON.md § Reporting]
- The parked `process.env.NODE_ENV` gap is the right engine-variance call: the XS runtime has no `process` global, so Node-gated CJS entry selection (`react`, `graphql`) dies at evaluation. Recording it as a confinement decision beats a silent shim. [rule: designs/endor-npm-registry-proxy.md § Known gaps]

Self-improvement: nothing landed; one candidate note for roles/jurors/spec-keeper/AGENT.md: on non-JS PRs, map the spec-citation axis onto the behavior contract the PR actually rests on (here npm package-json docs and node-semver) and engine variance onto toolchain variance; routed here per skills/self-improvement/SKILL.md since role edits land via the liaison.
