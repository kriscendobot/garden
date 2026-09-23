---
title: "Ad hominem security: a strategic pejorative"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-March/
source_snapshot: http://web.archive.org/web/20160730001520id_/http://www.eros-os.org/pipermail/cap-talk/2002-March.txt.gz
source_content_sha256: 5f07dc5aa961c927cd53ac66447d99492bb660c966fc9ca14ca79038e847c4dc
source_authors: [Norman Hardy, Ka-Ping Yee]
source_date: 2002-03-14
thread_subject: "A strategic pejorative"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Norman Hardy proposes a name for the Microsoft/Palladium premise that security is achieved by knowing the author of the code that runs on your machine: "ad hominem security", a deliberately chosen strategic pejorative, since it locates trust in *who wrote* code rather than in *what the code can do*. Ka-Ping Yee amplifies with a letter to the New York Times responding to Jonathan Zittrain's "Taming the Consumer's Computer" op-ed on trusted PCs. Yee's core distinction: whenever one meets the word "trusted", ask "trusted by whom?" A computer should reliably carry out the wishes of its *owner*, not its manufacturer; and it is entirely possible to build computers that safely run untrusted software, so the reliability Zittrain wants does not require surrendering the freedom to run arbitrary programs. The thread is an early capability-community framing of the trusted-computing / DRM debate.

## Ad hominem security (Hardy)

Hardy's coinage targets the identity-based model of trust: authenticate the author of code and admit code from trusted authors. He labels this "ad hominem security" by analogy to the logical fallacy of judging a claim by its source rather than its content, and offers the term as a strategic pejorative for use in argument. The capability position is the contrast: confine what code can do (grant it only the authority it needs) rather than decide whether to run it based on who signed it.

## Trusted by whom? (Yee)

Yee's letter attacks the ambiguity in "trusted PC". Zittrain framed reliability and security as requiring the loss of freedom to share and control information; Yee answers that this misses the distinction between control by the consumer and control by the manufacturer. A reliable machine is one that reliably does what its *owner* wishes. The "trusted" PCs Microsoft and content providers were promoting act as digital gatekeepers, admitting only software that looks or behaves a certain way, with the manufacturer holding the guest list, which converts reliability into manufacturer control over what the user may run and do. Yee's rebuttal is that untrusted software can be run safely (the capability claim), so the appliance-ization of the PC is a policy choice dressed as a technical necessity.

Source: [cap-talk 2002-March archive](http://www.eros-os.org/pipermail/cap-talk/2002-March/) (Internet Archive original-bytes snapshot `web/20160730001520id_/.../2002-March.txt.gz`, sha256 `5f07dc5a`), messages dated 2002-03-14.
