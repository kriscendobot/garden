---
source_kind: paper
source_authors: [Yifan Shi, Wei Zhang, Tianyi Cui]
source_title: "A Programming Paradigm for Spatiotemporal Composability"
source_year: 2026
source_venue: "Preprint (cordiverse/paper on GitHub)"
source_url: https://github.com/cordiverse/paper/blob/main/paper.pdf
source_pdf_sha256: 4d48478dc0b6222d9f74d7db10ee776449b1209eb112632336544d32a49db97f
source_pdf_pages: 88
source_fetched_via: direct
ingested: 2026-08-14
ingested_by: scholar
section_count: 6
status: current
notes: |
  Derived scholarly digest, not the original paper, of Shi-Zhang-Cui's
  "A Programming Paradigm for Spatiotemporal Composability" (Cordis). Authors:
  Yifan Shi (Peking University, DeepSeek-AI), Wei Zhang (Peking University),
  Tianyi Cui (DeepSeek-AI). The paper is hosted as a PDF in the GitHub repo
  cordiverse/paper@main; it carries no formal venue, so the idempotency anchor
  is the content SHA-256 (paper schema), not a git commit. Re-check freshness by
  re-fetching the raw blob and comparing source_pdf_sha256; a mismatch means the
  main-branch PDF was revised and warrants re-ingest. First non-endo,
  non-ocap-lineage programming-language-theory paper in the corpus; introduces
  the `dynamic-composition` and `effect-and-coeffect-systems` topics.
---

Abstract: A derived scholarly digest, not the original paper, of Shi-Zhang-Cui's *A Programming Paradigm for Spatiotemporal Composability*. The paper identifies two orthogonal dimensions of dynamic (runtime) composition — *temporal composability* (completely reverting a component's side effects on removal) and *spatial composability* (declaring and reactively managing inter-component dependencies) — and addresses them by lifting classical *effect* and *coeffect* systems from compile-time annotations to runtime mechanisms: *revertible effects* (every context transformation carries an inverse the runtime tracks) and *reactive coeffects* (each context change notifies a component against its dependency specification as activating/deactivating/neutral). The two are unified into a single *context type* (the paradigm proper), combined into a *component* with a lifecycle calculus whose metatheory carries the guarantees system-wide, and realized as the TypeScript meta-framework *Cordis* (core library + declarative loader with hot module replacement), validated on the Koishi chatbot framework's 4000+ community plugins. Directly relevant to the garden: the paper's own two motivating instances are plugin systems and **self-evolving agent harnesses**, and §6.3 independently identifies its dependency-declaration mechanism as **structurally capability-based access control**.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/papers--shi-spatiotemporal-composability-2026--overview.md) | dynamic-composition, effect-and-coeffect-systems | current |
| [revertible-effects](../sections/papers--shi-spatiotemporal-composability-2026--revertible-effects.md) | effect-and-coeffect-systems, dynamic-composition | current |
| [reactive-coeffects](../sections/papers--shi-spatiotemporal-composability-2026--reactive-coeffects.md) | effect-and-coeffect-systems, change-propagation | current |
| [context-paradigm-and-calculus](../sections/papers--shi-spatiotemporal-composability-2026--context-paradigm-and-calculus.md) | dynamic-composition, effect-and-coeffect-systems | current |
| [cordis-implementation-and-koishi](../sections/papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi.md) | dynamic-composition, module-loader | current |
| [boundaries-security-and-codesign](../sections/papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign.md) | capability-security, sandbox-platforms, dynamic-composition | current |
