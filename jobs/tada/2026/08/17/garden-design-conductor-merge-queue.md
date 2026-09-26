The work is complete. Design document written, mermaid validated, index updated, committed, and opened as a draft PR.

---

**Completion report — `garden-design-conductor-merge-queue`**

**Deliverable:** Draft design PR **kriscendobot/garden#72** — "design: the conductor as a merge queue" (head `design/conductor-merge-queue`, base `main2`, draft, bot-authored). This is the garden's sanctioned PR-against-itself design exception (`designs/README.md` § PR-against-garden exception).

**What I did:**
- Wrote `designs/conductor-merge-queue.md` (Status: Proposed) and added an index row to `designs/README.md`.
- Grounded the design in the existing machinery I read first: `roles/conductor/AGENT.md`, `designs/conductor-rebase-before-merge.md`, `ci-wait-merge.sh` (exit-code contract), `safe-rebase.sh`, `designs/approval-reconciler.md`, `designs/orchestration-jobs.md`, `pr-dependency-topo-sort`, `stacked-pr-build`, and `requeue-rediscover-prior-work`.
- Validated both mermaid fences parse (`flowchart-v2` OK ×2, parse-only per the mermaid-validation skill).

**What the design covers (all six required areas):**
1. **Handoff/entry/ordering** — approval = enqueue signal (comment-watcher + approval-reconciler collapse into it, no new producer); queue keyed per `(repo, trunk)`; stable topological order over the stacked-PR dep graph, ties by approval-FIFO then `(repo, number)`.
2. **Serial attempt loop** — one change in-attempt at a time; a change that can't go green or needs a nontrivial rebase **steps aside** and the line advances (the queue never wedges on one stuck change).
3. **Trivial/nontrivial boundary** — the load-bearing definition: `git range-diff` all-`=` (with clean `safe-rebase`) ⇒ trivial, approval preserved; any `!`/`<`/`>`, conflict resolution, or commit-set change ⇒ nontrivial. The policy width (context-only `!`; lockfile regeneration) is explicitly flagged as the **maintainer's call**, both options presented with risk, strict recommended.
4. **Return path** — weaver resolves → maintainer re-reviews with a rendered range-diff of *what changed* → re-approval re-enqueues; bounded by serialization + a re-review counter + frozen-base pin after two returns (the "pin the merge base" verb).
5. **Relationship to existing** — a new leader-only singleton daemon (`merge-queue.sh`, no-LLM, stateless-per-tick like the approval-reconciler) that subsumes conduct *dispatch* and composes with the existing `ci-wait-merge.sh` conduct worker; single-in-flight uses the board itself as the reap-safe lock.
6. **Failure/recovery** — journal-derived state (no desyncable queue file), atomic merge, requeue rediscovers via the on-GitHub marker, leadership handoff reconstructs the queue on first tick.

The doc explicitly states what it does **not** cover (ferrying, GitHub-native merge queue, shepherd/weaver internals, cross-trunk ordering, concrete `rebase-triviality.sh`/unit shapes) and lists open questions.

**Not implemented** — design-only, as instructed. The draft PR is left draft; its design-panel gauntlet is staged automatically by the completion machinery.

**Follow-ups:** the maintainer decisions in § Open questions (trivial-boundary policy width, return-loop threshold, tie-break, Dependabot-path placement) block a subsequent `build` job; the implementation lands on `main2` per CLAUDE.md Conventions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-design-conductor-merge-queue.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 2741 tokens (2610310 cached reads)
- Output: 28610 tokens
- Cost: $3.0661140000000002 (1 engagement(s) unpriced)
- Wall-clock: 457s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
