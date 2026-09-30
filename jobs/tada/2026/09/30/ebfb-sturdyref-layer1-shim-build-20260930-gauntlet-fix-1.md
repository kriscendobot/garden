Fix round 1 for endojs/endo-but-for-bots#774 is done. I applied the panel's three must-fix items, pushed them in one commit, and CI is green after one rerun.

**How much of the verdict I could act on:** the round-1 panel verdict came from a resumed record. Only the breaker seat's findings were kept in full. The other 16 must-fix seats have verdicts but truncated text, so I could not act on them. That includes changeset-auditor, typist, warden and the rest. If panel-2 still flags them, running it fresh (`GARDEN_PANEL_RESUME=0`) will recover their full text.

**Changes** (commit `12050148bd`, pushed with `safe-push-pr-head.sh`, head moved from `ef4662f04b` to `12050148bd`):
- **Foreign `new.target`:** the `SturdyRef` constructor now rejects subclassing and `Reflect.construct` with a foreign `new.target`. A ref that passes the brand check can no longer carry a prototype the caller chose, such as one with a `then`.
- **`WeakMap` methods:** the shim now captures `WeakMap.prototype.get`, `set` and `has` when the module loads and calls them via `apply`. Tampering with `WeakMap.prototype` before `lockdown` can no longer leak a ref's handler or fake the brand. I removed the false "owns its method" comments. Each map entry is now also frozen.
- **Adopted global:** `selectSturdyRef` now locks an adopted `globalThis.SturdyRef` (non-writable, non-configurable) if it was still configurable or writable, so later code cannot redefine it and have another importer adopt a different constructor.
- **README:** documents the subclassing rejection, the `WeakMap` capture and who is trusted, and the locking on adoption. It also adds the breaker's comment-only point that first-wins trusts whoever installs first.
- **Tests:**
  - a foreign `new.target` and a subclass both throw;
  - adoption locks the global, and redefining it afterwards throws;
  - a new `test/sturdyref-tampered-weakmap.test.js`, which runs without lockdown;
  - a pre-lockdown test showing `lockdown` hardens what the shim only froze (another comment-only breaker item).

**Checks:** locally, 25 of 25 sturdyref tests pass, eslint shows 0 errors, and `yarn lint:types` passes.

**CI:** the first run was red on one job, `test (22.x, ubuntu-latest)`. The failure was in `@endo/cli`'s `test/endo.test.js`: an unhandled "Termination requested" rejection while the daemon was shutting down. The PR doesn't touch that package, the sturdyref tests passed on that same job, and the other three test jobs were green. It matches the known `@endo/cli` exit-leak flake, so I reran the failed job once and all 33 checks passed. Across the reruns, the wait went past the 3600s deadline.

**Follow-ups:**
- Panel-2 (the driver re-posts it) should run fresh so the truncated seats' findings can be fixed.
- The changeset text doesn't mention that subclassing is now rejected; changeset-auditor may raise that.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2888462 cached reads)
- Output: 15174 tokens
- Cost: $1.6654444000000006
- Wall-clock: 4692s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
