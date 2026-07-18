---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T21:25:06Z -->

---
model: opus
---
# stage10d child 0/5 — FIXER: frozen arrays must actually be immutable (stage-10 review finding F1)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT, no PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `c345aa838` — **sync to the REAL remote tip first**; verify pushes by git EXIT CODE. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.

## The finding (adversarial review of `84d0d9c87`, confirmed at `c345aa838`)

`84d0d9c87` routed `Object.freeze`/`Object.isFrozen` through the ordinary path for arrays by stamping `XS_DONT_PATCH_FLAG`, and guarded **indexed element assignment** (`property_at_set`, interp.rs ~19522). But array elements/length live in the `arrays` side table, not property slots, and two mutation paths ignore the flag:

1. **`arr.length = N`** → `array_set_length` (interp.rs ~6669 and ~19553) has NO frozen guard — it truncates/extends a frozen array.
2. **Mutator methods** — `ArrayPush` (~14381), `ArrayFill` (~14535), and the rest (`pop`/`shift`/`unshift`/`splice`/`sort`/`reverse`/`copyWithin`) — write the side table directly with NO `XS_DONT_PATCH_FLAG` check.

Net effect: `const a=[1,2,3]; Object.freeze(a); a.push(4); a.length=1` — endor reports `isFrozen(a) === true` yet mutates `a`; the C-XS oracle refuses. A silent wrong answer inside the very integrity surface SES `lockdown` freezes. The boot-gate freeze test only froze plain objects, so no gate caught it.

## Definition of done

1. **Oracle-ground every semantic first** (isolated dual-run snippets — the established vehicle): what C-XS does for a frozen array under (a) sloppy `a.length = 1`, (b) strict `a.length = 1`, (c) `a.push(x)` sloppy + strict, (d) each remaining mutator (`pop`/`shift`/`unshift`/`splice`/`sort`/`reverse`/`fill`/`copyWithin`), (e) `Array.prototype.length` interactions on a frozen SPARSE/empty array. Encode exactly what the oracle does (expected per spec: length-write silently ignored in sloppy / TypeError in strict; mutators throw TypeError in both modes when they would write) — but the ORACLE's observed behavior is the bar, not the spec text.
2. `array_set_length` and every array-mutator native honor `XS_DONT_PATCH_FLAG` accordingly. Sort/reverse on a frozen array must not partially mutate before throwing (check the oracle's behavior; guard up front).
3. Promote the boot-gate freeze test to cover a frozen ARRAY: mutator attempts + length write + `isFrozen` readback agree with the oracle (extend `boot_step_ses_freeze_exotic_receivers_agree` or add a sibling).
4. Add corpus cases only if oracle-runnable in the curated harness; otherwise the dual-run snippets in the gate test suffice.
5. Sweep the OTHER freeze-ordinary exotic kinds `84d0d9c87` enabled (errors, RegExps, wrappers, Maps/Sets, ArrayBuffers, DataViews) for the same class of side-table mutation bypass: for each, name the mutation paths that write non-slot state (e.g. `Map.prototype.set` on a frozen Map — note the ORACLE allows internal-slot mutation of frozen collections per spec: freeze does not protect [[MapData]]; verify against the oracle and leave CORRECT behavior alone — the bug class is only where endor DIVERGES from the oracle on a frozen receiver).

## Bars that must stay green (before EVERY push; outputs to files, check `$?`)

Engine workspace (`rust/engine`) `cargo test --workspace --no-fail-fast` EXIT=0, 48 `test result:` lines all `0 failed` (708 passed at cut); `./target/debug/compile-diff` 1909/1909 identical + SYMB 1909/1909, 0 divergent; boot gate ≥28 (test binary's count is canonical); zero new Rust warnings; `#![forbid(unsafe_code)]` intact (7 anchored engine crate roots; `endor-oracle` the audited exempt seam); no new side table without a same-day `sidetable.rs` ledger row (VARIANT_COUNT 35 at cut); `c/moddable` at pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, clean, never staged; no committed bundles. **Doctrine: accuracy-over-parity** — result agreement gates; computrons advisory; never back-fit meters.

## Environment notes

`cargo` at `$HOME/.cargo/bin`; `TMPDIR=$HOME/tmp` (mkdir first; `/tmp` noexec). Seed `rust/engine/target/` by `cp -al` from a same-commit sibling (verify its tip sha); `rmdir` empty `c/moddable` before seeding the pinned checkout in.

## Discipline (BINDING)

- **Push-per-item**: each verified surface (length-write guard, push guard, remaining mutators, gate test) is its own commit, pushed immediately with a CAS rebase loop.
- **STOP-and-checkpoint** at ~1800s-with-nothing-pushed: land the smallest honest verified increment, push, tada with the exact resume point.
- Report via your tada completion report ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-18T21:25:11Z
