---
ts: 2026-06-03T04:12:17Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
---

Opened endojs/endo-but-for-bots#410 (DRAFT, base `design/gateway-package-phase-9`, head `feat/endo-gateway-cli-systemd`): `feat(cli,gateway): endo gateway start/stop/log + systemd packaging (#343)`.

Implements the maintainer directive on #343's review (2026-06-02 05:06Z) for starting / stopping the gateway daemon at the system level and proposing a systemd install mechanism.

## Coverage

- **CLI subcommands**: landed (`endo gateway start | run | stop | log | where | install-systemd`).
- **State locations**: landed (pure resolver in `@endo/gateway`, system Linux / system macOS / user-XDG / user-darwin / user-tmpdir paths, per-directory env overrides).
- **Systemd unit**: landed (`packages/gateway/systemd/endo-gateway.service`, hardened directives, `User=endo`).
- **launchd plist**: landed (`packages/gateway/systemd/com.endojs.endo-gateway.plist`).
- **Documentation**: landed (`packages/gateway/docs/system-service.md`, per-platform install procedure, security considerations, CLI reference).
- **Tests**: 19 gateway resolver tests + 9 CLI smoke tests, regression-evidence verified.
- **Changeset**: landed (`.changeset/endo-gateway-cli-systemd.md`, minor for `@endo/cli` and `@endo/gateway`).
- **Deferred**: HTTP listener wiring (not in scope per design's phase-9 status), `.deb`/`.rpm`/PKGBUILD/Dockerfile (design's Feature 10 future work), Windows Service.

## Commits (5)

- `feat(gateway): host-scope runtime-path resolver (#343)` — runtime-paths.js + types + tests + exports.
- `feat(gateway): runnable daemon entry script plus systemd / launchd packaging (#343)` — gateway-node.js, systemd unit, launchd plist, docs/system-service.md, README update.
- `feat(cli): endo gateway start / stop / log / where / install-systemd (#343)` — commands/gateway.js, gateway-paths.js, endo.js wiring, smoke tests.
- `chore: changeset for endo gateway CLI + systemd (#343)`.
- `chore: Update yarn.lock`.

## Test runner output

- `packages/gateway`: 416 tests passed (19 new in `runtime-paths.test.js`).
- `packages/cli`: 23 tests passed (9 new in `gateway-command.test.js`).
- `yarn lint` clean on both packages (only pre-existing JSDoc warnings).
- `yarn lint:types` clean on both packages.

## Self-improvement

Lesson: when a new package's `types` field points at a hand-written `types.d.ts` that only re-exports types (`export type *`), TypeScript consumers will not see the package's runtime exports through that overlay. The `@endo/gateway` package's `types.d.ts` had this shape: it re-exported types from `src/types.d.ts` but did not restate the runtime declarations from `index.js`. The first external TS consumer (the new `@endo/cli` import of `detectServiceMode` / `resolveGatewayPaths`) hit "no exported member" errors from tsc despite the runtime exports being correct. I worked around it locally by adding `export declare` shapes to `types.d.ts` for the new functions, but the broader question is whether the gateway package should ship an `index.d.ts` generated from `index.js`'s JSDoc (which would be the canonical fix, removing the maintenance burden of restating signatures by hand). This is a self-imposed pitfall that will trip the next consumer of any of the gateway's twenty-plus runtime exports unless someone lands a generated `index.d.ts`.

Self-improvement: surfaced gateway-package-types-d-ts-incomplete pitfall; the right fix is generating `index.d.ts` from JSDoc rather than continuing to hand-write the runtime-export shapes in `types.d.ts`.
