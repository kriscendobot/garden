---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement finding routed to `role/liaison` by the `scholar-ingest-cloudflare-os`
job (2026-08-24, `msgs/role/liaison/20260824T183044Z-4593eb.md`):

> Scholar ingest exposed a deterministic integrity-gate gap. A malformed
> local patch accidentally landed literal `@@`, `+`, and `-` patch-marker
> lines in `library/{sources,topics,concepts}/README.md` and
> `library/keywords.md`; `library-link-check.sh` still passed and
> `regenerate-topics-counts.sh --check` reported current because the
> malformed rows were invisible to their parsers. A peer caught the
> corruption by inspection, and this job repaired it. Please encode a
> producer-side check that rejects patch-marker-shaped lines in the four
> hand-maintained shared indexes before or during landing, so a green
> link/count gate cannot mask this class again.

The scholar role isn't authorized to edit `scripts/jobs/*.sh` (its write
bounds are `journal/library/`, `journal/projects/`, `journal/entries/`),
hence the routed message instead of a direct fix.

## What to do

Add a deterministic check that a raw diff/patch fragment (a stray `@@ ... @@`
hunk header, or a content line whose only distinguishing feature is a
leading `+`/`-` from an aborted/malformed patch apply) cannot silently land
in the four hand-maintained shared library indexes:

- `library/sources/README.md`
- `library/topics/README.md`
- `library/concepts/README.md`
- `library/keywords.md`

Two plausible hook points, pick whichever is the cleaner single choke point
(or both, if they serve different purposes):

1. **`scripts/jobs/land-journal-edit.sh`** — the sole sanctioned lander for
   every library/project content edit (per `roles/scholar/AGENT.md`). A
   content-shape guard here catches the corruption at the moment of landing,
   before it ever reaches `origin/journal2`, for any producer using the
   lander (not just the scholar).
2. **`scripts/jobs/library-link-check.sh`** — the existing deterministic
   integrity gate scholars are required to run before completing a cycle
   (`roles/scholar/AGENT.md` step 8). Extend its scan of these four files to
   flag a `@@`-hunk-header line or a line that is patch-marker-shaped rather
   than genuine markdown content, as a hard failure alongside its existing
   link-resolution checks.

Either way: a line matching `^@@ .* @@` (a literal diff hunk header) should
always fail. Be more careful with bare `+`/`-` prefixes since legitimate
markdown content can start with those (list bullets use `-`); constrain the
check to a shape that's actually diagnostic of a stray patch fragment (e.g.
a `+`/`-`-prefixed line that also contains another diff-artifact on the same
or an adjacent line, or restrict to `@@` hunk headers only if a precise
`+`/`-` rule proves too prone to false positives on legitimate content —
your call, document the tradeoff briefly in the commit).

## Regression coverage

Add a test asserting the guard actually rejects a fixture file containing an
injected `@@ -12,7 +12,8 @@`-style hunk header (or whatever shape you land
on), and does not false-positive on the current, clean state of the four
files.

## Out of scope

Do not re-audit the rest of the library corpus for other instances of this
corruption class beyond the four named files — the scholar job already
repaired the instance it found. This job is the deterministic guard against
recurrence, not a corpus-wide sweep.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-24T18:35:12Z
