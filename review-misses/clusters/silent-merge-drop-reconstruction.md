---
slug: silent-merge-drop-reconstruction
category: process
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-c4ef0155
prs: [475]
---

During a frozen-base reconstruction (restack/retcon) a semantic edit applied to one package/sibling is silently NOT propagated to its twins/consumers, leaving latent, test-passing inconsistencies; no rebase/reconstruction-fidelity check senses the dropped edit.
