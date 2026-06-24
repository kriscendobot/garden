---
ts: 2026-05-19T22:19:43Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/fixer--ca1c56/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/231
---

PR #231 (`design(familiar): MVR release plan (closes #229)`) round-two review by kriskowal addressed.

Three topical commits landed on `design/familiar-release` (force-push not needed; fast-forward push only):

- `c9c648c` — defer signing/notarization (G2), Windows (G3), auto-update (G6); resolve Open Questions 1, 2, 6.
- `ed838bc` — G9 expanded to align with the shared host Gateway (`endo-gateway.md`); collapse weblets to single iframe/localhttp+HTTP-virtual-host flavour; drop user-assigned-localhost-port variant.
- `3aba6ab` — note builder/designer/gardener follow-up dispatches in G1/G4/G5/G7/G8/G13/G14/G15/G16; defer G8/G10/G11; resolve Open Questions 3, 4, 5; widen MVR coverage matrix in phased plan; sync `designs/README.md` Updated date.

All 20 inline replies posted via the `/replies` endpoint (no REST-lag fallback needed). Top-level summary: https://github.com/endojs/endo-but-for-bots/pull/231#issuecomment-4492536871. Re-requested kriskowal via `gh pr edit --add-reviewer`; reviewer set confirmed.

The fixer dispatch authorized comment ops. CI is not a gate for this design-only PR (markdown is in `.prettierignore`; `lint:prettier` scopes to `.github` and `packages`).

**Axis-2 follow-up dispatches** for the steward to route (verbatim maintainer directives quoted):

1. **L153 builder** — "Please dispatch a builder." (G1: wire the existing build pipeline into a CI workflow that emits per-platform artifacts).
2. **L191 issue-file** — "Please file an issue with instructions for beginning the process of obtaining a certificate. This is otherwise out of scope for MVR, wherein it is sufficient to target MacOS." (G3: Windows EV/OV certificate-acquisition process).
3. **L205 builder** — "Please dispatch a builder to propose a pipeline for Flatpack. We can defer the other packaging systems." (G4: Flatpak manifest pipeline).
4. **L227 builder** — "Please dispatch a builder to move this to a working LTS release. I believe that's currently 22 or 24." (G5: advance bundled Node pin from v20.18.1 to current LTS).
5. **L227 gardener** — "Please dispatch a gardener to propose a mechanism for sensing motion on the Node.js LTS supported versions window and automatically updating this version as well as the CI versions, maintaining an upgrade PR as that window shifts and shepherding it through CI or discovering compatibility impasses early."
6. **L257 builder** — "Please dispatch a builder to improve the automation for projecting out these file formats from the source icon. If platform-specific, let's consider checking in the built artifact and creating automation that can be run in a CI environment to update the icons using platform-specific tool kits." (G7).
7. **L275 builder** — "This can be deferred, but please dispatch a builder to implement the consolidated solution so we have reviewable material." (G8: stop/purge via CapTP from Electron main, dropping the bundled CLI dependency).
8. **L359 designer** — "Please dispatch a designer to flesh this out." (G13: telemetry / opt-in crash reporting shape).
9. **L375 builder** — "Please dispatch a builder." (G14: third-party LICENSE aggregation step in `make-distributables.mjs`).
10. **L387 builder** — "Please dispatch a builder." (G15: macOS arm64 + x64 build matrix, or universal binary via `@electron/universal`).
11. **L405 builder** — "Dispatch a builder to add tests for this flow." (G16: smoke test of the Primer-into-CAS path in the packaged build).
12. **L539 issue-file** — "Please file an issue with instructions to set this up." (Open Question 2: macOS signing-identity setup; standalone of G2 deferral so the cert-acquisition admin work is staged when the project pursues notarization).

Self-improvement: nothing this time.
