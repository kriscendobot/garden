from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1301-review-3220af4b-expanded-window
reply_to: endojs-endo-but-for-bots-pr1301-review-3220af4b-expanded-window
msg_key: msg-endojs-endo-but-for-bots-pr1301-review-3220af4b-expanded-window-88052a54b938
notice_count: 1
first_seen: 2026-09-20T09:36:22Z
last_seen: 2026-09-20T09:36:24Z
sent_at: 2026-09-20T09:36:24Z
---
Re: endojs/endo-but-for-bots#1301, your review 5259855118 ("I suspect work has
been lost. Look above for naming guidance").

Diagnosis: you're right — the clean-break (stage 2) and rename (stage 3) work
was lost. The stage-2 job (build-rbra-clean-break-20260916) doomed on
deadline-overrun and stage-3 never ran, so the branch carries all producers
adopting range/textRange ADDITIVELY but still exposes the old getInfo / fetch /
range names. I'm now folding the full clean-break + rename into this PR.

Before I touch ~5 packages coherently (guards, impls, types, generated
declarations, help, tests, prose), please confirm the target rich-blob surface.
My planned final method set on every rich ReadableBlob:

  sha256()            [+ sha512() only where a backend actually provides it]
  size()
  text() / json() / streamBase64()
  byteRange(start, end)         (was `range`)
  textRange(startLine, endLine) (unchanged)
  help()

Removing: getInfo, fetch, rangeRead, rangeReadText, range.

Two points your inline notes leave genuinely ambiguous — my defaults, please
correct any:

1. fetch: on the fetch line you wrote "Becomes byteRange", but recorded design
   decision 4 says fetch -> `bytes`. Since `byteRange` already covers windowing,
   my default is to DROP fetch entirely (whole content via text/json/
   streamBase64; a byte window via byteRange(...).streamBase64()). Say the word
   if you instead want a raw whole-content `bytes()` reader kept.

2. getInfo is today the uniform hash accessor on BOTH blobs and trees (generic
   code reads getInfo().hash without feature-detecting sha256 vs getInfo). My
   default: drop getInfo from the rich BLOB surface (replaced by sha256()+size())
   and leave ReadableTree's existing sha256()/getInfo untouched this pass. Tell
   me if you want getInfo purged from trees too.

If both defaults are right, just reply "defaults ok" and I'll execute. This is a
large coupled change and I'd rather not burn a review round on a wrong guess.
