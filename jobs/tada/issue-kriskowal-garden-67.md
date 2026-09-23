Job `issue-kriskowal-garden-67` complete.

## What the job asked

dckc filed kriskowal/garden issue 67: adding two Morpho v2 vaults to Ymax looked like configuration data only, so what would it take to have a `creatorFacet` method for adding new ERC-4626 vaults? Create a design, identify implementation risks, answer whether the static `InstrumentId` enumeration has to become dynamic and at what cost, and cover every component of `DESIGN-BETA.md` (contract, YDS, EMS, planner, resolver, UI).

## What I did

Read the current agoric-sdk at upstream master `70d307de7f` (`ymax-v0.3.2607-beta5`), fetched into the bot fork's bare clone. Diffed the two real vault-addition changesets (PR 12767 merge `999dc4420f`, PR 12822 merge `70d307de7f`) to establish the actual cost of adding a vault today, then traced every runtime and type-level consumer of the static enumeration across `portfolio-api`, `portfolio-contract`, `portfolio-deploy`, and `services/ymax-planner`.

Wrote a 572-line design doc and pushed it to the bot fork (no PR opened, per the upstream-untouched constraint):

- Branch `design-erc4626-vault-registry` on `kriscendobot/agoric-sdk`, commit `00832c69b0`
- `packages/portfolio-contract/docs-design/erc4626-vault-registry.md`

Replied on the issue with a substantive summary: https://github.com/kriskowal/garden/issues/67#issuecomment-5103619281 — issue left open (verified `state: open`).

## Findings that shaped the design

- **The blocker is not the durable state and not the TypeScript type.** The durable layer was already prepared for this on purpose, under an `Ext` naming convention: `PoolKeyShapeExt = M.string()`, `TargetAllocationShapeExt`, and critically the positions `MapStore` `keyShape` (durable store key shapes cannot be tightened later). `chainOf` already has a syntactic `${Protocol}_${Chain}` fallback; `isERC4626InstrumentId` is a prefix test, not a membership test. What blocks is the enumerated *patterns* `AssetPlaceRefShape` and `TargetAllocationShape`, which are module-scope constants and so cannot observe runtime state at all.
- **The enumeration is doing undocumented safety work.** `portfolio.exo.ts:1491` builds a `TargetAllocation` straight from EMS EIP-712 allocations under a `// XXX: validate instruments` comment; nothing validates them. The enumerated pattern is the only thing stopping an arbitrary string from becoming a position. Relaxing it removes that backstop, so the explicit registry check must land in the same change.
- **The resolver needs no change at all** (keys on wallet address, `txId`, tx type, never a pool key), and the **EMS wire format needs no change** (`Allocation.instrument` is already `string`).
- **`InstrumentId` does not have to be given up.** Recommended `KnownInstrumentId | (string & {})` open union plus a `ERC4626_${string}_${AxelarChain}` template-literal type. The widening is nearly free; the real cost is four validation entry points and their tests.
- **The dominant risk is not upgrade mechanics.** `supply` does `usdc.approve(vaultAddress, …)` then `vault.deposit(…)`, so one `creatorFacet` call now decides which contract the remote wallet approves USDC to, removing the code-review step that currently sits there incidentally. Proposed two-phase activation (`probationary` → off-chain attestation by the planner, which already has Alchemy RPC and an on-chain reporting seat → `active`), plus per-instrument deposit caps.
- **Async-flow replay divergence** forces an append-only address field: a vault whose address changes must be a new instrument id.
- **Version skew gets worse before better**: `yds-portfolio-balances.ts:96-98` currently throws on any YDS instrument the planner's compiled `PoolPlaces` lacks.

## Verification status

Design work only; no code changed, so no tests were run and nothing is claimed as verified beyond what I read and executed. What I did execute and observe: the two commit diffstats and diffs, the upstream fetch and checkout, every cited file and line number (spot-checked `portfolio.exo.ts:518-521`, `prod-network.test.ts:155-157`, `engine.ts:212`, `main.ts:377-391`), the branch push, the file's presence on the fork via the GitHub API (32137 bytes), and the issue's post-comment state (`open`, 1 comment).

## Follow-ups available if wanted

- Turn phase 0 (structural shapes plus explicit membership checks against the existing static list, no registry, no new authority) into an actual PR on the fork. This is where most of the correctness risk lives and it is independently shippable.
- Drill into the two-phase attestation mechanism against the resolver's existing invitation-based reporting path.

Constraints honored: all work in the per-job worktrees, no git in the garden root, no upstream `agoric/agoric-sdk` interaction, and no issue or PR cross-reference to upstream from the comment, the doc, or the commit message.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriskowal-garden-67.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 141 tokens (8498347 cached reads)
- Output: 52555 tokens
- Cost: $7.3804135
- Wall-clock: 826s

<!-- garden-usage-end -->
