---
ts: 2026-05-13T23:38:34Z
kind: result
role: saboteur
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 148
    role: panel-saboteur
refs:
  - entries/2026/05/13/233119Z-message-steward-b4bb7f.md
---

# Saboteur findings on PR #148

Attack target: the PR's central claim "@endo/genie tools cannot escape the @endo/sandbox confinement boundary."
The juror covers the substance gap (the `files` / `memory` / `web` tool groups are by-design daemon-side and never traverse the slice).
My slot covers attack vectors against the boundary as constructed.

Total attack count: 10.
Verdict split: 2 real concern (must-fix), 4 should-fix, 4 mitigated (defensive coverage).

## Real concern (must-fix)

1. **Local-powers Mount.lookup follows symlinks; the daemon counterpart resolves with realPath.**
   `packages/genie/src/sandbox/local-powers.js` line 236-253: `lookup` calls `fs.stat(target)` (symlink-following), accepts a directory result, then constructs a sub-Mount whose `hostPath = join(workspaceRoot, ...segments)` (a textual join).
   Subsequent `list` / `readText` / `writeText` on the sub-Mount call `fs.readdir(hostPath)` / `fs.readFile(hostPath, ...)` etc., which the kernel resolves through the symlink at exec time.
   Daemon `Mount.lookup` (`packages/daemon/src/mount.js` line 217-233) calls `assertConfined` → `filePowers.realPath` before returning the sub-Mount.
   Place `${workspaceDir}/escape -> /etc` and `E(localMount).lookup('escape').list()` returns the `/etc` listing.
   Either harden `assertNoEscape` to call `realPath`, or document `local-powers` as "trusts the operator-supplied tree to contain no hostile symlinks" and pin the divergence with a test.

2. **Local-powers `provideHostPath` accepts sub-Mounts minted by `lookup`.**
   `local-powers.js` line 369 registers every sub-Mount returned from `lookup` into the WeakMap.
   `provideHostPath` resolves any registered cap, so a sub-Mount obtained by `mount.lookup('subdir')` is a valid `MountCap` to pass into `factory.make({ mounts: [{ cap, innerPath }] })`.
   Daemon-side `provideHostPath` (`packages/daemon/src/host.js` line 290-297) explicitly rejects "subdirectory views minted by Mount.lookup() and read-only attenuations".
   The asymmetry weakens the dev-repl's slice-mount surface: callers can mint a `MountCap` for any directory under the workspace and bind-mount it into the slice (composed with finding 1, into any directory anywhere reachable via symlink).

## Should-fix

3. **`__getMethodNames__()` is the only authentication on a pet-name Mount cap.**
   `main.js` line 1125-1144 (workspace) and line 1223-1242 (rootfs) trust `E(cap).__getMethodNames__()` to discriminate Mount caps.
   A remotable that returns `['readText', 'writeText', 'makeDirectory', 'has', 'list']` from `__getMethodNames__` passes validation regardless of actual method behaviour.
   The downstream `factory.make` still rejects via `provideHostPath` (the cap is not in the WeakMap / formula registry), so the bypass is shallow.
   Worth: a structural check is not an authenticity check.
   Pinning the rejection surface in a test would prevent future regressions if a maintainer ever short-circuits the resolution.

