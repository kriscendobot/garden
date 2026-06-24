---
ts: 2026-05-22T20:31:43Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer extends Familiar release narrative — per-platform packaging lanes + E2E in CI pre-release workflows

Dispatch root: `dispatches/designer--60e957/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Maintainer directive (verbatim)

> Please dispatch a designer to extend our existing narrative on shipping packaged releases of the Familiar application, with separate lanes for MacOS (dmg), Windows (msi, presumably, but you might know or find better information), Linux (deb, rpm, and flatpack) with particular attention to end-to-end testing in the validation feedback loop for all of these variations, in dedicated CI pre-release workflows.

## Existing narrative

The anchor is **`designs/familiar-release.md`** on the un-drafted PR `endojs/endo-but-for-bots#231` (`design/familiar-release` branch, base `llm`, "Familiar Preliminary Release", Status Proposed). It carries the MVR (Minimum Viable Release) framework with G1-G16 line items. To read the design itself, the designer should `git fetch origin design/familiar-release && git show origin/design/familiar-release:designs/familiar-release.md` from the project worktree.

In-flight follow-on PRs against `familiar-release.md`'s MVR table:

- **#318** — `ci(familiar): trigger per-platform build on PR + branch push (G1)` — DRAFT. Wires the existing Familiar Release workflow on PR + push, uploads per-platform artifacts (darwin-arm64, darwin-x64, linux-x64) to the workflow Artifacts panel. Does NOT yet build msi / deb / rpm — only the `.app` / `.exe` / linux-directory shapes from `@electron/packager`.
- **#322** — `design(familiar-flatpak-pipeline): Flatpak packaging proposal (G4)` — DRAFT. The Flatpak lane on Linux is already its own sibling design; the new design **references but does not duplicate** it.
- **#316** — `chore(familiar): bump bundled Node pin to v22.22.3 LTS (G5)` — DRAFT.

Related supporting designs already on `llm`:

