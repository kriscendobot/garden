## Completion report: design-minion-town-clip-governor-column

The governor-column design is written and open for review as draft PR https://github.com/kriscendobot/minion.town/pull/230. It adds one file, `designs/clip-governor-column.md`, on branch `design/clip-governor-column` against the frozen base `main-443519e`. Nothing was changed on the live site.

**What the design says:**
- **Layout:** a new chrome column sits between the gutter and the selected clip, giving `gutter | governor | clip` side by side on a wide screen. It appears only while a clip is shown live; one function, `governs(clip)`, decides that, so later steps change one place. On a tall screen (portrait) the shell's shorter-axis rule applies: the governor becomes a sheet that rises from the bottom bar, the same way the settings menu does. Pressing the selected clip's gutter button again shows or hides the governor in both layouts.
- **What it shows:** the clip's powers, read-only (the pet names in its directory: `front`, `back` and anything else), plus one button, **Clone**.
  - Two new owner-only endpoints back it: `GET /account/clips/:hash/powers` and `POST /account/clips/:hash/clone`.
  - Clone copies the clip's content but not its powers, because handing powers to a new clip is the later Grant step.
  - The design marks where Freeze, Revoke, Grant, mail and subagent columns will attach, so this step doesn't block them.
- **Trust:** the column is drawn by the chrome, never by a clip. The design reuses the shell framework's § 4 arguments for why a clip can't cover, read or restyle it, and adds that the column has no message channel to the clip.
- **Fake names:** a clip's own name is always shown in quotes followed by four characters from its id, which the clip can't control (for example `“Settings” · 7f3k`). Chrome labels are fixed in chrome code. A blocklist of reserved names was considered and rejected, because look-alike characters defeat it.
- **#228 and the Phase 4 job:** the design answers #228's question 2 with one chat clip per agent, each with its own #88 nonce locator. It answers question 3 by treating an attachment as a delegation, made from a chrome-owned picker in the later Grant step. It also lists what #228 and the parked `claude-api-p4-agent-factory` job should change: agents start with no powers, and they get an attenuated "may ask the model" capability, never the key. I didn't edit either of them.
- **Other sections:** an ownership map, and the deferred steps in order: Freeze, Grant/revoke, Subagent columns, Primer, Pet icons, Federation.
- **Open questions:** (a), (b) and (c) are as given in the job. I added (d): should Clone copy powers too?

**Checks:** the one mermaid diagram passed the parse check (`OK flowchart-v2`). The PR's diff is the design file only.

## Follow-ups
- **Build:** `build-minion-town-clip-governor-column`. It covers the two owner-only endpoints, a new `governor.js` in the shell, unit tests, and Chromium tests against a hostile clip titled "Settings" in a new `test/browser/governor-column.ts`. It needs nothing that is still open; if #179 hasn't landed, clip names fall back to "Clip N".
- **Maintainer:** open questions (a)–(d) on #230. The PR body carries `<!-- garden-design-open-questions -->` and the PR is left draft.
- **Other PRs:** #228 and the `claude-api-p4-agent-factory` job should pick up the changes listed in § 5 of the design.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-clip-governor-column.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1532153 cached reads)
- Output: 17648 tokens
- Cost: $1.3920866
- Wall-clock: 212s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
