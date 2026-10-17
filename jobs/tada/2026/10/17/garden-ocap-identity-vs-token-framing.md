**Completion report: garden-ocap-identity-vs-token-framing**

I pushed the maintainer's ruling to `main2` as commit **`0359b614c2e`**. The ruling: a bearer token fits with object capabilities unless it designates an identity. I didn't open a PR, per CLAUDE.md § Conventions.

Changes:
1. **`roles/jurors/decomplector/AGENT.md`**: new operating norm, "'Bearer token' alone is never a finding." The juror must ask whether the token designates one specific attenuated object (which is a capability) or an identity with ambient or master authority. It flags only the identity-shaped token and names what that token unlocks beyond the operation at hand. Quoting a design's "not a bearer token" line is no longer enough. The provenance is the kriskowal ruling from the liaison session on 2026-10-17, prompted by the minion.town #180 review and the parent design §7 citations.
2. **`skills/ocap-attenuation-authoring/SKILL.md`**: added the same test as a bullet under Notes, with the same provenance. The stub is still a placeholder, not a procedure.
3. **Other jurors:**
   - **`locksmith`**: one sub-bullet under its identity-keyed authorization finding, saying a bearer token is not identity-keyed in itself. It links to the decomplector norm. This seat is the most likely to repeat the misreading.
   - **`breaker`**: one sentence in its section on capability attacks, saying a token for one attenuated object is not a break. It also links to the decomplector norm.
   - **`warden`** and **`gateway`**: no edits. The warden mentions capabilities only for `harden` at boundaries, and the gateway reviews repo-root config files. Neither talks about tokens.

I set `updated:` to 2026-10-17 in the frontmatter of all four files.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-ocap-identity-vs-token-framing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (221806 cached reads)
- Output: 3194 tokens
- Cost: $0.47596120000000003
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
