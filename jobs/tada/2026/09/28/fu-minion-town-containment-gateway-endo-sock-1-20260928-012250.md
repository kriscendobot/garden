**Containment drift check, 2026-09-28: nothing has changed, so I sent no maintainer alert.**

I scanned `/var/lib/endo-gateway/store/vhosts/` on `i-0380cd68b90020fad` through SSM Run Command. The scan walked every subdirectory and matched record contents with whitespace ignored. It made no changes on the host.

- **Scan finished:** it read all 55 active vhost records, and none were unreadable.
- **The three de-registered records** (`f1d754fc…`, `fe0a8e60…`, `09201a316203…`) are still absent from the live store: no filename or content match. Each is still in `vhosts-revoked-20260812/`.
- **Records owned by dckc** (matched by the Cognito user ID `8929a9ae-…`): 20, the same count as 09-25 and 09-26. Earlier reports only gave the count, not the record IDs, so I compared by count. I found no unexpected record. This run's IDs are:
  - `0d579e87`, `0eef1d5e`, `18f537bd`, `1ef7b546`, `2d0c17f0`
  - `2d6d5649`, `32e492ff`, `4e064419`, `7736f637`, `806fc2ea`
  - `98a1ff7d`, `a64dae8b`, `b34347e4`, `b800cf58`, `c016601e`
  - `cd9cf344`, `d15c56a8`, `eddab2e6`, `f5cdf187`, `fc2e7aee`
- **Records with a `powers` value:** the same 4 as 09-26.
  - Two are dckc's old records, already judged harmless: `806fc2ea` (`counter`) and `c016601e` (`@none`).
  - Two belong to other owners: `f220b5fe` (`powers-fixture`) and `a0eeea3c` (`formula:live-deploy-verification`).
- I did not check the systemd containment drop-in, as the job says. The open powers plane is the authorized state under issue #58.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260928-012250.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (374137 cached reads)
- Output: 2781 tokens
- Cost: $0.47164739999999994
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
