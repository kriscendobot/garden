---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T20:25:05Z -->

---
model: opus
---
# Stage-5 fix4 3/4: numeric accessor keys, captured `arguments`, and the tco-call-args fold

You are a **fixer** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-4 child 3 of 4 (serial orchestration `xs2rust-endor-build-stage5-fix4`). Siblings 1–2
have just landed the field-init scope + eval folds — sync to the live tip first.

## Scope — four small, named, independent remainders

`rust/engine/README.md` § residual divergences — READ IT FIRST.

1. **Numeric accessor-name canonicalization (Class α's 4 files):**
   `statements/class/accessor-name-{inst,static}/literal-numeric-{leading-decimal,non-canonical}`
   (+ any `expressions/class` mirrors). The oracle canonicalizes a numeric accessor key `.1` to
   the STRING `"0.1"` (`NEW_PROPERTY` by name) while endor codes it through the computed
   integer-index path (`NUMBER`/`AT`/`NEW_PROPERTY_AT`) — endor is 16 bytes LONGER. Port XS's
   accessor-name numeric-literal handling (`fxPropertyName`/getter-setter name paths at the pin):
   a non-index numeric key becomes its canonical string; note fix3 child 4 already landed
   `string_key_to_index`/`push_property_index` (`4a8bdf6ab9`) — this is the inverse direction
   (numeric literal → canonical string when NOT an array index).
2. **Captured `arguments` classification (Class α's 1 file):**
   `statements/class/strict-mode/arguments-callee.js` — a captured `arguments` binding still
   classifies local where the oracle promotes to closure. Fix3's α child closed the
   parameter-named-`arguments` shape; this is the strict-mode-class capture residue.
3. **The `tco-call-args.js` named reject fold (`expressions/call`, 1 endor-reject):** the
   `captured function name deferred` assert at `coder.rs:3100`. A tail-call whose callee is the
   function's own captured name must code the name through its closure alias. Close the fold so
   `expressions/call` reaches divergent=0 endor-rejected=0.
4. **Latent numeric-key wrap (pre-existing, flagged by fix3 child 4):** an UNQUOTED numeric key
   above `i32::MAX` (e.g. `4294967294:`) goes through `push_property_index_number`'s `value as i32`
   and wraps negative instead of pushing a Number node per `fxPushIndexNode`. Fix faithfully and
   add a parser/coder fixture (`4294967294`, `4294967295`, `4294967296`, `2147483648`).

Each slice is independent — land and push each one green before starting the next, in this order.
If one resists byte-exactness within budget, leave it attributed (or a LOUD named fold), never a
silent mis-emit, and report the honest remainder.

## Bars (measure before push, capture to files, check `$?` directly — never pipe to `tail`)

- `statements/class`: the 4 accessor-name files + `arguments-callee` → byte-identical; NO new
  divergence or reject anywhere.
- `expressions/call`: **0 divergent, 0 endor-rejected** (the fold closed).
- `expressions/class`: measure before/after; report both numbers.
- Curated corpora: stays **1711/1711 divergent=0 endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0**.
- Byte-identity fixtures for every closed shape.
- `#![forbid(unsafe_code)]` intact.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
  FIRST `git fetch origin xs2rust-endor` and hard-sync to FETCH_HEAD (peers advance the branch).
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`
  (fallback source: a surviving sibling worktree's `c/moddable`).
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- The byte-identity harness takes a subtree arg: `cargo run -p endor-262 --bin compile-diff -- expressions/call`.
- Commit with explicit pathspecs; push rebase-CAS to `origin/xs2rust-endor`; verify by git EXIT CODE.
- **Budget: ONE 2400s invocation.** Land incrementally — push each green slice as you go; if you
  cannot finish, push what is green and report the honest remainder.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).

<!-- garden-reaped: 1 -->
