---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 318
created_at: 2026-05-22T22:17:30Z
last_appended_at: 2026-05-22T22:17:30Z
status: parked
---

# Follow-ups for endo-but-for-bots#318

## Items

- [ ] The PR body references `designs/familiar-release.md`, but that file does not exist on `feat/familiar-ci-build-pipeline` or `origin/llm`; it lives on `origin/design/familiar-release` and has not landed. Future readers of the merge commit will follow the doc reference into a dead link until the design PR (#231) merges.  
  **Source juror(s)**: integrator, archivist  
  **Round**: 1 (barrister-0417a2)  
  **Recommended action**: Land the design PR (#231) before #318, or after both merge, footnote #318's merge-commit text to record where the design lives. Liaison or builder dispatch against `designs/familiar-release.md` when #231 lands.

- [ ] `actions/download-artifact@d3f86a106a0bac45b974a628896c90dbdf5c8093` (v4) runs on Node 20, which GitHub deprecates September 2026. Annotation is a CI warning, not a job failure.  
  **Source juror(s)**: gateway  
  **Round**: 1 (barrister-0417a2)  
  **Recommended action**: Let the major-general's next Dependabot sweep pick up the SHA bump. No action required on the PR itself.
