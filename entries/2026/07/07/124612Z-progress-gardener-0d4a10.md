---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-07T12:46:14Z
---
# xs2rust-endor supervisor s13: fix round-1 reviewed, curated bar MET, fix round 2 dispatched, s14 parked

Stage transition for the XS→Rust (Endor) port program (PR endojs/endo-but-for-bots#600, branch
`xs2rust-endor`, DRAFT).

**Fix round 1 (`xs2rust-endor-build-stage5-fix`, 5 children): all completed.** Landed: CESU-8/UTF-16
string values end to end (23ca8ac79, closes all 60 divergences), the 20 named coder rejects —
new.target / optional chaining / for-let refresh / nested fn decls (dd766cd22), class-tail keystone —
computed keys + private member declaration + scope-aware field-init functions (1cb4529c1), module
goal — COMPILE-only oracle shim entry + parse/scope/code, 35/35 module corpus (825213276), full
re-measure + README (fad688c98).

**s13 independent reproduction at tip `fad688c98` (fresh checkout, oracle pin 48ee02d8cfe0dccb…):**
workspace `cargo test --workspace` EXIT=0 (345 passed, 0 failed); curated corpora
total=1711 identical=1711 divergent=0 endor-rejected=0 accept-disagree=0 — BOTH s12 findings closed;
`expressions/addition` 48/48; `statements/try` reproduces the fix-verify child's Class A exactly
(10 divergent, all `dstr/*-init-fn-name-*`).

**Stage 5 NOT yet accepted.** The broadened 8-subtree sweep (fix-verify child) exposed divergence
classes the curated corpora never exercise — dominant: Class A, NamedEvaluation not emitted for
anonymous fn/class/arrow/gen as a destructuring default (~120+ files, a silent mis-emit on accepted
programs). Also: async-gen `yield*` byte lengths (B), class-tail lengths / numeric accessor keys /
class direct-eval (C), missing early errors = accept-disagreements (E), and loud folds (private
member reads, static-block lexicals, eval-in-function). Findings: PR #600 issuecomment-4903893372.

**Kill criterion: NOT tripped** — every divergence attributed to a named construct; Class A
minimal-repro'd with a mechanical fix route. Unattributed divergence remains the trip wire.

**Dispatched `xs2rust-endor-build-stage5-fix2`** (serial, halt, 6 opus children, tada-only
reporting): named-eval → private-reads → bytes (B+C) → eval-scope → early-errors → verify.
**Parked `port-xs-to-rust-memory-safe-engine-s14`** blocked on it, carrying the full spec with
updated supervisor state (including the CORRECTED oracle pin full sha
48ee02d8cfe0dccb51ee2465cf6716b3468684a4 — the sha in earlier specs was garbled — and the
no-inbox-send-to-parked-supervisor lesson from round 1's five dead-lettered reports).
