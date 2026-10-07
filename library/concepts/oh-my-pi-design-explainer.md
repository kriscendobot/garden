---
id: oh-my-pi-design-explainer
aliases: [oh-my-pi-design, yeluo45 oh-my-pi explainer, oh-my-pi Rust core explainer, MinimizerWarning, FsPrimitive, brush-core-vendored]
topics: [llm-agent-frameworks, shell-runtimes]
---

# oh-my-pi-design-explainer

The unofficial site `yeluo45.github.io/oh-my-pi-design` describes oh-my-pi's architecture. Its Rust-core page is ingested as a secondary description only. Symbols such as `MinimizerWarning`, `FsPrimitive`, `parseAst`, and the path `crates/brush-core-vendored/` come from that page and do **not** exist in the oh-my-pi source. Search hits on them should route to the divergence ledger, which names the repo-sourced section to trust instead.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [the explainer's account of oh-my-pi's Rust core](../sections/web--oh-my-pi-design-rust-core--explainer-account-of-the-rust-core.md) | What the page claims, summarized for orientation. |
| [divergence ledger against the oh-my-pi source](../sections/web--oh-my-pi-design-rust-core--divergence-ledger-against-source.md) | Claim-by-claim corrections against `main` at `53f253fb`. |

## See also

- [[pi-shell-output-minimizer]]: the explainer presents it as a permission gate; it is an output reducer.
- [[pi-vfs]]: omitted entirely by the explainer.
- [[brush-shell]]: the explainer's vendoring path and rationale are wrong.
