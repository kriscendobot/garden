All work verified and complete. Worktree cleaned, inbox empty.

---

## Completion report: `improve-drift-scan-timer-oncalendar-persistent`

**What I did.** Converted the garden's relative-window maintenance timers from the `OnActiveSec`/`OnUnitActiveSec` monotonic pair to absolute wall-clock `OnCalendar` + `Persistent=true`, eliminating the indefinite first-elapse deferral. Committed `61ce9f2c3` to `main2`, fast-forwarded the live `/home/kris` tree, re-rendered+reloaded via `install-units.sh install`, and verified.

**Root cause confirmed.** `repo-watcher.sh` calls `daemon-reload` **unconditionally every 1 minute** (plus deploy-sync/install-units), which keeps re-arming any relative timer whose first-elapse window exceeds that cadence. The window never elapses, the service never runs, so `OnUnitActiveSec` never engages. Two timers were caught never-fired (`LastTriggerUSec=` empty): `library-source-drift-scan` and `journal-worktree-keeper`.

**Spec correction (please note).** The mandated expression `OnCalendar=*:07/60` is **invalid** — systemd rejects a step of 60 on the 0–59 minute field (`Failed to parse … Invalid argument`). I used the valid spelling of the identical intent, `OnCalendar=*:07` (minute 7 of every hour), verified with `systemd-analyze calendar`, and documented the why in the unit comment.

**Timers converted** (7, all `OnActiveSec >= 10m`, all `Persistent=true`):
| timer | OnCalendar | was |
|---|---|---|
| clone-keeper | `*:00/30` | 10m/30m (kept ahead of the audits) |
| library-source-drift-scan | `*:07` | 20m/1h |
| journal-worktree-keeper | `*:15/30` | 10m/30m (never-fired victim) |
| mentor | `*:20/30` | 30m/30m |
| reaper | `*:03/10` | 10m/10m |
| follow-up | `*:08/10` | 10m/10m |
| scheduler | `*:05/15` | 15m/15m (Persistent now catches up missed dispatch) |

Minute offsets preserve the original ordering intent (clone-keeper at :00/:30 freshens the bare clones before drift-scan audits them at :07 and worktree-keeper at :15/:45).

**Verification.** After reload, `list-timers` shows realtime `NEXT`/`LAST` for all seven. Both never-fired victims fired immediately via Persistent catch-up (`LAST 20:17:20`). The drift-scan oneshot ran to `success` and posted **all 4 predicted drifts** as new jobs — `scholar-refresh-endo--packages-{ses-src-error-console,ses-src-error-assert,captp-src-finalize,netstring-reader}-js` — then re-armed at `NEXT 21:07:00`.

**Deliberately not converted.** Sub-10m high-frequency pollers (gardener-scaler 1m, repo-watcher 1m, watchman/deadmail/mirror-closer 2m, deploy-sync/unblock 3m, proxy 5m, mention-watcher 90s): their small first-elapse window lands reliably between reloads, and minute-granularity wall-clock is too coarse for them. The `@`-instance timers (comment-watcher, triager) and issue-inbox already use the `OnBootSec` fixed-anchor hardening for the same bug.

**Follow-ups.**
- The 4 newly-posted `scholar-refresh-*` jobs are now on the board for scholars to claim (the drift backlog that had been invisible while the timer was wedged).
- `garden-foreman.timer` is `inactive (dead)` via a `pause.conf` drop-in (`exec-condition` skip) — a **deliberate pause**, not the timer bug. Left untouched, but flagging in case the pause is stale and foreman should be resumed.
