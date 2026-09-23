---
ts: 2026-06-22T13:30:07Z
kind: tick
role: librarian
project: endo-but-for-bots
---

Cycle 442 chat-lane library ingest. Source: `packages/whylip/src/SceneCanvas.jsx` (43 lines, kumavis, 2026-03-10). The 43-line React component that implements Layer 6 of the six-layer exfiltration defense via `sandbox="allow-scripts"` on an iframe rendering LLM-generated HTML scenes from Fae agents.

Single most structurally interesting move: §the-named-layer-6-narrower-than-design-implied. Cycle 220's design listed "Layer 6 (iframe sandbox) applied by Chat" as "Not Yet." The actual implementation lives in `packages/whylip/src/SceneCanvas.jsx`, not the main chat package. The iframe sandbox is specifically scoped to LLM-generated Whylip primer scenes from Fae agents. §the-named-layer-6-in-whylip-not-chat.

Key patterns named: §the-named-allow-scripts-as-minimum-viable-sandbox (maximum confinement compatible with interactive visualization); §the-named-srcdoc-as-no-network-load (LLM scene content arrives via CapTP, not URL fetch); §the-named-sandbox-plus-network-layers-are-complementary (Layer 6 + Layers 1-5 together provide "no network access").

Arc completion: §the-named-six-layer-defense-fully-grounded. All six layers of the exfiltration defense are now mapped to source files. §the-named-layer-6-closes-the-six-layer-arc.

State delta: 953 → 954 sections (+1). 479 → 480 source documents (+1). 872 → 883 citation arcs (+11). 89 → 90 conformant post-refactor cycles. Non-garden source run: 131 → 132 consecutive.

Library files written:
- `journal/library/sections/endo-but-for-bots--packages-whylip-src-SceneCanvas-jsx--layer-6-iframe-sandbox-via-allow-scripts-for-llm-scenes.md`
- `journal/library/sources/endo-but-for-bots--packages-whylip-src-SceneCanvas-jsx.md`
- `journal/library/sections/README.md` (updated totals + new entry)

Self-improvement: nothing this time.
