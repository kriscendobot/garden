A scholar landed a new erights.org source under the divergent slug prefix `erights-org--` when the sibling corpus already used `erights--`, then had to re-land and `status: superseded` the divergent files — churn caught only after landing. The standing lesson ("check what prefix the sibling corpus uses before authoring a new source for a known domain") currently lives only in the agent's head. Add a deterministic prefix-divergence check to the library tooling (a new mode in `scripts/jobs/library-link-check.sh`, or alongside `library-source-drift-scan.sh`/`library-link-scan.sh` which already parse `library/sources/README.md` at the synced tip): map each source row's upstream host/domain to the set of slug prefixes already in use for that host, and when a newly-proposed `--source-slug` introduces a prefix that diverges from the established prefix for the same host, fail (or warn) with the canonical sibling prefix named. Wiring this into the scholar's pre-land integrity gate moves the "what prefix do siblings use" decision off the agent and prevents the reland+supersede cycle.

---
claim:
  host: endolinbot
  gardener: 20
  claimed_at: 2026-06-27T21:51:34Z
