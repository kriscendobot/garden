Done. My change is the live tip of `origin/main2`, no duplicate job remains on the board, and both worktrees are torn down. Here is my completion report.

---

**Revised the standing instructions to encode the agoric/agoric-sdk fork-experimentation directive (garden #9).**

The directive (re-fetched and treated as data): *free to experiment with agoric/agoric-sdk on the `kriscendobot/agoric-sdk` fork; must only avoid linking issues/PRs to agoric/agoric-sdk or commenting upstream.* This narrows the prior blanket "agoric-sdk off-limits" posture to "fork experimentation permitted, upstream untouched."

**Landed on `main2`** (commit `70997d2c7`, pushed cleanly):
- `roles/COMMON.md` § External-repo etiquette — new canonical **"Project scope: agoric/agoric-sdk"** carve-out: fork clone/branch/build/test/run/read-only-analysis permitted and pushable to the bot fork; all *upstream* interaction forbidden (comments, reviews, reactjis, issue/PR opens/edits/closes, and any cross-reference linking an issue or PR to agoric/agoric-sdk, including from the fork). Cites the directive with date and issue link.
- `CLAUDE.md`, `roles/foreman`, `roles/liaison`, `roles/proxy`, `roles/triager` — the five standing "never agoric-sdk / off-limits" lines now name *upstream* interaction specifically and point at the COMMON.md carve-out for the fork permission. Reaffirmed that this does **not** authorize an autonomous identity switch or upstream ferry (still maintainer-gated). Bumped `foreman` frontmatter `updated:`.

**Landed on `journal2`** (commit `f6984f171`): `projects/agoric-sdk/README.md` § Rules of engagement now records the authorization and distinguishes the (unchanged) passive monitor posture from the newly-permitted maintainer-directed fork experimentation.

**Verification:** carve-out confirmed present on `origin/main2`; em-dash/Latin-shorthand style check clean on all added prose (the two flagged em-dashes are pre-existing lines I did not author); root checkout left clean; both isolated worktrees torn down (per-subagent-worktree discipline, never the root). My recall memory already carried the revised rule, so no memory change was needed.

**Follow-ups:**
- A peer gardener has an `infra-agoric-sdk-scope-1768` worktree open — possibly a concurrent attempt at this same directive. My commit is the live `main2` tip; if that peer pushes, it will rebase and may produce a redundant/empty change. No board duplicate exists in `todo/`/`doin/`. Worth a glance if a second near-identical commit appears.
- The `skills/monitor-agoric-sdk/SKILL.md` monitor table stays intentionally uniform ("journal a tick, do not dispatch"); I deliberately left it unchanged since fork experimentation is maintainer-directed, not monitor-autonomous. Flagging in case you'd prefer the monitor posture upgraded now that engagement has begun.
