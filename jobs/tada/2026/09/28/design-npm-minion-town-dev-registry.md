Completed the two-repository design:

- Draft [endojs/endo-but-for-bots#1361](https://github.com/endojs/endo-but-for-bots/pull/1361): npm publish/serve protocol, dated dev versions and tags, CAS/tree integration, full-graph read-through, and cold-client validation.
- Draft [kriscendobot/minion.town#134](https://github.com/kriscendobot/minion.town/pull/134): explicit Route53 provisioning, Caddy TLS, systemd hosting, durable state, secrets, and operations.

Both PRs use frozen bases and are mergeable. The designs explicitly establish that #879 does not block registry serving and defer production-npm promotion. Prettier, diff checks, Mermaid parsing, ownership-map checks, and Endo CI passed. GitHub reported no checks for the minion.town PR; its local documentation gates passed.

Follow-up: both drafts await an explicit “run the gauntlet” request. No implementation, DNS, service, secret, or live publication changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-npm-minion-town-dev-registry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2026s

<!-- garden-usage-end -->
