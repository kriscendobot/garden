Weave of PR #873 (`feat/endor-npm-workspace-resolution`) onto `origin/llm` — done.

**What changed**

- Rebased the single-commit PR branch onto `origin/llm` (tip: `eb64412d76`). Two files conflicted; resolved to merge both features correctly.

- `designs/endor-npm-registry-proxy.md` "Known gaps": all three items that had diverged (`[x]` auth, `[x]` workspace, `[x]` peers/optionals) now marked complete with their full descriptions preserved from both sides.

- `rust/endo/src/assemble.rs` — merged the PR's workspace resolution with the `llm` branch's `optional_edges` support:
  - `ResolvedCompartment` struct: now carries both `optional_edges` and `workspace` fields.
  - Both `edge_maps` (llm: splits `DepEdges` for registry packages) and `read_tree_dependencies` (PR: reads `dependencies` from CAS for workspace members) functions coexist.
  - Added `parse_dependencies` helper (used by `read_tree_dependencies`).
  - `resolve_workspace_members` updated to work with `DepEdges` types — extracts only `required` edges from member manifests; workspace member `optional_edges` starts empty.
  - Assembly loop: workspace edges classified first, remaining registry roots fed through `resolve_transitive_outcome`; registry packages get `(dependencies, optional_edges)` via `edge_maps`, workspace members get concrete deps + `workspace: true`.
  - `AssembleError::Workspace` variant and `From<WorkspaceError>` impl added.
  - Fixed escaped-quote regression in `parse_dependencies` error message.

**Verification**

- `cargo test -p endo`: 209 unit tests + 1 integration test all pass (210/210 green).
- `cargo test -p endo assemble`: all 20 assembly module tests pass (includes workspace tests).
- No conflict markers remain in either file.
- Force-pushed as two commits: the rebased merge (`d81fa73e1c`) and cosmetic fix (`ccc6b50c72`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr873-4e8841bd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 1894s

<!-- garden-usage-end -->
