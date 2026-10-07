---
title: Parser-based rewrite safety
source: crates/pi-shell/src/minimizer/plan.rs
source_repo: can1357/oh-my-pi
source_commit: 5a2ec7ffa6d8771962cc3cb71d6adefd5a7769d1
source_date: 2026-09-14
source_authors: [can1357, David Andrews (LexGenius.ai)]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, context-engineering, programming-language-design]
status: current
---

> Abstract: Before minimizing output, `plan.rs` parses the full command with the same vendored brush parser used by the shell and classifies whether rewriting can preserve command-output semantics. Simple commands may be minimized, safe `&&` and `;` chains may be segmented, and pipes or other compound forms pass through unchanged.

The command plan has five outcomes:

- `Single` identifies one simple command for whole-buffer filtering.
- `Chain` holds simple segments connected only by `&&` or `;`, with execution conditions preserved for segment-wise minimization.
- `Piped` is always opaque because a downstream consumer may parse the exact bytes.
- `Compound` covers `||`, background jobs, and unsupported multi-part forms.
- `Unsupported` covers parse failures, empty commands, and shell constructs the planner cannot safely reconstruct.

The conservative cases are correctness constraints, not command-danger judgments. Process substitutions and command substitutions defeat safe segmentation. Here-documents also remain unsegmented because brush's display reconstruction can quote the closing delimiter incorrectly. This is another concrete reason the minimizer cannot be treated as a privilege or destructive-command guard: its definition of "safe" means safe to rewrite output without corrupting shell behavior.

Source: [crates/pi-shell/src/minimizer/plan.rs](https://github.com/can1357/oh-my-pi/blob/5a2ec7ffa6d8771962cc3cb71d6adefd5a7769d1/crates/pi-shell/src/minimizer/plan.rs) at commit `5a2ec7ff`.
