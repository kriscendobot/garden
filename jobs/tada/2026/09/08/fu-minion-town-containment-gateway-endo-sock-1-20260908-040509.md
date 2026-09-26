The recursive scan is clean and matches the 2026-09-07 baseline exactly. This is a quiet no-change pass — no maintainer inbox alert, no code changes.

# Completion Report — containment drift check (2026-09-08 tick)

**Clean no-change pass**, reported quietly per the job's instructions (no maintainer inbox message).

## What I did
Ran a **recursive** read-only scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM `AWS-RunShellScript`. Matched the three de-registered hashes by **both filename and whitespace/format-tolerant content**, inventoried every dckc-owned and powers-bearing record, checked for host-shaped escape powers, and cross-checked the revoked store.

## Findings (all match the 2026-09-07 baseline)
- **Store is a flat directory** (`find … -type d` returns only the store itself) — 54 `.json` files, no nested subdir, so no root-only-glob blind spot.
- **All three de-registered records remain ABSENT** from the active store — `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — zero filename hits and zero content hits anywhere in the active tree. All three are present in `vhosts-revoked-20260812/`.
- **No unexpected active dckc-owned record.** dckc-owned set (Cognito sub `8929a9ae…`) is **20**, unchanged from baseline.
- **Powers-bearing records unchanged** — the same 4: `@none` (`c016601e…`), `counter` (`806fc2ea…`), `powers-fixture` (`f220b5fe…`, safe fixture), and `formula:live-deploy-verification` (`a0eeea3c…`, inert, non-dckc). **No host-shaped escape powers** (`@agent`/`@host`/`@self`/`@main`/`cw`) present.
- Total record count 54 — unchanged.

Per the retune, I did **not** assert the systemd containment drop-in; the powers plane is deliberately open under `kriscendobot/minion.town` issue #58, and that state is authorized, not drift.

## Changes
None. No garden-library edits, no commit, no maintainer inbox message (quiet no-change pass).

## Follow-ups
None. The check recurs daily; next tick re-runs the same recursive scan.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260908-040509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (426669 cached reads)
- Output: 6661 tokens
- Cost: $0.8251525000000002
- Wall-clock: 94s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
