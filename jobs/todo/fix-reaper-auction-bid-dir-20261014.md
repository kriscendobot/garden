---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix reaper.sh: auction_bid_dir not defined on the superseded-job path

`scripts/jobs/reaper.sh` (~line 1031, the SUPERSEDED branch) calls `auction_bid_dir`, which is defined only in `scripts/jobs/auction.sh:42` and never sourced by the reaper. Journal shows `reaper.sh: line 1031: auction_bid_dir: command not found` on 2026-10-14 after the unexpected shutdown. Effect: the bid-dir cleanup is silently skipped for superseded jobs.

Source or inline the helper the way sibling scripts do (check how other scripts reach it), add a test that exercises the SUPERSEDED path with a bid dir present, and land on main2 directly (garden repo, no PR). Also grep the reaper for any other helper called but not sourced.
