---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: aws
Repository: kriscendobot/minion.town.

Complete the post-deployment acceptance criterion handed off by
`minion-town-remove-mcp-tool-prefixes`. PR
https://github.com/kriscendobot/minion.town/pull/75 merged as
`7f0b8f9a25573a38a5259c5671acf9a4f6035b23`, and continuous deployment run
https://github.com/kriscendobot/minion.town/actions/runs/33539977066 succeeded.

Using the sanctioned `minion/test-cc-client` credential and the live
`https://minion.town/mcp` endpoint, attach the MCP to a fresh agent with no
repository or prior minion.town context. Give that agent exactly the directive
`evaluate 2 + 2`. Record the tools/list-driven tool choice, arguments, MCP
result, and final answer without giving the agent hints beyond the directive.
State whether discovery documentation alone led to the canonical `evaluate`
call and result 4. If it did not, post explicit named follow-up job(s) for every
documentation deficiency and cite them in the completion report. Never expose
the client secret or bearer token in logs, prompts, commits, or the report.
