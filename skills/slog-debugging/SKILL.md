---
created: 2026-07-03
updated: 2026-07-03
author: gardener
---

# Skill: slog-debugging

Read an Agoric **slog** (the swingset delivery/syscall log) and its binary sibling
the **flight recorder** to find why a vat delivery or upgrade failed. The slog is
the primary evidence trail when an XS worker aborts: it carries the delivery-level
error record that a bare exit code does not. This skill is the reading procedure;
the engine-level interpretation of what the record *means* is
[xs-debugging](../xs-debugging/SKILL.md).

Scope, like its siblings: agoric-sdk's swingset (`packages/swingset-*`,
`packages/cosmic-swingset`). Read-only analysis on bot forks and captured state.
No upstream interaction (`roles/COMMON.md` § External-repo etiquette).

## What a slog is

The slog is swingset's structured, append-only record of everything the kernel
does: each **delivery** to a vat (`deliver`, `deliver-result`), each **syscall** a
vat makes, vat **create/upgrade** events, and **worker** lifecycle
(`start-worker`, crank boundaries). Each line is a JSON record with a `type` and a
monotonically increasing sequence. The signal you usually want is the
`deliver-result` (or a `vat-upgrade` outcome) that carries the failure.

Two forms:

- **Text slog**: the JSON-lines stream (`slog.json` / `SLOGFILE=…`). Grep-able
  directly.
- **Flight recorder** (`flight-recorder.bin`): a fixed-size circular binary buffer
  the kernel writes continuously so the *last* N events survive a crash even when
  no text slog was enabled. This is often the only artifact after an abort.

## Preserve the artifact before it vanishes

The single most common way to lose the evidence: a test harness or inquisitor's
`shutdown()` removes its temp database directory (`/tmp/testdb-*`), taking the
flight recorder with it. **Copy the artifact out before teardown:**

```
cp "$(ls -t /tmp/testdb-*/flight-recorder.bin | head -1)" ./captured-flight-recorder.bin
```

Do this in the driver, immediately after the failing crank and **before**
`shutdown()`. When reproducing through
[agoric-chain-snapshot](../agoric-chain-snapshot/SKILL.md), the drivers already
note this: preserve the newest `flight-recorder.bin` and then inspect it
out-of-band.

## Finding the failure

1. **Count the smoking signal.** For an XS overflow the delivery-level cause is
   `Stack meter exceeded`:
   ```
   grep -c 'Stack meter exceeded' <slog-or-recorder>
   ```
   A non-zero count on the failing vat's deliveries confirms the XS value-stack
   exhaustion ([xs-debugging](../xs-debugging/SKILL.md)). In the ymax0 contract-
   control run it appeared **×30** alongside exit-12.
2. **Read the error record, not `JSON.stringify`.** The delivery error surfaces as
   `{"#error":"Stack meter exceeded","errorId":"error:liveSlots…"}`, which is
   swingset's rendering of XS `E_STACK_OVERFLOW` (exit 12) from
   `manager-subprocess-xsnap.js`. When you hold the kernel-promise resolution as a
   JS `Error`, log `err.message` / `err.stack`. **Never `JSON.stringify(err)`** (it
   renders `{}` and hides the cause).
3. **Locate the failing delivery.** Walk back from the error record to the
   `deliver` that produced it: the `vatID`, the delivery method, and the
   incarnation/span bounds tell you *which* worker and *what* it was doing (a
   bundle import, a specific method). A truncated transcript span (an upgrade span
   that opens but stops short of its expected end) is itself a failure tell. An
   upgrade span opening is **not** success; only the span reaching its full bounds
   is.
4. **Correlate incarnation.** For an upgrade, read the current span's incarnation
   before and after (`transcriptStore.getCurrentSpanBounds(vatID).incarnation`). A
   fresh span opens in **all** cases including failure, so use the *resolution* of
   the upgrade promise (reject = failure) plus the slog error, not the span-open,
   as the outcome signal.

## Procedure

1. **Get the artifact.** Prefer the text slog if one was enabled; otherwise
   preserve the flight recorder before teardown (above).
2. **Grep for the failure class.** `Stack meter exceeded` for XS overflow; more
   generally the `#error` records and any `deliver-result` with an error payload.
3. **Anchor to the delivery.** Identify the `vatID`, method, and incarnation of the
   failing delivery.
4. **Hand off to the engine reading.** Once you know it is an XS fault, switch to
   [xs-debugging](../xs-debugging/SKILL.md) to classify width-vs-depth and choose
   the remedy.

## Related

- [xs-debugging](../xs-debugging/SKILL.md): what a `Stack meter exceeded` /
  exit-12 slog record means at the engine level and how to fix it.
- [agoric-chain-snapshot](../agoric-chain-snapshot/SKILL.md): the reproduction
  lever whose drivers produce the slog / flight recorder you read here.
- Fixer debugging sub-role that routes here:
  [agoric-sdk](../../roles/fixer/subroles/agoric-sdk.md).
