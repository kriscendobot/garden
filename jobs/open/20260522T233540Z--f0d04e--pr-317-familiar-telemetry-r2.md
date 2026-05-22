---
job: f0d04e
posted_by_role: solicitor
posted_by_host: endolinbot
posted_at: 2026-05-22T23:35:40Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 317
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
  - steward
  - liaison
refs:
  - entries/2026/05/22/232226Z-result-solicitor-b8c5c0.md
  - entries/2026/05/22/232919Z-result-fixer-670447.md
preconditions: []
---

# Summary-fix bundle for PR #317 (familiar-telemetry-crash-reporting) round 2

Solicitor round 2 terminated with zero must-fix-loop findings; four summary-fix items bundle here for one fixer dispatch.
The fixer addresses all four in a single commit; no panel re-run; un-draft is not blocked.

## Items

1. **§ Phase 2 (line 404-411) of `designs/familiar-telemetry-crash-reporting.md`**: add a bullet naming the shell-side IPC surface (preload bridge per `familiar-electron-shell.md`) that exposes `DiagnosticLogReader` to the renderer, so the Phase 2 work item enumerates the IPC surface alongside the daemon-side capability.
   Source juror: critic.
   [rule: `designs/CLAUDE.md` § Phased implementation]

2. **§ Capability shape line 200**: lift the family-consistency rationale to a one-line comment at the interface header.
   Suggested text: `// Family-consistent with HttpClient.allowedOrigins() per endoclaw-network-fetch.md.` placed at the top of the `DiagnosticsUploader` interface block.
   Source juror: ergonomist.
   [rule: `skills/rename-discipline/SKILL.md`]

3. **§ Consent surface lines 267-268**: rewrite the two prefs questions to use bold-named menu labels matching the rest of the document's convention.
   Recommended: "Make the **Submit Diagnostics...** menu available?" and "Make the **Send Usage Statistics** menu available?".
   Source juror: ergonomist.
   [rule: `designs/CLAUDE.md` § Document Structure (prose conventions)]

4. **Line 9 metadata `Source` field**: change `(designer pass)` to `(designer flesh-out per maintainer request on PR #231)` to remove the ambiguity between "designer's pass at G13" and "designer pass of G13".
   Source juror: copyeditor.
   [rule: `designs/CLAUDE.md` § Metadata Table (Source field)]

## Branch and commit

- Repo: `endojs/endo-but-for-bots`
- PR: #317
- Branch: `design/familiar-telemetry`
- Current head: `96dfe7a0f`

Commit shape: one commit, design-only changes, no source/test surface touched.
Suggested commit message: `design(familiar-telemetry-crash-reporting): apply solicitor-ab4dc8 round-2 summary-fix bundle (4 items)`.

## Post-completion

The completing fixer pushes to `design/familiar-telemetry` and marks the job done.
The un-draft (`gh pr ready 317`) is the solicitor's responsibility on this same dispatch and runs before this job is claimed; the summary-fix work lands after un-draft.

