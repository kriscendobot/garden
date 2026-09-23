Comment posted successfully. This was a research/advisory job — no garden library code changes to commit; the deliverable is the issue comment itself.

---

## Completion report

**Job:** issue-kriskowal-garden-57 — dckc's issue #57, "automation for ymax agent demo / testing."

**What was asked:** Research the state of the art in UI testing for Web3 apps (incl. MetaMask steps) for ymax.app, make recommendations, and support recording short demo videos of 7 specific user flows (chat-driven mandate/agent delegation).

**What I did:**
- Re-fetched the full issue via `gh api` (the `--comments` view returned empty; raw API worked) and confirmed ymax uses **MetaMask / EIP‑712** signing with chat‑driven, Agoric‑side mandate enforcement, per the linked agent-delegation design doc (fetched for context).
- Ran targeted web research across the current tooling: real-extension drivers (**Synpress v4**, **Dappwright**), headless/mock wallets (**wallet-mock**, **walletless**, **headless-web3-provider**, wagmi mock connector), local-chain fixtures (**Anvil** mainnet-fork), and the **Playwright video/trace → ffmpeg/MP4** pipeline.
- Posted a comprehensive, cited comment to the issue: https://github.com/kriskowal/garden/issues/57#issuecomment-4996692670

**Recommendation delivered (summary):** A **two-tier Playwright harness** — Tier 1 (real MetaMask via Synpress/Dappwright, headed + `slowMo` + video) for the 7 demo videos; Tier 2 (headless mock wallet + Anvil fork) for fast CI regression, sharing one page-object/fixture layer. Flagged the real hard parts as the **multi-chain fixture** (Agoric local chain + EVM fork) and **chat/agent nondeterminism** (seed/stub the agent, assert on outcome state), plus the Synpress v4 + MetaMask v13 hang bug (pin versions) and the WebM→MP4 transcode step.

**Changed:** Nothing in the garden repo (research/advisory job; no main2 commit). Only a public issue comment.

**Did not:** Close the issue (submitter closes when satisfied). Did not touch agoric/agoric-sdk upstream.

**Follow-ups offered (not yet queued):** I offered in the comment to post a probe/build job to stand up a Tier‑1 skeleton recording flow #1 end‑to‑end, pending a design pass on the multi-chain fixture. Awaiting maintainer go-ahead before queuing.
