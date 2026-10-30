I revised design PR https://github.com/kriscendobot/minion.town/pull/230 (`designs/clip-governor-column.md`) with the maintainer's answers to (g), (h) and (i), and pushed it to `design/clip-governor-column` as 5816cf32. The PR is still a draft, and I posted no build job.

**What changed in the design:**
- **(g) Clips form a tree, and destroy cascades.** Destroying a clip, or a governor dropping a child (a new `children.release` method), destroys the whole subtree. The order is:
  - First, mark the top clip of the subtree as being destroyed. From then on the whole subtree is hidden and can't grow.
  - Then destroy children before their parents, and clear the mark last.
  - After a crash the cascade resumes when the facet next starts, and every step is safe to repeat.
  - The owner sees one confirmation listing all the clips that will go, and they all disappear together.
  - Reparenting is recorded as deferred (§ 18), not as an open question.
- **(h) CapTP by default.** The powers read, clone, clone with other powers, destroy, the clip list (with its governor links), the owner's child switch and the drill/return view are now methods on one CapTP owner facet. Rung 3's clone plan now passes references instead of pet-name strings. These are "entry handles": references the facet hands out that can't be called, and that only the facet that issued them, in the same session, can turn back into the real entry. This removes the old conflict with the rubric's rule against passing capabilities as strings. In the re-scored transport table (§ 15), the only REST left is what opens the session: login, the locator mint and its revoke, and the WebSocket upgrade.
- **(i)** The eject reading is written into § 2 and rung 7 as confirmed.
- **New rung 0, split in two.** I checked `main` first: `shell.js` only calls `fetch` on `/account/clips` and `/account/clips/order`, with no WebSocket or CapTP, so the prerequisite is real.
  - **0a** is the session plus one trivial method, `info()`:
    - The shell mints an expiring (12 h), revocable locator through a CSRF-checked `POST /account/shell-session`. The locator gives access to one session in one tab, not to the user's identity.
    - It then opens `wss://minion.town/account/shell-captp`. The server refuses the upgrade unless the request comes from exactly `https://minion.town` and carries a valid login cookie. The cookie is `SameSite=Lax`, so a clip on `*.ocap.site` can't send it.
    - The session's first object is an empty door with one method, `open(locator)`, which also checks that the locator belongs to the cookie's user.
    - The rung also covers reconnect, revoke, expiry and sign-out, plus tests where a hostile clip tries to reach the session.
  - **0b** moves the gutter's clip list and ordering onto the session (`list()` and `setOrder()`).
- **Open questions:** (g), (h) and (i) are removed. (f) stays, still only for rung 9; because children now die with their governor, it only concerns wrappers that left the subtree, for example into a clone. Two new ones:
  - **(j)** Should the shell hold one session per tab or one per browser?
  - **(k)** Once the gutter reads its list over CapTP, should the REST clip list (`GET /account/clips`) stay for the first page load and for callers that can't speak CapTP?

**Checks and PR housekeeping:** all three mermaid diagrams pass the parse check (two flowcharts and one sequence diagram). I rewrote the PR body and posted a summary comment (https://github.com/kriscendobot/minion.town/pull/230#issuecomment-6514067963).

**Follow-ups:**
- The maintainer needs to answer (f), (j) and (k).
- #228 could later move its chat-session mint onto this owner facet. The design (§ 17) notes this; I made no change to #228.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-pr230-captp-default.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1249438 cached reads)
- Output: 32764 tokens
- Cost: $1.7433676
- Wall-clock: 307s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
