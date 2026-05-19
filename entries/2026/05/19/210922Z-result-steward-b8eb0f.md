---
ts: 2026-05-19T21:09:22Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/205402Z-dispatch-steward-7ceb86.md
prs:
  - repo: endojs/endo-but-for-bots
    issue: 295
    role: target
  - repo: endojs/endo-but-for-bots
    issue: 296
    role: target
---

# Steward wrap-up: investigator on #295 + #296 (XS from Rust)

Investigator dispatch `40040b` returned. Topic file at
`journal/projects/endo-but-for-bots/xs-from-rust-investigation.md`
(committed as `d0fbe2f` in the dispatch journal); per-issue
comments posted.

**#295 (XS ModuleSource analysis for endor)**: **yes, partial
today, trivially extensible.** XS already exposes native
`ModuleSource` on `globalThis` with `.bindings` returning what
`@endo/compartment-mapper`'s `parseMjs` needs;
`packages/module-source/src-xs/index.js` already adapts it;
`rust/endo/xsnap/` on `llm` already statically links libxs.a
(`xsnap/build.rs`). Babel-free Rust bindings analyzer implementable
today via `Machine::eval` driving
`new ModuleSource(source).bindings`; direct-FFI variant over
`fxNewModuleSourceInstance` as a follow-up if profiling shows the
eval round-trip is material. Comment:
[#295 issuecomment-4492047894](https://github.com/endojs/endo-but-for-bots/issues/295#issuecomment-4492047894).

**#296 (XS bytecode cache from Rust)**: **partial today,
structurally sound.** `fxParseScript` (declared `extern` in
`xs/sources/xsAll.h`) returns `txScript*` with serialized
bytecode in `codeBuffer`. Snapshot pair already FFI-wired but
whole-machine, not per-module. The source-hash-keyed per-module
cache needs new FFI bindings for `fxParseScript` +
`txScript->codeBuffer`, writes to existing SHA-256 CAS at
`rust/endo/src/cas.rs`, plus `fxResolveModule`+`fxRunModule`
at load time. **Open empirical question**: position independence of
`txScript->codeBuffer` across machines (snapshot has explicit
pointer serialization; `fxParseScript`'s output portability is
undocumented). The XS *archive* format
(`fxGetArchiveCode` accessors) may be a better-fit cache format
and worth probing alongside. Comment:
[#296 issuecomment-4492049865](https://github.com/endojs/endo-but-for-bots/issues/296#issuecomment-4492049865).

**Experiment not attempted**: dispatch root's `c/moddable`
submodule uninitialized; libxs.a bring-up 5-15 min from fresh
dispatch. Parked as follow-up; topic file's § Concrete fix
candidates names a `gap-revealing-build` probe for #296 (independent
of any #295 work) and a designer→builder pair for #295.

**Garden main updated meanwhile** (commit `2f77194`): **understudy
role retired** (subsumed by concurrent stewards + job board) per
user's earlier note. Pulled clean; no operational change for the
steward (the understudy-shunting paths are removed but the steward
was already operating without an understudy).

Self-improvement (forwarded from investigator): when a fork's active
work sits on a branch (`llm`) other than the dispatch root's
checked-out branch (`master`), prefer `git show
origin/<branch>:<path>` over switching the worktree. Routed to
gardener for skill-nibble consideration.
