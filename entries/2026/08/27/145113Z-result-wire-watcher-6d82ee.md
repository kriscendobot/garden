---
kind: result
role: wire-watcher
host: liaison-session
at: 2026-08-27T14:51:13Z
---
# wire-watcher review — endojs/endo-but-for-bots PR #282 (panel seat)

Dispatch: jury seat `wire-watcher`, gauntlet `pr282-gauntlet-20260827` (panel iteration 1).
Worktree reviewed: `scratch/project-wt-endojs-endo-but-for-bots-pr282-gauntlet-20260827-panel-1-7047deba`
(HEAD `e73a77e92`, "test(endor): exercise Group F fixture parity"), base `origin/llm`.

### wire-watcher

**Verdict:** request-changes

**Findings:**

- **`rust/endo/src/entry_walk.rs:1560-1590`** (`resolve_subpath`, new in this PR) — the
  function's own contract, stated in its error text ("subpath {raw_sub} escapes package
  root"), is enforced only on the exact-file branch (line 1562-1570). The two fallback
  branches — appending a `.js`/`.mjs`/`.cjs`/`.json` extension (1572-1577) and the
  directory-index fallback (1578-1585) — return `with_ext.canonicalize()` / `idx.canonicalize()`
  directly with **no `starts_with(pkg_root)` check**, so a bare-specifier subpath containing
  `..` segments (`"@scope/pkg/../../../../whatever"`, produced by
  `split_bare_specifier`'s naive `/`-split at line 1457-1482, which does not reject `..`
  components) can resolve to a file outside the dependency's own package root on either
  fallback path. Currently this is **not independently exploitable**: both call sites
  (`resolve_bare` at line 1539-1545, and `record_common_dependency` at line 3758-3766)
  re-validate the returned `entry_file` against the canonical package root via
  `strip_prefix` and error out on escape, so the bug is caught one frame up today. But the
  invariant `resolve_subpath` advertises in its own error message does not actually hold
  inside the function, and any future caller of `resolve_subpath` that omits the
  caller-side `strip_prefix` check (there is nothing forcing that pairing — no type-level
  or naming signal ties the two together) would silently ingest an arbitrary host file
  matching the crafted extension into the CAS archive as source for a package the untrusted
  npm dependency graph controls. Fix the check once, inside `resolve_subpath`, on all three
  branches, rather than relying on both call sites remembering to duplicate it.
  [proposed-rule: a path-resolution helper whose own error text names a boundary invariant
  ("escapes X root") must enforce that invariant on every return path inside the helper,
  not rely on every caller re-deriving it.]
- **Failure-mode test gap**: no test exercises `resolve_subpath`'s escape rejection at all
  (the one escape test in this file, `resolve_relative_rejects_escape` at line 4763, covers
  the *relative-import* path, not the bare-specifier subpath path). Add a test that a
  crafted `../`-laden subpath is rejected via each of the three branches (exact-file,
  extension-appended, directory-index), plus one confirming the caller-side `strip_prefix`
  double-check still catches it if the inner check is ever weakened. [rule:
  roles/jurors/wire-watcher/AGENT.md § Failure-mode test catalog]

**Notes (out of scope but worth flagging):**

- The `fetch.rs` / `registry.rs` half of this diff (keying the registry-table cache on
  `(registry, name, version)` / `(registry, name)` instead of `(name, version)` / `name`)
  is exactly the wire-watcher's "identifier discipline" and "check before trust" surface
  done right: the fix is well-motivated (a `foo@1.2.3` cached from registry A must not
  satisfy a lookup against registry B), covered by a dedicated regression test
  (`fetch_package_does_not_serve_across_registries`), and the schema bump uses
  `PRAGMA user_version` to discard rather than silently misinterpret a pre-v1 cache. No
  finding here — flagging only so the panel record notes the positive contrast with the
  `entry_walk.rs` finding above. [rule: roles/jurors/wire-watcher/AGENT.md § Identifier discipline]

Self-improvement: no brief change proposed. The one proposed-rule above (a boundary-check
helper must not offload its own advertised invariant to callers) is narrow to this PR;
it isn't yet a recurring enough pattern across rounds to warrant baking into the brief.
