---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T00:16:03Z -->

---
model: opus
---
# Stage 7 child 2/7: intrinsics-ledger residuals (Reflect, typed-array-from-iterable, symbol-keyed defineProperty, class-instance construction)

PR `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (DRAFT — keep DRAFT). Stage 7 is the
engine boot-surface/intrinsics stage (supervisor decision, stage-6 acceptance PR #600
issuecomment-4997552045). Child 1 (live `globalThis`) precedes you serially — sync to the real
remote tip and READ what it actually shipped before designing yours.

## The work

The post-stage-4 review ledger's engine-intrinsics residuals, each blocking SES/boot-shim code
paths (the ses-boot bundles and the SES shim exercise exactly these):
1. **`Reflect`** — the namespace object with the members the SES shim and boot bundles use
   (at minimum `defineProperty`, `getOwnPropertyDescriptor`, `ownKeys`, `apply`, `construct`,
   `getPrototypeOf`/`setPrototypeOf`, `has`, `get`, `set`, `deleteProperty`); grep the
   `packages/ses` sources and the daemon boot bundle designs for the actually-consumed set and
   prioritize that.
2. **Typed-array-from-iterable** construction (`new Uint8Array([...])` and iterable sources).
3. **Symbol-keyed `Object.defineProperty`** (and symbol keys through the property-op surface
   where they currently miss).
4. **Class-instance construction** residuals — `new` on class constructors with the semantics
   test262 exercises intra-crank (the cross-crank `new f()` limitation is a KNOWN Pending
   side-table row, out of scope here; do not claim it).
Scope honestly: these four in priority order; if one cannot land green in budget, deliver the
ones that do plus a precise gap note.

## Verification

- Dual-run result-agreement tests for each landed item (oracle certifies results; computrons
  advisory per the accuracy-over-parity doctrine; meter costs via endor's own frozen table and
  its version-bump discipline).
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → EXIT=0, all `test result:`
  lines 0 failed (file + `$?`).
- `./target/debug/compile-diff` (curated) → EXIT=0, 1711/1711 + SYMB 1711/1711.
- Targeted endor-xst on the touched surfaces (e.g. `built-ins/Reflect`,
  `built-ins/TypedArray`, `built-ins/Object`, `language/statements/class`): 0 failed,
  coverage may only grow, skips stay named.
- `#![forbid(unsafe_code)]` intact.

## Practical

- Isolated checkout: `/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base>
  endojs/endo-but-for-bots xs2rust-endor`; sync to the real remote tip FIRST; verify pushes by
  git exit code; explicit pathspecs; `origin HEAD:xs2rust-endor` rebase-CAS.
- Workspace `rust/engine`, NOT the repo root. `cargo` at `$HOME/.cargo/bin`.
- Oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1); NEVER `git add`
  c/moddable. Prebuilt binaries run directly WITHOUT `--`.
- Capture test runs to files, check `$?`; `/tmp` is noexec; use `$HOME/tmp` for TMPDIR.
- Budget: ONE 2400s invocation. Land green increments; honest remainder in tada.
- Report via tada ONLY; never inbox-send the parked supervisor.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 11
  worker_kind: gardener
  claimed_at: 2026-07-17T00:16:08Z
