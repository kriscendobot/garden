Inbox is empty. Work is complete and pushed.

## Completion report

**Job:** `improve-cursor-outage-herd-suppression` — make `cursor-get.sh` latch journal-read outages so cursor consumers skip quietly during a shared cooldown, instead of every triager/comment watcher re-fetching and re-warning per repo; preserve loud structural/auth failures.

**What I did**

Added a **host-shared journal-read outage cooldown** — the direct sibling of the existing gh-api cooldown (`start_api_cooldown`/`api_cooldown_active`), for the different herd that hits the journal-clone fetch rather than the GitHub API.

- **`scripts/jobs/common.sh`** — new helpers `journal_outage_active` / `start_journal_outage_cooldown` / `clear_journal_outage_cooldown` and `_journal_outage_secs`. The latch is a flock-atomic marker under `GARDEN_ROOT/.garden-state/journal-outage-cooldown` (host-wide, resolved below `GARDEN_ROOT` so it's shared across watcher kinds and independently-namespaced `GARDEN_STATE`s). Window `GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS` (default 120s, capped 900, 0 = disabled). An observer never extends a live window; `active()` reaps expired markers; the healthy path is a single `stat` (no flock) when no marker exists.
- **`scripts/jobs/cursor-get.sh`** — consults the latch **first** (immediate `GARDEN_OFFLINE_RC`, no fetch, no warning, when a sibling already latched). Otherwise it runs `sync_clone` in a **subshell** so the offline `exit` can be classified rather than propagated: an EX_TEMPFAIL offline exit latches the cooldown (the winning tick owns one warning) and returns quiet; **any other nonzero rc — a non-offline `die`, i.e. a structural/authentication failure — is re-raised unchanged**, never masked. A successful read clears a stale marker (belt-and-suspenders for the cooldown-toggled-off edge).
- **Four consumers** (`comment-watcher.sh`, `triager.sh` ×2 sites, `mention-watcher.sh`, `issue-inbox-watcher.sh`) now skip **quietly** on `GARDEN_OFFLINE_RC` and keep **WARNing** on any other nonzero rc.
- **`scripts/jobs/test/cursor-outage-cooldown-test.sh`** — new focused test, wired into CI's focused-test list.

**Verification (ran, observed)**
- New test: `23 passed, 0 failed` — covers helper semantics (host-wide resolution, atomic single-latch under 8-way concurrency, observer-no-extend, clear, expiry-reap, disabled) and cursor-get end-to-end (short-circuit-on-live-latch, latch-on-detection, **herd suppression proven by a sentinel showing the fetch is never invoked while latched**, window-bounded recovery, and loud re-raise of a non-offline failure with no latch written).
- Sibling `api-cooldown-test.sh`: `6 passed, 0 failed` (no regression).
- `shellcheck -S warning` (CI severity) on all six changed production scripts: exit 0; `bash -n` on the new test: ok.

**Pushed:** commit `fab63b7af6` → `origin/main2` (fast-forward, first attempt).

**Follow-ups:** none required. The cooldown window (120s) is env-tunable if operational experience wants it longer/shorter.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-outage-herd-suppression.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4567158 cached reads)
- Output: 49813 tokens
- Cost: $4.754215
- Wall-clock: 679s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
