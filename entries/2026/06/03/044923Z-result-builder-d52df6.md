---
ts: 2026-06-03T04:49:23Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/builder--bc8cef
---

DRAFT PR endojs/endo-but-for-bots#412 opened: gateway distribution packaging recipes (#343 Feature 10 continuation).

Branched off `design/gateway-package-phase-10` (4d5cfc5b1); base for PR is `design/gateway-package-phase-10` (sibling to PR #410's `feat/endo-gateway-cli-systemd`, not stacked).
Head branch: `feat/endo-gateway-distribution`.

URL: https://github.com/endojs/endo-but-for-bots/pull/412

## Files landed

All under `packages/gateway/packaging/` plus one cross-platform doc and changeset:

- `debian/`: full Debian source-package layout (`control`, `changelog`, `compat`, `copyright`, `rules`, `postinst`, `postrm`, `endo-gateway.install`, `endo-gateway.service` pointer, `source/format`) plus `endo-gateway.default` operator override.
- `rpm/endo-gateway.spec`: Fedora/RHEL/openSUSE spec with `%pre` / `%post` / `%preun` / `%postun_with_restart` macros.
- `arch/PKGBUILD` + `endo-gateway.install`: Arch recipe with EnvironmentFile rewrite hook (Debian convention -> Arch convention).
- `docker/Dockerfile` + `.dockerignore`: multi-stage `node:22-bookworm-slim` image running as `endo:endo` (uid 1001), EXPOSE 3469.
- `brew/endo-gateway.rb`: Homebrew formula targeting the developer-machine LaunchAgent shape.
- Plus per-directory `README.md` for each recipe.
- `packages/gateway/docs/packaging.md`: cross-platform upgrade-workflow reference.
- `.changeset/endo-gateway-distribution-recipes.md`: `@endo/gateway` minor bump.
- `packages/gateway/package.json`: adds `packaging` to the `files` array.

## Commits

Six conventional-commit commits, one per recipe and one for the docs:

```
b5abc6ec9 docs(gateway): cross-platform packaging upgrade workflow (#343)
5f6477246 chore(gateway): add Homebrew formula dist template (#343)
ba142330a chore(gateway): add Dockerfile dist template (#343)
e537b948b chore(gateway): add Arch PKGBUILD dist template (#343)
62e1eb837 chore(gateway): add Fedora/RHEL/openSUSE .rpm dist template (#343)
2371d4e3f chore(gateway): add Debian/Ubuntu .deb dist template (#343)
```

## Recipes landed vs deferred

All five recipes named in the dispatch landed: `.deb`, `.rpm`, Arch, Docker, Homebrew. Nothing was deferred to follow-up.

## Choices that warrant maintainer confirmation

- **Directory name `packaging/` instead of `dist/`.** The dispatch named `dist/` but the repo's root `.gitignore` excludes `dist/`. I switched to `packaging/` so the recipes are tracked. The design doc at `designs/gateway-package.md` § Feature 10 itself names `packaging/{deb,rpm,arch,docker}/` so the rename aligns with the design's own framing.
- **README cross-link revert.** I initially added a one-paragraph cross-link to the new `packaging.md` / `packaging/` directory inside `packages/gateway/README.md`'s deferred-list, then reverted it when the `sentence-per-line-md` probe flagged pre-existing list items (lines 7-10) in the unchanged portion of that README. The cross-link survives via the changeset + the doc itself. A reviewer who wants the README pointer can land it as a one-line follow-up after fixing the pre-existing prose drift.
- **Homebrew sha256 placeholder.** The formula carries `sha256 "SKIP"`; the release workflow at tag time computes the real digest. `brew audit --new-formula` rejects `SKIP` so publishing in this state is impossible by accident.
- **No SELinux / AppArmor module.** The RPM README documents this as out-of-scope, downstream-packager work.

## Pre-push gates

Ran `pre-push-gates.sh --probes-only` after setting upstream to `origin/design/gateway-package-phase-10`:

- `filename-no-stutter`: pass
- `no-ascii-banners`: pass
- `no-inline-import-jsdoc`: pass
- `no-pull-citations`: pass
- `sentence-per-line-md`: pass (after rewriting my new docs to one sentence per line)
- `test-package-no-main`: pass
- `security-md-hash-uniform`: **fail (pre-existing repo state)**. The probe scans every `packages/*/SECURITY.md` whole-repo; the divergent / missing files are pre-existing, not introduced by this PR. My PR does not touch any SECURITY.md.

Also ran `yarn lint`, `yarn format`, `yarn lint:types` against the gateway package: 0 errors, no format changes, typecheck clean.

## Carry-forward

- Uint8Array byte-transmission convention (#393): no JS in this PR.
- Per-PR commit hygiene: six clean conventional commits.
- Standing relaxation on `endojs/endo-but-for-bots`: applies; PR is on the bot fork.

Self-improvement: the `pre-push-gates` `sentence-per-line-md` probe's awk skips lines starting with `[-*+]` (bullet list items) but not `[0-9]+\.` (ordered list items), so numbered lists in new markdown files flag every line. I worked around it by converting my list to bullets, but the right fix is to extend the probe's exempt-prefix regex to cover numbered lists. Below the gardener-discoverable threshold; flagging as a probe weakness only.
