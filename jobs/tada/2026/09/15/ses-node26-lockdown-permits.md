The build deliverable is complete and verified. PR author is the bot, PR is draft — `auto-gauntlet-handoff.sh` will extract the reported URL and post the gauntlet job. Here is my completion report.

---

## Completion report — `ses-node26-lockdown-permits`

**PR: https://github.com/endojs/endo-but-for-bots/pull/1281** (draft, author `kriscendobot`, base `master-f183efb`, head `fix/ses-node26-lockdown-permits`)

### What I did

**Step 1 — reproduce (Node 26).** Installed Node **26.8.2** (verified released 2026-09-09; downloaded from nodejs.org since no `n`/`nvm` was on PATH and `/tmp` is noexec, so extracted under `scratch`). Cloned **`endojs/endo` upstream `master`** fresh (`f183efbdd138`), resolved SES's three zero-dep workspace deps, and ran `lockdown()` importing the `packages/ses` source directly. Captured ground truth:

```
SES Removing unpermitted intrinsics
  Removing intrinsics.%InitialURL%.createObjectURL.prototype
  Tolerating undeletable intrinsics.%InitialURL%.createObjectURL.prototype === undefined
  Removing intrinsics.%InitialURL%.revokeObjectURL.prototype
  Tolerating undeletable intrinsics.%InitialURL%.revokeObjectURL.prototype === undefined
  Removing intrinsics.%URLSearchParamsIteratorPrototype%.RegisteredSymbol(nodejs.util.inspect.custom)
  Removing intrinsics.%URLSearchParamsPrototype%.RegisteredSymbol(nodejs.util.inspect.custom)
  Removing intrinsics.%URLPrototype%.RegisteredSymbol(nodejs.util.inspect.custom)
```

**Finding worth flagging:** this report is **identical on Node 22.23.2, 24.20.0, and 26.8.2** — it is *not* new in Node 26. The job's premise (a new major adds intrinsics ahead of `permits.js`) didn't hold here; these intrinsics have been present on every tested major, and `permits.js` (even after the recent `%InitialURL%`/`%SharedURL%` URL split already on master) simply never covered them. So the fix silences noise on every currently-tested Node, not just 26.

**Step 2 — adapt `permits.js` (audited, not blanket).** Two distinct causes:
- **`createObjectURL`/`revokeObjectURL` `.prototype`** (the `Removing`+`Tolerating` pairs): V8 implements these blob-registry statics as ordinary functions, so each has a `writable: true, configurable: false` (undeletable) `.prototype` whose only own property is `constructor`. Setting `false` would silence "Removing" but **not** "Tolerating undeletable" (that fires regardless of `known` on the undeletable-function-prototype path). So I added a new `fnWithUndeletablePrototype` permit that *keeps* the prototype as a hardened empty object with `constructor: false`, so the whitelist pass never attempts the impossible delete.
- **`Symbol(nodejs.util.inspect.custom)`** on `%URLPrototype%`, `%URLSearchParamsPrototype%`, `%URLSearchParamsIteratorPrototype%` (the three `Removing` symbol lines): a registered symbol (`Symbol.for('nodejs.util.inspect.custom')`), a non-standard Node display hook. Added `'RegisteredSymbol(nodejs.util.inspect.custom)': false` to each — the exact treatment already used for `TextEncoder`/`TextDecoder`.

After (Node 22 / 24 / 26): report completely silent, `lockdown()` completes with no errors thrown.

**Step 3 — PR.** Based on fresh upstream `master` (`f183efbd`), pushed a frozen base `master-f183efb` and head to `endojs/endo-but-for-bots`, opened draft PR **#1281** via `ensure-pr.sh` (with the `garden-job` marker + changeset). No push to `endojs/endo` (that's a ferry, out of scope).

### Verification (real execution)
- **Silence:** noisy → silent on Node 26.8.2, 24.20.0, 22.23.2.
- **Full `ses` ava suite:** `553 passed, 2 known failures, 2 skipped` under **both Node 26.8.2 and Node 22.23.2** (identical to baseline), including `test/error/permit-removal-warnings-node.test.js` (the dedicated removal-report test — still green; it asserts injected lines are *present*, so silencing the URL lines is compatible).
- **eslint** on `src/permits.js`: clean.
- **Functional smoke (post-lockdown, Node 26):** `new URL(...)` parses, `URL.createObjectURL` stays callable, its `.prototype` is a frozen empty object, and the inspect symbol is gone from `URL.prototype`.

### Changed files (commit `96c0012a5`, exactly 2 files)
- `packages/ses/src/permits.js` (+38/−3): new `fnWithUndeletablePrototype`; two blob statics repointed to it; three `inspect.custom: false` entries.
- `.changeset/silent-url-blob-permits.md`: `ses` patch.

(Diff kept ASCII — endo comments carry no em dashes; converted the two I'd introduced.)

### Follow-ups / notes
- **Gauntlet:** handled by the build-handoff invariant — `auto-gauntlet-handoff.sh` will read this report's PR URL and post the `ses-node26-lockdown-permits-gauntlet` job; CI (Node 22.x/24.x matrix) runs on the fork PR. I did not run `garden-pr.sh` myself (correct per the builder handoff model).
- **Local toolchain note (not a code defect):** `pre-push-gates.sh`'s `yarn format`/`yarn lint:fix` failed locally because I installed deps with `YARN_NODE_LINKER=node-modules` (the repo uses yarn's pnpm linker) — `@changesets/cli` wasn't in the pnpm map. The direct `eslint`/`ava`/`tsc`-independent checks all passed; the authoritative CI uses the proper install.
- **Upstreamability:** the change is version-agnostic and based on real upstream `master`, so it's clean to ferry to `endojs/endo` later if approved.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ses-node26-lockdown-permits.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 162 tokens (7678906 cached reads)
- Output: 64041 tokens
- Cost: $6.868618999999999
- Wall-clock: 1047s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
