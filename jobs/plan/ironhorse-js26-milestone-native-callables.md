---
gate: go-ahead
priority: normal
posted_by: gardener
posted_at: 2026-08-22T07:21:49Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
# js-26 MILESTONE — invoking native/bound callables (apply/call/bind + Array-method callbacks)

Consolidates the `ironhorse-js-26-ce-fn-native-receivers` child (from the
`ce-apply-call-toprimitive` cluster) into a per-family milestone with a real budget,
minted by `ironhorse-js26-milestone-consolidation` (2026-08-22). The parent cluster's
`non-primitive-completion` sub-family (function/class/arrow/bound completions rendered via
`Function.prototype.toString`) was ALREADY CLOSED earlier on the branch. THIS milestone
owns the remaining `unsupported-opcode` namesake family: invoking a callable whose
receiver/callback is a NON-USER (native/bound) function.

## Scope (all sites in `rust/engine/ironhorse-vm/src/interp.rs`)
- `unsupported-opcode:call:non-user-function-receiver` (`enter_call_dot_call`, ~L15952)
- `unsupported-opcode:apply:non-user-function-receiver` (`enter_call_dot_apply`, ~L16024)
- `apply:sparse-arguments-array` / `apply:arguments-array` (~L16062/16071)
- `call:primitive-this-boxing` / `apply:primitive-this-boxing` (~L15980/16045)
- `bind:non-user-function-receiver` (~L15741), `bind:new-bound` (~L8513),
  `bind:bound-callback` / `bind:call-target`
- `callback:non-user-function` (`run_callback`, ~L10723/10752)

Each self-names because invoking a native receiver/callback re-entrantly needs the
calibrated metering the authors deferred. NOTE: for test262 coverage the computron meter
is ADVISORY (only observable result/error agreement gates); the meter-exact gate applies
ONLY to the proprietary `rust/engine/ironhorse-262/cases/**` corpus. So the path to
`covered` is to route a native receiver/callback through the existing `call_native` /
`call_native_method` machinery (see `to_primitive` at ~L28078 for the re-entrant-native-
method pattern) and produce the correct observable result; then confirm no `cases/**`
meter-exact case regresses. Do NOT render an unnameable receiver as a wrong value — keep
the honest skip until the observable result is correct.

## MILESTONE DISCIPLINE — commit partial gains (this is the point of the re-scope)
COMMIT PARTIAL GAINS. This is a milestone, not an all-or-nothing cluster closure.
Landing verified coverage progress and reporting the honest residual is SUCCESS, not
failure. You are NOT required to fully close this family in one claim, and you MUST NOT
emit an orchestration-failure signal merely because residual cases remain. Bank verified
progress in bounded commits (implement → run the affected slice → push → repeat) until
your budget nears its wall, then report before/after totals and the residual. Reserve the
orchestration-failure signal ONLY for a genuine gate breakage you cannot repair (a
baseline regression, a red `cargo test`, a broken exact-meter gate) — never for un-closed
scope. If a large chunk remains, say exactly what and where so the next milestone claim
resumes cleanly.

## Quality bar (kept from the arc — non-negotiable for what you DO land)
Convert cases to COVERED via REAL execution against the XS differential oracle
(`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pin>
--no-fetch`), except a specifically-justified standards-grounded host-only/proposal
exclusion (cite spec). Do NOT relabel, suppress, skip-list, or add expectation files to
manufacture a pass. Add focused Rust regression tests under
`rust/engine/ironhorse-262/tests/` for every feature landed. Regression invariant: no
baseline-covered case (`rust/engine/ironhorse-262/baseline/baseline.json`) regresses; no
new `ironhorse-failure`/`infrastructure` result; every exact-metering case under
`rust/engine/ironhorse-262/cases/**` stays passing with its computron expectation
unchanged. Before EVERY push run: the affected official slice, `cargo test --workspace
--release`, and `ironhorse-xst --gate-meter-exact`. Anything failing for a DIFFERENT causal
reason than this family's is OUT of scope — leave it, do not relabel.

## COMMON
Repository endojs/endo-but-for-bots. Continue the EXISTING shared branch
`feat/ironhorse-262-language-completion` and draft PR
https://github.com/endojs/endo-but-for-bots/pull/970 — keep it OPEN and DRAFT, do NOT
merge. Get an ISOLATED checkout keyed by THIS job's base:
`scripts/jobs/ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots
feat/ironhorse-262-language-completion`. Fetch+rebase the latest shared head before
measuring and before every push, PRESERVE every prior commit, stack bounded commits, and
CAS-push (`git push origin HEAD:feat/ironhorse-262-language-completion`) with a rebase
loop. Pins: engine head measured `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`; test262
`tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1
c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; set TMPDIR off any noexec mount.
Cached test262 at the pin: `/home/kris/garden/scratch/test262-pin-be13516f`
(`--test262-dir … --no-fetch`).

**hardened262 (endojs/endo-but-for-bots#1040 / #1046):** once #1046 merges, the
`@endo/hardened262` `ironhorse`/`ironhorse+ses` coverage agents are available; use
hardened262 to ratchet Ironhorse parity and consolidate overlapping suites where that
preserves useful mode-specific coverage evidence. Do not BLOCK on it — the primary
measurement path here remains `full-run.sh` against the XS oracle.

**Report:** commands run, before/after totals+reasons for each slice, head SHA, PR URL,
and the honest residual (what remains and where).
