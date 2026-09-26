The work this job specifies is **already complete** on `main2` — no code change is needed.

## What I found

The defect described in the spec is the old line 50:
```sh
out="$(claude -p --dangerously-skip-permissions "$prompt")"
```
which, under `set -euo pipefail`, aborted the handler on a non-zero `claude` exit while its stdout (carrying the error text) was captured into `$out` and discarded — leaving only triager.sh's generic `die` in the journal.

That line no longer exists. The exact fix the spec sketches landed in commit **`03f33d7f1`** ("triager-claude: log claude's exit code and stderr instead of swallowing the failure"), an ancestor of HEAD/`origin/main2`. The current handler (lines 94–121) is a superset of the requested behavior:

- `if out="$(claude ... 2>"$errfile")"; then break; else rc=$?; …` — captures the exit status explicitly instead of letting `set -e` abort silently.
- Logs a combined diagnostic `stderr=[…] stdout=[…]` (both tails via `tail -c`, so short messages aren't lost — closing the "empty tail" gap when `claude -p` errors to stdout).
- On persistent failure, `die` carries that diagnostic into the failure path, so a self-heal responder gets a real signature.
- Still returns non-zero → triager.sh leaves the cursor unadvanced → the change re-triages on the next tick. Success path unchanged.

Three later commits hardened it further: `a8b87df68` (bounded 3-attempt retry with backoff), `921b8444f` (stdout tail logging), `d486643cf` (cold-start `git log` range fix).

## Divergence from the literal spec

The spec said "do not add retries." A bounded retry *was* added later (`a8b87df68`) as a deliberate peer/maintainer decision — it absorbs transient API/DNS/quota blips in-tick rather than burning a self-heal responder on a fault that self-recovers in seconds. It still fully preserves this job's core goal (surface the failure reason) and the non-advancing-cursor retry semantics. Reverting it to satisfy the spec's wording literally would undo intentional later work, so I did not.

## Changes / verification

- No files changed; `bash -n` passes; the vulnerable pattern is gone (only the guarded form at line 98 remains). Nothing to commit or push.

## Follow-ups

- None. This was a self-heal job that raced with peer self-heal commits on the same handler; the fix has already deployed. The originating failure on `garden-triager@kriscendobot-minion.town` will now surface its cause in the service log tail.
