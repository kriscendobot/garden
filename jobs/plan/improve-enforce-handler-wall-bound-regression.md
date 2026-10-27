---
gate: orchestrated
orchestrated_by: improve-enforce-handler-wall-bound-split
priority: normal
posted_by: producer
posted_at: 2026-10-27T15:05:52Z
---

---
role: gardener
handler-timeout: 2400
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Complete the regression and integration validation for the handler wall-bound fix delivered by predecessor job `improve-enforce-handler-wall-bound-watchdog`. Start from fresh `origin/main2` and inspect the predecessor's implementation and tests rather than assuming their shape.

Add a regression fixture that launches a handler descendant which survives or ignores TERM long enough to exercise forced teardown. Assert that the complete handler cgroup/process tree is terminated, watchdog evidence accompanies the failure, and `scripts/jobs/gardener.sh` returns within the configured handler budget plus the promised 60-second wall bound (use a safely shortened test budget/grace if the harness supports it without weakening the production assertion). Make any narrowly required integration fixes discovered by the fixture. Ensure the fixture itself cannot leak processes or hang CI. Run the focused regression and relevant broader shell/test checks, commit explicit pathspecs, and push to `main2` using the required garden repository lock and rebase CAS loop from the job prompt.

This is the second serial slice of `improve-enforce-handler-wall-bound-split`; it owns end-to-end evidence for the original job's acceptance criterion. End with the orchestrated failure signal only if you genuinely finish this slice but cannot achieve its gated outcome.
