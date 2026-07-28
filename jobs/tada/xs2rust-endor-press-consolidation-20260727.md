# Consolidation: ten redundant xs2rust press dispatches retired

Retired 10 stale dispatches of the standing press
`schedules/xs2rust-endor-press.md`. Every one carried `model: qwen3.6` (the
pre-redirect schedule body) and was stale-claimed by a local hermit that stopped at
2026-07-27T22:06:57Z, so none could make progress; the reaper was recycling them
between `doin/` and `todo/` where no live worker would take them.

The ten bodies were byte-identical apart from `<!-- garden-reaped: N -->` counters
and `claimed_at` stamps — ten copies of one charter, not ten units of work. No
per-base completion report is written because none of them produced any: no commits,
no pushes, no reports.

Retired:
  - xs2rust-endor-press-20260727-035010
  - xs2rust-endor-press-20260727-105002
  - xs2rust-endor-press-20260727-115015
  - xs2rust-endor-press-20260727-125027
  - xs2rust-endor-press-20260727-150502
  - xs2rust-endor-press-20260727-160502
  - xs2rust-endor-press-20260727-170531
  - xs2rust-endor-press-20260727-192007
  - xs2rust-endor-press-20260727-202011
  - xs2rust-endor-press-20260727-213502


Replaced by the serial orchestration **xs2rust-endor-finish-line**, which bins the
charter's three finish-line bars into one job each, pinned `model: claude-opus-5`
with `handler-timeout: 10800`:

  1. xs2rust-endor-s1-daemon-integration — wire the Rust engine into the endor daemon
  2. xs2rust-endor-s2-test-rust-green    — drive `test:rust` to green
  3. xs2rust-endor-s3-test262-parity     — meet the differential test262 bar

Not retired: `xs2rust-endor-press-20260727-182001`, repinned to opus earlier today
and actively claimed by ps23/gardener-2 — a live job is not yanked out from under its
worker.

Note: these were removed by a producer-clone edit rather than `complete-job.sh`, so
no `reputation/` events were recorded for them. That is deliberate — a reputation
event for a job no worker ever ran would be noise.

---

## Sweep 2: the parked poison graveyard (51 more)

Also retired: **51** parked dispatches of the same standing press, spanning
`20260720-022510` → `20260727-095001`. Every one was a reaper POISON record (`poisoned: true`), not
pending work — the reaper parks a dispatch here once it exhausts requeues or overruns
its deadline. All carried the same charter; they differed only in `poisoned_at` /
`posted_at` stamps and the pin of the day (50 × `qwen3.6`, 1 × `fable` from an
earlier pinning of the press).

The files are gone; their diagnostic signal is preserved here in aggregate:

| measure | value |
| --- | --- |
| parked dispatches retired | 51 |
| poison signature: requeue-exhausted | 29 |
| poison signature: deadline-overrun | 22 |
| total requeue cycles burned | 177 |
| total deadline overruns | 22 |
| poisoned on endolin-garden-ece02cb4 | 51 across both hosts |
| window | 2026-07-20 → 2026-07-27 |

**What those numbers say — corrected 2026-07-28 from the failure captures.** An
earlier revision of this record blamed the whole graveyard on the missing
`handler-timeout:`. The transcripts say that explains only about half of it. The 51
poison records split into two distinct failure modes:

**Mode 1 — deadline-overrun (22 records, the 2026-07-20/21 era).** Genuine long work
killed at the wall: the job carried no `handler-timeout:`, so each dispatch was
SIGTERM-killed at the 40-minute default (`rc=124, elapsed ~= GARDEN_HANDLER_TIMEOUT=2400s`),
requeued, and killed identically next cycle. The reaper's own notice named the triage:
"split the job, raise GARDEN_HANDLER_TIMEOUT for this work, or fix what makes it run
long." The replacement bins do the first two — one bar each, `handler-timeout: 10800`.

