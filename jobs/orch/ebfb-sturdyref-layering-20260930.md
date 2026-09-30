---
child-ebfb-sturdyref-layer1-shim-design-20260930-reap-count: 0
order: serial
children: ebfb-sturdyref-layer1-shim-design-20260930 ebfb-sturdyref-layer1-shim-build-20260930 ebfb-sturdyref-layer2-ses-20260930 ebfb-sturdyref-layer3-pass-style-20260930 ebfb-sturdyref-layer4-marshal-20260930 ebfb-sturdyref-layer5-captp-wire-20260930 ebfb-sturdyref-layer6-captp-construct-20260930 ebfb-sturdyref-layer7-ocapn-enliven-20260930 ebfb-sturdyref-layer8-daemon-formula-20260930 ebfb-sturdyref-layer9-agent-api-20260930
on-child-failure: halt
state: running
created_by: ebfb-sturdyref-layering-supervisor-20260930
created_at: 2026-09-30T04:43:18Z
---

Serial bottom-up SturdyRef layering stack per kriskowal's 2026-09-30 directive
on endojs/endo-but-for-bots#695 (comment 5903472512), arc
kriscendobot/garden#47. Ten children: a layer-1 design PR, eight build layers
(shim rework of #774, SES, pass-style, marshal, CapTP wire — which subsumes
llm's shipped ocapn-sturdyref, CapTP construct, OCapN enliven, daemon
formula-SturdyRef), then the layer-9 revisit of #695/#871. Supersedes the
halted ebfb-sturdyref-stack-rebase-20260916 campaign (remainder withdrawn
2026-09-30 by ebfb-sturdyref-layering-supervisor-20260930). Serial with halt:
each layer builds on the previous layer's head branch.
