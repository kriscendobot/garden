---
child-book-ch3-host: endolin-garden2-5bcdff64
child-book-ch5-host: endolin-garden2-5bcdff64
child-book-ch8-host: endolin-garden2-5bcdff64
order: parallel
children: book-ch1 book-ch2 book-ch3 book-ch4 book-ch5 book-ch6 book-ch7 book-ch8
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-09-30T03:45:47Z
---

A comprehensive book about the garden itself — how it works, how it
operates, how to use it, how to create your own instance (through
metamorphosis), and exacting detail on roles, skills, procedures,
cybernetics, and budgeting — maintainer request, 2026-09-30.

Eight chapters, run in parallel since each is independent: philosophy/
history/metamorphosis, architecture/operation, using the garden, creating
your own instance, a roles reference, a skills reference, procedures/
workflows, and cybernetics/budgeting. Each writes its chapter to
`journal/projects/garden-book/`. The largest two chapters (roles, skills)
are explicitly permitted to post their own follow-on part2/part3 jobs if a
single cycle can't cover their full scope. A separate assembly-and-publish
job, blocked on this orchestration's completion, gathers whatever chapters
exist once this orchestration finishes and publishes the assembled book as
an HTML minion-town clip.
