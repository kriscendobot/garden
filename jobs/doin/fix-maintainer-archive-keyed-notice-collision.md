---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix: `maintainer-archive.sh` cannot archive a RECURRING keyed notice (bare `git mv` collision)

## The defect

`scripts/jobs/maintainer-archive.sh:16` moves a message with a bare `git mv`:

    git -C "$DIR" mv "inbox/maintainer/unread/$id" "inbox/maintainer/read/$id"

Watchdog/reaper notices use **stable, dedup-keyed filenames** (the design in
`designs/watchdog-notice-dedup.md`: ONE keyed message per open condition), e.g.
`watchdog-triager-upstream-gone-kriscendobot-list.md`,
`poison-<base>-deadline-overrun.md`.

So this sequence wedges permanently:

1. Condition opens -> keyed notice written to `unread/`.
2. Maintainer archives it -> `read/<key>.md` now exists.
3. Condition RE-opens -> the writer creates `unread/<key>.md` again.
4. Archive now fails forever:
   `fatal: destination exists, source=inbox/maintainer/unread/<key>.md,
    destination=inbox/maintainer/read/<key>.md`

The message can never be archived through the supported path. It is not a
transient failure — every retry in the script's 50-attempt loop hits the same
deterministic `git mv` refusal, so it also burns the full backoff each time.

## Observed

Found 2026-08-14 during a maintainer-inbox backlog sweep: **7 keyed names exist
in BOTH `unread/` and `read/`**, all unarchivable. 6 surfaced as hard failures
in one sweep:

    poison-build-kebab-case-lint-wildcard-test262-deadline-overrun.md
    poison-endo-cbor-adopt-daemon-envelope-deadline-overrun.md
    poison-endojs-endo-but-for-bots-pr881-gauntlet-deadline-overrun.md
    watchdog-triager-fetch-failed-kriscendobot-agoric-3-proposals.md
    watchdog-triager-upstream-gone-kriscendobot-cosgov.md
    watchdog-triager-upstream-gone-kriscendobot-list.md

## Task

Make archiving a recurring keyed notice work. Decide between:

- **(a) overwrite** — `git mv -f`. Simplest; loses the earlier archived copy.
- **(b) preserve both** — archive to `read/<key>.<sent_at>.md` (or append the
  message id) so the history of a recurring condition survives.

(b) is likely right: a condition that recurs is exactly the history worth
keeping, and `designs/watchdog-notice-dedup.md` already treats recurrence as
signal (`notice_count`, `first_seen`, `last_seen`). Confirm against that design
before choosing.

Check `maintainer-reply.sh` for the same bug — it archives on the reply path too.

## Definition of done
- A recurring keyed notice archives cleanly, twice in a row, in a test.
- The 7 currently-stuck messages are archivable (do not hand-move them; fix the
  tool, then archive them with it).
- A test under `tests/checks/` covers the recurrence case.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T05:49:27Z
