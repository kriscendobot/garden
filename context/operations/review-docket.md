---
created: 2026-10-08
updated: 2026-10-08
author: builder
---

# Review docket operations

The clerk keeps maintainer review obligations in `journal2:review-docket/open/`
and renders the single maintainer-facing priority view at
[`PRIORITIES.md`](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md).
Records are not inbox messages: receiving an allowlisted formal review, or
observing a merged or closed PR, moves a generation into the dated retired tree.

## Normal operation

Garden producers call `scripts/jobs/review-docket-request.sh`; they must never
write a queue JSON file directly. Native GitHub review requests are imported by
`garden-review-queue.service`. `garden-review-docket-reconcile.timer` starts
`garden-review-docket-reconcile.service`, which re-reads every open PR every
five minutes and covers missed review/terminal events while refreshing head and
CI metadata. All three units are leader-only. The deploy unit
reconciler discovers and enables them from the tracked systemd sources.

The accountant remains the only allocation-policy writer. Every
`set-apportionment.sh` transaction invokes the clerk renderer before committing,
so an arc rank change and the resulting docket order land together. Review waits
do not consume arc headroom.

## Inspect and repair

Read the root document first, then inspect an individual open record when its
evidence looks stale:

```sh
systemctl --user status garden-review-queue.service
systemctl --user status garden-review-docket-reconcile.timer
journalctl --user -u garden-review-docket-reconcile.service -n 100
```

To request review manually, prepare a one-line summary and stable source id:

```sh
scripts/jobs/review-docket-request.sh \
  --url https://github.com/OWNER/REPO/pull/123 \
  --ask approve --source operator-OWNER-REPO-pr123 \
  --summary 'What this review unblocks'
```

To force a stateless repair pass, run
`scripts/jobs/review-docket-reconcile.sh`. Unknown GitHub state fails closed:
the open record remains visible. Do not delete or move records by hand.

## Archive and recovery

Every successful mutation rewrites that UTC day's snapshot under
`priorities-archive/YYYY-MM-DD.md` and regenerates the date index. Git history
retains same-day revisions. The initial migration's immutable audit material
starts at `<!-- review-docket-migration-appendix -->`; the renderer preserves
that marker and everything below it across same-day rewrites. Retired records live under
`review-docket/retired/YYYY/MM/DD/` and preserve their generation plus positive
review or terminal evidence. Repeating intake for the same source, head, and ask
is a no-op; a changed head or ask creates the next generation while preserving
`first_requested_at`.
