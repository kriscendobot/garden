Verified commit `bc4ef70` live via GitHub Actions and SSM:

- Both full deploy runs succeeded through app and endo-gateway.
- Services restart active; shared group, ownership, mode `2775`, supplementary groups, and `ReadWritePaths` are correct.
- No legacy files/ownership or publish writes outside the store were found.
- PKCE `weblet_publish` → gateway fetch returned HTTP 200 with exact expected content; fresh `0644` files were gateway-readable.
- Fixture seeding remained idempotent across two runs.
- Posted the full evidence and transcript on kriscendobot/minion.town#27.
- No code changes or follow-ups required.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-bc4ef70-verify-weblet-publish-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 248s

<!-- garden-usage-end -->