4. **`assertNoEscape` permits absolute-path segments.**
   `local-powers.js` line 137-150 only vetoes `..` and `\0`; segments like `'/etc/passwd'` pass.
   `posix.join(hostPath, '/etc/passwd')` evaluates to `${hostPath}/etc/passwd` (POSIX `join` does not reset on leading slash), so the textual escape is safe.
   But on `path.win32` semantics or if any caller swaps to `path.resolve` the absolute-segment promotes.
   Add a `segment.startsWith('/')` veto for defense in depth (and to match the daemon's `assertConfined` semantics).

5. **TOCTOU between `assertRootfsBackendCompatible` and the resolved backend.**
   `spawnAgent` (`main.js` line 1215) calls `assertRootfsBackendCompatible(parsedRootfs, backend)` with the unresolved `'auto'` selector.
   Inside `mintGenieSlice` `'auto'` resolves to `available[0].name` (`slice.js` line 348).
   `rootfs: 'oci:...'` + `backend: 'auto'` passes the form check; if `'auto'` resolves to `bwrap`, the slice-mint fails inside the bwrap driver with a different error string than the form check promised.
   `mintGenieSlice` should re-run the cross-check against the resolved backend before `factory.make`.

6. **`mintGenieSlice` does not harden the inner `env` object.**
   `slice.js` line 314-321 / 362-370 builds `harden({ rootfs, mounts, network, env, cwd, backend })` where `env` is whatever object the caller passed.
   The outer object is hardened; the inner `env` is not.
   A caller passing a Proxy `env` whose getter returns different values per access could differentiate "what `factory.make` saw" from "what the driver wrote into the slice".
   `factory.make` should harden the input on receipt, but defense in depth here is cheap: deep-harden the env at the boundary.

## Mitigated (defensive coverage worth pinning)

7. **Shell injection through LLM-supplied `argv` is contained by the slice.**
   `sandbox-spawner.js` line 141 does `['/bin/sh', '-c', argv.join(' ')]` on `shell: true`.
   An LLM-supplied `args: ['ls', ';', 'rm', '-rf', '/']` runs a shell command in the slice.
   This is by design: the slice is the blast-radius wall.
   Worth a test pinning the wall in place (run `rm -rf /` through the bash tool, assert the slice's `/workspace` survives).

8. **`harden` bypass on `cancelledP`.**
   `slice.js` line 386 calls `cancelledP.then(...)`.
   A non-promise thenable that calls its `onFulfilled` synchronously and re-entrantly during `dispose` could double-fire dispose; the `.catch` swallows but doesn't deduplicate.
   The caller pattern (`makePromiseKit` in `main.js`) is hardened, so the gap is theoretical; pin with an explicit `Promise.resolve(cancelledP)` if the seam is ever opened to caller-supplied thenables.

9. **Pid race on `sandbox-spawner`.**
   `sandbox-spawner.js` line 156-161 awaits `E(procHandle).pid()` after `spawn` returns and falls through to `0` on rejection.
   A `ProcessLike` consumer that uses `proc.pid === 0` as a sentinel may misroute a kill or log a misleading pid.
   Either reject the spawn if `pid()` fails, or document `0` as "pid unknown".

10. **`env: {}` default in `mintGenieSlice` vs. driver-supplied ambient env.**
    `slice.js` line 309 defaults `env = {}` and passes through to `factory.make`.
    Whether bwrap / podman inherit any host env in addition is the plugin's call.
    The PR's tests do not assert "the slice's env is exactly what we passed".
    A regression test that spawns `printenv` inside the slice with `env: { FOO: 'bar' }` and asserts the output set would lock the boundary down.

## Verdict and panel handoff

Real concern (1, 2) is a divergence between the dev-repl path's local-powers and the daemon path's discipline.
The PR's central claim ("tools cannot escape the confinement boundary") rests on the substance gap the juror is covering AND on the dev-repl's local-powers matching the daemon's confinement discipline.
The local-powers diverge on symlink resolution (1) and sub-Mount provenance (2).

The juror should fold these into the panel's must-fix slot when assembling the aggregated verdict.

Self-improvement: the saboteur-adversarial-review pattern catalog has one entry (rootfs-derived env derivation).
A second pattern is emerging from this pass: "in-process cap-registry analogues that mirror a daemon-side privileged operation".
The asymmetry between daemon `provideHostPath` (rejects sub-Mounts) and local-powers `provideHostPath` (accepts sub-Mounts) is the canonical shape.
Worth a catalog entry under "cap-registry symmetry" once a second similar PR surfaces, per the skill's "_2026-05-13_" notes-from-the-field cadence.
