---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-14T07:22:25Z
---
---
kind: result
role: warden
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `warden` on PR #986 (lal glob/grep search parity), diff base `origin/llm`.

### warden (SES boundary, harden discipline, unguarded globals)

**Verdict:** request-changes

**Findings:**

- must-fix. `packages/lal/tools/fs.js:66-97` documents a glob dialect built on `*` and `**` and a grep argument that is a raw ECMAScript RegExp source, but every tool argument first passes the SmallCaps decode at `packages/lal/tool-dispatch.js:83-88`, where a leading character in the range `!"#$%&'()*+,-` is a reserved marker. The canonical calls this PR advertises therefore never reach the capability. Ran `makeExecuteTool` against a stub: `glob("*.js")` and `glob("**/*.js")` throw `Special char "*" reserved for future use`; `grep("$")` throws `decodeRemotableFromSmallcaps option must return a remotable`; `grep("(foo|bar)")`, `grep("#include")` and `grep("-->")` throw; `grep("+1")` silently decodes to the BigInt `1n` and then fails the shape check. Only patterns starting outside that range (`TODO`, `^export`, `src/**/*.js`) work. `packages/lal/primer/smallcaps.md:16-19` tells the model the opposite in so many words ("No other argument is decoded as SmallCaps; every other field passes through bytes-for-bytes"), so the model has no way to learn the `!` escape. The decode predates this PR; these are the first tools whose ordinary argument values collide with it, which turns a latent inconsistency into a routine failure. Fix the primer claim, state the `!` escape in both new summaries, and pin `!*.js` in a test. [proposed-rule: when a tool argument is a pattern or source-text dialect, its summary and a test must state how the marshaling layer escapes the dialect's own metacharacters.]

- should-fix. `packages/lal/tools/fs.js:92` guards `maxResults` with bare `M.number()`, and `tool-dispatch.js:405-406` hardens and forwards it into the confined mount. Verified accepted and forwarded: `NaN`, `Infinity`, `-1`, `0`, `1.5`, `1e9`. `NaN` is the sharp one: `packages/daemon/src/mount.js:863` and `packages/platform/src/fs/search.js:474` compare `count >= maxResults`, false forever under `NaN`, so the daemon's 1000-result cap is defeated, every file under the mount face is walked, and `matches.slice(0, NaN)` then returns `[]`. One LLM-authored argument buys a full-cost scan with no output. Constrain to a positive safe integer at this boundary.

- comment-only. `grep`'s pattern becomes `new RegExp(pattern)` inside the daemon with no flags and no timeout, so a backtracking pattern from model output stalls the daemon vat that serves every guest. `evaluate` already grants at least this much, so this is not new authority, but the search engine is the natural place for a bound.

- comment-only. `glob` hard-caps at `GLOB_MAX_RESULTS` (10000) and `grep` defaults to 1000, both truncating silently. Neither summary says so, so the model will read a truncated list as exhaustive. Say it in the summaries. [rule: skills/gricean-maxims/SKILL.md]

**Notes (out of scope but worth flagging):**

- Harden discipline in the diff is correct. `harden({ maxResults })` at `tool-dispatch.js:406`; the mount hardens its own returns (`mount.js:867`), so returning the callee's array unhardened is safe here, matching `readText`. No `globalThis` write, no prototype walk, no intrinsic shadowing.
- The boundary contract is exercised only against a self-written stub (`packages/lal/test/search-tools.test.js:10-35`), so nothing proves lal's call shapes satisfy `MountInterface`. The riskiest of them, explicit `undefined` for `grep`'s optional `paths`, does hold: `packages/patterns/src/patterns/patternMatchers.js:1690` maps optional positionals through `MM.opt`. Confirmed by reading, not by test. All lal tests are stub-only today, so an integration test would be new precedent rather than a gap this PR opened. [rule: skills/adversarial-tests/SKILL.md]
- The `editText` line added at `packages/lal/primer/tools.md:58` documents a pre-existing tool and is unrelated to search parity.

Verification: `npx ava test/search-tools.test.js` in `packages/lal`, 6 tests passed. The decode and `maxResults` probes above were run as temporary test files and removed; worktree is clean.

Self-improvement: the SmallCaps finding came from asking what the tool's own documented dialect looks like as a literal argument, not from reading the diff for harden calls. Worth adding to `skills/adversarial-tests/SKILL.md`: for any new tool argument, type the summary's own example into the decoder before believing it round-trips.
