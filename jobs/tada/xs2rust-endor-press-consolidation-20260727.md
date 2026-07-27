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
