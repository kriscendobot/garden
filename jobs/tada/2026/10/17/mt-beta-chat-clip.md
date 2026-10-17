**Completion report: mt-beta-chat-clip**

The chat clip is built and open as a **draft PR: kriscendobot/minion.town#202** (`feat/chat-clip`). It is stacked on #201 (New Clip): the base is the frozen snapshot `feat/new-clip-inventory-a61dc66`, which I pushed for this PR. No production admission setting was touched.

**What I built**
- **Chat is a second form of the New Clip,** offered beside "Pet-name inventory" on the blank clip. Because it's the same clip turning into a chat, it keeps one clip id, the same mint, the same fail-closed page and the same rule that only `https://minion.town` may frame it.
- **The chat view:**
  - A peer list with **Invite** (makes a one-use invitation) and **Accept** (redeems a peer's invitation under a name you choose). An invited peer shows as pending until they accept.
  - A conversation pane: send, reply in a thread (the reply quotes its parent), and dismiss.
  - A value carried in a message shows as a chip; clicking it keeps the value in the clip.
  - A request offers Answer or Decline.
  - Other message types are labeled as not shown yet, never hidden.
  - New messages are fetched every 3 seconds.
- The interaction design follows Endo Chat (`packages/chat` on `llm`). No upstream code is imported.
- **Server side** (`src/endo/gateway/new-clip.ts`): new clip-power methods for peers, invitations, the conversation, sending, keeping a value, answering or declining a request, and dismissing. They only reach messages from or to peers held in the clip's own inventory. A message number outside that conversation is refused, sends are text only (at most 4096 characters), and kept or answering values stay inside the clip.
- **Docs, tests and CI:** new `designs/chat-clip.md`; `designs/new-clip.md` updated; new unit tests and a real-daemon test, with a CI step for the latter; a second-guest mint and a few control routes added to the dev stack.

**Alignment with ocap mailboxes (#37 / `build-minion-town-ocap-mailboxes`)**
I read the #37 design first. It is unmerged and its build job is parked, so the chat uses only the daemon's existing guest mail calls plus invite/accept. It defines no message model of its own. It maps onto #37's terms like this:
- Peers are opaque handles named by the clip's owner.
- Sending is restricted to the clip's peers (#37's restricted outbox).
- Reading and dismissing are limited to one peer's conversation (#37's inbox).
- Keeping values and answering requests correspond to #37's intake.
- Showing only introduced peers matches #37's known-sender rule.

When #37 lands, the clip's mail access should switch to its narrower mailbox facets; the page and the methods stay the same. This is written up in `designs/chat-clip.md` § 4.

**Evidence** (real Endo daemon at the pinned commit `1706e632`, real guests)
- `test/chat-clip-daemon.test.ts` passes. Two guests' clips become chats; Alice invites and Bob accepts. They exchange a message and a threaded reply. Alice keeps a value Bob's guest sent, and answers a request that Bob's guest then receives. Dismiss works, a note-to-self can't be seen or dismissed through the clip, and sends to non-peers are refused. A new session still shows the chat and its history.
- `dev/chat-clip-browser-demo.mjs` (Playwright, Chromium, two browser contexts, two guests): **15/15 checks pass**. That covers the message exchange both ways, sending from inside a frame served as `https://minion.town`, fail-closed on a dropped connection with "Try again" recovering, and another origin being blocked from framing the clip.
- Regressions: #201's daemon test (2/2) and browser demo (18/18) still pass, the unit tests pass (17), and typecheck is clean.
- Full `npm test`: 88 files pass, 1 fails. The failure is `git-remote/capability.test.ts › propagates a git failure`, which #201 already traced to this host's `git` wrapper.

**Risk to flag:** a clip URL works like a password. Anyone who has the URL of a chat clip can read its conversations and send messages *as the owner* to that clip's peers. The power limits this to the clip's peers but does not remove it. Narrowing it needs a credential other than the clip id (#88) and the #37 mailbox facets.

**Follow-ons**
- Deliver messages live instead of polling every 3 seconds.
- Switch to the #37 facets and require #88 before a chat clip is shared off the owner's own devices.
- Show when a request has already been answered, so it stops offering Answer.
- #202 must be rebased if #201 changes during its fix loop.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mt-beta-chat-clip.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 126 tokens (7548460 cached reads)
- Output: 58457 tokens
- Cost: $4.048207999999999
- Wall-clock: 825s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
