---
kind: result
role: jurors/assessor
host: endolin-garden-ece02cb4
at: 2026-08-08T11:00:23Z
---
role: jurors/assessor
pr: endojs/endo-but-for-bots#970
head: 258c760786fc9abed09a7a99072e6a03a1372dd4
base: origin/llm (the worktree's local `llm` ref is stale — 3390 files vs the PR's 27; reviewed `origin/llm...HEAD`)

### assessor (correctness logic and control flow)

**Verdict:** request-changes

**Findings:**

- `rust/engine/ironhorse-vm/src/interp.rs:5989` (and `:5536`, `:5558`, `:5571`, `:5592`, `:5813`, `:6986`, `:7002`) — **`Halt::Resume` escapes the dispatch loop through the new coercion/MOP seams.** This PR adds `Halt::Resume(target)` plus the `dispatch_result!` macro (`:2743`) precisely so a native helper's raise can resume at a catch target in an outer frame. The arithmetic/comparison/call arms use the macro; the new arms do not — `ordinary_get`, `ordinary_set`, `to_primitive`, `to_number_value`, `property_at_get`, `property_at_set` are all called with a bare `Err(halt) => return halt`. Trace: `var o={get x(){throw 1}}; try{o.x}catch(e){}` — the getter runs in `run_callback`'s nested `dispatch_at` (return_depth 1); `THROW` unwinds to the top-level jump, `call_stack.len()==0 < 1`, so `:7715` returns `Halt::Resume`; `run_callback` → `ordinary_get` → the `GET_PROPERTY` arm returns it out of the outermost dispatch. `run()` (`:5112`) then reports `completed=false` with an empty result: the `catch` never runs and the rest of the script is silently discarded. Same for a throwing setter and for a throwing `toString`/`valueOf` under `TO_STRING`/`TO_NUMERIC`. must-fix. [rule: roles/jurors/assessor/AGENT.md § Primary surface — async/error-path propagation]
- `rust/engine/ironhorse-vm/src/interp.rs:5407,5437,5827,6038,6055,6105,6121` — the seven in-loop `raise_js` sites resume with `pc = target; continue` and **omit the `call_stack.len() < return_depth` guard** that the same PR added to all three `unwind_to_jump` sites (`:7281`, `:7714`, `:7736`). Inside a nested dispatcher (callback, generator/async resume) these jump to an outer frame's pc while the native caller's frame is still live. Fold them into `catchable_type_error()` + `dispatch_result!`. must-fix. [rule: roles/jurors/assessor/AGENT.md § invariant-claim overlap]
- The PR claims "realm-catchable Error TypeErrors", and adds `catchable_type_error()` — but uses it **twice**, against **17 new uncatchable `Halt::Throw("TypeError: …")` sites** in the new surface: `Object.create`/`defineProperty`/`defineProperties` (`:12123` area), `%CopyObject%`, `Reflect.isExtensible`/`preventExtensions`/`defineProperty`, `descriptor_from_object`, `to_property_id`. `try { Object.defineProperty(1,'x',{}) } catch(e) {}` aborts the whole run instead of entering the catch. should-fix (or state the exclusion in the PR body). [proposed-rule: when a PR introduces a catchable-error path, every new error site on that surface uses it — a mixed catchable/uncatchable surface is worse than a uniformly self-naming one, because the harness scores the difference as coverage.]
- `rust/engine/ironhorse-vm/src/interp.rs:6062` — `XS_CODE_DELETE_PROPERTY`'s catch-all primitive arm returns `true` unconditionally. `delete "abc".length` must be `false` (sloppy) / TypeError (strict); the sibling `DELETE_PROPERTY_AT` arm (`:6114`) does model the non-configurable String index case, so the two disagree. should-fix. [rule: roles/jurors/assessor/AGENT.md § Be specific]

**Notes (out of scope but worth flagging):**

- `Object.getOwnPropertyNames` (`:12001`) returns `own_all_string_ids` order, while the new `Reflect.ownKeys` (`:14539`) applies the index-first/insertion-order sort. Same spec ordering (OrdinaryOwnPropertyKeys), two code paths — one will drift. [proposed-rule: one key-ordering helper per spec operation; callers never re-derive it.]
- `ordinary_define_own_property` (`:18142`) reads correctly against ValidateAndApplyPropertyDescriptor, including the non-configurable rejections, kind conversion attribute preservation, and SameValue signed-zero — no finding.
- The rustfmt sweep across `interp.rs` is ~60% of the 4035 changed lines and buries the semantic hunks. A separate `style:` commit would have made this reviewable. [rule: skills/retcon/SKILL.md]
- The regexp inline-modifier grammar (`ironhorse-regexp/src/compile.rs:1190`) and the `duplicate_proto_setter_line` Annex-B check both read correct, including `(?-s:)`, disjointness, and the ObjectBinding cover-grammar exclusion.

Self-improvement: the assessor brief says "cite `file:line`", but on a PR whose diff base ref is stale in the worktree, line numbers taken from the diff are meaningless. I resolved the real base (`origin/llm`) first and then cited post-image line numbers read from the file on disk, not from the diff hunk headers. Worth encoding: a seat verifies its diff base resolves to the PR's `baseRefName` head before reviewing, and cites file:line from the checked-out post-image. Routing this to the gardener as a `[proposed-rule]` for `skills/panel-review/SKILL.md`.
