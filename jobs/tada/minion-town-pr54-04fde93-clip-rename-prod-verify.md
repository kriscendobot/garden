Verified production against PR #54:

- Frozen DNS domain, `endo-weblet-store` ownership, and `"weblet-v1"` ID derivation remain intact.
- No live `WEBLET_*` environment assignments or drop-ins remain; `CLIP_SITES_LIVE=1` boot succeeded.
- `/mcp` exposes only the four `clip_*` tools. Publish/list/unpublish and both new/legacy URL serving passed; `weblet_publish` returned tool-not-found.
- Updated `minion/test-cc-client` metadata from retired scopes to `mcp/tools mcp/guest`.
- No old tool references remain in active project or garden code. Historical journal/e2e records and one active bulletin note still use old names.
- Existing `weblet-gateway.caddy` residue is owned by the separately posted caddy-prune job.
- No repository changes were needed. Results were posted durably to the journal.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr54-04fde93-clip-rename-prod-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 834s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
