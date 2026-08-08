---
gate: orchestrated
orchestrated_by: ironhorse-test262-report-and-gap-plan
priority: high
roadmap: ironhorse-language-completion
role: builder
posted_by: gardener
posted_at: 2026-08-08T03:44:05Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Run and publish the authoritative Ironhorse test262 report

After `ironhorse-full-test262-automation` completes, use its delivered PR head and exact SHA to run the new full-suite automation against the current authoritative TC39 test262 revision. Create the isolated project checkout with:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh ironhorse-full-test262-report-publish endojs/endo-but-for-bots <automation-head-branch>`.

Run the complete suite, not a curated sample. Use the automation's resume/batching support and, if the wall-clock exceeds a claim, leave a safe resumable or detached run rather than restarting from zero. Capture exact commands, revisions, elapsed time, totals, infrastructure failures, and an explicit Proxy result. Do not collapse unsupported/skipped cases into passes and do not treat oracle/harness failures as language failures.

Publish the generated self-contained HTML report and its machine-readable JSON under the garden GitHub Pages tree on `kriscendobot/garden` `main2` (for example `docs/reports/ironhorse-test262/<run-id>/` plus a stable latest link/index). Work only in this job's dedicated garden worktree and commit explicit pathspecs. Preserve existing Pages/bulletin content. Push with the required rebase/CAS loop to `origin/main2`, wait for the Pages deployment, and verify the public report URL with a real HTTP fetch. If Pages deployment fails, follow the existing pages-shepherd path and do not report publication as verified until the URL returns the intended report.

Leave the issue open. The next orchestration child will analyze the published data and post the substantive issue reply.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
----- END ISSUE NOTE -----
