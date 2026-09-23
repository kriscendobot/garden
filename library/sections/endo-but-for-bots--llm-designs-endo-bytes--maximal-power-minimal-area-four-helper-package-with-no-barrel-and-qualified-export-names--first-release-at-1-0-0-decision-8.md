---
source: designs/endo-bytes.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-bytes.md
source_path: designs/endo-bytes.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Designer (dispatched per kriskowal review)
topics:
  - tooling
  - patterns
  - pass-style
genre: §endo-but-for-bots-design
cycle: 172
lane: designs
status: current
title: §First-release at 1.0.0 (Decision 8)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *The first release ships as `1.0.0` via a `'@endo/bytes':
> major` changeset entry. The workspace `package.json`
> `version` stays at the `0.1.0` floor; the changeset's
> major bump from a `0.x.y` baseline lands the published
> version at `1.0.0`. This matches the convention recently
> established for fresh utility packages where the first
> published artifact is API-stable from day one and there
> is no `0.x` line to leave behind.*

§First-release-API-stable-from-day-one. §No-0.x-purgatory.

§Why-this-matters: §0.x-versions-signal-instability and
many consumers refuse to depend on them. §Starting-at-
1.0.0-says-the-API-is-deliberately-stable.

§Implemented-via-changeset-major-bump (not by hand-editing
package.json). §Tooling-driven-versioning.

§Synthesis-target: future utility-package designs in Endo
can follow §start-at-1.0.0 pattern.
