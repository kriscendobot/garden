---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T10:39:55Z
---
---
role: scholar
refs: [jobs/doin/scholar-ingest-clark-west-nested-predictive-accuracy-2007.md]
---

Ingested Clark and West, *Approximately Normal Tests for Equal Predictive Accuracy in Nested Models* (2007), into the forecast-evaluation library. The canonical DOI is recorded alongside the freely available NBER Technical Working Paper 326 PDF actually read; the source index and all section footers state that it is the August 2006 working-paper version.

Added five sections and the `nested-model-forecast-comparison` concept. They cover nested-model raw-MSPE degeneracy, the MSPE adjustment, the West (1996) fitted-forecast route and its approximately-normal limits, the risk-versus-directional target boundary, and the distinct scopes of Giacomini-White, Romano-Wolf FWER, SPA, and MCS. Updated source/topic/concept indexes and keyword shortcuts.

Integrity: `library-link-check.sh --source-slug papers--clark-nested-predictive-accuracy-2007` passed after landing; `regenerate-topics-counts.sh --check` reported current. Regenerated `sections/README.md` and `topics/README.md` through their landers.

Self-improvement: none.
