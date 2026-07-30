---
kind: result
role: warden
host: endolin-garden-ece02cb4
at: 2026-07-30T01:13:04Z
---
project: endo-but-for-bots

Dispatch: gauntlet panel round 1 (job base endojs-endo-but-for-bots-pr857-gauntlet-panel-1), seat `warden`, reviewing PR endojs/endo-but-for-bots#857 (diff base e2c6ff853c2c6a418e8566681a5b67155dc8bc45, head c174de482). Read-only pass over the diff from the SES / hardened-JS boundary seat.

### warden

**Verdict:** request-changes

**Findings:**
- (should-fix) `rust/endo/src/semver.rs:144-148`: `Range::parse` silently drops any token `parse_comparator` rejects. A mixed range like `workspace:* || ^1.0.0` parses as bare `^1.0.0`, and a typo inside an AND set (`>=1.0.0 <2.0.0x`) weakens the set to `>=1.0.0` alone, selecting majors the manifest never allowed. These strings are untrusted registry input that decides which compartments the map binds, and the module doc (`rust/endo/src/npm_resolve.rs:55`) promises unsupported ranges "are an error on a required edge and a skip on an optional one". Make one unparseable token fail the whole parse (return `None`) so `select_all`'s required-error / optional-skip path actually sees it. [proposed-rule: parsers consuming untrusted registry manifests fail closed; a range token that does not parse invalidates the whole range, never silently narrows or widens the declared constraint]
- (comment-only) `designs/endor-npm-registry-proxy.md:476-482`: the new TODO floats a `process` global for the archive runtime's CJS loader. The doc frames it correctly (frozen, an explicitly open confinement decision), so this is not the recurring unsafe-docs finding; the warden requirement lands on the implementation. Mint the shim fresh per compartment, freeze it at creation, synthesize its values (`NODE_ENV`, nothing host-derived). One shared `process` across compartments, or a pass-through of the host's `process.env`, would be a mutable ambient authority plus a host-information channel inside the SES runtime. [rule: roles/jurors/warden/AGENT.md § Operating norms] [proposed-rule: an ambient global endowed into a compartment is minted fresh per compartment and hardened at creation; host process state never crosses as a reference]

**Notes (out of scope but worth flagging):**
- `rust/endo/src/npm_resolve.rs:194-199`: `peer_is_optional` ignores a non-object `peerDependenciesMeta` (serde_json `Value::get` yields `None` on non-objects) while the sibling `field_map` errors on non-object dependency fields. The lenient direction is the strict one (the peer is treated as required), so impact is cosmetic; align for symmetry. [proposed-rule: same fail-closed manifest-parsing rule as the semver finding]
- Boundary check passes elsewhere in the diff: the compartment map leaves the Rust side as JSON (data-only), skipped optional edges are omitted from `modules` so the runtime `require` fails closed with cannot-find, and the un-skip retry when a required edge names a previously skipped optional (in `resolve_transitive_outcome`) is covered by the `required_edge_to_missing_package_still_fails` test. No `harden`-relevant object crossings, no `globalThis` writes, no prototype walking in the Rust or docs this PR touches. [rule: roles/jurors/warden/AGENT.md § Operating norms]

Self-improvement: lesson routed to `liaison` by bus message: the warden brief's docs-finding norm ("unguarded globals in docs are must-fix") needs a third state for docs that correctly defer a confinement decision, as this PR's `process`-global TODO does; that case is comment-only plus implementation requirements, not must-fix.
