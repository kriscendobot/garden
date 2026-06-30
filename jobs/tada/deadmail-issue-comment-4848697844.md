# Completion report — dead-lettered `deadmail-issue-comment-4848697844`

**Intent:** Pick up a dead-lettered notification (addressee `issue-kriskowal-garden-9` had completed) about a new kriskowal comment on kriskowal/garden#9 — "there are examples for publishing a bundle to chain in the mainnet validation tree" — fold it into the in-flight work and reply on the issue thread.

**What I found / did:**
- Read the full #9 thread and the `agoric-chain-snapshot` skill to reconstruct context: the doer had raised two gaps blocking the faithful contract-control upgrade repro (the over-threshold failing bundle, and a handle to the live v290/v288 admin facet, since the bootstrap `ymax0Kit` is the stale v275 kit).
- Located the publishing examples in the local upstream agoric-sdk worktree. They fully resolve both gaps and confirm mhofman's correction: install is `MsgInstallBundle` (network/instance-agnostic); the contract-control upgrade is a smart-wallet `sendBridgeAction` invoking `ymaxControl.upgrade({ bundleId })` from the account holding the control facet (the path inquisitor can inject).
- **Discovered a peer was already handling the same comment:** a peer gardener (lane `garden-issue-9-mhofman-contract-kit-and-inquisitor-bridge`) had already (a) landed a more thorough skill section identifying the "mainnet validation tree" as `a3p-integration/` with the full publish→install→contract-control sequence, and (b) **posted the issue replies** at 23:26:17Z (to kriskowal) and 23:26:55Z (to mhofman).

**Decisions:**
- **Did NOT post a duplicate issue reply** — kriskowal's comment was already answered by the bot; reply-once-per-comment discipline applies. My drafted reply was discarded.
- **Resolved a merge conflict** against the peer's superior section by keeping theirs, and folded in only my genuinely additive material: the per-target **ymaxControl smart-wallet addresses** (ymax0-main `agoric1e80twf…`, ymax0-devnet `agoric10utru…`, ymax1-main `agoric18dx5f…` — the `controlAddress` an injected bridge action must originate from) and the **ymax-ops operations driver** (`install-bundle.ts` / `ymax-upgrade.ts` / `wallet-admin.ts`) as the ops counterpart of the a3p path. Also removed a stray comment the linter had injected into the skill's YAML frontmatter.

**Changed / pushed:** one commit to `main2` — `3b816ee09 skills/agoric-chain-snapshot: add ymaxControl addresses + ymax-ops upgrade driver` (CAS push, clean on attempt 1).

**Follow-ups:** None owed by me. The remaining real blocker on #9 (already stated by the peer's reply) is supplier-side: the over-threshold devnet "v320" `bundle-ymax0.json` must be fetched as a release asset (or rebuilt from a named branch) before the faithful v290 control/patched upgrade can be run through inquisitor.
