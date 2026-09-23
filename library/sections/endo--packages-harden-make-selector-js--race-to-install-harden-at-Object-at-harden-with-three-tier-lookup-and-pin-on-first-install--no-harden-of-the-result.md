---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: §No-harden-of-the-result
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

Notice: the wrapper *doesn't* harden the result of
calling the underlying harden. The underlying harden
already returns its argument (typically the same object,
post-harden); the wrapper just forwards.

§Pass-through-by-design: §the-wrapper-is-a-selector-not-
a-transformer. §Any-transformation-is-the-underlying-
harden's-job.

§The-only-thing-the-wrapper-adds: §the-tier-walk-on-
first-call.
