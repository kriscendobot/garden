---
ts: 2026-05-20T06:37:23Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/317
---

G13 from PR #231 review fleshed out per kriskowal's "Please dispatch a designer to flesh this out" on `designs/familiar-release.md` L359. Lighter-touch route was a new sibling design file rather than folding into `familiar-release.md`: the release doc is already 680 lines, every other Familiar concern lives as its own file (`familiar-electron-shell`, `familiar-bundled-agents`, `familiar-localhttp-protocol`, etc.), and `familiar-release.md` lives on the unmerged `design/familiar-release` branch (PR #231) rather than `llm` directly, so cross-linking it from a new file off `llm` keeps the dependency asymmetric the way it should be.

Shape: three pipelines (always-local error logs that match current `src/logger.js`; opt-in JS+native crash dumps with `Electron crashReporter` `uploadToServer:false`; opt-in usage telemetry explicitly deferred behind a Phase-4 go/no-go) feeding a single on-disk `diagnostics-pending/` staging directory consumed by a `DiagnosticsUploader` capability the Electron shell holds alone. Non-negotiable preview pane plus two-step consent surface (first-run opt-in + per-submission click); default opt-in throughout. Privacy guarantees encoded as structural exclusions rather than policy: logger doesn't see transcripts (redactor is belt-and-braces), `lal-fae-form-provisioning`'s `secret: true` markers honored, no env vars or network identifiers or persistent installation id, preview is the contract. Local-first locality (every artifact under Endo state dir; nothing hosted) reinforces `familiar-release` G10's cleanup story. Cap follows `endoclaw-network-fetch` single-origin-allowlist pattern. Phased plan 0..4 from MVR docs through optional usage telemetry.

Branch: `design/familiar-telemetry` off `llm` at `68246ad92`. Commit: `5bf4cee03`. PR: <https://github.com/endojs/endo-but-for-bots/pull/317> (DRAFT, base llm). File: `designs/familiar-telemetry-crash-reporting.md` (489 lines added).

Open questions surfaced for the maintainer rather than picked: endpoint discovery shape (hardcoded vs. config vs. user-entered), bundle size ceiling (proposed default 10 MiB cap with manual-attach fallback), receiving-service shape (GitHub Issues via `gh` vs. dedicated minidump endpoint vs. mailbox; explicitly out of scope for this design, candidate for a sibling).

A follow-up edit on the `design/familiar-release` branch (PR #231) can compress the G13 entry to a one-line "see `familiar-telemetry-crash-reporting.md`" cross-reference once both documents land.

Self-improvement: nothing this time.
