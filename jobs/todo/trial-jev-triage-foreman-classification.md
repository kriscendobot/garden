---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-08T04:24:03Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Trial: replay real journal data through the Jev triage/foreman classifiers

Run the **Trial plan** in the design produced by `design-jev-triage-foreman-integration`
(find its PR and design file from that job's report in `jobs/tada/`; follow its recommended
option and pass criteria exactly). The point is evidence from real experience, not a demo.

- Build the replay harness under `scripts/jobs/` with tests: it extracts real inputs and
  their ground-truth outcomes from the journal, proposes a template via the amortization
  loop, classifies the held-out inputs through Jev, and scores them. Keep the deterministic
  policy authoritative in the harness exactly as the design specifies.
- **Egress limit:** use only data classes the design marks as already authorized (the
  maintainer-authored text and maintainer inbox, per the accepted Muster pilot terms).
  Do NOT send third-party comment text. If the only way to meet a pass criterion needs
  unauthorized text, stop and report that; do not widen the data.
- **Credential:** `TYPESAFE_API_KEY` is maintainer-provisioned. If it is absent, do not
  hunt for one; post ONE clear question to the maintainer inbox saying the trial is blocked
  on the key, and complete this job with `verdict: blocked`.
- Cap spend at the design's budget. Record cost per decision and the break-even computed from
  real volumes.
- Report in the job's tada report, machine-readable on the first lines:
  `verdict: pass|fail|blocked`, the measured numbers against each pass criterion, the
  template version used, and the path to the committed results.

Land harness and results on `main2` directly (the garden's own repo takes no PR workflow).
