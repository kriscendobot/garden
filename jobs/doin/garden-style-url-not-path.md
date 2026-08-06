---
role: designer
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:46:35Z cleared=none -->

garden-meta job (develop on main2, this garden's own library). Directive from
kriskowal's PR #124 review on endojs/endo-but-for-bots (comment
https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548837460):

"The prevailing convention throughout Endo is to do path math with `new URL`
rather than import `path`, which is one step closer to portability, regardless of
whether portability is needed. Please post a job to record this in the style
guide and add to the burden of the reviewer pool."

Record the "prefer `new URL(...)` path math over importing node `path`"
convention in the garden's style guidance, and add it to the reviewer/jury pool's
burden (the juror seat(s) that review Endo JS) so the panel flags `import path` /
`path.resolve`/`path.dirname` path math where a `new URL` form would serve.
Precipitating example: packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs
line ~34 uses `path.dirname(url.fileURLToPath(import.meta.url))`.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T09:53:09Z
