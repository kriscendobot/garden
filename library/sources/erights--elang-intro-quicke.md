---
source_kind: web
source_url: https://erights.org/elang/intro/quickE.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/quickE.html
source_fetched_via: mirror
source_content_sha256: 0a9cec3ff648ad327f7320b47ede7b8be1820c950e0b338f6a19f6ce874a6a55
source_authors: [Marc Stiegler]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
section_count: 4
status: current
notes: |
  Primary erights.org E-language tutorial body chapter, Marc Stiegler's "A 15 Minute
  Introduction to E" (the highlights tour that distinguishes E from other languages by
  leaping straight to the eventually operator and promises). Fetched 2026-06-27 from the
  erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh
  (`source_fetched_via=mirror`; erights.org refuses sandbox connections). Idempotency
  anchor is source_content_sha256, not a commit. Split into 4 sections (conventional
  subset; eventually operator + location transparency + pass-by-copy; promises +
  when-catch + far references + message ordering; bootstrapping the first remote
  reference). Body chapter of the tutorial whose index is
  [erights--elang-intro](erights--elang-intro.md); the eventual-send / promises material
  parallels the prior cycle's [erights--elang-concurrency-introducer](erights--elang-concurrency-introducer.md);
  grounds the secondary-source survey
  [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md).
---

Marc Stiegler's "A 15 Minute Introduction to E": the highlights tour that distinguishes E from other object-oriented languages. It skips most of the conventional language (treated as Java-familiar background) and leaps straight to the features that make E unique — the eventually operator `<-` (the eventual send) and its attendant promise architecture. The chapter develops location transparency (you do not know or need to know where an object is), the capability-security argument that unguessable reference URIs make wide-area computations as secure as a locked box, deadlock-freedom (a send never waits), pass-by-copy of immutables versus home-machine residency of mutables, promises and the `when (p) -> done(v) { ... } catch e { ... }` resolution construct, the `far`-prefix naming convention as a function contract, the partial-order guarantee on messages, nested when-catch, and finally how a program bootstraps its first off-machine reference (uri encoding, `makeURIFromObject` / `getObjectFromURI`, `introducer onTheAir`), with the pointed note that distributing uris is the one security problem E cannot solve for you.

| Section | Topics | Status |
|---------|--------|--------|
| [erights--elang-intro-quicke--overview-and-conventional-subset](../sections/erights--elang-intro-quicke--overview-and-conventional-subset.md) | getting-started, eventual-send | current |
| [erights--elang-intro-quicke--eventual-send-and-location-transparency](../sections/erights--elang-intro-quicke--eventual-send-and-location-transparency.md) | eventual-send, capability-security | current |
| [erights--elang-intro-quicke--promises-when-catch-and-far-references](../sections/erights--elang-intro-quicke--promises-when-catch-and-far-references.md) | eventual-send | current |
| [erights--elang-intro-quicke--bootstrapping-remote-references](../sections/erights--elang-intro-quicke--bootstrapping-remote-references.md) | eventual-send, capability-security | current |
