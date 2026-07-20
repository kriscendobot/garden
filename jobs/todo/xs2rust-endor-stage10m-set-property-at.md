---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T04:25:03Z -->

---
model: opus
---
# stage-10m child 0: land the `set_property_at` runtime-opcode frontier (computed-key assignment)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT), branch `xs2rust-endor`, base `llm`.
Design: `designs/xs2rust-endor-engine.md`. Doctrine: **accuracy-over-parity** (results gate; computrons
advisory; never back-fit meters). The C-XS oracle at pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`
certifies RESULTS; transliterate bit-exactly from the pinned sources (even artifacts like the
`indexOf_aux` unparenthesized macro — never "fix" the C).

**Worktree:** get an ISOLATED checkout via
`/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh xs2rust-endor-stage10m-set-property-at endojs/endo-but-for-bots xs2rust-endor`.
FIRST fetch and confirm the REAL remote tip (s43 tip was `1481757f7f`; the hourly press may have advanced
or REBASED it — read the latest `xs2rust-endor-press-*` tadas; if a press job is live, message it to defer).
Seed caches (`cp -al`) from the same-commit-or-near sibling
`/home/kris/garden2/scratch/project-wt-port-xs-to-rust-memory-safe-engine-s43-5cd7f36a` (at `1481757f7f`,
endolin-garden2: engine target, ROOT target, `c/moddable` at the pin, `rust/endo/xsnap/src/*.js` bundles) —
`rmdir` the empty `c/moddable` first; verify the pin sha and clean status before trusting the seed. The Rust
workspace is `rust/engine` (NOT the repo root); `cargo` at `$HOME/.cargo/bin`; never commit bundles or
`c/moddable`.

## The item

`XS_CODE_SET_PROPERTY_AT` — computed-key assignment (`o[k] = v`, and object literals with integer keys
`{2:'x'}`, which the compiler emits through the same opcode). Named the next runtime-opcode frontier at
s42/s43: today the whole surface honest-skips `set_property_at`. Transliterate bit-exactly from the pinned
`c/moddable/xs/sources/xsRun.c` (find the opcode's case; follow its helpers exactly). Scope:

- Ordinary objects and exotic arrays as receivers; string, integer-index, and (if the C routes them here)
  symbol computed keys. Anything beyond the transliterated coverage self-names honestly (e.g. TypedArray
  receivers, Proxy receivers) — never a wrong completion.
- Respect the existing property machinery end to end (the s34/s37/s39/s40/s41/s42 F1 bug CLASS is binding
  review doctrine): flags preserved/honored, accessor setters route through the accessor path
  (`accessor_in_chain` intercepts first), frozen/non-writable targets behave per the existing freeze
  machinery, the RegExp `re["lastIndex"]=N` side-table miss is a known ledger row you may fix or leave
  self-naming (do not silently regress it).
- **BINDING (pinned at s43): integer-key own-key ORDER.** Once integer keys become creatable on plain
  objects, `Object.keys`/`Object.getOwnPropertyNames`/`for-in`/`JSON.stringify` (as covered) must list
  present integer-index keys FIRST, ascending, then string keys in creation order — oracle:
  `var o={b:1, 2:'x', a:2, 1:'y'}; Object.keys(o).join(',')` → `"1,2,b,a"`;
  `Object.getOwnPropertyNames` same; `var o={10:'t', z:0, 2:'x'}` → `"2,10,z"`. The current
  `own_enumerable_ids`/`own_all_string_name_ids` walks return pure creation order — extend them (or the
  storage) so the dual-run agrees. Add these exact probes as tests.
- Dual-run tests for every landed shape (result agreement or honest named skip), including: computed
  string key, computed integer key on plain object and array, literal integer keys, accessor-setter via
  computed key, frozen receiver via computed key, key-order probes above, `delete o[k]` interaction if it
  falls out naturally (`XS_CODE_DELETE_PROPERTY_AT` is a separate ledger item — do NOT scope-creep into it
  unless trivially shared).

## Discipline

- **Reproduce-first:** before coding, reproduce the current `set_property_at` self-skip at the real tip.
- **Push-per-item:** commit and push each coherent slice as it lands (verify pushes by git EXIT CODE; the
  push CAS can race the press — rebase and retry).
- **HARD STOP:** size to ONE 2400s invocation; reassess the clock after every pushed item; stop at a
  green checkpoint rather than start an item you cannot finish.
- **BINDING no-boot-regression bars on ANY pushed engine change** (acceptance-grade: `cargo clean -p
  endor-compile -p endor-vm -p endor-oracle`; oracle from the sha-verified pin): engine workspace
  `cargo test --workspace -- --test-threads=1` EXIT=0 (s43 anchor: 923/0, 73 `test result:` lines — count
  grows by your new tests; capture to a file, check `$?`, never pipe to `tail`); compile-diff no-arg
  1909/1909 + SYMB 1909/1909 EXIT=0; boot gate 30/0 (`endor-262 --test boot_bundle_gate`); ROOT
  `cargo test -p endo --lib` 111/0 with the three markers GREEN (needs the seeded bundles). Forbid roots
  intact, VARIANT_COUNT 35 unless you ledger a new variant same-day, 0 non-oracle warnings, no new
  `unsafe`, no new side table without a same-day ledger row.
- Report via your tada completion report ONLY (never inbox-send the parked supervisor). Name every landed
  item's commit sha, every honest skip added/removed, and the measured bar numbers at your final tip.
