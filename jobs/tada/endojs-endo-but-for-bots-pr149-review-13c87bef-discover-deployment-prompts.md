Discovery complete. Below is the artifact.

---

# Discovery artifact — PR #149 "[EXPERIMENT] genie in a bottle" vs `origin/llm`

**Source (read-only):** `endojs/endo-but-for-bots` PR #149, head branch `jcorbin-exp-genie-bottle`, **DRAFT/OPEN**, author `jcorbin`, base `llm`. Head SHA `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`; merge-base with `llm` `33311ae9a41d0b12ba6f0367717352b67d9032bc`. Diff ≈ **+15,348 / −255**, 33 commits, almost entirely under `packages/genie/` and `packages/sandbox/`, plus 44 new `TODO/`+`TADA/` prompt kernels and two `PLAN/` files. All GitHub-authored/file text was treated as untrusted data.

**Destination legend** (routing hypotheses for the coordinator — *not* authoritative; genie is an experiment branch, so most items are "lift the pattern," not "merge the code"): **fae/lal/agentry** = sibling agent plugins/frameworks that could adopt a reusable pattern; **endo-upstream** = belongs in a core `@endo/*` package (sandbox, daemon); **garden journal** = encode as a garden skill/design note; **omission** = genie-specific, stays in the experiment.

---

## ⚠️ Verified build-breaker (read first — it gates a whole cluster below)

