---
ts: 2026-05-20T06:43:50Z
kind: result
role: builder
worktree: dispatches/builder--d845c7/project
repo: endojs/endo-but-for-bots
project: endo
---

# Familiar Flatpak packaging pipeline (PR #231 G4 followup)

## Dispatch

Builder pass requested by the liaison for `familiar-release.md` G4
(line 205): "Please dispatch a builder to propose a pipeline for
Flatpack. We can defer the other packaging systems." The design
lives on PR #231 (branch `design/familiar-release`); the dispatch
asked for a branch off `llm` adding the proposal as a new design.

## What landed

PR https://github.com/endojs/endo-but-for-bots/pull/322 (DRAFT),
branch `feat/familiar-flatpak-pipeline`, base `llm`, head SHA
`1aef055b64473bb46c72c716becf82e41f8a31ad`.

One commit:

- `1aef055b6` `design(familiar-flatpak-pipeline): Flatpak packaging
  proposal (#231 G4)` — adds
  `designs/familiar-flatpak-pipeline.md` (648 lines) and updates
  `designs/README.md` (Summary table row, Recently-added paragraph,
  totals bump 15 -> 16 Proposed, 119 -> 120 designs).

## Manifest shape (summary)

- **App ID**: `org.endojs.Familiar`.
- **Runtime**: `org.freedesktop.Platform//24.08` + `org.freedesktop.Sdk//24.08`.
- **Base**: `org.electronjs.Electron2.BaseApp//24.08` (Flathub-published
  Chromium support libs + `zypak` sandbox shim).
- **Finish-args**: narrow set (IPC, network, Wayland + X11 fallback,
  PulseAudio, DRI for GPU, `--filesystem=xdg-{data,config,state,cache}/endo:create`,
  reserved `--talk-name` for Notifications + secrets).
  No `--filesystem=home`, no `--filesystem=host`, no `--persist=.`.
- **Launcher**: `launcher.sh` calls `zypak-wrapper` to route Chromium's
  namespace-sandbox calls through Flatpak's `bwrap`; replaces the
  `chmod 4755 chrome-sandbox` story entirely.
- **Companion files**: `org.endojs.Familiar.desktop` (XDG entry) and
  `org.endojs.Familiar.metainfo.xml` (AppStream metadata; ready
  for Flathub review when the project pursues listing).
- **Build script**: `packages/familiar/scripts/flatpak-build.mjs` runs
  after the existing `package-app.mjs`, stages the packaged app +
  companion files + icons, calls `flatpak-builder --repo` then
  `flatpak build-bundle` to emit
  `out/make/Familiar-<version>-linux-x64.flatpak`.
- **CI integration**: grafts onto `familiar-release.yml`'s Linux `make`
  job (install Flathub remote, install runtime + SDK + base, run
  `yarn workspace @endo/familiar step:flatpak`, upload the bundle
  as a workflow artifact that the `release` job picks up via its
  existing `familiar-*` glob).

## How to test

Local developer host (Ubuntu 24.04 or Fedora 40+):

```sh
sudo apt install flatpak flatpak-builder   # or dnf
flatpak remote-add --if-not-exists --user flathub \
  https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user --noninteractive flathub \
  org.freedesktop.Platform//24.08 \
  org.freedesktop.Sdk//24.08 \
  org.electronjs.Electron2.BaseApp//24.08

cd packages/familiar
yarn build:app
yarn step:flatpak

flatpak install --user --bundle \
  out/make/Familiar-0.1.0-linux-x64.flatpak
flatpak run org.endojs.Familiar
```

Smoke: chat window opens, LLM-provider form rendered, daemon binds
captp socket under sandboxed `$XDG_STATE_HOME/endo/`
(`~/.var/app/org.endojs.Familiar/state/endo/`), round-trip message
to `lal` works.

CI validation gates (built into the design's testing section):
`flatpak-builder --user --install --force-clean ...`,
`appstreamcli validate org.endojs.Familiar.metainfo.xml`,
`desktop-file-validate org.endojs.Familiar.desktop`.

## Deferrals captured in the design

- **Other Linux formats**: Snap, `.deb`, `.rpm`, AppImage, `.tar.gz`
  out of scope per the maintainer's 2026-05-19 G4 resolution. The
  existing `.zip` output stays for the unsigned-download case.
- **Signing**: a Flatpak GPG signing key, signed-bundle workflow,
  and Flathub listing are a separate followup (parallels
  `familiar-release.md` G2 / G3 admin work).
- **Auto-update via Flatpak channel**: tracked by `familiar-release.md`
  G6 (auto-update deferred entirely).
- **arm64 matrix entry**: the manifest is arch-agnostic; the
  `org.electronjs.Electron2.BaseApp` ships aarch64. The CI matrix
  add is a one-liner when the maintainer turns it on.

## Pre-push gate

Ran `garden/skills/pre-push-gates/pre-push-gates.sh --probes-only
--summary`. Walked each probe individually against my new file
(`designs/familiar-flatpak-pipeline.md`); all seven probes pass
cleanly on the new file.

The aggregate gate run reports failures, but every finding is
pre-existing repo state (no-inline-import-jsdoc and
no-pull-citations falling back to `origin/master` scan because my
diff intersects no `packages/**` paths; sentence-per-line-md
flagging lines in `designs/README.md` that I touched only in the
single Totals line, where the existing prose shape was preserved).
None are introduced by this change. The `yarn format` and `yarn
typecheck` stages were skipped because `node_modules` is not
installed in the detached worktree (the changes are markdown-only,
so format / lint cannot affect them meaningfully).

Three iterative passes on the new file's sentence-per-line shape
addressed every multi-sentence-line finding the probe surfaced
on my prose: the numbered Status quo list became unordered,
multi-sentence paragraphs were re-split, the Design Decisions
list went from numbered to unordered with first-sentence-on-its-own-line,
the Known Gaps and TODOs items got their second sentences
broken out, and the verbatim prompt quote moved from a blockquote
into a fenced block (probe ignores fenced content).

## Self-improvement

The seven pre-push-gate probes that fall back to scanning against
`origin/master` when the staged diff doesn't intersect their glob
(`no-inline-import-jsdoc`, `no-pull-citations`, also
`sentence-per-line-md`'s fallback path) produce a noisy report on
any diff that touches only docs / designs. The probes were
designed for `packages/**/*.{js,md}`-touching diffs where the
fallback is moot. A docs-only diff invokes the fallback's full
walk and surfaces every pre-existing finding in the repo's
packages, which buries the diff-attributable findings.

The fix is one of: (a) probes that scope to only the changed
paths from the cached diff (and skip entirely when the cached
diff is empty for their glob), (b) a `--scope=staged-only` flag
on the gate that disables the fallback for all probes
simultaneously, or (c) a calling-role convention to always stage
before invoking the gate so the staged-diff path is non-empty
even when its glob has no matches. Option (a) is the most
defensive: the probe's contract is "check the changes the role
is about to push", which the fallback violates by silently
expanding to "the whole branch vs master". This is a
gardener-routable lesson on the pre-push-gates skill author; the
provenance is the failure mode I hit on this dispatch's
docs-only diff. Routing as a `message` to liaison per the
self-improvement skill threshold; the change is a few-line probe
edit but spans seven probe scripts and is the kind of cross-cutting
adjustment the skill author should land in one pass.
