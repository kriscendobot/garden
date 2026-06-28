// github.js — pure client-side GitHub access for the bulletin.
//
// Reads (bulletin README, maintainer inbox) go through the REST Contents API
// unauthenticated when no token is present (the garden repo is public). The
// reply commit is built atomically through the Git Data API so a single commit
// both delivers the reply and archives the original message.
//
// All requests hit https://api.github.com, which returns permissive CORS
// headers, so everything here runs in the browser with no backend.

const GH = (() => {
  const cfg = window.GARDEN_BULLETIN_CONFIG;
  const API = 'https://api.github.com';
  const TOKEN_KEY = 'garden_gh_token';

  // --- token storage (the maintainer's machine only) --------------------------
  const getToken = () => localStorage.getItem(TOKEN_KEY) || '';
  const setToken = (t) => localStorage.setItem(TOKEN_KEY, t.trim());
  const clearToken = () => localStorage.removeItem(TOKEN_KEY);
  const hasToken = () => !!getToken();

  // --- utf-8 <-> base64 (handles non-ASCII bulletin text) ---------------------
  const b64encode = (str) =>
    btoa(String.fromCharCode(...new TextEncoder().encode(str)));
  const b64decode = (b64) =>
    new TextDecoder().decode(
      Uint8Array.from(atob(b64.replace(/\n/g, '')), (c) => c.charCodeAt(0)),
    );

  async function api(path, opts = {}) {
    const headers = {
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      ...(opts.headers || {}),
    };
    const t = getToken();
    if (t) headers.Authorization = `Bearer ${t}`;
    const res = await fetch(API + path, { ...opts, headers });
    if (!res.ok) {
      let detail = '';
      try {
        detail = (await res.json()).message || '';
      } catch (_) {
        /* ignore */
      }
      const err = new Error(`GitHub ${res.status}: ${detail || res.statusText}`);
      err.status = res.status;
      throw err;
    }
    return res.status === 204 ? null : res.json();
  }

  const repoPath = (p) => `/repos/${cfg.owner}/${cfg.repo}${p}`;

  // --- reads ------------------------------------------------------------------

  // Fetch and decode a file on the journal branch. Returns null on 404.
  async function getFile(path, ref = cfg.journalBranch) {
    try {
      const j = await api(repoPath(`/contents/${path}?ref=${ref}`));
      return { text: b64decode(j.content), sha: j.sha };
    } catch (e) {
      if (e.status === 404) return null;
      throw e;
    }
  }

  // List a directory on the journal branch. Returns [] on 404.
  async function listDir(path, ref = cfg.journalBranch) {
    try {
      const j = await api(repoPath(`/contents/${path}?ref=${ref}`));
      return Array.isArray(j) ? j : [];
    } catch (e) {
      if (e.status === 404) return [];
      throw e;
    }
  }

  async function dirExists(path, ref = cfg.journalBranch) {
    try {
      await api(repoPath(`/contents/${path}?ref=${ref}`));
      return true;
    } catch (e) {
      if (e.status === 404) return false;
      throw e;
    }
  }

  // --- atomic reply commit (Git Data API) -------------------------------------
  // Builds one commit on the journal branch that (a) adds `replyPath` with
  // `replyBody` WHEN a reply body is given, (b) copies `unreadPath` to `readPath`
  // (the archive), and (c) deletes `unreadPath`. An empty acknowledgement omits
  // the reply blob and just moves unread -> read (kriskowal #10). Retried against
  // a moved ref so the ref update is a compare-and-swap, mirroring the bus's own
  // push protocol.
  async function commitReply({ replyPath, replyBody, unreadPath, readPath, origSha, message }) {
    const branch = cfg.journalBranch;
    for (let attempt = 0; attempt < 6; attempt++) {
      const ref = await api(repoPath(`/git/ref/heads/${branch}`));
      const headSha = ref.object.sha;
      const headCommit = await api(repoPath(`/git/commits/${headSha}`));

      const tree = [];
      // Add the reply blob only when a reply body was given (empty
      // acknowledgement = mark-as-read only, no reply file).
      if (replyPath && replyBody) {
        const blob = await api(repoPath('/git/blobs'), {
          method: 'POST',
          body: JSON.stringify({ content: b64encode(replyBody), encoding: 'base64' }),
        });
        tree.push({ path: replyPath, mode: '100644', type: 'blob', sha: blob.sha });
      }
      // Archive the original (move unread -> read) when we were given one.
      if (unreadPath && readPath && origSha) {
        tree.push({ path: readPath, mode: '100644', type: 'blob', sha: origSha });
        tree.push({ path: unreadPath, mode: '100644', type: 'blob', sha: null });
      }

      const newTree = await api(repoPath('/git/trees'), {
        method: 'POST',
        body: JSON.stringify({ base_tree: headCommit.tree.sha, tree }),
      });
      const newCommit = await api(repoPath('/git/commits'), {
        method: 'POST',
        body: JSON.stringify({
          message,
          tree: newTree.sha,
          parents: [headSha],
        }),
      });
      try {
        await api(repoPath(`/git/refs/heads/${branch}`), {
          method: 'PATCH',
          body: JSON.stringify({ sha: newCommit.sha, force: false }),
        });
        return newCommit.sha;
      } catch (e) {
        // 422 == the branch moved under us; rebuild on the new head and retry.
        if (e.status === 422 && attempt < 5) continue;
        throw e;
      }
    }
    throw new Error('reply commit failed after retries (branch kept moving)');
  }

  return {
    cfg,
    getToken,
    setToken,
    clearToken,
    hasToken,
    getFile,
    listDir,
    dirExists,
    commitReply,
  };
})();
