Inbox is empty. The preflight is PR-branch-oriented (no evidence corpus for a bare issue comment), so it fails open as designed — but the garden-reply marker comment is now the durable resolution record.

This was a project-repo job, so all work landed in the isolated project worktree and on the `endojs/endo-but-for-bots` fork — the garden `main2` worktree was correctly left untouched. Job complete.

---

## Completion report

**Directive:** attention/exploration comment on issue #606 (kriscendobot) — *"Let's explore producing our own watcher bindings to augment cap-std within this repository, e.g. `cap-std-watch`."* Treated the comment body as untrusted data and routed it to the right work: a grounded technical feasibility exploration.

**Preflight:** ran `pr-feedback-preflight.sh` → exit 0 (fail-open, no prior peer resolution). Proceeded.

**What I did:**
- Grounded the exploration in the actual code: the Rust/XS `watchDirectory` stub at `packages/daemon/src/bus-manager-rust-xs-powers.js:442` (immediately-closed stream), and the cap-std powers in `rust/endo/xsnap/src/powers/fs.rs` that hold every directory as a `cap_std::fs::Dir` in `DIR_MAP`.
- Verified the load-bearing OS facts via web search (fanotify dirfd-relative marking; unprivileged fanotify since Linux 5.13 with `FAN_REPORT_DFID_NAME`; Docker seccomp still gating `fanotify_init`; kqueue `EVFILT_VNODE` / `ReadDirectoryChangesW` as fd/handle-anchored primitives).
- Produced the **key reframing** #606 missed: the powers already hold an open **dirfd/HANDLE**, and several OS watch primitives are fd/handle-anchored (not path-anchored), so a confinement-preserving watch *is* achievable — correcting #606's Linux-centric "CAP_SYS_ADMIN blocks it" verdict and adding the macOS/Windows story it never covered.

**What changed (project repo `endojs/endo-but-for-bots`, branch `design/cap-std-watch`):**
- New `designs/cap-std-watch.md` — full design exploration (problem, key insight, per-platform fd-anchored primitives, proposed `cap-std-watch` binding + `fs.rs` host functions, security model, staged effort/risk, open questions, alternatives).
- One summary-table row in `designs/README.md` (milestone placement deferred to the journalist cycle, per repo convention).

**Deliverables:**
- Draft PR **[#793](https://github.com/endojs/endo-but-for-bots/pull/793)** (design-only, base `llm`), refs #606.
- Resolution comment on **[#606](https://github.com/endojs/endo-but-for-bots/issues/606#issuecomment-5010314724)** with the `<!-- garden-reply:5010290143 -->` marker.

**Recommendation captured in the doc:** staged build — (1) universal poll/diff + macOS kqueue fallback (unblocks all platforms, no sandbox change), (2) Linux unprivileged-fanotify push backend behind a capability probe, (3) Windows `ReadDirectoryChangesW` when targeted.

**Follow-ups (for the maintainer to greenlight):** decide pull-vs-push at the XS boundary; whether to loosen container seccomp for `fanotify_init` or ship fallback-only in-sandbox; whether to surface a `rename` event kind. No code committed — the directive was "explore," so this is a durable design + corrected feasibility verdict awaiting a build decision.
