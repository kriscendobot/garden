---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 450
created_at: 2026-06-18T08:44:00Z
last_appended_at: 2026-06-18T08:44:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#450

## Items

- [ ] Verify concrete type/shape of severance promise rejection reason when marshal tables are partially torn down at disconnect time. The design names the "error-path-cannot-depend-on-error-path" constraint but does not specify the concrete type (plain string vs structured Error vs passable).
  **Source juror(s)**: critic, skeptic
  **Round**: R2
  **Recommended action**: verify and document the rejection-reason type in the implementation PR's code-panel review (archivist / scribe surface).

- [ ] Provide test vectors for all three severance sub-cases: (1) transport-level (CTP_DISCONNECT from netlayer close), (2) object-level (CTP_DROP, remote peer drops the export), (3) permission-revoked (local host revokes the import via membrane drop / capability filesystem unmount). No test plan for any of these sub-cases is present in the design.
  **Source juror(s)**: skeptic
  **Round**: R2
  **Recommended action**: implementation PR code-panel (prover seat) should verify test coverage for all three sub-cases.

- [ ] Clarify the routing of the permission-revoked sub-case through CTP_DISCONNECT. The design lists it in scope and says "falls under the same observer" but does not describe how a membrane-drop or capability-filesystem-unmount event reaches the CTP_DISCONNECT path.
  **Source juror(s)**: skeptic
  **Round**: R2
  **Recommended action**: implementation PR should document or verify the routing; if the path does not exist, the design needs an amendment.

- [ ] Specify behavior of E.whenSevered called on a presence that is already severed at call time. The "one-shot, monotonic" invariant implies it should return an already-rejected promise, but the design does not state this explicitly.
  **Source juror(s)**: skeptic
  **Round**: R2
  **Recommended action**: implementation PR should document and test the already-severed-at-call-time case.
