---
source_kind: web
source_url: https://erights.org/elang/concurrency/introducer.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/introducer.html
source_fetched_via: mirror
source_content_sha256: aaa19683547437e7e9e926472b1e5cca6f53f8d0667727fcb806167ef94b0e62
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Primary erights.org E-language tutorial chapter on secure distributed object
  programming ("Introducing Remote Objects"). Fetched 2026-06-27 from the
  erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh
  (`source_fetched_via=mirror`; erights.org refuses sandbox connections).
  Idempotency anchor is source_content_sha256, not a commit. The historical
  primary source behind the live-reference / sturdy-reference / capability-URI
  hierarchy that CapTP and Endo's locator model carry forward; the worked
  Granovetter introduction across two processes. Listed by the tutorial index
  [erights--elang-intro](erights--elang-intro.md); grounds the secondary-source
  survey [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md).
---

The E tutorial's chapter on **secure distributed object programming** and the historical primary source for the **live-reference / sturdy-reference / capability-URI** hierarchy CapTP and Endo carry forward. It introduces the `introducer` (turned `onTheAir()` to enable distribution over the cryptographic Pluribus protocol), the live-vs-sturdy reference distinction (a live reference passes messages but breaks on partition; a sturdy reference does neither but can re-obtain a live one), the capability URI (`cap://host:port/<swiss-number>`) made by `introducer.sturdyToURI` and consumed by `introducer.sturdyFromURI`, and the **eventually-operator `<-`** for asynchronous sends to deferred remote references that reject synchronous calls. It frames the whole exchange as the Granovetter Diagram with a human Alice, and closes on the capability discipline in miniature: sharing a `counter` grants exactly the eright to increment and read its variable and no other authority.

| Section | Topics | Status |
|---------|--------|--------|
| [erights--elang-concurrency-introducer--remote-objects](../sections/erights--elang-concurrency-introducer--remote-objects.md) | capability-security, capability-theory, eventual-send, captp | current |
