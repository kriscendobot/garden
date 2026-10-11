I opened draft PR [kriscendobot/minion.town#179](https://github.com/kriscendobot/minion.town/pull/179), which gives gutter clips real names and icons and dims clips that aren't being served. The CI `test` job passed (typecheck, build and the full suite). The two "Claude harness" CI jobs were still waiting for a runner when I stopped, so that part of CI hasn't run yet.

**Where the name comes from.** Publishing doesn't record any name for a site, so the name is the `<title>` of the clip's front `index.html`. A guest-assigned name would mean changing publish to store one, which I didn't do.

**What changed:**
- **Reading the title:** a new module, `src/endo/gateway/clip-title.ts`, finds the clip's front page and reads its title from the first 16 KiB of `index.html` (HTML files only).
- **Treated as untrusted:** the title is cleaned of control and right-to-left override characters, has its spacing collapsed, and is capped at 64 characters. Any failure, or a lookup slower than 1.5 s, just means no name. A name problem never makes the listing fail.
- **Publisher and wiring:** `publish.ts` and `src/http.ts` look up the name when listing clips. On the live path that means one extra daemon read per clip, run in parallel over a separate daemon connection.
- **`GET /account/clips`:** each entry can now carry an optional `name`, cleaned again at the endpoint and left out when nothing usable remains. The MCP `listSites` tool gets the same optional field.
- **Gutter (`shell.js`):**
  - **Name:** checked again in the browser, falling back to "Clip N". It is only ever written as plain text, never as HTML. A test fails if the gutter code gains an `innerHTML`-style call.
  - **Icon:** taken from a leading emoji in the name (e.g. "🌵 Cactus"). Otherwise it's picked from the clip's id, so a clip keeps its icon when others are added or removed; before, icons shifted by position.
  - **`serving: false`:** the clip is greyed out with a dotted border and "(not being served)" in its tooltip, but can still be selected.

**Tests:** I added `test/gateway/clip-title.test.ts` and extended the publish, endpoint and shell test files. Locally, typecheck is clean and the full suite passes except one test, `test/git-remote/capability.test.ts > propagates a git failure…`. That file isn't touched by this change and the same test passed in CI, so the failure comes from my local environment.

**Follow-ups:** the review chain (clean → panel review → fixes → un-draft) should be staged automatically when this job completes. The next gutter steps in the plan, `minion-town-ui-gutter-live-refresh` and `minion-town-ui-gutter-reorder`, don't depend on this one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-gutter-clip-labels.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3748808 cached reads)
- Output: 27258 tokens
- Cost: $2.2701376000000004
- Wall-clock: 1017s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
