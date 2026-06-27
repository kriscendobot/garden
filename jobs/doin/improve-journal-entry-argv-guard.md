Harden `/home/kris/scripts/jobs/journal-entry.sh` against malformed first-argument (`kind`) values. Today line 18 (`kind="${1:?...}"`) accepts anything as the entry kind, so `journal-entry.sh --help` wrote a permanent append-only journal entry with `kind: --help` (the stray `entries/2026/06/27/115515Z---help-gardener-a67841.md`, flagged in the 115543Z scholar result). Fix: (a) recognize `-h`/`--help` and print the existing usage header, exit 0, without writing or pushing; (b) reject any `kind` beginning with `-` (and ideally validate against the known kind set — progress, claim, result, message, dispatch, error, etc. — or at least require a `[A-Za-z]`-leading token) with a `die "unknown kind: $kind"` before the clone/push loop, so a typo fails fast instead of polluting the journal. This is the same unguarded-argv class as the inline-body stdin hang tracked by garden-harden-producer-body-read-hang; consider folding the body-source guard (warn when `$2` is a non-empty non-file string rather than silently falling through to `cat` on stdin) into the same change. Add/extend a test under `scripts/jobs/test/` asserting `--help` exits 0 with no journal write and a leading-dash kind exits non-zero.

---
claim:
  host: endolinbot
  gardener: 49
  claimed_at: 2026-06-27T12:06:42Z
