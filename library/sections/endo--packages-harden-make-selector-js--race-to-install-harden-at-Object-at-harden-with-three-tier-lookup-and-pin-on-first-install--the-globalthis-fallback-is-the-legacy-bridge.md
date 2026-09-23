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
title: §The-globalThis-fallback-is-the-legacy-bridge
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

> *`// @ts-ignore globalThis.harden is a HardenedJS
> convention`*

§HardenedJS-convention: `globalThis.harden` is what SES's
lockdown() installs. §Pre-`@endo/harden` code looked
there.

§This-selector-bridges-the-two-conventions: §accept-
either-and-make-them-equivalent. §No-need-to-rewrite-
existing-code that uses `globalThis.harden`.

§Migration-aided-by-bridge: §existing-`globalThis.harden`-
code-continues-to-work; §new-code-uses-`Object[@harden]`-
directly-via-this-selector.
