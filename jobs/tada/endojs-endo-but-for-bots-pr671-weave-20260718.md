Weave complete. Head branch rebased onto current `origin/llm`, conflict cleared, force-pushed.

## Completion report

**Job:** Weave `endojs/endo-but-for-bots` PR #671 (`endo-registry-capability`) onto current `origin/llm` (role: weaver).

**What I did**
- Fetched current `origin/llm` (head `228c48aeb74`, "content-locator interface methods #783") and rebased the PR's 5 commits (old head `1eabe975cb1`) onto it — a true rebase preserving each of the PR's commits verbatim, not a rework.
- Resolved conflicts across 4 of the 5 commits. The conflict shape had evolved since the 2026-07-10 weave: base `llm` had **renamed the daemon modules** (`daemon*.js` → `manager*.js`, `bus-daemon*` → `bus-manager*`, `daemon-database*` → `manager-database*`). Every conflict was an import-region collision between that rename and the PR's added `registry` imports. Resolutions kept base's newer `manager-*` module paths while retaining the PR's registry additions:
  - `bus-manager-node-powers.js`, `manager-go-powers.js`, `manager-node-powers.js` — kept `manager-*` paths + `makeRegistryNodePowers` import.
  - `manager.js` — kept both `WritableGitWorktree` (base) and `RegistryFormula` (PR) type imports.
  - `bus-manager-node.js`, `manager-go.js`, `manager-node.js` — folded the PR's `gunzip` import into the base's `manager-node-powers.js` import.
  - `bus-manager-rust-xs.js` — applied commit 4's removal of the now-unused `makeRegistryStubPowers` (replaced upstream by a local `makeRegistryUnavailablePowers`), keeping `manager-*` paths.

**Verification**
- No conflict markers remain; all kept imports resolve to existing modules/exports (verified `makeRegistryNodePowers`, `gunzip`, and the `manager-*` targets; no dangling `daemon-*` imports or `makeRegistryStubPowers` refs).
- `prettier --check` clean on all touched daemon/registry sources (earlier lint fix preserved).
- Force-pushed with `--force-with-lease` against the known head `1eabe975cb1`; new head `dd256916fc4`.
- GitHub re-evaluated PR #671: `mergeable` went **CONFLICTING/DIRTY → MERGEABLE**. State is `BLOCKED` (pending checks/reviews), not `DIRTY` — the conflict is cleared and CI will now dispatch.

**Changed:** PR #671 head branch `endo-registry-capability` force-updated to `dd256916fc4` (5 commits rebased onto `origin/llm@228c48aeb74`). No garden-repo (`main2`) changes.

**Follow-up:** The chained shepherd job `endojs-endo-but-for-bots-pr671-shepherd-20260718` (parked blocked on this weave) can now unblock and drive CI to green — the second half of the "Shepherd." directive.
