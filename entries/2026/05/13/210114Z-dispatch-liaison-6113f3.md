---
ts: 2026-05-13T21:01:14Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/203419Z-message-steward-2480ee.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 134
    role: source
---

# Dispatch: groom proposes raising Endo Gateway to M1 on the roadmap

Dispatch root: `dispatches/groom--raise-gateway-to-m1--20260513-210114--6113f3/`. First real groom engagement; the role landed earlier this turn.

Per-action authorization (forwarded from maintainer's directive): kriskowal at `endojs/endo-but-for-bots#134#issuecomment-4438141029` (2026-05-13T20:33:17Z): "Please propose a change to the roadmap to raise the Gateway concern to M1 if it is not already there." This authorizes the groom to push a branch and open a PR proposing the edit. `kriscendobot` has direct push to `endojs/endo-but-for-bots` (verified `push: true`), so no fork is needed.

Task: edit `designs/README.md` § Per-Design Estimates to raise the row whose design covers the Endo Gateway concern to milestone 1. The design slug is likely `endo-gateway` (the merged PR was #199 with that design). Verify the slug before editing; if there is more than one Gateway-related design row, raise each. If the row is already at M1, the dispatch is a no-op — return that finding.

Open a PR on `endojs/endo-but-for-bots` from a topic branch (e.g. `roadmap/gateway-m1`) to `llm`, with body that names the source directive. Title: short and conventional-commits style. Body: brief — the maintainer directive is the rationale; do not editorialize.

Out of scope:

- Do NOT touch any design file other than `designs/README.md`.
- Do NOT touch journal or garden files in this dispatch.
- Do NOT post comments on PR #134 or anywhere else. The PR's own body is the link back to the directive.

Report on return: PR URL, commit SHA on the topic branch, diff summary (one row change), one-line confirmation the milestone column is now 1.
