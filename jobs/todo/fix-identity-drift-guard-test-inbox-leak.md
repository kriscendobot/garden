role: fixer
# identity-drift-guard's test posts REAL maintainer-inbox reports; the hermetic
# sink override does not cover every escalation path

Maintainer directive (kriskowal, 2026-07-28). Fix in the garden repo (`main2`,
DIRECT push, NO PR per CLAUDE.md § Conventions).

## Evidence

Three genuine `kind: error` messages landed in the real maintainer inbox on
`journal2` within 10 seconds of each other:

- `inbox/maintainer/unread/20260728T051801Z-1b0b91.md`
- `inbox/maintainer/unread/20260728T051806Z-dd5830.md`
- `inbox/maintainer/unread/20260728T051811Z-75a540.md`

Each carries `from_host: driftname`, `from: identity-drift-guard:endolin-garden-ece02cb4`,
and cites the override path `/tmp/idg-naehdO/state/identity-override`. They are test
output, not real drift:

- `driftname` is not a real host (`journal/hosts/` holds only `ps23`,
  `endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`).
- `/tmp/idg-XXXXXX` is the test's `mktemp` fixture root.
- `identity-drift-guard.sh` is not armed as a systemd unit on that host, so no real
  guard tick could have produced them. The 5-second spacing matches the test's
  subtest sequence.

`scripts/jobs/test/identity-drift-guard-test.sh` declares itself hermetic ("the
reporting sinks are captured via the guard's EMIT overrides (no real ...)") and sets
`GARDEN_IDENTITY_GUARD_MAINTAINER_EMIT` / `GARDEN_IDENTITY_GUARD_EMIT` to capture
into temp files. `scripts/jobs/identity-drift-guard.sh` honors both (around lines
59-70). Something nonetheless reached the real bus, so at least one escalation path
either bypasses the override, runs before it is applied, or is invoked from a
subshell or child process that does not inherit it.

## The task

Find the uncovered path and close it. Likely shapes to check: an escalation emitted
before the override defaults are established; a helper in `common.sh` (for example
`message-user.sh` / `send-msg.sh`) called directly rather than through the guard's
emit wrapper; a code path reached only when the drift branch also triggers a
secondary report; or an override that is set but not exported into a child.

Then make the class impossible rather than patching the one instance: the test must
not be able to write to the real journal even if a future escalation path forgets the
wrapper. Prefer a structural guard (point the whole run at a throwaway journal clone
or state root, or refuse to emit when a test marker is set) over adding one more
override variable.

## Do NOT suppress real drift reports

The obvious shortcut is wrong: do not make `identity-drift-guard:*` messages
auto-clearable by `proxy.sh` (whose pre-pass archives `watchdog:*` senders). Real
host-identity drift is exactly the condition a maintainer must see. GARDEN keys claim
metadata, `hosts/<host>` worker counts, the journal index, and the leader marker, so
a genuine drift is serious and must keep reaching the inbox. The defect is the test
emitting, not the guard reporting.

## Definition of done

- A full run of `scripts/jobs/test/identity-drift-guard-test.sh` writes NOTHING to
  the real `journal2` inbox or journal. Demonstrate this: record the inbox entry
  count before and after a run and show it unchanged.
- A regression test proves the containment holds for a NEW escalation path that
  forgets the wrapper (simulate one).
- Real drift still reports to the maintainer inbox, unchanged and un-auto-cleared.
- CI-equivalent checks run locally before pushing.
- Direct push to `main2`. Report the root cause in one paragraph: which path leaked
  and why the override missed it.

Note: the three messages above are being archived separately by the liaison, so do
not count on them still being unread; the journal history preserves them.

<!-- garden-reaped: 1 -->
