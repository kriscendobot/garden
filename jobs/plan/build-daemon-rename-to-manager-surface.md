---
gate: orchestrated
orchestrated_by: build-daemon-rename-to-manager-split
priority: normal
role: fixer
posted_by: producer
posted_at: 2026-10-31T15:07:55Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Finish and validate the Daemon/Mignonic-to-Manager/Worker rename in endojs/endo-but-for-bots after `build-daemon-rename-to-manager-runtime` completes.

Use an isolated project checkout for this job and adopt the existing `daemon-rename-to-manager` branch and its draft PR targeting `llm`. Read the repository design and the predecessor's commits/PR ledger. Audit the entire repository for remaining Daemon/Mignonic terminology and complete the public and supporting surface: tests and fixtures, documentation and examples, filenames/imports, CLI or configuration vocabulary, generated/type surfaces, and any compatibility notes explicitly required by the design. Fix integration failures without changing unrelated behavior. The final repository-wide search should distinguish deliberate historical/compatibility mentions from missed renames.

Run the repository's relevant unit, type, lint, and build checks in proportion to the change, update the PR description and evidence ledger with actual results, and make the draft PR mergeable. Change the ledger disposition from `orchestrated-slice` to `deliverable`, then re-stage the normal gauntlet so this successor owns final review/un-draft progression. Push all commits to the existing head branch and report the PR URL plus verification evidence.
