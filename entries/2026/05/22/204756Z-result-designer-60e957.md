---
ts: 2026-05-22T20:47:56Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/22/203143Z-dispatch-liaison-60e957.md
---

# Result: designer extends Familiar release narrative — per-platform packaging lanes + E2E in CI pre-release workflows

PR: <https://github.com/endojs/endo-but-for-bots/pull/360> (DRAFT, base
`llm`, head `070438cb855187d09388f1cd49f5ec048909bb4f`).

## Decision: two sibling designs, not one

Per the 1-3-screens rule, split into:

- `designs/familiar-platform-packaging.md`: per-platform lanes (macOS
  dmg, Windows .exe via NSIS, Linux deb/rpm via Forge makers invoked
  as libraries, Flatpak cross-linked).
- `designs/familiar-pre-release-e2e.md`: per-platform Playwright E2E
  spec pattern + dedicated pre-release CI workflow gating Release
  publication.

The platform-packaging design alone is ~3 screens with five lanes,
five signing models, and a cross-cutting concerns section. The
E2E + pre-release-CI design adds ~2 more screens (job topology,
phase table, CI cost estimate). One combined design would have hit
5+ screens, past the rule. The split also separates concerns cleanly:
implementation chunks are independently buildable (a builder can land
each platform lane separately, and the pre-release workflow lands
after the lanes exist).

## Per-platform picks

| Platform | Producer | Signing |
|---|---|---|
| macOS arm64/x64 | `electron-installer-dmg` + `@electron/osx-sign` + `@electron/notarize` | Developer ID Application cert; notarytool only (altool decommissioned) |
| Windows x64 | `electron-winstaller` (NSIS) | EV cert via Cloud HSM (Azure Key Vault recommended); self-hosted-runner-with-USB-token as alternative |
| Linux deb | `@electron-forge/maker-deb` invoked as library | unsigned for MVR (hosted apt repo with GPG signing is followup) |
| Linux rpm | `@electron-forge/maker-rpm` invoked as library | unsigned for MVR (hosted dnf repo with GPG signing is followup) |
| Linux flatpak | per PR #322 (cross-linked, not duplicated) | OpenPGP deferred |

**Windows installer pick: NSIS, not MSI.** Rationale: smaller artifact
(~60% of MSI), mainstream Squirrel auto-update path, no Windows-only
build-host dependency. MSI / MSIX kept as named alternatives for
revisit (group-policy enterprise, Microsoft Store).

**Tooling: stay with `@electron/packager` plus hand-rolled scripts,
do not switch to Electron Forge wholesale.** Important clarification:
the current pipeline does **not** use `forge.config.cjs` (that file
does not exist in the current tree); it uses `@electron/packager`
directly via `scripts/package-app.mjs`. The Forge `maker-deb` /
`maker-rpm` packages can be invoked as libraries from
`make-distributables.mjs` without adopting the Forge pipeline.
Continuity favours this over a Forge refactor with no packaging-
correctness payoff.

## E2E shape (all lanes)

Five-phase Playwright spec per platform, modelled on
`chat-playwright-smoke.md` but targeting the installed packaged
binary, not the dev build:

1. Install (`hdiutil` / `msiexec /S` / `apt install` / `dnf install`
   / `flatpak install --bundle`).
2. Launch with `--remote-debugging-port=9222`; assert window opens,
   daemon spawns, `localhttp://` registers.
3. First-run setup: drive the `lal-fae-form-provisioning.md` form
   (LLM host, model, auth token).
4. lal-agent responds via a **stubbed local HTTP server** mimicking
   the Anthropic/OpenAI/Ollama API — no real LLM credits consumed,
   deterministic, offline-capable.
5. Clean shutdown: assert no orphaned daemon, no port leaked.

Per-platform failure-harvesting (daemon log, system log, screenshot)
uploads to the workflow's artifact panel for maintainer triage.

## Pre-release CI workflow gate shape

- **Trigger**: `push: tags: [familiar-v*]` and `workflow_dispatch`
  (with `version` and `dry_run` inputs).
- **Fan-out**: preflight (tag-vs-pkg.version, Primer SHA, Node pin)
  → build-artifacts → matrix-make (six lanes: dmg-arm64, dmg-x64,
  nsis, deb, rpm, flatpak) with **signing in-job per lane**.
- **Fan-in**: matrix-E2E (one job per lane, downloads matching
  signed artifact).
- **Release-job gate**: every E2E green, signing succeeded,
  checksums manifest generated + signed with a separate release
  key.
- **Publication**: drafts a GitHub Release tagged `familiar-v<v>`
  with artifacts + checksums. Stays Draft; **maintainer manually
  publishes** (defense in depth; revisit after three clean ships).
- **Cost**: ~114 wall-clock minutes / ~554 GH-billed minutes per
  pre-release (macOS 10x, Windows 2x). E2E is pre-release-only;
  the per-PR pipeline (PR #318) stays cheap.

## Open questions surfaced

1. Windows code-signing custody: Cloud HSM vs self-hosted runner?
2. EV vs OV Windows cert (reputation vs cost)?
3. Hosted apt/dnf repo URLs and GPG key custody?
4. Universal macOS binary (`@electron/universal`) timing?
5. Auto-publish on full-green vs manual?
6. Self-hosted Fedora runner for rpm E2E vs Docker container?
7. Notarization-failure fallback (fail-all vs skip-macOS)?
8. Release-signing key custody and rotation?

## designs/README.md sync

- Two new rows in the summary table.
- Both added to M1 per-design-estimates (M-sized and M-L-sized).
- Familiar subgraph in the dependency graph extended with
  `familiar-release` / `familiar-platform-packaging` /
  `familiar-pre-release-e2e` / `familiar-flatpak-pipeline` nodes
  and edges.
- See-also paragraph updated; totals refreshed (104 → 106).

Self-improvement: nothing this time.
