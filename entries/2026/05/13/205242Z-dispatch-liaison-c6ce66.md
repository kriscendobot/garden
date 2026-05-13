---
ts: 2026-05-13T20:52:42Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/072735Z-message-steward-e50e62.md
  - entries/2026/05/13/110355Z-result-gardener-7352e8.md
---

# Dispatch: gardener records erights authority structure and updates monitor surfacing

Dispatch root: `dispatches/gardener--erights-authority-structure--20260513-205251--c6ce66/`.

The maintainer authorized this engagement at ~16:20 UTC after the steward's monitor skills silently swallowed several erights reviews on garden-authored PRs (notably #69 `fix(pass-style): treat document.all-like values as objects`). The `monitor-endo-but-for-bots` skill currently routes `PullRequestReviewEvent` by `kriskowal` vs `other reviewers`; erights is neither. He is a senior collaborator on Endo whose authority on pass-style / SES / hardened-JS / capability-security / OCapN matters meets or exceeds kriskowal's. On garden-internal infrastructure and kriskowal's personal scope, his authority is lesser or non-applicable.

Tasks:

1. Add an `## Authority structure` section to `journal/projects/endo/README.md` and `journal/projects/endo-but-for-bots/README.md`. Name erights as a senior contributor with the topic-scoped authority framing above. State the practical rule for agents reading the project README: erights' review/comment on a topic-matching PR (pass-style, SES, hardened-JS, OCapN-protocol, capability-security) carries kriskowal-equivalent (or greater) weight on the technical question; on garden infrastructure or scope-out-of-topic, his input is senior-contributor input rather than maintainer-equivalent. Phrase it so it generalizes: future per-project READMEs can adopt the same shape for other non-default-authority actors. The journalist's role file should *not* be updated in this dispatch (the journalist owns rendering, not authority data).

2. Update `skills/monitor-endo-but-for-bots/SKILL.md` and `skills/monitor-endo/SKILL.md`:
   - `PullRequestReviewEvent` from `erights` on a topic-matching PR (heuristic: PR title or labels mention `pass-style`, `ses`, `hardened`, `harden`, `marshal`, `pattern`, `eventual-send`, `captp`, `ocapn`, `capability`; OR the PR touches files under `packages/{pass-style,ses,marshal,patterns,eventual-send,captp}/`): surface to the bulletin and route a `message` to liaison so the maintainer can decide how to react. Do NOT auto-dispatch fixer; that remains a kriskowal-directive privilege.
   - `IssueCommentEvent` or `PullRequestReviewCommentEvent` from `erights` on a kriscendobot-authored PR: same surfacing rule.
   - Other reviewers / non-topic PRs: keep the existing "journal only" fallback.

3. Add a brief section to `roles/COMMON.md` titled "**Authority structure of upstream projects.**" explaining the pattern: per-project READMEs may name non-default-authority actors and topic-scopes; per-project monitor skills consult that data to decide whether to surface a non-maintainer review. Cite the endo project README as the prototype. Keep it short — the canonical place for an actor's authority is the project README, not COMMON.md.

Out of scope:

- Do NOT add an authority section to the other project READMEs (`agoric-sdk`, `cosgov`, `garden`, `ocapn`). The erights pattern is endo-specific today; other projects' authority structures land when the maintainer surfaces them.
- Do NOT modify `roles/{liaison,steward,monitor,review-queue,boatman,fixer,weaver,shepherd,conductor,designer,scout,botanist,major-general,journalist,librarian,scholar,timekeeper,gardener}/AGENT.md` beyond what's strictly needed (the monitor role file itself probably doesn't need an edit; the per-project skills carry the data).
- Do NOT retroactively re-process the recent erights events the steward swallowed silently. The journal is append-only; the rule takes effect for future events.
- Do NOT touch the groom port (concurrent gardener dispatch handles that).

Report on return: commit SHAs on `main` and `journal`, the chosen heuristic for "topic-matching PR" (file paths vs labels vs title; pick one or document a combination), and a one-line confirmation that the rule is now ready to fire on the next erights event.
