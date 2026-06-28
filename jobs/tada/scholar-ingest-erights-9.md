# scholar-ingest-erights-9 — completion report

Ingested the four ELib `elib/concurrency/` single-page mechanics chapters and both
sub-hub MAP pages (6 sources, 6 consolidated sections), deferring the six sub-hub
child chapters to scholar-ingest-erights-10.

Sources ingested (all idempotency-checked; SHAs matched the job anchors; mirror-served):
- erights--elib-concurrency-refmech (reference-kind taxonomy)
- erights--elib-concurrency-msg-passing (six primitives, call vs eventual send)
- erights--elib-concurrency-turns (turns as micro-transactions)
- erights--elib-concurrency-partial-order (partial-order on references)
- erights--elib-concurrency-when-index (Four Layers of When sub-hub MAP)
- erights--elib-concurrency-eio-index (EIO sub-hub MAP)

Indexes: hub map section + hub source refreshed (4 chapters + 2 maps flipped to
ingested); topic pages e-language (+6), eventual-send (+6), pass-style (+1 refmech),
capability-security (+1 refmech); topics/README counts corrected (e-language 38,
eventual-send 92, pass-style 71 [cleared 56->70 drift], capability-security 240
[cleared 236->239 drift]); sources/README +6 rows.

Gates: library-link-check --source-slug PASSED on all 7 touched clusters;
regenerate-sections-index.sh landed. Posted scholar-ingest-erights-10 for the six
sub-hub children (completes the chapter). Result entry:
entries/2026/06/28/174820Z-result-gardener-f73f9a.md (plus a self-improvement
correction at 174904Z: the conventions-named inserter script is present on origin/main2;
this host's deployed root merely lags — upgrade-ready on endolinbot).
