Containment check completed via SSM (`20462714-5798-4415-8a2d-cab23e116641`, Success).

- The two originally revoked records remain absent from the active store and preserved in the revoked directory.
- The systemd drop-in remains intact and effective; its SHA-256 matches, the gateway is active, and `GATEWAY_ENDO_SOCK` is absent from the live process.
- Found a different active dckc-owned `@agent` record, apparently restored during the August 23 gateway restart. The powers plane still contains it: external verification returned HTTP 404.
- Reported the recurrence to the maintainer inbox (`20260825T025457Z-be0f26`). I did not revoke this third record because the job’s remediation authorization names only the two original records.
- No repository changes or commits.

Self-improvement: reported the whitespace-sensitive record-scan pitfall; yesterday’s exact JSON match missed this pretty-printed record.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260825-025004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 264s

<!-- garden-usage-end -->
