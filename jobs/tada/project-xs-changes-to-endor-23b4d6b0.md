The follow-up plan landed on `origin/journal2` (`jobs/plan/port-endor-oracle-bump-8-3-1.md`, commit `9ef95bbef`). Inbox is empty. Everything is complete.

---

## Completion report

**Job:** Project engine-relevant XS/Moddable 8.0.1→8.3.1 upstream changes onto the oracle-locked Rust port (`endojs/endo-but-for-bots`, branch `xs2rust-endor`, `rust/engine`).

**Key finding that reframed the job:** the port is not measured against endo's vendored 8.0.1 (`5516726818`). Its differential/byte-identity **oracle is `c/moddable` @ `48ee02d8cfe0` = moddable 8.2.3** (2026-06-17). So the port already inherits every engine-semantics change through 8.2.3 for free, and "mirroring" a *post*-8.2.3 change means bumping the oracle first — implementing 8.3.1 behavior against the 8.2.3 oracle would break the bar. I fetched moddable `public` (HEAD `23b4d6b0` = 8.3.1) and classified each named commit against the 8.2.3 oracle line.

**Per-item verdict (all cited by sha + file in the port README):**
- **Item 4** (`transfer*` drop `@@species`; `36aa1485a4`,`eff30ae5ba`) — **in-oracle; no action.** `transfer` is a named skip today (no species lookup to be wrong); auto-inherits.
- **Item 7** (native stack overflow #1635 `bc5a1ecfdb` + parser-stack `82e80152a3`/`ebc286a46c`/`da87ebd954`) — **in-oracle; already mirrored.** Port models it as `Halt::StackOverflow` = host abort, not a catchable `RangeError` (`interp.rs:2431`).
- **Items 1,2,3,5,6** (`f3c53dc018`/`a3a4761939`/`cf5603f0b2`; `c41a35d165`; `0e1c47d81f`; `d8baa8cdf7`; `a3da68e484`) — **post-8.2.3 follow-ups**, gated on the oracle bump; several also await VM stages the port hasn't reached (ArrayBuffer/DataView runtime, `Array.from`, disposal protocol).
- **Item 8** (`f5615ff3fb` trim) — behavior-neutral; no-op.

**Changes landed** (committed `a58d89df7`, pushed to `xs2rust-endor` → `c29e26533`; `cargo check -p endor-compile` clean):
- `rust/engine/README.md`: new **"Upstream moddable delta tracking (oracle 8.2.3 → public 8.3.1)"** section — the recorded baseline note, with the full itemized table. The oracle pin was **deliberately NOT bumped** (gaps tracked as follow-ups, per the deliverable).
- `rust/engine/endor-compile/src/parser/stmt.rs`: surgical fold note at the `for await` parse site recording the `mxAwaitingFlag` delta (`c41a35d165`), matching the port's named-fold idiom — the one surface where a post-8.2.3 divergence is latent in existing code.

**Follow-up posted:** parked plan job **`port-endor-oracle-bump-8-3-1`** (on `origin/journal2`) — bump the oracle 8.2.3→8.3.1 and mirror items 1,2,3,5,6 (item 8 optional) as their surfaces exist, with per-item sha/file instructions. Parked (not active) because it's a deliberate whole-bar re-base and several sub-items depend on unreached VM stages.

**Follow-ups / notes:** the oracle bump is the single gate for all remaining mirrors; the README table should flip each item from follow-up→mirrored as future stage work lands. No upstream PRs/comments; read-only on Moddable and endo; work done only on the bot fork.
