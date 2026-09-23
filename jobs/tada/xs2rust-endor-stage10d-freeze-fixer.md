All 4 commits are on the remote tip, working tree clean, scratch example removed. The full bar was green at commit 4 (the tip): 708 passed / 0 failed across 48 result lines, compile-diff 1909/1909 + SYMB 1909/1909, boot gate 28, 0 new Rust warnings, moddable pin clean and never staged. The PR remains DRAFT (I only pushed branch commits, never touched draft state or posted comments).

<<<GARDEN-JOB-COMPLETE>>> — wait, let me write the report first.

## Completion report

**Job:** stage10d child 0/5 — FIXER: frozen arrays (and the swept exotic kinds) must actually be immutable (stage-10 review finding F1), `endojs/endo-but-for-bots` PR #600, branch `xs2rust-endor`.

**What I found (oracle-grounded against C-XS, pin `23b4d6b0`):** The finding was confirmed and the sweep uncovered **two additional RegExp bugs** in the same side-table-bypass class. Every semantic was grounded with isolated dual-run snippets before writing code.

**What I did — 4 push-per-item commits (each with full bars green before push):**

1. **`6c4045e3ec` — frozen array `length` is non-writable.** `array_set_length` now honors `XS_DONT_PATCH_FLAG` at both call sites (named `arr.length=N` and AT-key `arr["length"]=N`). Oracle: sloppy write silently ignored in **every** direction (shrink/grow/same); strict throws `TypeError: set length: not writable` → self-named `strict-set:integrity-violation`. Setter frame still metered first.

2. **`b04f74c5e5` — array mutator natives.** `push`/`pop`/`shift`/`unshift`/`splice` guard unconditionally (they always Set `length`, so throw even empty/no-arg — oracle-verified); `reverse`/`fill`/`copyWithin` guard **only on a non-empty write range**, because empty/single-element `reverse`, start-past-end `fill`, and zero-count `copyWithin` write nothing and **complete** on the oracle (I deliberately did not over-guard these into spurious skips). `sort` left untouched: it already self-names orthogonally (`data-dependent-comparison-metering`), so never mutates-then-completes.

3. **`45fcf053ff` — frozen RegExp `lastIndex` assignment (sweep bonus).** `re.lastIndex=N` routed through a dedicated side-table path that ignored the flag. Now sloppy no-op / strict self-name. Swept Map/Set/ArrayBuffer/DataView/Error and left them correct (oracle allows internal-slot mutation of frozen collections/buffers per spec; Error `message` already covered by the shared slot loop).

4. **`c421df5710` — exec/test/match on a frozen global/sticky RegExp (sweep bonus).** `regexp_match_drive` advanced `lastIndex` on the side table ignoring the flag; the oracle's internal `Set(lastIndex,…,true)` throws (even a no-match reset to `0`). Now self-names `RegExp:frozen-lastIndex-advance`; non-global/sticky exec/test still completes.

**Gate test:** `boot_step_ses_freeze_exotic_receivers_agree` extended with all four surfaces (sloppy no-ops, strict/mutator/regexp aborts, and the no-write green cases). Added an `assert_abort_self_named` helper for the oracle-throws-endor-self-names (`BothAbort`) shape, distinct from the existing `assert_named_skip_unsupported` (oracle-completes).

**Bars at tip (`c421df5710`):** `cargo test --workspace` = 48 result lines, all 0 failed, **708 passed**; compile-diff **1909/1909** identical + SYMB **1909/1909**; boot gate **28**; **0** new Rust warnings; `#![forbid(unsafe_code)]` intact; no new side table; moddable pin `23b4d6b0…` clean, never staged. PR kept **DRAFT**, no PR comments.

**Follow-ups (noted in commit 3 message, out of this fix's scope — distinct code paths, not the assignment bypass):**
- AT-key `re["lastIndex"]=N` misses the RegExp side table even on a **non-frozen** RegExp (a pre-existing modeling gap, not a freeze bug) — its strict-frozen form is currently `EndorOnlyComplete`.
- Wrapper reads after freeze (`new String("ab")[0]`, `new Number(5)+1`) are pre-existing read-side skips (`OracleOnlyComplete`), not mutation bypasses — no wrong answer, left as-is.
