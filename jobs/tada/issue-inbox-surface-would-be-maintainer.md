Done. Landed on `main2`.

## Completion report

**What I did:** Extended `scripts/jobs/issue-inbox-watcher.sh` so that when the maintainer-trust gate drops a non-maintainer author, it now *also* surfaces that individual once to the maintainer inbox — closing the gap where a genuine collaborator (the real case: mhofman on #29) was silently ignored.

**Changes to `issue-inbox-watcher.sh`:**
- New overridable seam `GARDEN_ISSUE_MAINT_SEND` (defaults to `inbox-send.sh`), mirroring the existing `GARDEN_ISSUE_POST` / `GARDEN_ISSUE_MSG` seams so the test can stub it.
- New `surface_would_be_maintainer()` helper: sends a `kind: access-request` maintainer-inbox message via `GARDEN_SENDER="issue-inbox-watcher"` (exactly as `identity-drift-guard.sh` emits its `kind: error` report). **Structured fields only** — author login (`@<author>`), `$REPO`, issue `#<number>`, and `$url`; the untrusted comment body never enters the message. Body names the individual, states they were dropped, gives the exact `add-maintainer.sh <login>` command, notes future comments will dispatch but this one was already dropped, that it shows once per person, and that reply/archive dismisses it.
- **Dedup** via a per-author marker at `$GARDEN_STATE/issue-inbox/notified-nonmaintainers/<lowercased-login>`, created *only after a successful send* (a failed send retries on the author's next interaction; no silent loss).
- Escape hatch: `GARDEN_NO_MAINTAINER_ALERT=1` suppresses the surface.
- Wired into the drop branch — the existing `log` + `dropped++` + `slide` + `continue` (dispatch nothing) are all **unchanged**; the surface is purely additive.
- Updated the header seam list and pipeline docstring.

**Changes to the test:** added a `MAINTSTUB` for `GARDEN_ISSUE_MAINT_SEND` (records target + stdin body), threaded a 10th `maintlog` param through `run_watcher`, and added test **L** asserting: (1) exactly one message per would-be maintainer, naming the author + add command + `kind` tag, with the comment body provably absent; (2) a second comment from the same author sends nothing (dedup); (3) a different author gets its own message; (4) drop behavior unchanged (nothing dispatched, `non-maintainer` + id still logged).

**Verification:** `issue-inbox-watcher-test.sh` → 38 passed, 0 failed. Related `issue-inbox-journal-linkage-test.sh` → 17 passed, 0 failed. `bash -n` clean; shellcheck shows only pre-existing warnings, none in the new code.

**Landed:** committed to `main2` directly (garden-meta change, no PR) and pushed (`adf354174..6a4dcddea`).

**Follow-up (out of scope, not done):** apply the same "surface the sender once" idea to the GitHub-wide mention-watcher's (`mention-watcher.sh`) sender-trust gate.
