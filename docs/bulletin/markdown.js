// markdown.js — a small, dependency-free renderer for the bulletin README.
// Covers the constructs the journalist bulletin emits: ATX headings, unordered
// lists, blockquotes, paragraphs, and inline bold / italic / code / links. Not
// a full CommonMark implementation; it is deliberately minimal so the page
// carries no third-party runtime. All text is HTML-escaped before inline markup
// is applied, so bulletin content cannot inject markup.
const Markdown = (() => {
  const esc = (s) =>
    s
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');

  const CODE = ''; // private-use sentinel guarding code-span contents

  // Inline: code spans first (so their contents are not re-marked), then links,
  // bold, italic. Operates on already-escaped text.
  function inline(text) {
    const codes = [];
    text = text.replace(/`([^`]+)`/g, (_, c) => {
      codes.push(c);
      return `${CODE}${codes.length - 1}${CODE}`;
    });
    text = text.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, (_, label, href) => {
      const safe = /^https?:\/\//.test(href) ? href : '#';
      return `<a href="${safe}" target="_blank" rel="noopener noreferrer">${label}</a>`;
    });
    text = text.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    text = text.replace(/(^|[^*])\*([^*]+)\*/g, '$1<em>$2</em>');
    text = text.replace(/(^|[\s(])_([^_]+)_/g, '$1<em>$2</em>');
    text = text.replace(
      new RegExp(`${CODE}(\\d+)${CODE}`, 'g'),
      (_, i) => `<code>${codes[+i]}</code>`,
    );
    return text;
  }

  function render(md) {
    const lines = esc(md).split('\n');
    const out = [];
    let para = [];
    let list = null;
    let quote = [];

    const flushPara = () => {
      if (para.length) {
        out.push(`<p>${inline(para.join(' '))}</p>`);
        para = [];
      }
    };
    const flushList = () => {
      if (list) {
        out.push(`<ul>${list.map((li) => `<li>${inline(li)}</li>`).join('')}</ul>`);
        list = null;
      }
    };
    const flushQuote = () => {
      if (quote.length) {
        out.push(`<blockquote>${inline(quote.join(' '))}</blockquote>`);
        quote = [];
      }
    };
    const flushAll = () => {
      flushPara();
      flushList();
      flushQuote();
    };

    for (const raw of lines) {
      const line = raw.replace(/\s+$/, '');
      const h = line.match(/^(#{1,6})\s+(.*)$/);
      const li = line.match(/^[-*]\s+(.*)$/);
      const bq = line.match(/^>\s?(.*)$/);

      if (h) {
        flushAll();
        const level = h[1].length;
        out.push(`<h${level}>${inline(h[2])}</h${level}>`);
      } else if (li) {
        flushPara();
        flushQuote();
        (list ||= []).push(li[1]);
      } else if (bq) {
        flushPara();
        flushList();
        quote.push(bq[1]);
      } else if (line.trim() === '') {
        flushAll();
      } else {
        flushList();
        flushQuote();
        para.push(line);
      }
    }
    flushAll();
    return out.join('\n');
  }

  return { render };
})();

if (typeof module !== 'undefined') module.exports = Markdown;
