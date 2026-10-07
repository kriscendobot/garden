---
id: pi-shell-output-minimizer
aliases: [pi-shell minimizer, output minimizer, artifact output]
topics: [shell-runtimes, context-engineering]
---

# pi-shell-output-minimizer

The `pi-shell` output minimizer is an opt-in, per-program stdout and stderr compaction layer. It uses brush parsing to avoid rewriting unsafe command shapes and retains rewritten-away output for retrieval through an `artifact://` reference. It is not a command-permission or privilege-escalation guard.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [opt-in command-output minimization](../sections/oh-my-pi--crates-pi-shell-src-minimizer--opt-in-command-output-minimization.md) | Per-program output rewriting, telemetry, artifacts, and the correction that this is not a permission gate. |
| [parser-based rewrite safety](../sections/oh-my-pi--crates-pi-shell-src-minimizer-plan--parser-based-rewrite-safety.md) | Brush AST classification keeps pipes and unsafe compound command shapes opaque. |

## See also

- [[producer-typed-shape-consumer-rendering]] for a related producer/consumer boundary.
- [[pi-iso]] for oh-my-pi's workspace layer.
