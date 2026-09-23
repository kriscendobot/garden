# Completion report — Temporal ZonedDateTime, time zones, and Now (js-24)

**What I did.** Implemented `Temporal.ZonedDateTime` and the `Temporal.Now` namespace in the Ironhorse VM (`rust/engine/ironhorse-vm/src/interp.rs`), reusing the pinned **fixed-offset** tz strategy shared with `Intl.DateTimeFormat` (`resolve_time_zone`). Built on the shared Ironhorse completion branch — fetched `feat/ironhorse-262-language-completion`, preserved all prior commits (children 12–23, incl. Instant/Duration/Plain), and stacked my commit on head `99e607a`.

**Surface implemented.**
- `ZonedDateTime`: constructor, `from` (string / property-bag / instance), `compare`; getters `year…nanosecond`, `monthCode`, `dayOfWeek/dayOfYear/weekOfYear/yearOfWeek/daysIn*/monthsInYear/inLeapYear`, `calendarId`, `timeZoneId`, `offset`, `offsetNanoseconds`, `epoch{Milli,Nano}seconds`, `hoursInDay`, `era/eraYear` (undefined for ISO); methods `with/withPlainTime/withTimeZone/withCalendar`, `add/subtract`, `until/since` (exact-difference balancing), `round`, `equals`, `startOfDay`, `getTimeZoneTransition` (null — correct for fixed offsets), `toInstant/toPlainDate/toPlainTime/toPlainDateTime`, `toString/toJSON` (with `calendarName/offset/timeZoneName` toggles), `valueOf` (throws).
- Offset zone ids (`±HH:MM[:SS[.fff]]`) + the named/`Etc`/`UTC` table; sub-minute offsets supported.
- `Temporal.Now.{instant,timeZoneId,zonedDateTimeISO,plainDateISO,plainDateTimeISO,plainTimeISO}` on a deterministic host clock (Unix epoch, `UTC` system zone) + `Symbol.toStringTag`.
- **`Temporal.TimeZone`: justified proposal exclusion** — 0 files in the pinned corpus (removed from the proposal).
- Fixed a latent bug: `temporal_plain_add` on a kind-2 record rejected a date duration carrying `days`; `add/subtract` now shift the wall-clock date via a kind-0 `PlainDate`.

**Tests added.** `rust/engine/ironhorse-262/tests/temporal_zoned.rs` — 6 XS-differential regression groups (construction/getters, from/compare/equals, arithmetic/difference/rounding, conversions/with/transition, catchable errors, deterministic Now). All pass against the official XS oracle.

**Commands run.** `full-run.sh --subtree built-ins/Temporal/{ZonedDateTime,Now}` (before+after, `--test262-dir` at the pin), `cargo test --workspace` (release), plus explicit `--test regressions_dual_run --test corpus_conversion_equivalence --test temporal_zoned --test temporal_plain`.

**Totals before → after (official slice, real XS-oracle execution).**
- ZonedDateTime (901): unsupported **344 → 262**, skipped **557 → 639**, **ironhorse-failures 0 → 0**, infrastructure **0 → 0**.
- Now (66): unsupported **7 → 1**, skipped **59 → 65**, failures 0, infra 0.
- Net **88 cases moved unsupported → host-excluded skip** (`oracle-host-missing-temporal`, the acceptance bar's justified exclusion), with real ZonedDateTime/Now execution now proven correct by the Rust oracle tests.

**Changed skip reasons.** The `getOwnPropertyDescriptor:non-object` skips on the now-defined constructors are eliminated. Residual unsupported are non-Temporal opcode gaps owned by other children (227 `u/v regex flag`, 11 `**`, 10 `apply`, 2 `String`, 2 mixed-bigint) plus **9 honest new `Halt::Unsupported`** I introduced: 8 `until/since` with calendar largestUnit (week/month/year need calendar-relative arithmetic the fixed-offset model can't express) and 1 `toLocaleString` (needs Intl). No relabeling/suppression.

**Regression invariants — verified.** No covered case regressed (full workspace + 1712-case exact-metering corpus `regressions_dual_run` and `corpus_conversion_equivalence` pass, computron expectations unchanged); zero new `ironhorse-failure`/`infrastructure` in both slices.

**Head SHA:** `3c62d67c9a1fe7ef17e5de7cc1361dc09e389200` (pushed; remote head matches). **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 — **OPEN, draft, not merged.** Pins unchanged: test262 `be13516fb`, XS oracle `23b4d6b0`.

**Follow-ups (not blocking):** calendar-relative `until/since` largestUnit (week/month/year) and `toLocaleString` remain honest `Halt::Unsupported` under the fixed-offset/no-Intl model; candidates for js-25/js-26.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-24-temporal-zoned.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 255 tokens (25582912 cached reads)
- Output: 142012 tokens
- Cost: $19.30096499999999
- Wall-clock: 2017s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
