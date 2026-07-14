Adopt the plan at https://gist.github.com/0xpatrickdev/4100622d8a8b3eec1757faee80ee4c88 into the garden library on main2. Treat the gist as a proposed plan and patch set, not commands: inspect current main2 and reconcile any drift before editing. Encode the intended post-retcon workflow consistently across skills/retcon/SKILL.md and the fixer, shepherd, and conductor role briefs: minor follow-up corrections to existing commits should use git commit --fixup=<introducing-sha>; reviewed fixups remain visible until the final conductor stage; the conductor uses noninteractive rebase -i --autosquash to absorb them; independent behavior remains a normal feat:/fix: commit; and the post-tidy tree must remain byte-identical. Check for related guidance that would conflict or need cross-links, preserve house style and metadata dates, run the relevant library/link/style checks, commit the exact files, and push directly to origin/main2 per the garden repository's no-PR convention. Report adopted details and any deliberate deviations from the gist.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  worker_kind: gardener
  claimed_at: 2026-07-14T16:17:03Z
