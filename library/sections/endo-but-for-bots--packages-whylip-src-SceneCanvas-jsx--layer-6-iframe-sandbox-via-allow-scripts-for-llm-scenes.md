---
source: endo-but-for-bots--packages-whylip-src-SceneCanvas-jsx
cycle: 442
lane: chat
ingested: 2026-06-22
repo: endo-but-for-bots
branch: llm
package: whylip
cluster: pivot
shape: react-component
shape_subtype: iframe-sandbox-for-llm-generated-html
authored_conformant: true
post_refactor_era: true
post_refactor_sequence: 90
---

The 43-line `SceneCanvas.jsx` from `@endo/whylip/src` is the React component that implements Layer 6 of the six-layer exfiltration defense by sandboxing LLM-generated HTML scenes in an iframe with `sandbox="allow-scripts"`. Cycle 442's single most structurally interesting move closes the six-layer arc and names a precision that the design left implicit: Layer 6 is scoped to a specific threat surface. §the-named-layer-6-narrower-than-design-implied names the observation.

The design document (cycle 220) listed Layer 6 as "iframe sandbox applied by Chat" and marked it "Not Yet" on the Chat side. Cycle 442 grounds the actual implementation: Layer 6 lives in the Whylip package, not the main chat package. The iframe sandbox is specifically for the Whylip interactive primer's scene HTML — LLM-generated, self-contained HTML+CSS+JS documents that visualize educational concepts from a Fae agent. §the-named-layer-6-in-whylip-not-chat names the structural fact.

The confinement is precise: `sandbox="allow-scripts"` permits JavaScript execution (the scenes are interactive) but denies everything else — no same-origin access, no form submission, no top-level navigation, no popups, no access to storage APIs. A compromised or malicious LLM-generated scene can run JS inside the iframe but cannot escape to the parent page, cannot exfiltrate via navigation, and cannot acquire storage access. §the-named-allow-scripts-as-minimum-viable-sandbox names the mechanism: maximum confinement compatible with interactive visualization. §the-named-sandbox-allows-scripts-denies-everything-else as tier-3 meta-pattern.

The design in `add-space-modal.js` (line 40) makes the threat model explicit: "The scene runs in a sandboxed iframe with no network access." No network access is not from the sandbox attribute itself (which does not block fetch/XHR within `allow-scripts`) but from the broader six-layer stack — Layers 1-5 in the Electron/Familiar stack still apply. §the-named-sandbox-plus-network-layers-are-complementary names the architectural fact: the iframe sandbox (Layer 6) and the network layers (Layers 1-5) operate at orthogonal surfaces and both are required.

The component renders conditionally: no scene produces a placeholder element; a scene sets `iframeRef.current.srcdoc` via a React `useEffect` hook. The `srcdoc` attribute places the HTML directly into the iframe document without a URL, which means no network request is needed to load the scene content. §the-named-srcdoc-as-no-network-load names the mechanism: the content arrives through the CapTP message stream (as a string from the Fae agent response), never via a URL fetch. §the-named-srcdoc-avoids-URL-fetch-channel as tier-3 meta-pattern.

The iframe's title attribute mirrors the scene's title, supporting accessibility without leaking data to external resources. §the-named-title-attribute-for-accessibility names the convention.

The full six-layer defense is now grounded across source files:
- Layer 1 (CSP): `packages/familiar/src/protocol-handler.js` (cycle 440)
- Layer 2 (request interception): `packages/familiar/src/exfiltration-defense.js` (cycle 436)
- Layer 3 (DNS poisoning): `packages/familiar/src/exfiltration-defense.js` (cycle 436)
- Layer 4 (navigation delegate): `packages/familiar/src/navigation-guard.js` (cycle 438)
- Layer 5 (WebRTC disabled): `packages/familiar/src/exfiltration-defense.js` (cycle 436)
- Layer 6 (iframe sandbox): `packages/whylip/src/SceneCanvas.jsx` (cycle 442, THIS FILE)

§the-named-six-layer-defense-fully-grounded names the completion. All six layers of the exfiltration defense are now mapped to their implementing source files. §the-named-layer-6-closes-the-six-layer-arc as tier-3 meta-pattern.

The Whylip package imports `mountWhylip` from its own index, and `whylip-component.js` in the chat package delegates to it. The iframe sandbox lives two layers of indirection from the chat UI. §the-named-whylip-as-sandboxing-host-not-chat-directly names the delegation structure.

§the-named-ninety-conformant-cycles-and-counting marks the session-level observation: ninetieth AUTHORED conformant single-body section doc in post-refactor era (cycles 353-442). §one-hundred-and-thirty-two-cycles-with-named-pivot-domain-stay (310-442).

Closes eleven citation arcs. Cycle 441 (1, adjacent forward). Cycle 440 (5, MAJOR COMPLETION — Layer 6 now grounded; all six layers mapped to source). Cycle 438 (5, Layer 6 + Layers 1-5 = defense complete; EXECUTION-CONTEXT-LEAK layer now has sibling in iframe escape prevention). Cycle 436 (5, MAJOR ARC CLOSE — six-layer-exfiltration-defense fully grounded; cycle 436 said "Layer 6 applied by Chat"; it is applied by Whylip). Cycle 220 (5, MAJOR DESIGN CLOSURE — the full six-layer design from cycle 220 is confirmed implemented across source files). Cycle 218 (3, familiar-chat-weblet-hosting's iframe-sandbox design now confirmed implemented; design doc matched by working component). Cycle 326 (75). Cycle 322 (75). Cycle 364 (4, shapes growing with Layer-6 implementation). Cycle 318 (3, Endo idiom). Cycle 433 (3, cotenant + exfiltration defenses together ensure the iframe cannot become a cotenant threat). Pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-EIGHTY-THREE (872 + 11 net new).

**The six-layer exfiltration defense is fully grounded. The cluster's security vocabulary remains four-dimensional (COTENANT + EXFILTRATION + EXECUTION-CONTEXT-LEAK + LIVENESS-REVOCATION), and all six defense layers addressing the EXFILTRATION dimension are now mapped to their implementing source files. The key architectural clarification from cycle 442: Layer 6 lives in Whylip, not in the Chat package itself — the iframe sandbox is scoped to LLM-generated interactive scenes from Fae agents, a narrower and more precise deployment than "applied by Chat" implied.**
