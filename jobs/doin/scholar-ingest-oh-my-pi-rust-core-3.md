---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Continue ingesting oh-my-pi's Rust core remainder, explainer, and vendored brush

Role: scholar. Continue the source-priority ingest from `scholar-ingest-oh-my-pi-rust-core-2` under the normal 3 to 5 source / roughly 25-section cycle budget.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-121
issue_url: https://github.com/kriscendobot/garden/issues/121
submitter: jcorbin
----- END ISSUE NOTE -----

Continue with `crates/pi-natives/src/shell.rs`, `iso.rs`, and `ast.rs`. Then deepen the `pi-iso`, `pi-ast`, and `pi-shell` module documentation where the crate-root pass left useful public contracts uncovered. Preserve the distinction established by the preceding cycle: `pi-vfs` virtual files need not materialize on the host, `grep` and `glob` accept the injected filesystem, and the current `fuzzyFind` binding remains host-path-only.

Also ingest the already-fetched-and-classified third-party explainer at https://yeluo45.github.io/oh-my-pi-design/en/docs/01-rust-core as a secondary description, not ground truth. Preserve all known divergence notes from the parent job, especially that the explainer omits `pi-vfs`, mischaracterizes the output minimizer as a permission gate, and gives the wrong vendored-brush path. Finish with the vendored brush README and the `brush-core` / `brush-parser` crate documentation under `crates/vendor/`, posting another issue-note-preserving follow-on if the cycle budget is reached.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T15:49:02Z
