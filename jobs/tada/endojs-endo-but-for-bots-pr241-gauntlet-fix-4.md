CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #241 gauntlet FIX round 4 — design-only PR adding `designs/familiar-run-apps-vfs.md`.

**What I did:** Applied the panel-4 (round-4) request-changes items to the design doc, pushed as a review-feedback follow-up commit, and watched CI to a green terminal.

**Changes (`designs/familiar-run-apps-vfs.md`, commit `0b9f5e3a0`):**
- **pedant [must-fix]:** Removed all 8 em-dashes (em-dash-style) and the Unicode arrow at the worked-example (typist-friendly-code-points), rewriting each as period/parentheses/colon/`->`.
- **critic/skeptic:** Reconciled Resolved-decisions #4 with the detailed peer policy — the summary now states transitive-closure satisfaction rather than the narrower entry-package-only rule.
- **critic:** Stopped borrowing SES-compartment vocabulary for Case 2 multi-major hosting; decision #3 and "Cross-major-version semantics" now name it as Node nested-`node_modules` resolution and flag the weaker isolation.
- **ergonomist:** Split the overloaded `IngestionError` into `IngestionError` (fetch/registry, retryable) vs `ResolutionError` (peer/version-conflict, needs a package.json change), keeping the shared `@endo/errors` envelope; updated all call sites and both test-catalog entries. Cross-referenced `endo checkout` at the first Ejection use in Case 2 Shape.
- **decomplector/skeptic:** Decomplected the re-eject scratch dir — a read-only hash-named tree (unconditionally reusable) plus a separate per-run writable working directory, retiring the single-use/dirty flag and making the "no-op reuse" test reachable (Shape steps 2-3, Re-eject discipline, Case 2 test catalog). Materialized an explicit in-memory `RegistryResolution` before the run so map/log/cache derive from one immutable value rather than a live-table re-read.
- **skeptic:** Stated the guest Lal caplet reaches only Case 1; `host-node-app` (Case 2) stays host-only until the POSIX-sandbox follow-up (guest-access section + dispatch section).
- **copyeditor/novice:** Split the ambiguous Case 2 Purpose sentence; moved the Glossary ahead of § Relationship and glossed XS worker/`endor` at first use in Purpose.

**Result:** Pushed `e5a582bdb..0b9f5e3a0` to `endojs/design/familiar-run-vfs-apps` via safe-push-pr-head (advance/fast-forward). CI terminal: 5 checks, 0 failed, **GREEN**. Did not re-run the panel (the driver re-posts panel-5).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 140 tokens (6380781 cached reads)
- Output: 35061 tokens
- Cost: $5.194175500000001
- Wall-clock: 883s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
