---
title: "Any future for a permissive POLP/POLA stack? (AppArmor / MinorFs / E)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2012-December/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2012-December.txt.gz
source_content_sha256: 8e4ad5a7d7fa29794872101060a96a8e75cf2bb970c673211fda3150ffe9db42
source_authors: [Rob Meijer, Bennie Kloosteman]
source_date: 2012-12-19
thread_subject: "Any future for a permissive POLP/POLA stack?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, sandbox-platforms, e-language]
status: current
notes: "Derived summary, not the original messages. Dense month (196 messages); this section covers the 12-message POLA-stack-adoption thread."
---

Abstract: Rob Meijer asked the adoption question directly, having once had "great hopes" for a layered least-authority stack: **AppArmor** supplies the *static* part of POLA (initial per-executable file-system privileges, on Ubuntu/Suse), **MinorFs** supplies the *dynamic* part (per-process file-system authority, and the glue that fits file-system access to E's persistent VATs), and **E** takes POLA "way beyond just file-system access." He gave the talk repeatedly to enthusiastic feedback, yet nobody adopted the stack: the organizations he spoke to had no suitable project, were standardized on Red Hat (so introducing Ubuntu/Suse was impossible), or — like his own employer — could not introduce a new programming language. Now building a retrofit MinorFs2, he wondered aloud whether to give up on the AppArmor/MinorFs/E stack and drop pseudo-persistent-processes as a granularity level. Bennie Kloosteman's reply was bleak but concrete: doomed to fail unless backed by a big company — if Apple or Google baked it into Android or an SDK it would have a chance; Linux will be "fundamentally the same in 20 years" because its open-source nature makes the revolutionary change capabilities require impossible, though new runtimes on top (like Android) are possible, and BSD's small base gives it a shot as a new secure OS via **Capsicum**. He described his own stalled project (a Capsicum-using Mono fork exposing the Windows 8 Store Apps object-capability ABI so Store apps could run on Linux/BSD), which lost its funding after 10% completion.

## Adoption is blocked by the transition cost, not the technology

The thread is a candid post-mortem on why a technically sound POLA stack does not get used, and the causes are all *deployment*, not *design*: the OS layer (AppArmor) is distro-specific, so a Red Hat shop cannot adopt it; the language layer (E) is a new language, which enterprises refuse; and the whole thing lacks the big-company backing that alone can drive an ecosystem transition. Kloosteman's diagnosis — capabilities require a *revolutionary* change that an open, consensus-driven platform like Linux structurally cannot make, so the realistic paths are (a) a vendor baking it into a controlled platform (Android, Windows 8 Store apps, an SDK) or (b) a small-base OS (BSD/Capsicum) that can move faster — is the recurring adoption lesson of the whole archive, here stated without illusion. The failed-funding anecdote underlines it: even a concrete compatibility bridge (run capability-ABI Store apps on open OSes) needs sustained backing to cross 10% to 100%. The technology worked and drew enthusiasm; what it lacked was a party able to pay the transition cost.

## Bearing on Endo

Endo is the next iteration of exactly the AppArmor/MinorFs/E ambition — POLA from the file system up through a persistent object language — and it is explicitly designed around this thread's adoption lesson. Endo does *not* require a new OS, a specific Linux distro, or a new programming language: it runs Hardened JavaScript on an ordinary Node.js on whatever OS the user already has, which is the deployment path Meijer's stack lacked (his needed Ubuntu/Suse *and* a language switch). Kloosteman's "start where a vendor or a small fast platform can move" is answered by Endo choosing the JavaScript runtime as its substrate — the single most widely deployed managed-language platform, so no OS or language transition is demanded of the adopter. The MinorFs "dynamic POLA glued to persistent VATs" idea survives directly as Endo's persistent formula graph and per-guest dynamic authority; what changes is that Endo refuses to make adoption contingent on replacing any layer the user already has. This thread is the cautionary tale Endo's deployment strategy is built to avoid repeating. See [reducing-ambient-user-authority-install-manifest](cap-talk-2009-2012--reducing-ambient-user-authority-install-manifest.md) and [rabbitmq-capabilities-rejected-by-deployment-friction](cap-talk-2009-2012--rabbitmq-capabilities-rejected-by-deployment-friction.md), and the concept [[principle-of-least-authority]].

Source: [cap-talk 2012-December archive](http://www.eros-os.org/pipermail/cap-talk/2012-December/) (Internet Archive original-bytes `id_` snapshot of `2012-December.txt.gz`, sha256 `8e4ad5a7`), thread "Any future for a permissive POLP/POLA stack?", 2012-12-19.
