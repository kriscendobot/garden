Inbox is empty. Design delivered and PR opened.

## Completion report

**Job:** designer — remove the toy "minion" tools and prune the demo-only OAuth scopes (follow-up to kriscendobot/minion.town PR #18 approved review).

**What I did:**
- Traced the full blast radius of the toy tools and their scopes across the repo: `src/server.ts` (three tools + in-memory `minions` Map), `src/auth/scopes.ts` (`SCOPES`, `TOOL_SCOPES`), `src/auth/accounts.ts` (`Role`/`ROLE_SCOPES`), `src/config.ts`, `src/http.ts`, `config/policy.json`, `infra/lib/minion-town-stack.ts` (Cognito resource server + PKCE client scopes), `deploy/aws/systemd/minion-mcp.service`, the `www/{index,connect}.html` pages, `DEPLOYMENT.md`, `dev/client.ts`, and the test suite.
- Confirmed the key coupling: `mcp/tools` (route-level auth gate, `http.ts`) and `mcp/guest` (daemon-guest admission, `authorizeGuest`) gate the **real** product and must survive; only `mcp/minions:read`/`:write` are demo-only. This aligns with the maintainer's own directive of record in `designs/mcp-endo-guest.md` (OAuth scopes are the thin outer auth layer; real authZ is object capabilities behind the tools).
- Wrote `designs/remove-toy-tools-and-prune-minion-scopes.md`: enumerates exactly what's removed vs. kept; decides `minion_status`'s fate (recommend replacing with a minimal non-toy `whoami` baseline tool so `mcp/tools` stays tool-level-exercised and the server is never toolless when Endo is unmounted); decides the `resident` role's fate (it collapses into `guest` once `minions:read` goes — recommend collapse now, reintroduce `resident -> [mcp/tools, mcp/guest]` in daemon-guest increment B4); details the Cognito resource-server/PRM deploy ordering; and hands off a builder decomposition.
- Validated the mermaid diagram parses (parse-only checker, `flowchart` OK).

**What changed:** one new design file on branch `design/remove-toy-tools-and-prune-minion-scopes`, opened as **PR #30** against `main` (ready for review, per the project's design-delivery-is-PR-review rule). Does not block PR #18.

**Follow-ups / open questions for the maintainer (in the PR):** (1) `whoami` replacement vs. delete `minion_status`; (2) collapse `resident` now vs. repurpose its grant to `mcp/guest` in this PR (which would make it a partial B4); (3) whether to strip the dead `default.scopes` note in `policy.json` (recommend leave). A builder takes the actual removal PR once the two decisions land. Note surfaced: `mcp/guest` is currently granted by nothing, so the guest tools are unreachable until B4 regardless — the `resident -> mcp/guest` grant is B4's natural home.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-remove-toy-tools-scopes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (2216915 cached reads)
- Output: 21118 tokens
- Cost: $2.5299764999999996
- Wall-clock: 361s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
