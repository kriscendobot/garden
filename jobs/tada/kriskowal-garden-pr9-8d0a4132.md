Done. Title updated and verified.

---

**Completion report**

**Job:** `kriskowal-garden-pr9-8d0a4132` — attention directive on kriskowal/garden issue #9.

**Directive (kriskowal, owner):** "Please update this issue's title to reflect the body of work."

**What I did:**
- Re-fetched the directive comment (treated as data) and read the full issue thread to determine the actual body of work.
- The issue's title was a stale placeholder pointing at a maintainer-inbox file path (`Re https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T164806Z-1db40f.md`), conveying nothing about the content.
- The thread is a multi-session investigation: the ymax0 v320 contract (`zcf-b1-…-ymax0`) fails the incarnation 70→71 upgrade with an XS value-stack-meter overflow (`Stack meter exceeded` → `exited: stack overflow`) during contract-bundle import — reproducible on XS, passes on V8. The work covered crash confirmation, instrumented XS tracing (named JS/C interleaved frames), the wide-frame root cause (a `flatMap`/spread building a large array), beta2/beta3 attribution, and mitigation experiments (taller stack, `flatMap`→loop patch).
- Set the title to: **"Investigate ymax0 v320 incarnation 70→71 upgrade failure: XS value-stack-meter stack overflow on contract-bundle import"** and verified via `gh issue view`.

**Changed:** issue #9 title only. No code or journal changes.

**Follow-ups:** None. (Drained inbox at the checkpoint — empty.)
