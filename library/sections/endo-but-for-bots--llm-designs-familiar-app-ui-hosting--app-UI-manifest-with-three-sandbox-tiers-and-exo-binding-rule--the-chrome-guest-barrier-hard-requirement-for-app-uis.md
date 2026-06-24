---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §chrome/guest barrier — *hard requirement for app UIs*
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The §chrome/guest barrier paragraph:

> *The host chrome (pane frame, close button, app title) lives
> outside the iframe; the app's UI lives inside it. Controls
> that act on the app's lifecycle are never rendered by the
> guest. This is the same barrier described in
> [familiar-chat-weblet-hosting](familiar-chat-weblet-hosting.md),
> restated here as a hard requirement for app UIs because app
> authors are potentially untrusted third parties.*

The §host-chrome-not-guest-chrome discipline: *close button*,
*pane title*, *app-lifecycle controls* — all rendered by Chat's
chrome, *outside* the iframe. The guest cannot draw a fake
close button or hide the real one.

The §restated-here-as-hard-requirement clause: the same
discipline already in `familiar-chat-weblet-hosting`; this
design *re-emphasizes* it for the app-UI case because *app
authors are potentially untrusted third parties* (vs Chat's
plugins which might be considered first-party).
