Item 1: The permanent host-escape fix is confirmed running in production.

- Read-only SSM command `4bf20471-a17b-4804-978c-9c6616ebfe27` succeeded. `endo-gateway.service` was active as PID `1621352`, started `2026-08-30 05:57:29 UTC`, with the powers plane enabled.
- Five live gateway artifact SHA-256 values exactly matched a clean TypeScript build of deployed main commit `199a06138d6e259dcbd215079847f9d6d481c696`. That commit contains `affa345` (`feat: publish weblets through guest site directories`), which removes caller-controlled gateway top-host powers resolution. The live artifact uses site-directory `back` capabilities and contains no legacy host resolver or host-shape blocklist.
- This is the object-capability redesign that superseded PR #44; PR #44 itself was closed unmerged.
- Recursive read-only SSM scan `d7422439-5e11-41df-99e7-968e4057c32d` found neither original record active. Both `f1d754fc...` and `fe0a8e60...` remained in `vhosts-revoked-20260812/`.
- Initial command `c0e20028-6686-4d0c-9fb6-7d11ae332e70` produced service/process evidence but failed its git probe because production is an artifact rather than a git checkout; the successful artifact-hash comparison superseded that probe.

Item 2: The third record was de-registered.

- The recursive precheck found `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f.json` active under `store/vhosts/`. It validated as dckc-owned with whitespace-normalized powers `@agent`.
- Authorized SSM command `92b664b7-f441-46b6-ab8f-c503c695b16d` moved it to `store/vhosts-revoked-20260812/`.
- The command returned all three records as `active=0 revoked=1`, `ACTIVE_AGENT_RECURSIVE_COUNT=0`, and `ACTIVE_PARSE_ERROR_COUNT=0`.
- Independent SSM postcheck `31e28935-0cf1-4149-9fed-e04aef688bd9` again found the third record only in the revoked store and zero active `@agent` records. External requests to its bootstrap and root URLs both returned HTTP 404.

Follow-up: the August 30 and 31 root-only scans missed the active third record because active records now live under `store/vhosts/`. Any retained check must scan recursively while excluding revoked directories; retiring or repurposing the obsolete schedule remains recommended. The maintainer was notified between items and again after completion. No repository changes, commit, or push were required.

Self-improvement: no garden-library change; reported the project-specific recursive active-store scan pitfall to the maintainer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-gateway-containment-verify-20260831.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 852s

<!-- garden-usage-end -->
