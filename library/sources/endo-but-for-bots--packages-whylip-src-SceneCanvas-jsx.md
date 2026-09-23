---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/whylip/src/SceneCanvas.jsx
source_line_range: 1-43
source_commit: e1a5cda58e2f7686833e399da2f3cf8e699d680e
source_date: 2026-03-10
source_authors: [kumavis]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 442 chat-lane ingest. 43-line SceneCanvas.jsx
  from @endo/whylip/src — the React component that
  implements Layer 6 of the six-layer exfiltration
  defense via `sandbox="allow-scripts"` on an iframe
  that renders LLM-generated HTML scenes from Fae
  agents. Ninetieth AUTHORED conformant single-body
  section doc in post-refactor era. One-hundred-and-
  thirty-second consecutive non-garden source after
  the pivot (310-442).

  Single most structurally interesting move: §the-
  named-layer-6-narrower-than-design-implied — cycle
  220's design said "Layer 6 (iframe sandbox) applied
  by Chat" and was marked "Not Yet." Cycle 442 grounds
  the actual implementation: Layer 6 lives in the
  Whylip package (`packages/whylip/src/SceneCanvas.jsx`),
  not the main chat package. §the-named-layer-6-in-
  whylip-not-chat names the structural fact. The iframe
  sandbox is scoped to LLM-generated interactive scenes
  from Fae agents (Whylip primer visualizations), not
  general weblet hosting.

  §the-named-allow-scripts-as-minimum-viable-sandbox —
  `sandbox="allow-scripts"` permits JavaScript
  execution (scenes are interactive) but denies
  same-origin access, form submission, top-level
  navigation, popups, and storage API access.
  Maximum confinement compatible with interactive
  visualization. §the-named-sandbox-allows-scripts-
  denies-everything-else as tier-3 meta-pattern.

  §the-named-srcdoc-as-no-network-load — the `srcdoc`
  attribute places LLM-generated HTML directly into
  the iframe without a URL. Content arrives via the
  CapTP message stream from the Fae agent response;
  no URL fetch is needed or possible for scene
  content. §the-named-srcdoc-avoids-URL-fetch-channel
  as tier-3 meta-pattern.

  §the-named-sandbox-plus-network-layers-are-
  complementary — the "no network access" guarantee
  comes from the COMBINATION of Layer 6 (iframe
  sandbox) and Layers 1-5 (CSP, request interception,
  DNS poisoning, navigation guard, WebRTC disabled).
  The iframe sandbox blocks escape to parent; the
  network layers block outbound traffic. Both required.

  §the-named-six-layer-defense-fully-grounded — all
  six exfiltration-defense layers are now mapped to
  implementing source files (cycle 436 for Layers 2,
  3, 5; cycle 438 for Layer 4; cycle 440 for Layer 1;
  cycle 442 for Layer 6). §the-named-layer-6-closes-
  the-six-layer-arc as tier-3 meta-pattern.

  §the-named-ninety-conformant-cycles-and-counting.

  Closes eleven citation arcs: cycle 441 (1, adjacent
  forward) + cycle 440 (5, MAJOR COMPLETION — Layer 6
  now grounded; all six layers mapped to source) +
  cycle 438 (5, Layer 6 + Layers 1-5 = defense
  complete) + cycle 436 (5, MAJOR ARC CLOSE — cycle
  436 said "Layer 6 applied by Chat"; it is applied
  by Whylip) + cycle 220 (5, MAJOR DESIGN CLOSURE —
  the full six-layer design confirmed implemented) +
  cycle 218 (3, familiar-chat-weblet-hosting iframe-
  sandbox design confirmed implemented) + cycle 326
  (75) + cycle 322 (75) + cycle 364 (4, shapes
  growing with Layer-6 implementation) + cycle 318
  (3, Endo idiom) + cycle 433 (3, cotenant +
  exfiltration defenses complete together). Pushes
  citation-arc-closures-in-pivot to EIGHT-HUNDRED-
  AND-EIGHTY-THREE (872 + 11 net new).
---

43-line `packages/whylip/src/SceneCanvas.jsx` — the React component implementing Layer 6 of the six-layer exfiltration defense. Renders LLM-generated HTML scenes from Fae agents inside a sandboxed iframe (`sandbox="allow-scripts"`). Chat-lane after cycle 441 designs-lane howto-messaging.md. **Single most structurally interesting move**: §the-named-layer-6-narrower-than-design-implied — *Cycle 220's design listed "Layer 6 (iframe sandbox) applied by Chat" as "Not Yet." Cycle 442 grounds the implementation: Layer 6 lives in Whylip (`packages/whylip/src/SceneCanvas.jsx`), not the chat package. The sandbox is specifically scoped to LLM-generated Whylip primer scenes from Fae agents, not general weblet hosting.* §the-named-layer-6-in-whylip-not-chat. §the-named-allow-scripts-as-minimum-viable-sandbox (`sandbox="allow-scripts"` permits JS execution, denies same-origin/navigation/storage); §the-named-sandbox-allows-scripts-denies-everything-else. §the-named-srcdoc-as-no-network-load (content via CapTP message stream, not URL fetch); §the-named-srcdoc-avoids-URL-fetch-channel. §the-named-sandbox-plus-network-layers-are-complementary (Layer 6 blocks escape; Layers 1-5 block network; both required). §the-named-six-layer-defense-fully-grounded; §the-named-layer-6-closes-the-six-layer-arc. §the-named-ninety-conformant-cycles-and-counting. Eleven citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-EIGHTY-THREE.

## Section list

- [endo-but-for-bots--packages-whylip-src-SceneCanvas-jsx--layer-6-iframe-sandbox-via-allow-scripts-for-llm-scenes](../sections/endo-but-for-bots--packages-whylip-src-SceneCanvas-jsx--layer-6-iframe-sandbox-via-allow-scripts-for-llm-scenes.md)
