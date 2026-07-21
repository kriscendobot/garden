from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-20T10:53:08Z
poison_base: xs2rust-endor-stage10p-unbound-builtins
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-20T10:53:08Z
last_seen: 2026-07-20T10:53:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/xs2rust-endor-stage10p-unbound-builtins; it stays HELD until a human promotes it
(promote-plan.sh xs2rust-endor-stage10p-unbound-builtins) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: xs2rust-endor-stage10p-unbound-builtins

--- original job body ---
---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T10:07:03Z -->

---
model: opus
---
# Stage-10p child 2: the unbound-builtin cluster (PR #600, xs2rust-endor)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR #600 (DRAFT — keep DRAFT).
**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`;
sync to the REAL remote tip first (press + earlier stage-10p children advance the branch). Cache
seeding, bundle rules, oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, cargo/TMPDIR notes:
identical to child 0's brief (same-tip siblings on endolin-garden include
`scratch/project-wt-port-xs-to-rust-memory-safe-engine-s46-5cd7f36a`).

## The findings (s45, re-scoped by the stage-10o oracle-driven sweep — absence wrong-completions)

Six builtins are entirely UNBOUND in endor (`typeof` → `undefined`; a call throws "not a function";
reflection reads wrong-complete by absence): `String.prototype.padStart`, `String.prototype.padEnd`,
`Number.prototype.toFixed`, `Number.prototype.toPrecision`, `Map.groupBy`, `RegExp.escape`.

## Task — reproduce-first, transliterate, push-per-item (6 items)

For EACH builtin, in its own commit:
1. Reproduce absence at tip via dual-run (`typeof`, a call, `.length` read).
2. Bind it with arity/name transliterated from the pinned C builder tables (`xsString.c`, `xsNumber.c`,
   `xsMapSet.c`, `xsRegExp.c` — cite file:line in the commit body; NEVER guess), and semantics mirroring
   the C callback (`fx_String_prototype_padStart`, `fx_Number_prototype_toFixed`, …). Where the C
   semantics need machinery endor lacks (e.g. locale/float formatting corners), implement the covered
   core and make uncovered corners HONEST skips (`Unsupported`) — never a differing result.
3. Gate tests (dual-run agreement) covering the mainline plus edge shapes the oracle certifies
   (padStart/padEnd truncated fills and empty pad; toFixed/toPrecision boundary digits and rounding;
   Map.groupBy key identity incl. -0 normalization per C; RegExp.escape metachar coverage).
4. Full bars at the pushed tip (workspace count GROWS; compile-diff 1909/1909 + SYMB; boot 30/0; ROOT
   111/0; 0 non-oracle warnings; no new `unsafe`; no new side table).

If the 2400s budget runs short, land FEWER complete items rather than all six half-done — every pushed
item must carry its gates and bars. Report the remainder explicitly in your tada. Accuracy-over-parity.
Tada ONLY; keep PR DRAFT.

<!-- garden-deadline-overrun: 1 -->
