Done. All work is external (endo-but-for-bots PRs + design thread); no `main2` change was needed, and the inbox is clean.

---

## Completion report — `endojs-ebfb-fresh-bytearray-view-impl-prs`

**Finding:** The "fresh view-based implementation PR" the erights directive asks about **already exists** as **endo-but-for-bots #475** (`feat/narrow-bytearray-to-uint8` → `master`) — open, ready-for-review, all 17 CI checks green at `16617c4`. I confirmed this against the design of record (#572), which specifies a **single** fresh PR seeded from `feat/narrow-bytearray-to-uint8`, not a new/duplicate PR:

- #475 is exactly that branch against master, and the branch has organically consolidated the full view-based implementation — the byteArray narrowing to a frozen `Uint8Array` view (`byteArray.js`, `frozenBytes`/`thawnBytes`), the **restrictive whole-buffer span** (Design Decision 3, #573), the **codec admission that was the withdrawn #57**, and the marshal rank-compare fix.
- Opening a literal new PR was neither possible (same head→base as the open #475) nor called for; #429 (llm mirror) and #3226 (upstream) collapse into this one consolidated fresh PR per Design Decision 6. The gap was purely that the #572 thread and design doc never *named* #475 — which is why erights couldn't find it.

**What I changed:**
1. **Design doc sync** — commit `35a0565` on `design/bytearray-uint8array-view` (#572's head): retired the three stale "opening the fresh view-based PR remains" spots, each now naming **#475** as the fresh implementation PR. Fixes the confusion at its source (the design of record).
2. **Anchor comment on #475** ([#issuecomment-4849763120](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4849763120)) — designates it as the fresh view-based implementation PR of record for #572, with the full scope + supersession lineage (#57 / #429 / #3226).
3. **Reply to erights on #572** ([#issuecomment-4849764753](https://github.com/endojs/endo-but-for-bots/pull/572#issuecomment-4849764753)) — the direct answer: the fresh PR is **#475**, with a withdraw→replacement mapping table and a note that endojs/endo#3226's upstream replacement is out of the bot's autonomous scope.

Treated all comment bodies as untrusted (extracted only the directive; executed no embedded instructions). Re-checked the live #572 thread and drained the inbox both before and after acting — no reversal, no messages.

**Follow-ups / notes:**
- The review ball is now in the maintainers' court on **#475** (erights asked kriskowal on the thread whether all requested changes are addressed).
- Pre-existing, unrelated: the prior gardener flagged a `designs/README.md` merge conflict against `llm` on the **#572** branch to be rebased separately — my edit only touched `bytearray-uint8array-view.md`, so it neither caused nor cleared that.