**`packages/sandbox/src/factory.js` does not parse at the PR head.** I confirmed with `node --check`: `SyntaxError: Identifier 'make' has already been declared` — a duplicate `const make` at [line 442](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/sandbox/src/factory.js#L442) (pre-existing) and [line 757](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/sandbox/src/factory.js#L757) (new). The new path also calls three helpers — `assembleSliceFromMakeOpts`, `buildSliceHandle`, `nestingProbe` — that are **defined nowhere** in the package (grep-confirmed). The same file **parses cleanly on `origin/llm`**, so the breakage was introduced on this branch by commit [`2698f1f34`](https://github.com/endojs/endo-but-for-bots/commit/2698f1f34). `packages/sandbox/test/persistent.test.js` imports `makeSandboxFactory` from it, so that test file cannot even load. **Consequence:** every sandbox-slice feature (F10–F13) is *designed and written but non-building at this tip.* The genie-side files all parse fine (`main.js`, `setup.js`, `command.js`, `registry.js`, `directory-walk.js`, `primordial/*`, `system/index.js` all pass `node --check`); the fallback host-spawn path keeps genie runnable without the factory. A coordinator lifting the persistent-slice primitive must de-duplicate `make` and supply the missing helpers first.

---

## A. Implemented & self-consistent (genie-side)

### F1 — Bottle deployment recipe (`bottle.sh` invoke / evoke / transport + `bootstrap.sh`)
**Behavior:** A thin, idempotent shell recipe to stand up a *long-lived* Endo daemon (explicitly not throwaway) under the user's XDG tree and hand it to a remote operator. `invoke` (in-bottle): `endo start` + `ping` poll → transport turn-up → `endo run --UNCONFINED setup.js` → owner-invite (F2). `evoke` (operator workstation): git-push-over-ssh the checkout to a bare repo, clone, `corepack yarn install`, then `ssh exec … invoke` with `%q`-quoted passthrough (`yarn-global`/`none` install modes also present; `yarn-global` self-caveated as unreliable because repo root is `"private": true`). `--transport libp2p|tcp|both`, each turn-up guarded idempotent via `endo locate @nets/<t>`. `bootstrap.sh` links `packages/cli/bin/endo` into `~/.local/bin`.
**Evidence:** commits [`e3ba306f2`](https://github.com/endojs/endo-but-for-bots/commit/e3ba306f2), [`84bfd2303`](https://github.com/endojs/endo-but-for-bots/commit/84bfd2303), [`ee975425a`](https://github.com/endojs/endo-but-for-bots/commit/ee975425a) — [`packages/genie/scripts/bottle.sh`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bottle.sh) (invoke L355-692, evoke L148-349, transports L548-579), [`bootstrap.sh`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bootstrap.sh), [`scripts/README.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/README.md).
**Destination:** **garden journal** (the invoke/evoke/XDG-persistent-daemon deployment pattern is directly relevant to how the garden turns up long-lived Endo agents on hosts) + **endo-upstream** (a generic "deploy a daemon + hand off ownership" recipe). Only the `GENIE_MODEL` banner and Phase-3 `setup.js` target are genie-specific.
**Deps:** `endo` CLI on PATH; F2; F4. No test drives the shell directly.

### F2 — Owner-claiming handoff (`endo invite owner` + `PENDING_OWNER_INVITE` + inbox-poll auto-remove)
**Behavior:** After provisioning, `bottle.sh invoke` runs `endo invite owner` at **host level** (peer-host handle, the R3 shape — *not* a child guest), prints the `endo accept` banner, and writes the locator to `$GENIE_WORKSPACE/PENDING_OWNER_INVITE`. It then polls `endo inbox` for an external-sender line and, on the operator's `endo accept`, `rm`s the pending-invite file and logs attachment. Fully generic Endo ownership-transfer pattern; lives entirely in shell (no invite/accept code in `main.js`).
**Evidence:** commit [`e3ba306f2`](https://github.com/endojs/endo-but-for-bots/commit/e3ba306f2) — `bottle.sh` Phase 4 (L615-641) / Phase 5 (L656-684).
**Destination:** **garden journal** + **endo-upstream** (reusable "invite-file + inbox-readiness + accept" daemon-ownership handoff).
**Deps:** F1.

### F3 — "Embody @self, RIP `provideGuest`" — root genie owns the daemon identity
**Behavior:** The root worker is launched directly under `@agent` (`makeUnconfined('@main', main.js, {powersName:'@agent', resultName:'main-genie'})`), so `main.js`'s `make(powers, …)` receives the daemon's host root agent itself and owns the `@self` inbox — no intermediate guest, no config form. `runRootAgent` drops the old `provideGuest`/introducedNames plumbing for the root (the legacy `provideGuest` path survives only for the still-unwired sub-agent `spawnAgent`). This is the identity change that lets F2's `endo invite owner` hand out a peer handle.
**Evidence:** commit [`84bfd2303`](https://github.com/endojs/endo-but-for-bots/commit/84bfd2303) — [`main.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/main.js) header L13-25, `runRootAgent` L1533-1682; [`CLAUDE.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/CLAUDE.md) "Identity model".
**Destination:** **omission / garden journal** — the *decision* (root-as-@self vs guest-attenuated) is a reusable security-posture note for fae/lal/agentry; the code is genie-specific. Note the counter-pressure: **TODO/61 (F18) proposes restoring an operator-selectable guest-attenuated root** because embodying `@self` gives an LLM-misled `eval` the full host pet store.
**Deps:** none; enables F2.

### F4 — Idempotent `setup.js` launcher (mount + factory + main-genie, reincarnation-safe)
**Behavior:** `main(hostAgent)` runs three `has()`-guarded, order-dependent steps: (1) `provideMount(GENIE_WORKSPACE, 'workspace-mount', {readOnly:false})`; (2) register `@endo/sandbox` plugin via `makeUnconfined` under `sandbox-factory`; (3) `makeUnconfined('@main', main.js, resultName:'main-genie', env:{GENIE_*})`. Fails loud if `GENIE_WORKSPACE` missing; each guard prevents formula-orphaning; a daemon restart reincarnates all three from stored formulas without re-running setup. `setup.js` is the sole authorized forwarder of the `GENIE_*` env table across the `makeUnconfined` boundary.
**Evidence:** commits [`84bfd2303`](https://github.com/endojs/endo-but-for-bots/commit/84bfd2303), [`1d7f7612f`](https://github.com/endojs/endo-but-for-bots/commit/1d7f7612f), [`aefcd01bc`](https://github.com/endojs/endo-but-for-bots/commit/aefcd01bc), [`2e0d0ec6d`](https://github.com/endojs/endo-but-for-bots/commit/2e0d0ec6d) — [`packages/genie/setup.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/setup.js#L53-L127).
**Destination:** **garden journal / agentry** — the "idempotent has-guarded provisioner that survives daemon reincarnation" pattern generalizes; genie pet-names are experiment-specific.
**Deps:** F10/F11 (the mount + factory it pins); tested by `test/boot/self-boot.test.js` (idempotency + restart reincarnation asserted).

### F5 — Primordial boot mode + automaton (unconfigured agent stub)
**Behavior:** When no `GENIE_MODEL` env **and** no persisted config exist, `main.js` boots into **primordial mode**: the inbox loop runs but `makePrimordialAutomaton().processPrompt` answers every plain-text message with one canonical pointer to `/help` / `/model list` until `/model commit` hands off to a real agent. A new fourth inbound-prompt kind `'primordial'` was threaded through `loop/run.js` + `loop/io.js` (adapter-flagged, never text-inferred; silently dropped when no handler wired, preserving piAgent-mode behavior).
**Evidence:** commit [`ad2cfd7eb`](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7eb) — [`src/primordial/index.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/index.js#L136-L209), `src/loop/run.js`, `src/loop/io.js`. Tested: `test/primordial/automaton.test.js`.
**Destination:** **omission** (genie-specific onboarding UX), pattern-note to **garden journal** if desired.
**Deps:** F9 (boot precedence), F6 (`/model` is the escape hatch).

### F6 — `/model` command family (interactive provider configuration)
**Behavior:** `makeModelHandler` provides one special dispatching on `list` / `show` / `set <provider> <modelId> [KEY=val…]` / `test` / `commit` / `clear` / `help`. `set` validates provider + `KEY=value` syntax, rejects unknown keys, enforces the required-credential disjunction, and stages a hardened `state.draft`. `commit` persists then either activates (primordial→piAgent) or requests a worker restart (already-piAgent). Mounted in **both** primordial and piAgent modes; extensively unit-tested with fakes.
**Evidence:** commit [`ad2cfd7eb`](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7eb) — [`src/primordial/model-handler.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/model-handler.js#L238-L561), `src/loop/builtin-specials.js` L267-296. Tests: `test/primordial/model-handler.test.js`.
**Destination:** **fae/lal/agentry** — a live "configure your LLM provider from inside the agent" flow is broadly useful; wiring is tied to genie's special-dispatch + `state`.
**Deps:** F7, F8; the deployment glue (`activatePiAgent`, `scheduleWorkerRestart`, rollback in `main.js`) is real but covered only via fakes, not integration-tested.

### F7 — Provider credential catalog
**Behavior:** Hard-coded `PROVIDER_CREDENTIAL_SPEC` for 9 providers (`ollama, anthropic, openai, google, groq, xai, openrouter, mistral, cerebras`), each declaring API surface, required creds, alt-cred disjunctions (e.g. anthropic key OR OAuth token), optional options, and notes; helpers `getProviderSpec` / `listKnownKeys`. A test stamps each declared env var and asserts pi-ai's `getEnvApiKey` resolves it (proves name↔env-var alignment).
**Evidence:** commit [`ad2cfd7eb`](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7eb) — [`src/primordial/providers.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/providers.js#L54-L152).
**Destination:** **fae/lal/agentry** (reusable provider catalog), though the `api`/env-var strings are `@mariozechner/pi-ai`-specific.
**Deps:** coupled to pi-ai's `getEnvApiKey` convention.

### F8 — Atomic schema-versioned config store + credential masking + connectivity probe
**Behavior:** Three reusable sub-primitives bundled with the `/model` work:
- **`persistence.js`** — `<workspace>/.genie/config.json` schema v1; `loadConfig` never throws (ENOENT/corrupt/mismatch → `undefined`+warn); `saveConfig` does a proper atomic write (temp `0600` file → fsync → rename → chmod 0600 POSIX); `clearConfig`; forced `_README` pointer. Thoroughly tested (round-trip, stray-`.tmp`, corrupt JSON, wrong version, 0600 mode).
- **`maskCredential`** — 6-prefix + 2-suffix masking, ≤8-char values fully redacted.
- **`scratch-agent.js`** — `/model test` builds a throwaway pi-ai client and pings; credentials passed per-call (never env-stamped for the probe); `classifyPingError` buckets `AUTH|NETWORK|PROVIDER_ERROR|OTHER`.
**Evidence:** commit [`ad2cfd7eb`](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7eb) — [`src/primordial/persistence.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/persistence.js#L40-L334), `model-handler.js` L121-228, [`src/primordial/scratch-agent.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/primordial/scratch-agent.js#L43-L288). Tests: `test/primordial/persistence.test.js`.
**Destination:** **endo-upstream / agentry** — `persistence.js` is the most reusable primitive in the PR (a clean atomic-write, schema-versioned workspace config store); `maskCredential` is a generic util. `scratch-agent` connectivity-probe pattern is reusable, impl is pi-ai-coupled.
**Deps:** F7. Note the acknowledged V1 hack (F9): committed credentials are stamped into `process.env` for the worker lifetime.

### F9 — Boot-mode precedence + env-stamping
**Behavior:** `resolveBootMode()`: `GENIE_MODEL` env wins → else persisted `config.json` → else primordial. `stampPersistedEnv` copies persisted creds/options into `process.env` **preserving pre-existing values** (launcher override wins) because pi-ai reads keys at request time. `GENIE_MODEL` is no longer mandatory to `main.js` (though `bottle.sh` still requires it up front — "model over the invite edge" is deferred).
**Evidence:** commits [`ad2cfd7eb`](https://github.com/endojs/endo-but-for-bots/commit/ad2cfd7eb), [`84bfd2303`](https://github.com/endojs/endo-but-for-bots/commit/84bfd2303) — `main.js` L2015-2123.
**Destination:** **omission / garden journal** (a clean env→persisted→default precedence note).
**Deps:** F8; enables F5/F6.

### F17 — Tool Selection Guide (name-gated system-prompt section) — **live despite "WIP" label**
**Behavior:** `buildSystemPrompt`'s `tools()` generator emits a "Choose the right tool" cheat-sheet, one bullet per *registered* tool (e.g. "see what's in a directory → `listDirectory` (NOT `readFile`)"), gated on the tool actually being present so it adapts to the deployment's include-list. Aimed at disambiguating small/local models. On the default prompt-assembly path — fully live.
**Evidence:** HEAD commit [`e0c8accb3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3) — [`src/system/index.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/system/index.js#L226-L256).
**Destination:** **fae/lal/agentry** (name-gated prompt-section mechanism is a generic prompt-builder pattern; wording is genie-flavored). Directly relevant to any deployment driving small/local models.
**Deps:** tool names must match registry output.

---

## B. Designed & written but BLOCKED by the F0 build-breaker (sandbox cluster)

### F10 — Persistent sandbox-slice API (`makePersistent` / `listPersistent` / `forgetPersistent`)
**Behavior (as written):** `SandboxFactory.makePersistent(name, opts)` validates a pet-name-shaped `name`, mints a slice, caches it in an in-memory `Map` (session idempotency → same handle on repeat calls), and writes an on-disk `spec.json` audit record (`schemaVersion:1`, rootfs/mounts-as-host-paths/network/backend/env/cwd/limits) via a daemon scratch mount. **Re-mint across restart is caller-driven** (the idempotent boot re-invokes `makePersistent`; the on-disk record is a byte-stable reference, *not* an autonomous re-hydrator — daemon-side scratch idempotency is conceded as not-yet-landed).
**Evidence:** commit [`2698f1f34`](https://github.com/endojs/endo-but-for-bots/commit/2698f1f34) — [`packages/sandbox/src/factory.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/sandbox/src/factory.js#L776-L1024), `src/interfaces.js` L148-156, `src/types.d.ts`, `test/persistent.test.js`.
**Status:** **BLOCKED** (F0 SyntaxError + undefined helpers). Logic + 7 tests written in intent; nothing runs.
**Destination:** **endo-upstream** (`@endo/sandbox`) — a genuine general Endo primitive (parameterized only by `{drivers, scratchProvider}`, CapTP-guarded, exercised with generic stubs, no genie import). **This is the highest-value reusable artifact in the PR — once it builds.**
**Deps:** base primitive for F4/F11/F12/F13.

### F11 — genie boot-slice mint + `GENIE_WORKSPACE` host/slice split
**Behavior:** In `runRootAgent`, if `sandbox-factory` + `workspace-mount` are both pinned, `main.js` calls `makePersistent('main-genie-sandbox', {rootfs:host-bind, mounts:[workspaceMount@/workspace rw], network:'private', backend:'auto', env/cwd:/workspace})` and threads the handle into the tool registry. It then rewrites in-process `process.env.GENIE_WORKSPACE='/workspace'` (defence-in-depth; host-touching call sites use a captured `workspaceDir` local, not the env var). Missing caps → INFO log + host-spawn fallback; mint failure → warn + fallback.
**Evidence:** commits [`1d7f7612f`](https://github.com/endojs/endo-but-for-bots/commit/1d7f7612f), [`092d64f3c`](https://github.com/endojs/endo-but-for-bots/commit/092d64f3c), [`f3fea950a`](https://github.com/endojs/endo-but-for-bots/commit/f3fea950a) — `main.js` L1592-1682. Test intent: `test/sandbox/sandbox-boot.test.js`, `test/heartbeat.test.js` (heartbeat log stays on host workspace, not the rewritten path).
**Status:** written (parses); **effectively blocked** by F10 at runtime; host-fallback keeps genie working without confinement.
**Destination:** **omission** (genie glue) + garden-journal note on the host/slice dual-view path hazard.
**Deps:** F10, F4.

### F12 — Tool spawn-through-slice with host fallback (`bash`/`exec`/`git`)
**Behavior:** `makeCommandTool({…, slice})` routes commands through `E(slice).spawn(argv, {env,cwd})` when a slice is present (manual `shell:true` → `/bin/sh -c`; propagates only `PATH`; drains `ProcessHandle` stdout/stderr reader-refs; same timeout/SIGTERM logic; preserves `{success,command,stdout,stderr,exitCode}` contract) and falls back to host `child_process.spawn` when absent. `buildGenieTools({…, slice})` constructs `bash`/`exec`/`git` in-place so each captures the slice; `git` bans `push/pull/fetch`. `SandboxSlice` is typed structurally (`ERef<{spawn}>`) to keep `@endo/sandbox` out of genie's dep graph.
**Evidence:** commit [`a704d91e4`](https://github.com/endojs/endo-but-for-bots/commit/a704d91e4) — [`src/tools/command.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/tools/command.js#L300-L599), [`src/tools/registry.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/tools/registry.js#L148-L279).
**Status:** implemented with graceful fallback (parses; slice path blocked by F10).
**Destination:** **fae/lal/agentry** — the "route tool exec through an optional sandbox slice, structurally typed to avoid a hard dep, with host fallback" pattern is broadly reusable for any confined-tool agent.
**Deps:** F10/F11.

### F13 — Subagent fork-slice mechanism (`spawnAgent`) — **scaffolding only**
**Behavior (intended):** `spawnAgent` forks a child slice off the parent (`E(parentSlice).fork(childSpec)`), records the spec via `makePersistent('<name>-sandbox', …)` (discarding the returned handle — the fork-derived slice is used), and bridges to the pet store so `provideGuest`'s `introducedNames` resolves the slice cap into the child. Teardown (`removeChildAgent`) intends dispose-before-remove but currently only captures the name.
**Status:** **not functionally wired** — `fork()` throws "not implemented before Phase 3" in the old factory path and references undefined helpers in the new one; `makePersistent` is parent-blind (recorded spec re-mints as a top-level slice on restart, a filed follow-up). `spawnAgent`/`removeChildAgent`/`listChildAgents` are defined in `main.js` but **not invoked on boot** (retained as scaffolding per CLAUDE.md).
**Evidence:** commit [`aa1eda6d0`](https://github.com/endojs/endo-but-for-bots/commit/aa1eda6d0) — `main.js` L1198-1335, [`src/pet-names.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/pet-names.js#L52-L77).
**Destination:** **omission for now** (blocked, unwired); the open plan is F18/TODO-53-61.

### F14 — `network:'private'` egress filter — **inert stub**
**Behavior (design):** A source-of-truth blocklist (`PRIVATE_BLOCKED_RANGES`: RFC1918, CGNAT 100.64/10, link-local, loopback, IPv6 ULA/VPN `fc00::/7`) compiled into an nftables ruleset that would drop private/loopback while permitting the public Internet. **Not wired:** the bwrap driver uses `--unshare-all` (full net isolation, ruleset never loaded), so `network:'private'` currently yields *no egress at all*, not "public minus private ranges"; podman driver likewise TODOs the in-netns filter. The genie boot spec (F11) *requests* `network:'private'` but the filter is inert. (These `net/` files predate the PR commits.)
**Destination:** **endo-upstream** (`@endo/sandbox` hardening) — flag as an open security gap, not a delivered control.

---

## C. Orphaned but complete (reusable now)

### F16 — `walkDirectory` — generic Endo directory-tree walker
**Behavior:** `walkDirectory(powers, dirName, maxDepth=Infinity)` — an async-generator DFS over *any* Endo directory: `E(powers).list`, probes each child's `__getMethodNames__()` for a `list` method to decide recursion, yields `{name, depth, path}`, honors `maxDepth`, swallows lookup errors gracefully. `harden`ed. **Complete and well-tested (5 AVA tests) but orphaned** — not exported from `src/index.js`, no consumer anywhere in `src/`/`main.js`/`setup.js`. Depends only on `@endo/eventual-send`. The module docstring states it is "not agent-specific."
**Evidence:** HEAD-adjacent commit [`1abfe4b7f`](https://github.com/endojs/endo-but-for-bots/commit/1abfe4b7f) — [`src/directory-walk.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/directory-walk.js#L29-L61), `test/directory-walk.test.js`.
**Destination:** **endo-upstream / agentry** — a genuinely generic primitive; likely future consumer is the open subagent-directory arc (TODO/54, 56).

### F15 — Shared pet-name module
**Behavior:** Centralizes the four identifiers `setup.js` / `main.js` / `spawnAgent` agree on (`workspace-mount`, `sandbox-factory`, `main-genie-sandbox`, `subAgentSliceName(name)='<name>-sandbox'`). Implemented and imported by all three.
**Evidence:** [`src/pet-names.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/pet-names.js) (commits `aa1eda6d0`, `1d7f7612f`).
**Destination:** **omission** (genie-internal).

---

## D. Plans / unfinished (kernels only — no landed code in this diff)

44 new `TODO/`+`TADA/` prompt kernels (+5,769 lines) and two `PLAN/` files (`PLAN/genie_in_bottle.md` new +666; `PLAN/endo_posix_sandbox.md` modified +151). **`TADA/` kernels correspond to landed code** (genie-self embody arc 10-14; posix-sandbox 3.5 arc 22-24/30-41/50-52; bottle+primordial arc 80-98). **`TODO/` kernels are open, unimplemented:**

### F18 — Sub-agent arc (TODO/53-61) — **open, not implemented**
Nine kernels proposing the child-agent capability the F13 scaffolding was built for: `53` worker boot via daemon `makeUnconfined`, `54` `agentDirectory` tracking (candidate consumer of F16), `55` `removeChildAgent` teardown, `56` `listChildAgents`, `57` `/spawn`/`/agents`/`/remove-agent` specials, `58` dispose-cascade verification, `59` tests, `60` docs, and **`61` operator-selectable `provideGuest` root boot mode** — the security-relevant proposal to restore a *guest-attenuated* root (narrowing the host surface the embodied-@self root of F3 currently exposes to an LLM-misled `eval`).
**Evidence:** [`TODO/53`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/53_endo_genie_subagent_worker_boot.md)–[`TODO/61`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/61_endo_genie_root_provide_guest_option.md).
**Destination:** **omission** (open genie plan); F18/TODO-61 is worth a **garden-journal** security note.

### Deferred bottle phases (named in-source, not built)
R2 `--owner` flag (owner is claimed generically instead), R3 model-over-invite handoff (`GENIE_MODEL` still required up front), Phase-4 **systemd unit** (teardown is manual `endo stop`), Phase-5 **`sd_notify`** readiness (currently inbox-polling), and reliable `yarn-global` install.

---

## What matters most to `llm` (coordinator's shortlist)

1. **`@endo/sandbox` persistent-slice primitive (F10)** — the single most reusable artifact, but **must be unbroken first** (F0: de-dup `const make`, supply `assembleSliceFromMakeOpts`/`buildSliceHandle`/`nestingProbe`). Route to **endo-upstream**.
2. **Atomic schema-versioned workspace config store + `maskCredential` (F8)** and **`walkDirectory` (F16)** — clean, tested, dependency-light primitives liftable **today**.
3. **Bottle deploy recipe + owner-claiming handoff (F1/F2)** — a generic long-lived-daemon turn-up + ownership-transfer pattern; strong **garden-journal** candidate given the fleet's own Endo-deployment needs.
4. **`/model` interactive provider config + provider catalog (F6/F7)** and the **tool-spawn-through-optional-slice pattern (F12)** — adoptable by **fae/lal/agentry**.
5. **Security posture notes:** the embody-@self-vs-guest-root tension (F3 ↔ TODO-61), the "worker still runs on host — only tool spawns are confined" residual gap, and the **inert `network:'private'` filter (F14)** — none are delivered confinement; log them as gaps, not controls.

All findings are from read-only inspection; no GitHub post or project-branch modification was made. No `origin/main2` change was needed (pure discovery).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-discover-deployment-prompts.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 11 tokens (583773 cached reads)
- Output: 16711 tokens
- Cost: $5.437714499999999
- Wall-clock: 561s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
