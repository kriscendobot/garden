<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T12:17:58Z -->

# Harden producer body-reading: a non-file body arg + non-tty stdin hangs on `cat` holding the producer lock

## The bug (observed 2026-06-27, real producer-clone wedge)

`post-plan.sh` and `journal-entry.sh` read their body with this shape:

```sh
if   [ -n "$body_src" ] && [ -f "$body_src" ]; then cat "$body_src"
elif [ ! -t 0 ];                                then cat
else <placeholder>
fi
```

When the caller passes the body as an inline STRING in the second positional
arg (not a file path) AND stdin is not a tty (every background / `claude -p` /
systemd context), `body_src` is non-empty but `[ -f "$body_src" ]` is false, so
control falls to the `[ ! -t 0 ]` branch and `cat` blocks on stdin that never
closes. The script hangs forever. Because post-plan/journal-entry hold the
shared per-clone producer lock (`$GARDEN_STATE/producer/journal.lock`) across
the body read + CAS loop, the hang wedges the ENTIRE shared producer pipeline:
every other gardener's post-job / post-plan / journal-entry against that clone
blocks behind the stale lock until the dead holder times out. A scholar idle
cycle hit exactly this and had to kill the tree and `rm` the stale lock by hand.

`land-journal-edit.sh` already does the right thing (line ~120): a non-empty
`body_src` that is not a file is a hard `refuse`, never a silent stdin fall-through.

## The fix

Make `post-plan.sh` and `journal-entry.sh` match `land-journal-edit.sh`'s
discipline. Two acceptable shapes, pick one and apply to both scripts:

1. Mirror land-journal-edit.sh exactly: if `body_src` is non-empty but not a
   file, `die`/`refuse` with a usage error instead of falling through to `cat`.
2. Or accept an inline body: if `body_src` is non-empty and not a file, treat
   the string itself as the body (`printf '%s' "$body_src"`).

Either way, NEVER read stdin when a non-empty body arg was supplied. Belt-and-
suspenders: the body-read `cat` for the genuine `[ ! -t 0 ]` stdin case should
also not be reached while a non-empty body arg is present.

## Also fold in: journal-entry.sh has no `--help` / leading-`-` kind guard

`journal-entry.sh --help` silently posts a junk entry `kind: --help`
(observed: `entries/2026/06/27/115515Z---help-gardener-a67841.md`; append-only,
cannot be cleaned). Add `-h|--help` -> print usage, exit 0; reject any `kind`
starting with `-` as a usage error (exit 2), mirroring land-journal-edit.sh.

## Discipline

Garden-infra job: build in an isolated worktree off origin/main2, re-apply on the
clean base, commit explicit pathspecs, push HEAD:main2. Add a test under
scripts/jobs/test/ that asserts both scripts, given an inline non-file body arg
with stdin redirected from /dev/null, exit promptly (non-zero usage error or a
clean post) and NEVER block, and that `journal-entry.sh --help` exits 0 without
posting.
