---
title: "Chrome's renderer sandbox still depends on brokered authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-September/
source_snapshot: https://web.archive.org/web/20160730002051id_/http://www.eros-os.org/pipermail/cap-talk/2008-September.txt.gz
source_content_sha256: aec8fe517334dd773f25b70d8d5ab9880184c3bc03ec9e35606d1f5746893177
source_authors: [Mark Seaborn, Jed Donnelley, Raoul Duke, Marcus Brinkmann, Jonathan S. Shapiro, Scott Parish, Mark S. Miller, Ben Laurie, David-Sarah Hopwood, Rob Meijer, Toby Murray, Matej Kosik, James A. Donald, David Wagner, Ihab Awad, William Pearson, Sandro Magi, Alan H. Karp, Tony Bartoletti]
source_date: 2008-09-02 to 2008-09-09
thread_subject: "Google Chrome - web browser with sandboxed rendering"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, compartments]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Chrome's process-per-tab design was immediately recognized as useful fault isolation, but process separation alone does not establish least authority. The security question is which ambient OS powers are removed from the renderer and which browser operations remain available only through a narrow broker protocol.

Mark Seaborn introduces the new browser's sandbox. The discussion asks how Linux and Windows confinement work, how plugins escape the model, and whether Caja-like language confinement complements native-process jails. A renderer that cannot directly open files or devices can still render useful pages because a more trusted browser process mediates network, UI, storage, and user-designated operations.

This is an early mainstream instance of the architecture Endo compartments use: isolate untrusted computation, strip ambient authority, and supply explicit powers through a supervising boundary. The broker interface, not the process count, determines the authority envelope.

Source: [cap-talk 2008-September archive](http://www.eros-os.org/pipermail/cap-talk/2008-September/) (Internet Archive original-bytes snapshot `web/20160730002051id_/.../2008-September.txt.gz`, sha256 `aec8fe51`), messages dated 2008-09-02 to 2008-09-09.
