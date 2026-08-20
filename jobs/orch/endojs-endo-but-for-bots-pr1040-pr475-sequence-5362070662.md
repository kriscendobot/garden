---
child-endojs-endo-but-for-bots-pr1040-conduct-gate-5362070662-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr1040-conduct-gate-5362070662-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1040-conduct-gate-5362070662 endojs-endo-but-for-bots-pr475-advance-llm-base-5362070662 endojs-endo-but-for-bots-pr475-arraybuffer-tests-5362070662
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-08-20T21:43:47Z
---

# Conduct pull 1040, then complete the requested pull 475 sequence

First await and verify the already-active conductor job's merge of
https://github.com/endojs/endo-but-for-bots/pull/1040. After that merge, advance
and rebase https://github.com/endojs/endo-but-for-bots/pull/475 onto a fresh
frozen snapshot of the live `llm` branch. Only after the rebase succeeds, add
the requested test262-style behavior matrix for immutable/mutable,
emulated/genuine array buffers with array views and DataView views across
Node+SES, XS+SES, and bare XS.

Source: https://github.com/endojs/endo-but-for-bots/pull/1040#issuecomment-5362070662
