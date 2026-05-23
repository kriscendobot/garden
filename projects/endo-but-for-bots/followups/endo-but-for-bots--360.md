---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 360
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-23T00:29:41Z
last_appended_at: 2026-05-23T00:29:41Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#360

Created from the design-panel verdict (seven seats, in-band fallback) across rounds 1 and 2 on `design(familiar): per-platform packaging lanes + CI pre-release workflows with E2E (extends #231)` (branch `design/familiar-multi-platform-pre-release`). The PR adds two new design documents (`designs/familiar-platform-packaging.md` and `designs/familiar-pre-release-e2e.md`) and updates `designs/README.md`. Three deferrals warrant revisit when the PR (or its upstream mirror, if one is later ferried) merges.

## Items

- [ ] **Reproducibility audit (separate designer pass).**
  **Source juror(s)**: decomplector, critic.
  **Round**: 1.
  **Recommended action**: open a follow-up design doc (or a tracking issue on `endojs/endo-but-for-bots`) for the reproducibility audit that `familiar-platform-packaging.md` § *Reproducibility* defers. The MVR posture is best-effort determinism (`yarn install --immutable`, pinned Node download, pinned Electron version, deterministic esbuild output) plus published SHA-256 checksums; the audit scope is which non-deterministic inputs to attack first (signing timestamps, Node-binary `mtime`, Vite content-hash inputs). The audit is the input to the "future reproducibility audit is a separate designer pass" the design names. Out of scope for the design PR itself.

- [ ] **Auto-update (G6) follow-on designer pass.**
  **Source juror(s)**: ergonomist, skeptic.
  **Round**: 1.
  **Recommended action**: open a follow-up designer pass extending `familiar-release.md` G6 with the per-platform auto-update story once the signing chains land. `familiar-platform-packaging.md` defers `electron-updater` against a GitHub Releases manifest on macOS (signs against the same Developer ID) and Squirrel-on-NSIS via `electron-updater` on Windows. The design names both as out-of-scope-for-MVR with the canonical path indicated; the designer pass writes them up as their own deliverable. Lands after the signing chains are in place.

- [ ] **Confirm `lal-fae-form-provisioning.md` `host` field.**
  **Source juror(s)**: integrator, novice.
  **Round**: 1.
  **Recommended action**: open a one-line investigation (or a small PR if the form needs to change) to confirm that `lal-fae-form-provisioning.md`'s form actually has a `host` field that points the agent's outbound `fetch` at a stub LLM server. `familiar-pre-release-e2e.md` § *Five phases of the per-platform E2E* phase 3 assumes the form fills "the LLM-provider host, model, and auth-token fields"; the design's phase 4 stub-LLM-server posture depends on `host` being routable to `127.0.0.1:<stub-port>` at form-submit time. If the form's field is named differently (`endpoint`, `url`, `apiBase`) or the field is read-only after first run, the E2E phase 4 spec needs alignment before Phase 2 of the e2e implementation lands. One grep of `lal-fae-form-provisioning.md` (or the implementing code) settles it.