- `designs/familiar-electron-shell.md` (Complete) — Electron shell, Electron Forge packaging via `forge.config.cjs`, `make-distributables.mjs` produces DMG on macOS + zip everywhere.
- `designs/familiar-daemon-bundling.md` (Complete) — esbuild CJS bundles for daemon/CLI/worker + embedded Node binary.
- `designs/familiar-bundled-agents.md` (Complete) — lal setup + agent bundles inside `bundles/`.
- `designs/chat-playwright-smoke.md` (Complete) — the **existing E2E precedent** in this repo. Playwright build-and-load smoke for the Chat renderer. The new design's E2E section extends this pattern to the **packaged Familiar binary** across all platforms.
- `designs/gateway-packaging-ci.md` (Proposed, just landed as PR #356) — server-side Gateway packaging with rpm/deb/PKGBUILD/Docker via CI. The Familiar packaging design **diverges from this**: the Gateway is a system service (no UI, server-side install); the Familiar is a desktop app (UI, end-user-installed via dmg/msi/deb/rpm/flatpak). Different lanes, different tooling, different validation. Read it for the CI-workflow-shape patterns, but the artifacts are different.

## The narrative gap this dispatch fills

`familiar-release.md` enumerates G-items as a checklist; it does not lay out *how* each platform's packaged lane is built, signed, and validated. PR #318 covers the CI trigger surface. PR #322 covers Flatpak. The missing pieces:

- **macOS (dmg)** — the existing pipeline already produces DMG via `make-distributables.mjs` on macOS, but: code-signing identity (Developer ID), notarization through Apple's notary service, hardened-runtime entitlements, the `.dmg` background image / volume layout, and the universal-binary question (one dmg with both x64 + arm64 vs. two).
- **Windows (msi)** — the maintainer guessed `.msi`; **the designer should research and recommend**. The Electron ecosystem's main options:
  - **`.msi`** via WiX Toolset — the canonical Windows installer, supports group-policy deployment.
  - **`.exe`** via NSIS or Squirrel.Windows — what Electron Forge / electron-builder default to; smaller, easier to sign.
  - **`.appx` / `.msix`** — Microsoft Store / modern packaging.
  - **Portable `.zip`** — already produced today; not an installer.
  - The designer picks one (or a primary + a fallback) with rationale: signing model, smartscreen reputation, update-channel integration, group-policy needs.
- **Linux deb / rpm** — these are not in the current pipeline. `electron-builder` supports both natively; Electron Forge has a `@electron-forge/maker-deb` and `@electron-forge/maker-rpm`. The designer picks which tool (Electron Forge vs. electron-builder — the existing pipeline uses Electron Forge per `forge.config.cjs`, so continuity favors Electron Forge unless a feature is missing). Cover: GPG signing of repos, dependency declaration (libgtk-3-0 etc.), desktop-file integration, systemd-user-service question.
- **Linux flatpak** — already covered by **PR #322**; the new design **references but does not duplicate**.
- **End-to-end testing per platform** — the validation feedback loop. The chat-playwright-smoke pattern is the existing E2E reference; the new design extends it to test the *packaged binary* (not the dev build) on each platform: install → launch → first-run setup → connect to LLM provider → bundled `lal` agent responds → close cleanly. Across all five artifact types (dmg, Windows installer, deb, rpm, flatpak). The CI workflow runs the E2E on a runner that matches each target platform; the designer picks runner shapes (macos-14 + macos-13 already; ubuntu-latest already; windows-latest is the new one).
- **Dedicated CI pre-release workflows** — distinct from the per-PR build pipeline (PR #318 produces artifacts on every PR). Pre-release is a *gate*: when a `familiar-v*` tag is pushed (or a `workflow_dispatch` with version input fires), the pre-release workflow builds all five lanes, runs E2E on each, and only on full-green does the GitHub Release get drafted. The designer names the exact workflow shape, the artifact-signing gates, the E2E-must-pass gate, and the manual-attestation step (if any) before the release goes from Draft to Published.

## Task

Produce one or two design documents under `project/designs/`. The designer decides 1 vs. 2 based on the *1-to-3-screens* rule in `garden/roles/designer/AGENT.md`. If the per-platform packaging *and* the E2E + pre-release-CI workflow each comfortably fit in 1-3 screens, **lean toward one combined design**; if either grows past 3 screens, split. Suggested slugs:

- **Single-design option**: `designs/familiar-multi-platform-pre-release.md`.
- **Stacked option**: `designs/familiar-platform-packaging.md` (per-platform lanes) + `designs/familiar-pre-release-e2e.md` (E2E in CI pre-release workflows, depends on the first).

### Each design should cover

The new design (or pair) is structured per the `project/designs/CLAUDE.md` conventions. Sections in order:

1. **Metadata table** — Status `Proposed`. Add `Source: Issue #229 (extended)` if the maintainer's earlier #229 directly motivates this; otherwise leave `Source` off. No `Supersedes:` — the new designs extend `familiar-release.md`, they do not replace it.
2. **Problem statement** — name the gap surfaced here: `familiar-release.md` enumerates the G-items as a checklist but does not lay out the per-platform build / sign / validate / publish chains, and PRs #318 / #322 only partly fill those rungs. The new design(s) are the missing rungs.
3. **Per-platform packaging lanes.** One subsection per platform (macOS, Windows, Linux deb, Linux rpm, Linux flatpak). For each lane:
   - **Artifact format** — the picked installer / package format with rationale (and named alternatives considered).
   - **Build tooling** — Electron Forge maker (`@electron-forge/maker-deb`, `-rpm`, `-dmg`, `-squirrel`, `-flatpak`?) vs. electron-builder, with rationale. The existing pipeline uses Electron Forge per `forge.config.cjs`; deviations need a why.
   - **Signing** — code-signing identity / GPG key / Apple Developer ID / Windows EV / etc., where the secret lives (Github Actions environment secret? AWS KMS? hardware token?), how the CI runner accesses it. Surface signing-identity ownership as an open question if not yet decided.
   - **Distribution** — where the artifact ultimately lives: GitHub Releases, a custom CDN, the platform stores (Homebrew tap, Microsoft Store, snapcraft, flathub).
   - **Auto-update channel** (out-of-scope for MVR but named): `electron-updater` vs. Squirrel vs. Sparkle vs. platform-store-native vs. none.
4. **End-to-end testing per platform.** The validation feedback loop. Cite `chat-playwright-smoke.md` as the existing pattern. Per-platform:
   - **Install step** — how the runner installs the artifact (`open foo.dmg && cp Familiar.app /Applications` on macOS; `msiexec /i foo.msi` on Windows; `apt install ./foo.deb` on Linux; `flatpak install` for flatpak).
   - **Launch step** — start the app in headless or headed Playwright mode, with the Familiar's `localhttp://` protocol intercept being the load-bearing thing to verify.
   - **First-run setup step** — the form-based provisioning from `lal-fae-form-provisioning.md` (the user supplies host, model, auth token).
   - **lal-agent-responds step** — send a test message, assert a coherent response from a stubbed LLM provider (or a tiny canned model) within a timeout.
   - **Close step** — clean shutdown; assert no orphaned daemon process and no port still bound.
   - **Failure modes** — capture screenshots, daemon logs, system logs on failure. Per-platform log harvesting differs.
5. **Dedicated CI pre-release workflows.** Distinct from the per-PR build pipeline (PR #318):
   - **Trigger** — `push: tags: [familiar-v*]` and `workflow_dispatch` (with a version input). PR / branch push fires the artifact-build pipeline (PR #318); pre-release adds the gate.
   - **Job topology** — fan-out per platform (matrix on `os: [macos-14, macos-13, ubuntu-latest, windows-latest]` + per-Linux-package-format), each producing one installer artifact. Then a fan-in `e2e` job per platform that exercises the matching installer (windows installer on windows runner; deb on ubuntu; rpm on fedora-or-rocky-on-self-hosted; dmg on macos; flatpak on a flatpak-equipped runner). Then a `release` job that drafts the GitHub Release only on full-green.
   - **Gate** — every E2E must pass; signing must succeed; checksums must be uploaded.
   - **Manual attestation** — does the maintainer manually flip the draft Release to published, or does the workflow do it automatically on full-green? Recommend manual for first cut (defense-in-depth against accidental ship); surface as a design decision.
   - **Cost** — Windows + macOS minutes are expensive; the design names how much CI minutes the pre-release workflow consumes per ship, and whether the per-PR pipeline runs the E2E (recommend: no — E2E is pre-release-only or scheduled).
6. **Cross-cutting concerns.**
   - **Reproducibility** — can the maintainer rebuild a published `.dmg` from a git ref and get the same bytes? If not, what's the closest approximation (deterministic-modulo-signing-timestamp)?
   - **Version stamping** — the artifact's embedded version comes from `package.json`? a git tag? a CI-injected envvar?
   - **Bundled-Node-version coordination** — interaction with PR #316 (Node LTS pin).
   - **Bundled-Primer / agent-bundle freshness** — the `lal` Primer ships inside the artifact; how is it kept in sync with the agent's expectations?
7. **Phased implementation.** Rough cuts: Phase 1 — Linux deb + rpm (smallest delta from today's pipeline; Electron Forge already supports). Phase 2 — Windows installer (new platform, new signing). Phase 3 — dmg signing + notarization (macOS already produces dmg; the missing piece is sign + notarize). Phase 4 — pre-release CI workflow with E2E across all platforms. Phase 5 — flatpak (carried by PR #322; designer references but does not re-author). Designer adjusts phasing.
8. **Dependencies table.** `familiar-release.md` (extends), `familiar-electron-shell.md` (parent for `forge.config.cjs`), `familiar-daemon-bundling.md` (Node binary embedding), `chat-playwright-smoke.md` (E2E precedent), `gateway-packaging-ci.md` (adjacent CI shape, different artifact), `familiar-flatpak-pipeline.md` from PR #322 (cross-link for the Linux flatpak lane).
9. **Design decisions** with rationale — Windows installer choice (msi vs. NSIS vs. Squirrel vs. msix), Electron Forge vs. electron-builder, signing-key custody, manual-vs-automatic release publication, E2E-runner-per-Linux-package choice.
10. **Open questions** — signing identity ownership (developer account, hardware token, KMS), repo-hosting for deb / rpm (private apt / dnf repo? Cloudfront-fronted bucket? GitHub Releases as-is?), Windows code-signing certificate provider, the `familiar-v*` tag-cutting cadence and who owns it.
11. **Prompt** — capture the maintainer's verbatim directive under `## Prompt` per `designs/CLAUDE.md` § Capturing the prompt.

## Procedure

1. Read `garden/roles/COMMON.md`, then `garden/roles/designer/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md` (index domain terms: dmg, msi, msix, NSIS, WiX, Squirrel, electron-forge, electron-builder, flatpak, snap, apt, dnf/yum, codesign, notarytool, hardened-runtime, EV cert, smartscreen, etc.).
3. Read `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`, `garden/skills/prompt-section-discovery/SKILL.md`.
4. Read `project/designs/CLAUDE.md` and `project/designs/README.md`.
5. Read **the anchor design**: `git fetch origin design/familiar-release && git show origin/design/familiar-release:designs/familiar-release.md` — the G1-G16 MVR table is essential.
6. Read the existing supporting designs:
   - `project/designs/familiar-electron-shell.md` (Complete)
   - `project/designs/familiar-daemon-bundling.md` (Complete)
   - `project/designs/familiar-bundled-agents.md` (Complete)
   - `project/designs/chat-playwright-smoke.md` (Complete) — **E2E precedent**
   - `project/designs/gateway-packaging-ci.md` (Proposed, just landed) — adjacent shape; read for CI patterns, **do not duplicate**.
   - `project/designs/lal-fae-form-provisioning.md` — for the first-run setup E2E step.
7. Read the in-flight PRs:
   - `git fetch origin feat/familiar-ci-build-pipeline && git show origin/feat/familiar-ci-build-pipeline:.github/workflows/familiar-release.yml` (the existing workflow PR #318 extends).
   - `git fetch origin feat/familiar-flatpak-pipeline && git show origin/feat/familiar-flatpak-pipeline:designs/familiar-flatpak-pipeline.md` (PR #322's Flatpak design — cross-link, do not duplicate).
8. Inspect `project/packages/familiar/forge.config.cjs`, `project/packages/familiar/scripts/{bundle,download-node,prepare-package,package-app,make-distributables}.mjs`, and the existing `.github/workflows/familiar-release.yml` for the present pipeline shape.
9. Decide on Windows installer format. Research: what does Electron Forge's `maker-squirrel` produce? What does electron-builder's `nsis` / `appx` produce? What does WiX integrate cleanly with? Pick one (or a primary + a fallback) with rationale.
10. Decide: one combined design or two sibling designs. Land the file(s).
11. Sync `project/designs/README.md`: new row(s), milestone assignment (probably M2 or M3 since this extends the Familiar packaging story), dependency-graph edges to `familiar-release.md` and friends, size estimates.
12. Open as DRAFT PR against `endojs/endo-but-for-bots@llm`. Branch: `design/familiar-multi-platform-pre-release` (or your final slug). Title: `design(familiar): per-platform packaging lanes + CI pre-release workflows with E2E (extends #231)`. Body cites the maintainer directive, names PR #231 as the parent narrative, names #318 / #322 / #316 as in-flight prerequisites/siblings, summarizes the per-lane picks, and flags the open questions surfaced.

## Per-action authorization

Standing on `endojs/endo-but-for-bots`: push to your `design/<slug>` branch, open draft PR against `llm`. No comment authority outside the new PR's body. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation.
- No edits to `packages/familiar/` source.
- No re-rendering of `familiar-release.md` (extend via sibling, do not modify).
- No edits to PR #322's Flatpak design (cross-link only).
- No upstream ferry. No un-draft.

## Report

≤ 700 words. PR URL + head SHA. Design file path(s) on llm. Per-platform picks: Windows installer format (with rationale), Electron Forge vs. electron-builder choice, signing model. The E2E shape across the five lanes. The pre-release CI workflow gate shape (trigger, fan-out, fan-in, release-job gate). Open questions surfaced rather than answered. The 1-vs-2-design decision (with rationale). One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-designer-60e957.md` and push journal (rebase if non-fast-forward).
