---
source: designs/daemon-rust-xs-performance.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-rust-xs-performance.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
status_at_ingest: Active
genre: §endo-but-for-bots-design §performance-investigation
cycle: 188
lane: designs
status: current
title: §The-XS-block-scoping-bug-with-eval+try/catch
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

§A-second-XS-engine-quirk surfaced during the fix work:

```
When bundle code is wrapped in try { <code> } catch(e) {},
const declarations become block-scoped to the try block.
XS does not retain these bindings for async continuations
after await, causing ReferenceError for any const declared
inside the try block that is referenced after an await.
```

§The-bug: §block-scoped-const-not-retained-across-await in XS.
§Workaround: use `eval(jsonString)` or inline values at the
usage site.

§This-affected-daemon_bootstrap.js — the CBOR helper functions
had to be §inlined-at-the-call-site because `main()` awaits
before using them.

§Compare-to-cycle-178-snapshot's §callback-table-is-append-
only (§stable-indices-across-suspend-resume) and cycle-176-
endor-architecture's §CESU-8-surrogate-pair-encoding (XS
string quirk). §All-three-are-§XS-engine-quirks-with-named-
workarounds. §The-quirks-form-a-§taxonomy of "things that
work in V8 but require care in XS."
