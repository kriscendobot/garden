**Undraft report: kriscendobot/minion.town#238** ("design(agents): API-key agent workbench — endowments, budgeted spawner, git VFS tools")

The PR is now out of draft, at the same head the panel passed (`d94936ffb7340030dcc547c8a096be444d4e0e0e`).

**What I did**
- **Gate check before changing anything:** the PR was OPEN and still a draft, and its head was exactly `d94936ff…`, so I ran `gh pr ready`.
- **Check afterwards:** `isDraft` is now false and the head is still `d94936ff…`.
- **Advisory appellate pass:** I ran a light `claude -p` review over the diff. The diff was cut to its first 40 KB before review, so later parts went unread. The findings are below and did not block the undraft.

**What the appellate pass flagged (for the maintainer to look at)**
- **Pausing an agent doesn't stop it right away:** `pause()` without `cancelInFlight` lets the current turn finish, so a paused child can still spend its full reservation plus any overrun.
- **Overruns have no upper limit:** the spending reserve is only checked after a turn settles, and nothing limits how far a settlement can go past its reservation. Pausing a whole subtree because one grandchild overran also lets one bad grandchild stop its siblings.
- **Forwarded grants:** forwarding (open question 6) charges the sibling's budget, not the forwarder's. That is a confused-deputy and budget-theft path. `AgentInference` is a bearer capability that isn't tied to whoever holds it.
- **Lease takeover:** it relies on an exclusive lock on the state directory that the design hasn't confirmed exists. If the lock is missing, two brokers could both admit work.
- **Workbench confinement is not spelled out:** the design doesn't say how a child's access is checked as a "subset" of its parent's when symlinks, denied path segments and git tiers are involved. The `glorp`/`grep` tools also leave regex denial-of-service and symlink escape open.
- **`endow`:** the design doesn't say whether it binds to the stored formula or to the pet name. It also doesn't say how the "durable formula only" check tells durable values from temporary ones.
- **`revoke`:** it doesn't say where usage that arrives late is charged after a grant is deleted, or what happens to the revoked agent's children.
- **Status and evidence:** five code claims are still unverified, and phase W3 depends on a change to a design that hasn't merged yet.

Nothing in the garden repo changed, and nothing was committed.

**Follow-up:** the maintainer may want to review open question 6 (forwarded grants) and the missing limit on overruns before accepting the design.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr238-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179361 cached reads)
- Output: 1817 tokens
- Cost: $0.43268419999999996
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
