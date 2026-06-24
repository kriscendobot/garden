---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 322
created_at: 2026-05-22T23:52:00Z
last_appended_at: 2026-05-22T23:52:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#322

## Items

- [ ] `designs/familiar-flatpak-pipeline.md` lines 113-114: `--talk-name=org.freedesktop.Notifications` and `--talk-name=org.freedesktop.secrets` ship capability with no call-site ("Reserved; not currently wired"). Landing capability before the call-site exists invites Flathub-review questions.  
  **Source juror(s)**: skeptic  
  **Round**: 1 (solicitor-8b1fc0)  
  **Recommended action**: Revisit when the libsecret-migration followup (familiar-release.md G11) and the notifications-wiring followup lands. Drop the reserved lines from the manifest until the implementation needs them; re-add as part of the wiring PR.

- [ ] `packages/familiar/scripts/flatpak-build.mjs` at implementation time: consider splitting into `flatpak-prepare.mjs` (stage inputs, data) + `flatpak-build.mjs` (invoke builder, effect) to match the mermaid diagram at line 64 of the design (steps 6a, 6b, 6c). The current single-script form braids data and effect.  
  **Source juror(s)**: decomplector  
  **Round**: 1 (solicitor-8b1fc0)  
  **Recommended action**: Revisit on the implementation PR (Phase 2 of the design). The decomposition is a refinement, not a redesign; the implementation PR's builder dispatches under this design.

- [ ] CI step `Install Flatpak toolchain` (design lines 410-421) bundles three actions (apt install, remote-add, runtime install). A failure surfaces as one step with three possible causes. The design's own `## Testing § Validation Gates the Manifest Itself Must Pass` (line 568) prescribes one-failure-per-step.  
  **Source juror(s)**: ergonomist  
  **Round**: 1 (solicitor-8b1fc0)  
  **Recommended action**: Revisit on the CI-wiring PR (Phase 3 of the design). Split into three steps: `Install Flatpak packages` (apt), `Register Flathub remote` (flatpak remote-add), `Install runtime dependencies` (flatpak install).

- [ ] `designs/familiar-flatpak-pipeline.md` Dependencies table (lines 610-615): the four rows conflate "design that produced this work" (`familiar-release.md` G4) with "designs this composes with" (`familiar-electron-shell.md`, `familiar-daemon-bundling.md`, `familiar-bundled-agents.md`). The Relationship column reads inconsistently.  
  **Source juror(s)**: decomplector  
  **Round**: 1 (solicitor-8b1fc0)  
  **Recommended action**: Revisit on a documentation-grooming pass. Split the table into "Source" (one row) and "Composes with" (three rows), or relabel the column to make the relationships explicit per row.

- [ ] State-cohabitation: Flatpak relocates `XDG_STATE_HOME` to `~/.var/app/org.endojs.Familiar/.local/state/`. A user running both the Flatpak and a direct daemon launch on one host sees two state directories with no shared identity. The design's `rm -rf ~/.var/app/...` recipe at line 562 is correct for the Flatpak path but does not address the cohabitation case.  
  **Source juror(s)**: decomplector  
  **Round**: 1 (solicitor-8b1fc0)  
  **Recommended action**: Revisit on the implementation PR. Add one paragraph to the design (or the README the implementation PR lands) naming the cohabitation case and the recommended posture: either run only the Flatpak on a given host, or symlink the state directory across the two roots.
