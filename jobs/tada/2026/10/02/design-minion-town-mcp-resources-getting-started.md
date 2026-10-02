The design is finished. The earlier attempt had already opened it as **draft PR kriscendobot/minion.town#147**, so this run only checked that the PR is complete and correct, and changed nothing.

**What I checked**
- `ensure-pr.sh --find-only` found #147 by its job marker. No duplicate PR was opened.
- #147 is a draft. Its base is a frozen snapshot, `main-af7af61`, and its head is `design/mcp-resources-getting-started`. It is 1 commit ahead and 0 behind. The only file in the diff is `designs/mcp-resources-getting-started.md` (367 lines).
- The design covers all four things the brief asked for:
  - **Which resources (§ 3):** seven standalone `minion-town://` markdown resources, including a getting-started guide, a publish-a-clip worked example and troubleshooting. A resource that documents a tool is listed only when that tool is mounted. § 3.1 flags that the garden's `powers: "sites"` advice is stale and unsafe, and requires the build to verify a safe recipe on production before the guide states it.
  - **Where it lives (§ 4):** a `resources/*.md` directory in the minion.town repo, served by a new `registerGuideResources` called from `createMcpServer`. Files are re-read on each `resources/read`, a content-only deploy script ships guide fixes without restarting the service, and a lint test bans garden-specific references.
  - **Validation (§ 6):** the confined subscription Claude isn't ready, because the endo-but-for-bots guest-bootstrap and sandbox PRs (#1407 and #1408) are still drafts. So the design uses a stand-in: a bare `claude -p` limited to minion.town's MCP tools and the two resource-reading tools, with no garden skills or prior context. It runs four tasks graded by an independent verifier, once before the resources ship and once after, and must pass at least 4 of 5 runs.
  - **The skill (§ 7):** the served guide is the single source. The garden skill shrinks to a pointer plus garden-only operations, and a probe plus a test catch drift between the two.
- The design also has an ownership map and a build-slices section.
- The one mermaid diagram passes the parse check.
- Commit e02555bca7f on main2 already marks the stale `powers: "sites"` advice in `skills/minion-town-clip-publishing/SKILL.md`. I didn't check whether the earlier attempt or another job made it.

**For the maintainer — § 9 has three open questions**
1. Which principal should the validation runs use?
2. Should the guide also be published outside MCP, as a web page or a downloadable skill bundle?
3. How does the confined in-guest Claude get the guide? Its MCP connection goes to `@endo/agent-mcp-stdio`, not this server.

The PR stays a draft. The completion machinery should schedule its design-panel review automatically, so I didn't post one by hand.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-mcp-resources-getting-started.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (386963 cached reads)
- Output: 3069 tokens
- Cost: $0.5907646000000001
- Wall-clock: 50s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
