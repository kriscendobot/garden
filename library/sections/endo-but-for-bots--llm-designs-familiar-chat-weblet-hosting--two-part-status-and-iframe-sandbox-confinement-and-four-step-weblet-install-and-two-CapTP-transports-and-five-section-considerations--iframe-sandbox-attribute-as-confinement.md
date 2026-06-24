---
title: §iframe-sandbox-attribute-as-confinement
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

```html
<iframe
  src="localhttp://<weblet-id>/"
  sandbox="allow-scripts allow-same-origin allow-forms"
  allow="clipboard-write"
></iframe>
```

§Three-named-sandbox-permissions: `allow-scripts` / `allow-same-origin` / `allow-forms`. §One-named-allow-permission: `clipboard-write`. §The-iframe-boundary-enforces-confinement.

§Borrowable-pattern: §browser-iframe-as-the-confinement-substrate. §Sibling to:
- cycle 200 worker-rust-xs: §engine-level-confinement-via-XS-native-Compartment (different substrate, same purpose).
- cycle 212 outliner-design-doc: §custom-attenuation-code-in-SES-Compartment (different layer, same purpose).
- cycle 196 endoclaw: §ambient-vs-object-capability (the framing within which confinement happens).

§Four-cycles-using-different-substrates-for-confinement (200/212/196/218): XS native Compartment / SES Compartment / capability framing / iframe sandbox. §The-discipline-is-the-same-across-substrates.
