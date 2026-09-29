**Containment drift check, 2026-09-29: nothing has changed, so I sent no maintainer alert.**

I scanned `/var/lib/endo-gateway/store/vhosts/` on `i-0380cd68b90020fad` through SSM Run Command (`AWS-RunShellScript`, a Python `os.walk` over every subdirectory). It matched filenames and whitespace-ignored record contents, and made no changes on the host.

- **Scan finished:** it walked 56 files and read and parsed all of them; none were unreadable. That is one more record than the 55 on 09-28. The new one is not dckc's and has no `powers` value, so it does not affect this check.
- **The three de-registered records** (`f1d754fc…`, `fe0a8e60…`, `09201a316203e9d9…`) are still absent from the live store: no filename or content match. All three are still in `vhosts-revoked-20260812/`.
- **Records owned by dckc** (matched by the Cognito user ID `8929a9ae-…`): 20, the same record IDs as the 09-28 list (`0d579e87` … `fc2e7aee`). None are unexpected.
- **Records with a `powers` value:** the same 4 as 09-28.
  - Two are dckc's old records, already judged harmless: `806fc2ea` (`counter`) and `c016601e` (`@none`).
  - Two belong to other owners: `f220b5fe` (`powers-fixture`) and `a0eeea3c` (`formula:live-deploy-verification`).
- I did not check the systemd containment drop-in, as the job says. The open powers plane is the authorized state under issue #58.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260929-013606.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (429489 cached reads)
- Output: 2680 tokens
- Cost: $0.5021777999999999
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
