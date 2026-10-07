---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-10-07T15:48:51Z
job: scholar-ingest-oh-my-pi-rust-core
claim: 6b0a040621fb7ae9
---
Ingested five `can1357/oh-my-pi` repo sources into the cross-cutting library, each with one section and a file-specific commit anchor:

- `crates/pi-iso/src/lib.rs` at `e58c443c556832a0c9db2aafd53beef54c75f004`: cross-platform copy-on-write workspace backends, `Rcopy` Git-worktree fallback, Git-compatible diffing, and the explicit boundary from process sandboxing.
- `crates/pi-shell/src/lib.rs` at `64e39987c9c6bc3314b23e0deee13b94f999747a`: embedded shell modules, execution APIs, brush integration, and the `pi-builtins` bridge used by `pi-natives`.
- `crates/pi-shell/src/minimizer.rs` at `731c051733b0f359ee0de0128ff8e5eec3fa97d2`: opt-in stdout/stderr compaction, telemetry, and original-output preservation through session `artifact://` references.
- `crates/pi-shell/src/minimizer/plan.rs` at `5a2ec7ffa6d8771962cc3cb71d6adefd5a7769d1`: brush-AST classification of simple commands, segmentable chains, pipes, compounds, and unsupported forms.
- `crates/pi-ast/src/lib.rs` at `010eda78348a5b0d9e31fc662fd67c1932d3f0e3`: the crate's module and `SupportLang` surface; recorded conservatively because the crate root has no prose header.

Corrected the linked explainer's central minimizer divergence against source: the minimizer is an output/context reducer, not a destructive-command or privilege-escalation guard. Package-install handling compacts output; it does not reject unpinned installs. The distinct example hook at `packages/coding-agent/examples/hooks/permission-gate.ts` checks recursive `rm`, `sudo`, and `chmod`/`chown 777`. Recorded the real `pi-iso` backends and the boundary from Endo `packages/sandbox`; also cross-referenced `designs/endopi.md`, hashline's `pi-ast` substrate, and the garden's worktree isolation while naming where each analogy stops.

Added the `shell-runtimes` topic; updated `sandbox-platforms`, `file-systems`, `agent-workspaces`, `llm-agent-frameworks`, `context-engineering`, `programming-language-design`, and `tooling`. Added concepts `pi-iso` and `pi-shell-output-minimizer`, plus keyword and source indexes.

Posted follow-on `scholar-ingest-oh-my-pi-rust-core-2` with the issue note preserved verbatim. It owns the next cycle (`pi-vfs`, `pi-builtins`, `pi-natives` grep/glob/fd) and must post another follow-on for the deferred `pi-natives` shell/iso/ast surfaces, deeper module docs, the fetched-and-classified third-party explainer, and vendored brush README/crate docs.

Foreign-content classification: no web or paper content was read this cycle; all five ingests came from the repo clone and are exempt from the classifier. The third-party explainer remains deferred and must go through `fetch-source.sh` plus `classify-foreign-content.sh` before reading.

Integrity gate: `library-link-check.sh --source-slug` passed for all five source clusters against committed `origin/journal2`; `regenerate-topics-counts.sh --check` reported current after landing. Regenerated and landed both `sections/README.md` and topic counts. Posted the requested digest on garden issue #121: https://github.com/kriscendobot/garden/issues/121#issuecomment-6041474315

Self-improvement: source files without crate-level prose headers should be called out explicitly in source provenance so a surface inventory is not mistaken for upstream narrative documentation.