**Mode 2 — requeue-exhausted (29 records, and every one of the ten in-flight jobs
above).** NOT slow at all: the handler failed in 3-15 seconds with `rc=1`, every time.
The captured output gives the reason verbatim:

    ERROR codex_models_manager::manager: failed to refresh available models:
      ... body: {"object":"list","data":null}
    {"type":"error","message":"unexpected status 404 Not Found:
      model 'qwen3.6' not found, url: http://127.0.0.1:11434/v1/responses"}

The local Ollama endpoint serves **no models at all** — `GET /api/tags` returns
`{"models":[]}` and `ollama list` is empty — so every `model: qwen3.6` job 404s on its
first turn. Across error entries from 2026-07-24 to 07-27 whose capture blobs are still
resolvable on this host, **99 of 100 carry this exact signature** (1 other, 37 blobs
held only on the peer host). The oldest sampled instance is 2026-07-26T15:33Z, so the
endpoint had been empty for at least two days before the redirect.

This reframes the redirect to Claude: it was not a preference change, it was the only
model that could run at all. It also means the hermit fleet is dead weight until the
local model store is repopulated — and that the routing table's `local qwen* qwen3.6`
default currently names a tag the box does not serve.

A third mode is referenced in the fleet code but did not appear in this graveyard's
poison signatures: the "exit-0-unsatisfying wedge" (`gardener.sh:671`, which names the
xs2rust-endor-press wedge by name) — a handler exiting 0 without the completion signal
at near-constant elapsed, e.g. 542s across consecutive cycles on
`xs2rust-endor-stage10n-remeasure`.


Retired in this sweep:
  - xs2rust-endor-press-20260720-022510
  - xs2rust-endor-press-20260720-123515
  - xs2rust-endor-press-20260720-145005
  - xs2rust-endor-press-20260720-172003
  - xs2rust-endor-press-20260720-192031
  - xs2rust-endor-press-20260720-203502
  - xs2rust-endor-press-20260720-215002
  - xs2rust-endor-press-20260720-230516
  - xs2rust-endor-press-20260721-002001
  - xs2rust-endor-press-20260721-022003
  - xs2rust-endor-press-20260721-043501
  - xs2rust-endor-press-20260721-053503
  - xs2rust-endor-press-20260721-063505
  - xs2rust-endor-press-20260721-100501
  - xs2rust-endor-press-20260721-122001
  - xs2rust-endor-press-20260721-143501
  - xs2rust-endor-press-20260721-165010
  - xs2rust-endor-press-20260721-180501
  - xs2rust-endor-press-20260721-202001
  - xs2rust-endor-press-20260722-012002
  - xs2rust-endor-press-20260722-033502
  - xs2rust-endor-press-20260722-045001
  - xs2rust-endor-press-20260722-055018
  - xs2rust-endor-press-20260726-012007
  - xs2rust-endor-press-20260726-023504
  - xs2rust-endor-press-20260726-035002
  - xs2rust-endor-press-20260726-045004
  - xs2rust-endor-press-20260726-060501
  - xs2rust-endor-press-20260726-070504
  - xs2rust-endor-press-20260726-082003
  - xs2rust-endor-press-20260726-093506
  - xs2rust-endor-press-20260726-103521
  - xs2rust-endor-press-20260726-115001
  - xs2rust-endor-press-20260726-125016
  - xs2rust-endor-press-20260726-140502
  - xs2rust-endor-press-20260726-150502
  - xs2rust-endor-press-20260726-160502
  - xs2rust-endor-press-20260726-170508
  - xs2rust-endor-press-20260726-180521
  - xs2rust-endor-press-20260726-192001
  - xs2rust-endor-press-20260726-202002
  - xs2rust-endor-press-20260726-212016
  - xs2rust-endor-press-20260726-223501
  - xs2rust-endor-press-20260726-233502
  - xs2rust-endor-press-20260727-003508
  - xs2rust-endor-press-20260727-013518
  - xs2rust-endor-press-20260727-025003
  - xs2rust-endor-press-20260727-050502
  - xs2rust-endor-press-20260727-072006
  - xs2rust-endor-press-20260727-083507
  - xs2rust-endor-press-20260727-095001
