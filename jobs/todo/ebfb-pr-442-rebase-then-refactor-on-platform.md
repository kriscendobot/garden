# PR #442 — rebase, then refactor @endo/daemon-cas onto @endo/platform (maintainer direction)
Repo: endojs/endo-but-for-bots (bot). PR #442 — *feat(daemon-cas): extract CAS surface into
@endo/daemon-cas* — https://github.com/endojs/endo-but-for-bots/pull/442 — base `llm`,
reviewDecision **CHANGES_REQUESTED**.
kriskowal direction (2026-06-28T07:08Z, comment 4825204276):
> The @endo/platform overlap concerns me — @endo/platform may be overreaching, with @endo/*cas
> and @endo/fs emerging outside its scope and contesting its central position. @endo/daemon-cas
> should stand upon @endo/platform with a coherent model for CAS methods and injected
> dependencies. **Atomizing @endo/platform is NOT in scope** for this change — but for now assume
> @endo/daemon-cas stands on @endo/platform for filesystem dependencies and shared CAS interfaces,
> and refactor accordingly. **But first, rebase.**
Task (in order): 1) **Rebase** the branch onto the current `llm`, resolve conflicts, force-push-with-lease.
2) **Refactor** so `@endo/daemon-cas` **stands on `@endo/platform`** for filesystem dependencies and
shared CAS interfaces, with a coherent model for CAS methods + injected dependencies — do **NOT**
atomize/restructure `@endo/platform` itself (explicitly out of scope). 3) Verify (local-verify), push,
and post a **reply comment** on #442 describing the rebase + the @endo/platform-based refactor. CHANGES_REQUESTED → builder/fixer. Bot fork; no upstream contact.
