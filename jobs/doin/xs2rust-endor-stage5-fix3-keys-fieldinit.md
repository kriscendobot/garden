---
role: fixer
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T18:37:14Z -->

---
model: opus
---
# Stage-5 fix3 4/5: Classes δ + ε — integer-index object keys + field-initializer scope/ordering

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-3 child 4 of 5 (serial orchestration `xs2rust-endor-build-stage5-fix3`).

## Scope

Close the two smallest residual classes (`rust/engine/README.md` § residual divergences — READ IT
FIRST), then re-measure the sweep at your tip and mop up attributable strays:

1. **Class δ — integer-index object-literal key coding** (1 divergence,
   `expressions/object/S11.1.5_A3.js`, `{0 : 1, "1" : "x", o : {}}`): the oracle codes an
   integer-valued literal key via the integer-index property path (`integer` / `at` /
   `new_property_at`); endor uses the string-atom path (`string` / `new_property`), one byte
   shorter. Port the key-classification from `fxPropertyNodeCode`/`fxObjectNodeCode` at the pin —
   including which strings count as integer indexes ("1" here does NOT flip to the integer path;
   match the oracle exactly, canonical-numeric edge cases and all).
2. **Class ε — class field-initializer scope/ordering** (2 divergences):
   `class/elements/static-field-init-with-this.js` (the oracle wraps the static-field initializer
   in a `with` scope — `fxDefineNodeCode`/field-init `with` handling; endor emits
   `this`/`new_property` directly) and `class/elements/init-value-incremental.js` (same-length
   instruction ORDERING diff in field-init sequencing).
3. **Re-measure** `statements/class`, `expressions/object`, `statements/function`,
   `expressions/assignment` at your tip (siblings 1–3 land before you). If small attributable
   strays remain in reach, close them; anything you leave, attribute by name in your report.

Port at the oracle pin from `xsCode.c`. Transliterate, don't improvise. If a sub-shape cannot be
made byte-exact within budget, leave a LOUD named fold (panic), never a silent mis-emit.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- `expressions/object`: divergent 1 → **0**.
- The ε files in `statements/class` → byte-identical; introduce NO new divergence or reject anywhere.
- Curated corpora: stays **1711/1711 divergent=0 endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0**.
- Add byte-identity fixtures (integer-key object literals incl. negative cases; static-field-init
  `with`; incremental field-init ordering).
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (children 1–3 land before you).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally; if you cannot finish, push what is green
  and report the honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  claimed_at: 2026-07-07T18:37:18Z
