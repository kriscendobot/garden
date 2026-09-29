Root cause: expected behavior, not a gateway defect.

- The example clip’s live vhost record contains only `contentRoot`; it has no `directoryId`. The gateway therefore intentionally takes the `!record?.directoryId` branch and returns `404 no such clip`.
- The example content URL returned HTTP 200; its bootstrap endpoint returned HTTP 404 with `Cache-Control: no-store`.
- Published powered probe `fo5v4at4jovk76vln4vcjkpdi2kdmzvb5s4ees5zeo3kn2a7tfka.ocap.site`. Its record has `directoryId`, and its bootstrap endpoint returned HTTP 200 with `endo:2bbb5e027c4baaaffaab6f2a24a9e346943666a1ecb8424bb923b6a6e81f9954`.
- `test/gateway/powers-plane.test.ts`: 18/18 tests passed.
- No source changes or PR were needed.

Follow-up: the supported `unpublish` and `listSites` tools repeatedly returned `Connection stream ended`, so the probe remains live. Reported this project-specific cleanup issue to the liaison as message `20260929T092712Z-399d87`.

Self-improvement: recorded the clip-cleanup tool failure for liaison follow-up; no role or skill files changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-clip-ocapn-bootstrap-404.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 267s

<!-- garden-usage-end -->
