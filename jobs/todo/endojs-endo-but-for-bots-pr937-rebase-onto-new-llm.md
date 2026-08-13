---
role: weaver
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-13T15:01:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
role: weaver

# Rebase PR #937 onto the new `llm`, to clarify the review

`https://github.com/endojs/endo-but-for-bots/pull/937` ("fix(daemon): restore
XS bundle generation on llm") is currently based on the pinned snapshot
`llm-5f9ccde`. `https://github.com/endojs/endo-but-for-bots/pull/903`
(`@endo/sha256` platform-neutral hash + git-injection work) has just merged
into `llm` — the maintainer wants #937 re-based onto the new state of `llm`
so its diff is clean and interpretable for review (it currently overlaps
conceptually with what #903 landed).

**Re-pin, don't float.** Per the garden's standing merge-base-pinning
discipline (`skills/frozen-base-branch/SKILL.md`; see also the parked
`review-improve-merge-base-pinning` cluster job) — branch/rebase onto a
freshly pinned `llm-<short-sha>` snapshot of the current `llm` tip, never
onto the floating `llm` branch directly. #937 already followed this
convention once (base `llm-5f9ccde`); preserve it, don't regress to a
floating base.

Rebase #937's commits onto the new pinned snapshot, resolve any conflicts
with #903's now-landed changes, verify it still builds/tests clean
(`node packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` and the usual
suite), and push. Do not merge or request review yourself — the rebase is
the deliverable; the maintainer will review once the base is current.
