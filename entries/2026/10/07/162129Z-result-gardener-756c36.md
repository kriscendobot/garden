---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-07T16:21:31Z
job: scholar-ingest-oh-my-pi-rust-core-4
claim: b05c1d159b56a117
---
# scholar-ingest-oh-my-pi-rust-core-4 — result

issue_spine: issue-kriscendobot-garden-121 (https://github.com/kriscendobot/garden/issues/121, submitter jcorbin)

Source-priority continuation of the oh-my-pi Rust-core ingest (can1357/oh-my-pi `main` at `53f253fb`), each anchored on its file-specific commit. **This closes the issue-121 Rust-core ingest.** No follow-on job posted.

## Sources ingested (9 new, 1 extended): 12 sections

- `crates/pi-natives/src/shell/vfs.rs` @ `7dc2ef90`: 2 sections (ShellFilesystem 34-op wire protocol; routing/lifetime/consumers). Confirms from source that `pi-vfs` virtual files need no host materialization, that `nativeLocalPaths` routes only URL paths to the handler, and that `ShellFilesystem` is accepted by shell, grep, glob, and ast but not by `fuzzyFind` (fd.rs has no filesystem option).
- `crates/pi-iso/src/rcopy.rs` @ `7f6974c3`: 1 section (git worktree + staged/unstaged/untracked replay, or recursive copy).
- `crates/pi-iso/src/overlayfs.rs` @ `5b5b65ec`: 1 section (kernel overlay; fuse-overlayfs fallback on EPERM/EACCES/ENODEV/ENOENT/EINVAL; per-mount teardown flavor).
- `crates/pi-iso/src/lib.rs` @ `e58c443c`: **idempotency match** with the recorded anchor, so the existing section was not rewritten. One *additional* section was appended (backend resolution priority and `clone_candidates`), the rules the pi-natives `isoResolve` binding forwards. The source page's section_count went from 1 to 2.
- `crates/pi-ast/src/language/mod.rs` @ `11f3a262`: 1 section. 57 languages, all native `tree_sitter_*` crates, and **no WASM anywhere in pi-ast**. The explainer's "50+ languages" is roughly right; "per-language WASM" is wrong.
- `crates/pi-ast/src/ops.rs` @ `e4517e15`: 1 section (explicit lang wins; JSON multi-node wrapper fallback; identical-edit collapse, overlap rejection, per-rule re-parse; the `collect_matched_files` host walker is unused by pi-natives).
- `crates/pi-shell/src/process.rs` @ `d93fb847`: 2 sections (identity-pinned references per OS; terminate_tree two-wave shutdown with harness-subtree protection, upstream #7452).
- `crates/pi-shell/src/cancel.rs` @ `257c0acf`: 1 section (deadline + weak abort flag; `abort_reason()` excludes an elapsed deadline).
- `crates/pi-shell/src/shell.rs` @ `53f253fb`: 1 section covering only the documented contracts (session vs run, `pids()`, background-job retention, raw-byte streaming without the minimizer, cancellation grace 2s/5s, `GIT_REPO_LOCATION_ENV_VARS` stripping). The ~7k undocumented lines are **deliberately deferred**, not queued: read them only if a concrete question needs them.
- Optional item done: `packages/natives/native/loader-state.js` @ `d6262173`: 1 section. **Refutes the explainer's "native loader falls back to JS" claim.** There is no JS implementation: the loader tries candidate paths and CPU variants and throws an aggregated error. The only soft fallback is the stale-addon `missingNativeExport` stub. The divergence ledger was NOT edited (append-only); the resolution lives in the new section and the explainer concept page.

The known divergences in the existing ledger are preserved untouched.

## Pages touched

- Concepts: new `pi-shell`. Rows added to `pi-vfs`, `pi-native-search`, `pi-iso`, `pi-ast-grep`, and `oh-my-pi-design-explainer`. `concepts/README.md` and `keywords.md` got 5 new lines.
- Topics (rows via insert-sections-table-row.sh): virtual-filesystems, file-systems, agent-workspaces, tooling, sandbox-platforms, programming-language-design, shell-runtimes, agent-fleet-durability, llm-agent-frameworks.
- `sources/README.md`: 9 rows in the "oh-my-pi Rust core" block, and the pi-iso crate-root count changed from 1 to 2.

## Gates

- `library-link-check.sh --changed`: OK (every checked link resolves to a committed file).
- `regenerate-topics-counts.sh --check`: stale counts only (informational) and no missing topic page. Both projections were regenerated and landed (`sections/README.md`, `topics/README.md`).
- All 41 content files landed via land-journal-edit.sh (modified files with `--base-blob`), with no refusals.

Foreign-content gate: not applicable. Every read was of the upstream GitHub repo source via a scratch git clone; there were no web, paper, or archive fetches.

Follow-ons: none. Issue-121 Rust-core ingest is complete.
