Done. The index gap is closed.

**What I did:** Added the missing `tc39-module-harmony--compartments-compartment-class` entry to `library/sources/README.md`, inserting it between the layer-3 (Evaluators) and GRAPH rows so it sits in cluster order (overview → layer 0 → 1 → 2 → 3 → **4** → GRAPH).

**The row** follows the existing per-source format, drawing values from the source file's frontmatter:
`| [Compartments — layer 4 (Compartment class)](tc39-module-harmony--compartments-compartment-class.md) | https://github.com/tc39/proposal-compartments/blob/master/4-compartment.md | 1 | 5 | current |`
(canonical human blob URL matching siblings, section_count 5, status current).

**How it landed:** Composed the whole-file replacement from the current `origin/journal2` tip (verified byte-identical to the live worktree), then landed it through `scripts/jobs/land-journal-edit.sh --base-blob 777d1f8… library/sources/README.md` — the sanctioned producer-clone path, no hand-git on the live journal worktree. Landing succeeded (CAS push verified reachable), and the row is confirmed present on the freshly re-fetched `origin/journal2` tip.

**Follow-ups:** None. The source file was already `current` and correctly section-counted; only the index link was missing, and it now resolves.
