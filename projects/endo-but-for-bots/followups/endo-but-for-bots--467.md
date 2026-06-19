---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 467
created_at: 2026-06-19T01:57:46Z
last_appended_at: 2026-06-19T01:57:46Z
status: parked
---

# Follow-ups for endo-but-for-bots#467

## Items

- [ ] `designs/fs-interface-reconciliation.md` — `followNameChanges` returns an immediately-terminating empty stream for CAS (D6). A viewer cannot distinguish "this backing is immutable (CAS)" from "the backing's watcher connection was lost." The design resolves the symptom (viewer reads a closed stream as "snapshot") but does not address the distinguishability question for a caller with no prior knowledge of the backing type. A follow-up design note or viewer-contract clause naming the intended behavior would close the gap.
  **Source juror(s)**: R1 ergonomist, R2 panel (carry-forward)
  **Round**: R2 (carry-forward to R3)
  **Recommended action**: amend design doc `designs/fs-interface-reconciliation.md` § D6 Observation or the viewer contract to name the intended behavior for callers who cannot distinguish "immutable CAS" from "broken watcher"

- [ ] `designs/fs-interface-reconciliation.md` § Library and project references — the section spans approximately 200 lines and precedes the main technical analysis. A reader who wants to skip the prior-art context has no navigation guidance. A single skip-sentence ("Readers already familiar with the prior designs may skip to § Divergence survey.") would serve both new and returning readers.
  **Source juror(s)**: R2 panel (carry-forward)
  **Round**: R2 (carry-forward to R3)
  **Recommended action**: add a one-sentence navigation note at the top of § Library and project references pointing to § Divergence survey for readers who want to skip the prior-art context
