# producer-arg-guard-test.sh has 2 pre-existing failures: uppercase-kind expectation vs journal-entry.sh's actual charset

## Observed (2026-06-27, on origin/main2 tip, unrelated to the body-read-hang fix)

`scripts/jobs/test/producer-arg-guard-test.sh` fails 2 of its assertions on a
clean `origin/main2` (confirmed identical with and without the
garden-harden-producer-body-read-hang edits, so this is independent):

```
FAIL: out-of-charset kind not rejected (upper=0 slash=1 empty=1)
FAIL: happy-path entry wrong (ok=1 n=1 kind='kind: Progress')
```

## Root cause

The test (step 3) asserts `journal-entry.sh Progress` (an uppercase-led kind) is
rejected non-zero. But `journal-entry.sh`'s actual kind guard is:

```sh
case "$kind" in [A-Za-z]*) : ;; *) die ... ;; esac
case "$kind" in *[!A-Za-z0-9_-]*) die ... ;; esac
```

— which ACCEPTS uppercase letters (`[A-Za-z]` and the `A-Za-z0-9_-` charset both
admit `Progress`). So the script accepts `Progress`, the test expects rejection,
and the happy-path sub-assertion then trips because the first posted entry is the
accepted `kind: Progress` rather than the intended lowercase `progress`.

`journal-entry-argv-test.sh` (the sibling, 19/19 green) does not test uppercase,
so the divergence only shows in producer-arg-guard-test.

## The decision to make

Real kinds are all lowercase letter-led tokens (progress, claim, result, message,
dispatch, error, tick, worktree). Pick one and land it so the test is green:

1. Tighten `journal-entry.sh`'s guard to reject uppercase-led / uppercase-bearing
   kinds (charset `[a-z]` led, `[a-z0-9_-]` body), matching the test's intent and
   the all-lowercase kind vocabulary; OR
2. Loosen `producer-arg-guard-test.sh` step 3 if uppercase kinds are intended to
   be legal (they do not appear anywhere in practice, so option 1 is likelier
   correct).

## Discipline

Garden-infra job: isolated worktree off origin/main2, explicit pathspecs, push
HEAD:main2. Re-run producer-arg-guard-test.sh to green and confirm
journal-entry-argv-test.sh stays 19/19.

---
claim:
  host: endolinbot
  gardener: 13
  claimed_at: 2026-06-27T12:23:42Z
