# Topic: shell-runtimes

> Abstract: Embedded and standalone command-shell runtimes: parsing, execution, builtins, process and stream handling, and agent-facing output transformation. Seeded from oh-my-pi's Rust `pi-shell` facade and its brush-parser-backed output minimizer; distinct from `sandbox-platforms`, which owns execution boundaries rather than shell semantics.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [oh-my-pi--crates-pi-shell-src-lib--embedded-shell-public-surface](../sections/oh-my-pi--crates-pi-shell-src-lib--embedded-shell-public-surface.md) | oh-my-pi pi-shell | The shell facade exposes execution, processes, cancellation, output decoding and minimization, brush child sessions, and the builtins bridge used by pi-natives. |
| [oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization](../sections/oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization.md) | oh-my-pi minimizer | Opt-in per-program filters reduce captured stdout and stderr, retain telemetry, and preserve original output through session artifacts. |
| [oh-my-pi--crates-pi-shell-src-minimizer-plan--parser-based-rewrite-safety](../sections/oh-my-pi--crates-pi-shell-src-minimizer-plan--parser-based-rewrite-safety.md) | oh-my-pi minimizer planner | Brush AST classification permits rewrites for simple commands and safe chains while treating pipes and compound syntax as opaque. |

## See also

- [context-engineering](context-engineering.md) for limiting tool-output context.
- [sandbox-platforms](sandbox-platforms.md) for process and workload isolation.
- [programming-language-design](programming-language-design.md) for parsing and AST design.
