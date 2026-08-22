---
slug: error-message-names-in-scope-operation
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-489e73fc
prs: [475]
---

A thrown error carries a generic message while the failing operation or context (a method name, an operation label) is already bound in scope and could name the failure; review reads the throw for correctness but not for whether the available identifying context is threaded into the message.
