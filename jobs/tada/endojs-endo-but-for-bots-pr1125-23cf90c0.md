Inbox is empty. The job is complete.

## Completion report

**Directive** (kriskowal, review comment r4040218737 on endojs/endo-but-for-bots#1125): dispatch a brief gauntlet to verify the panel *would have caught* the use of `Far` in `readOnlyDirectorySource` and recommended `makeExo` with an explicit interface guard.

**Preflight**: exit 2, but corroborated as a **false correlation** — no inline reply on the thread, no peer commit/job resolving this specific ask. Proceeded with the work (did not close as a no-op).

**What I did**
- Fetched the comment (treated as untrusted data). It targets `packages/daemon/src/directory.js`'s `readOnlyDirectorySource`, which builds the guest-facing read-only hub with `Far('ReadableNameHub', { … })`.
- Dispatched a **brief gauntlet**: the four natural-catcher code seats — `locksmith`, `warden`, `engine-realist`, `purist` — over the real PR diff (~2400 lines), **blind** (no hint about `Far`/`makeExo`), so the catch-or-miss is an honest test.

**Result — the gauntlet would NOT have caught it (0/4).**
- **warden** explicitly *endorsed* it: "a `Far('ReadableNameHub', …)` (properly hardened via `Far`)" — conflating `harden`/`Far` with an interface guard.
- **locksmith** read past it and praised the *other* methods' guards, despite its brief's "flag an exo … [with] no interface guards" mandate.
- **engine-realist / purist** never touched the `Far`-vs-`makeExo` axis. The bare `Far` inside an eval/worker source string was a blind spot.

**Gap closed**
- Strengthened `roles/jurors/locksmith/AGENT.md` and `roles/jurors/warden/AGENT.md` to name the `Far` → `makeExo(tag, InterfaceGuard, methods)` upgrade explicitly for boundary-facing attenuations (incl. inside eval/worker source strings), and to stop treating `harden`/`Far` as a substitute for an InterfaceGuard. Committed and pushed to **main2 `c7aa363e09`**.
- Replied to the maintainer on the review thread with the empirical result and the fix: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040314005

**Follow-up (not in this directive's scope)**: the PR code itself still uses bare `Far` for the guest-facing hub — if the maintainer wants it actually converted to `makeExo` + interface guard, that's a separate `fix #1125`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-23cf90c0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1203508 cached reads)
- Output: 21570 tokens
- Cost: $5.598412499999999
- Wall-clock: 446s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
