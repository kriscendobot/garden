Completed B4 on https://github.com/kriscendobot/minion.town/pull/19 (head `c8c10a2`).

- Added TTL-snapshot isolation and test coverage proving suspension denies on the first post-TTL guest-tool revalidation.
- B4 guest tools, `mcp/guest` wiring, facet grants, and local two-tenant coverage are present on the stacked B4 branch.
- Verified: `npm run build`; focused tests; 136 passed, 3 real-daemon tests skipped.

Follow-up: B3 remains the PR base; merge it before B4. Live edge validation was not possible: `https://minion.town/healthz` timed out and AWS CLI is unavailable, so no real-identity or browser evidence was claimed.
