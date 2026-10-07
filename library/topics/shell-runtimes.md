# Topic: shell-runtimes

> Abstract: Embedded and standalone command-shell runtimes: parsing, execution, builtins, process and stream handling, and agent-facing output transformation. Seeded from oh-my-pi's Rust `pi-shell` facade and its brush-parser-backed output minimizer; distinct from `sandbox-platforms`, which owns execution boundaries rather than shell semantics.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [oh-my-pi--crates-pi-shell-src-lib--embedded-shell-public-surface](../sections/oh-my-pi--crates-pi-shell-src-lib--embedded-shell-public-surface.md) | oh-my-pi pi-shell | The shell facade exposes execution, processes, cancellation, output decoding and minimization, brush child sessions, and the builtins bridge used by pi-natives. |
| [oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization](../sections/oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization.md) | oh-my-pi minimizer | Opt-in per-program filters reduce captured stdout and stderr, retain telemetry, and preserve original output through session artifacts. |
| [oh-my-pi--crates-pi-shell-src-minimizer-plan--parser-based-rewrite-safety](../sections/oh-my-pi--crates-pi-shell-src-minimizer-plan--parser-based-rewrite-safety.md) | oh-my-pi minimizer planner | Brush AST classification permits rewrites for simple commands and safe chains while treating pipes and compound syntax as opaque. |
| [N-API shell sessions and filesystem injection](../sections/oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) | oh-my-pi `pi-natives` shell | Persistent and one-shot brush shells reach JavaScript with streamed output, minimizer telemetry, and session- or run-scoped `pi-vfs` filesystems. |
| [bounded output bridge and drain semantics](../sections/oh-my-pi--crates-pi-natives-src-shell--bounded-output-bridge-and-drain.md) | oh-my-pi `pi-natives` shell | A 64-slot queue, 64 KiB coalescing, and awaited callbacks backpressure the child; stall and drain timeouts bound wedged consumers and orphaned readers. |
| [the explainer's account of oh-my-pi's Rust core](../sections/web--oh-my-pi-design-rust-core--explainer-account-of-the-rust-core.md) | third-party explainer (secondary) | An unofficial design site's three-crate account of the Rust core; orientation only, not ground truth. |
| [divergence ledger against the oh-my-pi source](../sections/web--oh-my-pi-design-rust-core--divergence-ledger-against-source.md) | third-party explainer vs source | Where the explainer departs from the source: missing `pi-vfs`, minimizer-as-permission-gate, wrong brush path, invented AST and iso APIs. |
| [vendored brush-parser and its here-document fix](../sections/oh-my-pi--crates-vendor-brush-parser-readme--vendored-parser-with-heredoc-fix.md) | oh-my-pi vendored brush-parser | brush-parser 0.4.0 is vendored to delimit `$(...)` here-document bodies correctly; local changes and removal condition are listed. |
| [brush-parser tokenizer and parser surface](../sections/oh-my-pi--crates-vendor-brush-parser-src-lib--tokenizer-and-parser-surface.md) | oh-my-pi vendored brush-parser | Public shell AST, word, arithmetic, pattern, and test modules plus re-exported tokenizer, parser, error, and span entry points. |
| [brush, a bash-compatible shell in Rust](../sections/oh-my-pi--crates-vendor-brush-core-readme--brush-bash-compatible-rust-shell.md) | oh-my-pi vendored brush-core | Upstream brush README: bash/POSIX compatibility, embeddable `brush_core::Shell`, known gaps; silent on oh-my-pi's local patches. |
| [brush-core interpreter and embedding surface](../sections/oh-my-pi--crates-vendor-brush-core-src-lib--interpreter-and-embedding-surface.md) | oh-my-pi vendored brush-core | `Shell`/`ShellBuilder`, execution and spawn-observation types, and embedding-safe `ulimit` state that `pi-shell` builds on. |

## See also

- [context-engineering](context-engineering.md) for limiting tool-output context.
- [sandbox-platforms](sandbox-platforms.md) for process and workload isolation.
- [programming-language-design](programming-language-design.md) for parsing and AST design.
