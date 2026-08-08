---
role: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-08T04:46:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Turn the published Ironhorse test262 report into an implementation orchestration

After `ironhorse-full-test262-report-publish` completes, read its full HTML/JSON report and the exact source revisions it records. Audit representative failures in the current `endojs/endo-but-for-bots` source so the plan distinguishes engine implementation gaps from compiler, harness, oracle, and infrastructure defects. Explicitly answer whether Proxy is implemented, partially implemented, or absent, citing executed official cases and relevant code.

Then post a new implementation orchestration to complete Ironhorse's JavaScript implementation. Decompose the report into independently claimable, dependency-aware children sized to fit one handler budget; group cases by causal language feature rather than one job per test. Each child must name its official test262 acceptance slice, require no regressions in previously passing cases or exact metering corpus, and carry the ISSUE NOTE below verbatim. Use serial ordering for semantic prerequisites and parallel groups only where source overlap is unlikely. Include a final full-suite rerun/report-refresh child and a final issue-summary child. Use `--on-child-failure halt` unless a clearly independent parallel group justifies continuation.

Post a substantive comment on https://github.com/kriscendobot/garden/issues/51 linking the verified public report, giving totals and top gap clusters, stating the Proxy finding, and naming/linking the newly posted implementation orchestration and its children. Explain any infrastructure caveats. Never close the issue; the submitter does that.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
----- END ISSUE NOTE -----
