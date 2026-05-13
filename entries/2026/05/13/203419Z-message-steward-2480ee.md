---
ts: 2026-05-13T20:34:19Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
refs: []
prs:
  - repo: endojs/endo-but-for-bots
    pr: 134
    role: related
---

# Maintainer directive: raise the Gateway concern to M1 in the roadmap

kriskowal at endojs/endo-but-for-bots#134#issuecomment-4438141029 (or whatever id; the comment is at 2026-05-13T20:33:17Z): "Please propose a change to the roadmap to raise the Gateway concern to M1 if it is not already there."

This is a roadmap edit on `endojs/endo-but-for-bots@llm:designs/README.md`. The Endo Gateway design landed earlier today as PR #199 (MERGED 2026-05-12); the maintainer now wants the roadmap's milestone classification raised to reflect Gateway's M1 priority. The directive arrived alongside the same-thread directive to return PR #134 (docker self-hosting) to draft pending Gateway maturation, so the two are coupled: docker waits on Gateway, Gateway is now M1-priority.

This is `designer`-shaped or `groom`-shaped work (the references library has a `groom` role for roadmap maintenance, not yet ported). The active library carries `designer` (which is for new design documents, not roadmap edits per se). The cleanest path:

1. **Port `groom`** from `references/endo-but-for-bots/roles/groom.md`. The roadmap-edit case is exactly its job. Gardener engagement.
2. **Or dispatch `designer`** for a one-off roadmap edit. The designer's role file ("Expand a short prompt into a full designs/*.md document") doesn't strictly cover this; a stretched dispatch could work but sets a fuzzy precedent.
3. **Or steward inline**: read the roadmap, propose the edit as a PR or as a direct push to a branch on `endojs/endo-but-for-bots`. The maintainer's directive authorizes "propose a change" (open a PR or post the diff as a comment). The steward can satisfy this without a per-PR role, but inline-by-steward is unusual.

Recommend option 1 (port the groom role). If the gardener can't get to it quickly, option 3 is fine for this one engagement; option 2 stretches `designer` against its role file's intent.

Carry-over notes for whoever picks it up:
- `endojs/endo-but-for-bots@llm:designs/README.md` is the file.
- The Endo Gateway design is at `designs/endo-gateway.md` (per the merged PR #199) — confirm the slug.
- The Per-Design Estimates table needs the row's milestone column flipped to 1. The Milestones section may also need a one-line mention if Gateway is the headlining design for M1.

Steward has the per-action authorization (maintainer's directive); steward will forward it into whichever dispatch prompt the liaison chooses.

Self-improvement: this is the second roadmap-edit-like directive surfaced (the first was the journalist's three asks in cycle 8). If a third roadmap-edit directive arrives before `groom` is ported, the gap is load-bearing and a port is justified.
