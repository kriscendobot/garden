Both worktrees removed, both branches pushed, comparison posted, maintainer notified. Here's my completion report.

---

## Completion report: `sturdyref-retention-competing-design-pair`

**Outcome:** The competing design pair is complete, mutually aligned, compared by a design panel, and surfaced to the maintainer for the decision. No implementation done (design-only, as required).

### What I did

1. **Assessed both plans against the directive + #521.** #511 (FinalizationRegistry) was already aligned with #521's key correction — that a SturdyRef is an **inert opaque data box**, *not* a presence, *not* registered with `HandledPromise`, with `@endo/eventual-send` unchanged. #510 (endor syscall) still carried the stale `E(sturdyRef)`/`HandledPromise` framing in item 1.

2. **Completed #510 as a genuine competitor (designer pass).** Rewrote its item-1/pass-style framing to the inert-data-box model (enliven → presence → `E(presence)`), corrected the unbox step, Rule 1, the OCapN integration test, acceptance criteria, and the problem statement; fixed stale sibling-branch references; cross-linked #511 and #521; stamped the Updated date and synced `designs/README.md`. Its differentiator (daemon-side ephemeral retention + `retain`/`release` syscall) was already strong and left intact. → pushed to `design/sturdy-refs-via-endor-syscall`.

3. **Tightened #511 for symmetry.** Added #521 and #510 to its dependencies table, dropped a residual `HandledPromise` claim in its layer table that contradicted the rest of the doc (surfaced by the panel), stamped Updated, synced README. → pushed to `design/sturdy-refs-via-finalization-registry`.

4. **Ran a solicitor-style design panel.** Two independent jurors (ocap-kernel/determinism lens; petname-daemon/user-agency lens). Both independently converged on the **same recommendation**.

5. **Surfaced the comparison + recommendation on #500** (side-by-side crux table + synthesis) and **messaged the maintainer** the recommendation and decision ask.

### Recommendation (panel consensus)

**Synthesis with #510 (endor syscall) as the spine:** daemon owns retention, authoritative per-handle revocation edges, no new `FinalizationRegistry`; **plus** (1) promote #510's deferred proactive per-turn `deleteExport` to a *requirement* so both retention paths are GC-timing-independent; (2) keep #511's `FinalizationRegistry` only as an optional off-by-default leak-detector; (3) borrow #511's local-only-at-the-daemon-boundary rule. Plan A is not recommended as primary because it makes the hard user-agency invariant depend on nondeterministic GC and its holder list is admittedly stale.

### Final states
- **#510** — OPEN, not draft (`design/sturdy-refs-via-endor-syscall`)
- **#511** — OPEN, draft (`design/sturdy-refs-via-finalization-registry`)
- Comparison: endojs/endo-but-for-bots#500 comment `4805502325`
- Worktrees torn down; bot identity throughout (endolinbot).

### Follow-ups
- **`getStudyRefLocator` is a typo** for `getSturdyRefLocator` in #521's shipped surface (both designs mirror it) — worth fixing in #521 before it sets the public name. Flagged on #500 and to the maintainer.
- Decision itself is the maintainer's; both PRs left open awaiting it (no auto-merge — these are design plans, and endo-but-for-bots design PRs await the human call here).
