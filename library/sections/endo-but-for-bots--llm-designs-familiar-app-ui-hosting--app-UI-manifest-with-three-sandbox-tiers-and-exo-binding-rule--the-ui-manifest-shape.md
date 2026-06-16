---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §UI manifest shape
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The `ui` field on an app handle:

```
ui: {
  entry:   'index.html',                 // path within the assets tree
  assets:  <readable-tree>,              // static files to serve
  sandbox: 'isolated' | 'connected' | 'trusted',
  bridge:  'message-port' | 'web-socket',// CapTP transport to the app exo
}
```

Four fields: *what HTML to serve as the entry point* + *which
files to make available* + *which sandbox tier to use* +
*which transport to use for the back-channel*.
