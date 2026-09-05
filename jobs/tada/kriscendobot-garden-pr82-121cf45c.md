Updated the release-supervisor design on `main2` (`9b94302f39`) and PR #82 (`0763ca945f`).

- Dispatch/name: `release-supervisor`, invoked as `supervise release <owner/repo>#<N>`; reply `3939974169`.
- Authority: maintainer-rooted proxy delegation, no separate supervisor/repository allowlists; reply `3939974232`.
- Scope: minion.town only, with CI plus live production deployment proof; reply `3939974279`.
- Vetoes: `CHANGES_REQUESTED` or unanswered/unacknowledged maintainer feedback; reply `3939974327`.
- Tier: Fable/mentat only, without fallback; reply `3939974353`.

Posted the [completion summary](https://github.com/kriscendobot/garden/pull/82#issuecomment-5550525866). The remaining open question is the initial minion.town release-criteria predicate set.

Checks: five pre-push probes passed, local verification exited 0, and Mermaid parsed as `flowchart-v2`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr82-121cf45c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 452s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
