---
posted_at: 2026-10-31T21:12:52Z
role: gardener
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1504
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Replace the PR body of endojs/endo-but-for-bots#1504 (pruner + coverage-auditor findings)

Gauntlet fix-1 for https://github.com/endojs/endo-but-for-bots/pull/1504 pushed the code fixes, but the bot PAT on oros-studio cannot edit endojs PRs (HTTP 403). On this host, replace the PR body with the text between the BEGIN/END markers below, verbatim (for example `gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/1504 -F body=@<file>`). It drops the per-package tour, the design-deviation paragraphs, the evidence-ledger table, and the inline test tallies (pruner), updates the prose for the fix-1 semantics, and documents the XS coverage limitation (coverage-auditor). Keep the trailing `garden-job` marker. Do nothing else to the PR.

----- BEGIN BODY -----
Refs: #1497

## Description

This implements Phase 2c, the sandbox shell engine, from `designs/daemon-agent-tools.md` § Next Slice (design PR #1497). A `Shell` provisioned with `engine: 'sandbox'` runs its children inside an `@endo/sandbox` slice. The children see only the shell's mount (at `/work`), read-only host system directories, and no network. The capability surface, tool records, and wire schemas stay the same. The one visible change is that `inspect()` now reports the engine (`'host'`, `'sandbox'`, or `'environment'` for a shell that delegates to an environment runner), so a holder can see how confined its shell is.

```js
const factory = /* the @endo/sandbox plugin's `make` result, already held by the host */;
const shell = await E(host).provideShell(worktree, 'repo-shell', {
  allowedCommands: ['make', 'grep'],
  timeoutMs: 60_000,
  maxOutputBytes: 1_048_576,
  engine: 'sandbox',
  sandbox: factory,
});
await E(shell).inspect(); // { allowedCommands, timeoutMs, maxOutputBytes, engine: 'sandbox' }
```

Output past the cap is truncated and drained under both engines; neither engine kills a child for writing past it.

### Security Considerations

This change narrows authority. Under the host engine, an allowlisted child can read anything the daemon user can read, which is the escape described in § The honest boundary. Under the sandbox engine, the child sees only the shell's mount, read-only `/usr`, `/lib*`, `/bin`, `/sbin`, and `/etc`, a private `/tmp`, its own pid namespace, and no network. The sandbox factory is a capability the host passes in: the daemon never reaches for it ambiently, and `provideShell` rejects an identifier it does not hold. A sandboxed shell never falls back to the host engine: an unusable backend rejects at `provideShell`, a failed `make` fails the incarnation, and a persisted formula naming an unknown engine refuses to reincarnate. Containment failures reported by the slice reach the caller rather than being reported as a signal exit. `/etc` stays readable inside the slice because the existing `host-bind` rootfs binds it.

### Scaling Considerations

Each sandboxed shell incarnation keeps one slice alive, and each `exec` starts one bwrap process tree. The host engine is unchanged.

### Documentation Considerations

The `@endo/host-spawner` and `@endo/exo-shell` READMEs document the sandbox adapter, the `engine` field, and the published conformance table; the changeset `.changeset/shell-sandbox-engine.md` describes the new `provideShell` option. Once #1497 lands, `designs/daemon-agent-tools.md` Phase 2c can be checked off.

### Testing Considerations

The real-bwrap tests in `packages/sandbox/test/shell-engine.test.js` run in the CI `test-sandbox-drivers` job and skip only on bwrap's own namespace-denial diagnostic.

The XS daemon bundle now includes `@endo/host-spawner`'s sandbox adapter, but no XS test executes the daemon bundle: `@endo/daemon` has no `test:xs` target, and the sandbox engine needs a native bwrap slice that the XS supervisor cannot reach. Until one exists, the bundle build in CI covers that the module graph resolves, and the adapter itself is tested under Node.

### Compatibility Considerations

A policy without `engine` means `'host'`, so existing shells and persisted formulas behave as before. `Shell.inspect()` gains an `engine` field, so a `ShellToolCapability` implementation must now return it, and a caller that deep-equals the old three-field record needs updating; the changeset bumps `@endo/agent-tools` to `minor` for this.

### Upgrade Considerations

None. Formulas persisted before this change reconstitute as host-engine shells.

<!-- garden-job: daemon-agent-tools-design-build -->
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T22:17:37Z
