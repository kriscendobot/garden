---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 705
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-07-21T04:39:11Z
last_appended_at: 2026-07-21T04:39:11Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#705

Created from the code-panel verdict (19 recommended seats, panel-hints subset) on
the git remote push tier (`feat(agent-tools): makeGitRemoteTool`, base `llm`).
The must-fix (missing changeset) and four summary-fixes (README exports, the
divergence-gate value-type strengthening, the present-empty options dispatch
boundary, and the parity-claim comment) were addressed in the panel-fixer round
(head `84f68180`). The items below are deferred (out of this PR's scope, or a
change spanning peer files) and warrant revisit when the PR merges.

## Items

- [ ] **Forward the marshalled positional vector from `makeTool` instead of
  re-deriving it in `execute`.**
  **Source seat(s)**: warden, saboteur, assessor, purist, prover, corner-prober.
  **Round**: 1.
  **Recommended action**: open a follow-up PR (or a `makeTool` refactor) so a
  json-tool `execute` receives the already-marshalled positional array
  `makeTool.invoke` computed, rather than re-implementing `namedToPositional` +
  the trailing-`undefined` pop. The two copies are equivalent today only because
  every git-remote verb has `requiredCount == 0`; `makeTool`'s pop floor is
  `requiredCount` while `execute`'s is `0`, so a future verb with a required
  positional would let the two diverge (the exo stays the real backstop). The
  same duplicated loop lives in `git.js` and `shell.js`, so the fix is a shared
  `tool.js` helper across all json-tool makers, not a one-file change.

- [ ] **Hoist the interface-guard payload read above the per-method map.**
  **Source seat(s)**: breaker, purist, saboteur.
  **Round**: 1.
  **Recommended action**: `positionalArgGuards` calls
  `getInterfaceGuardPayload(GitRemoteInterface)` once per method (4x at tool
  construction), re-deriving the same `methodGuards` each time. Cold path (no
  per-invoke cost), and it mirrors `git.js` verbatim, so hoist the single
  interface-payload read above the map in both files together if at all.

- [ ] **Assert (or document) that `positionalArgGuards` mirrors the whole method
  guard, not a subset.**
  **Source seat(s)**: breaker.
  **Round**: 1.
  **Recommended action**: `positionalArgGuards` reads only `argGuards` +
  `optionalArgGuards`, silently dropping `restArgGuard`/`returnGuard`. Exact for
  the current `GitRemoteInterface` (all four methods are closed `M.call()` with 0
  required + <=1 optional, no `.rest()`), but the "one-to-one onto the guards"
  claim would quietly become false if a future method grew a rest/variadic arg,
  and the divergence gate would not catch it (its corpus only varies the single
  `options` slot). Assert the dropped payload fields are empty, or document that
  variadic guards are intentionally not mirrored, so a future reshape fails loud.

- [ ] **Align the git-remote tool descriptions to the package's ASCII-apostrophe
  convention.**
  **Source seat(s)**: stylist.
  **Round**: 1.
  **Recommended action**: `git-remote.js` description strings use U+2019 curly
  apostrophes and a U+2026 ellipsis, while the peer `fs.js`/`git-mount.js` use
  ASCII apostrophes (prettier auto-selects double quotes for the affected string
  literals). Convert the affected literals to double-quoted ASCII with prettier
  in the loop (a bare code-point swap breaks the single-quoted strings, which is
  why the author used the curly glyph). Deferred here because it could not be
  verified locally without prettier and is non-blocking cosmetic consistency.
  The JSDoc em-dashes are a package-wide habit (shared with `shell.js`/`http.js`),
  left as-is to avoid one-file inconsistency.

- [ ] **Strengthen the exo-side credential-free `inspect` assertion.**
  **Source seat(s)**: locksmith.
  **Round**: 1.
  **Recommended action**: the tool's credential-free `inspect` guarantee is
  delegated to `@endo/exo-git`'s `GitRemote.inspect` (out of this PR's diff), and
  the end-to-end test's `t.false('credential' in bounds)` checks only a top-level
  key, not credential-carrying fields (a `url` with userinfo, headers). Strengthen
  the assertion in the exo package's own test to cover url-userinfo/header
  stripping, since that is where the guarantee is enforced.
