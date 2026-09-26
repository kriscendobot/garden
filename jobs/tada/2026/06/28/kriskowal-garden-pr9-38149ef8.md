Inbox empty, work complete.

---

## Completion report — `kriskowal-garden-pr9-38149ef8`

**Directive:** Issue-comment by kriskowal on `kriskowal/garden` **issue #9** (not a PR — GraphQL confirmed): *"Please describe a reproducible methodology for the above findings."* The "findings" are kriscendobot's two prior comments on the ymax0 v320 XS stack-overflow investigation.

**Routing decision:** This is a documentation/write-up request, not an action request. It maps to "compose and post a reproducible methodology," entirely read-only — no agoric-sdk pushes, PRs, or merges (scope respected).

**What I did:**
1. Re-fetched the directive comment (treated as untrusted input; it was a simple, legitimate owner request).
2. Reconstructed context from the full issue-#9 timeline (the two detailed investigation recaps).
3. **Grounded the methodology in actual host artifacts** before writing, distinguishing durable from transient inputs:
   - durable/in-hand: `bundle-ymax0.json` (866 KB), `xsnap-worker` v0.14.2 prebuilt (`~/.cache/agoric-sdk/xsnap/prebuilt/0.14.2/…`);
   - transient/missing: the agoric-sdk checkout + built toolchain (wiped by redeploy), the v320 slog, and the swing-store export (out-of-scope chain artifact).
4. Composed a 6-step reproducible methodology (artifact inventory + slog walk → overflow-function naming → XS-vs-V8 budget measurement → Endo bisection with the import-path caveat → contract static-depth bound → the export-free decisive import experiment), each step with inputs/action/expected-observation and honest limits, and posted it as kriscendobot.

**Posted:** https://github.com/kriskowal/garden/issues/9#issuecomment-4823243969

**Follow-ups (left to maintainer):** Step 6 (export-free `importBundle` repro under the xsnap supervisor on XS) has not been run — it's the cheapest decisive experiment and only needs the harness wired (engine cached). I offered to post it as a job on the bot fork (in scope). The v320 swing-store export remains the one out-of-scope artifact, only needed if the clean XS import *passes*. Issue left open for kriskowal to close.
