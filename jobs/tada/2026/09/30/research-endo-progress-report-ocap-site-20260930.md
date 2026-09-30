I've published the Endo progress report as a static clip: **https://hllk2wmfocuoijaliiapckuth4f3qxqlvo5vjwzywazvawvrqaiq.ocap.site/**

After publishing I fetched it back: the page and its stylesheet both return HTTP 200, and the served page is byte-for-byte the file I built. I also sent the URL and a short summary to the maintainer inbox.

**What the report covers (24 June to 30 September, same window as the earlier completions report):**
- **Summary of where Endo stands.** M1 and M2 were already complete before the window and didn't change. M3 is still the first incomplete milestone, targeted for late November to mid-December. Comparing the roadmap (`designs/README.md` on `llm`) at the start of the window against today: 40 existing design rows changed status (8 to Complete, 26 to In Progress), and 38 new designs were added.
- **Milestone table, M1 to M11**, showing what moved in each during the window. M11 (the Rust daemon, `endor`) grew from 2 rows to about 15 and is landing well ahead of its place in the order.
- **What shipped, in six themes**, each item tied to its merged PRs:
  1. **Agent tooling:** mounts, Git as a capability (including push), filesystem search, shell and HTTP tools, `@endo/agentry` code mode, and `@endo/workflow`.
  2. **Daemon networking:** daemons now connect to each other over OCapN-Noise (#340), plus a second transport on iroh and the CBOR/ASCII wire groundwork.
  3. **Guests:** any guest can now issue and accept invitations (#1305, #1310). This includes the story where the first production rollout crash-looped on minion.town's real database, was rolled back, and shipped after a migration fix (#1329). Also the MCP server scoped to one guest (#1336) and the `@endo/claude` confinement core (#1015).
  4. **npm packages:** `endor` now fetches, stores and runs real npm packages from a content-addressed store, with most of Node's module rules.
  5. **IronHorse (the Rust port of the XS engine):** merged in #600. It now has heap persistence, a native `lockdown()` and a first guest `Compartment`. The number of test262 cases it passes against the XS reference went from 4,740 to 29,015 to 37,285, out of 51,976.
  6. **Chat and the operator UI.**
- **Notable callouts**, including what still blocks M3 and M5.

**Things to know:**
- **Shipped vs. proposed is judged by PR content, not branch.** The job assumed implementations land on `master`, but only 6 of the 471 merges in the window targeted `master`, the last on 13 July. Nearly all implementation work lands on `llm`, because the packages it touches exist only there. So a PR that only changes design files counts as proposed, and a merged PR with code and tests counts as shipped. The report says this openly: 412 PRs touched code, 59 were design-only.
- **CSS is in a separate file, not inline.** The job asked for inline CSS, but the clip's security policy only allows same-origin stylesheets, so the page links a `styles.css` next to it, the same way the earlier report does.
- **Theme counts are approximate.** The "about 90 IronHorse fix PRs" figure comes from sorting PR titles by keyword, not a hand count.

**Garden change:** I added two notes to `skills/minion-town-clip-publishing/SKILL.md` and pushed them to `main2` (`087f4e1c22b`). One explains how to publish from a script that talks to the existing `minion-mcp-bridge.py`, which avoids pasting a large encoded payload into a tool call. The other says the CSS must be a sibling file. No other follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/research-endo-progress-report-ocap-site-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2856491 cached reads)
- Output: 22652 tokens
- Cost: $1.8747621999999993
- Wall-clock: 291s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
