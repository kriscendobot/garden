---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The single most structurally interesting move — §the UI is
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

bound to a specific app exo

§Design Decision 3:

> *The UI is bound to a specific app exo, not ambient authority.
> Whether referenced or cloned, the UI can only reach the
> instance and powers the app was run with.*

The §exo-binding-rule:

> *The CapTP bootstrap handed to a `connected`/`trusted` UI
> resolves to **that app instance's exo**, carrying only the
> powers the app was run with (`run.powers` from the app
> handle).*

The §two share-modes:

- **Referenced**: a referenced app's UI bridges back to *the
  author's running exo*.
- **Cloned**: a cloned app's UI bridges to *the recipient's
  local exo*, under the *recipient's powers*.

The §reference-vs-clone-determines-which-exo discipline. The
*same UI code* can be hosted under different share-modes; the
exo binding determines what it can do. The
§capabilities-not-configurations discipline (cycle 105's
canonical principle) applied at the UI layer.

This is the §ambient-authority-prevention move: the UI gets a
*specific* exo's powers, never *all daemon authority*. Even a
malicious UI is bounded to the powers the app was provisioned
with.
