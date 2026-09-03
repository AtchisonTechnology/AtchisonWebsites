#!/usr/bin/env python3
"""
Helper used during the Spec0024 Part 5 back-catalog export to turn one
post's raw data into src/_articles/<slug>.md. This is the mechanical half
of the pipeline described in Spec0024 Part 5 (HTML cleanup, pandoc
conversion, front-matter formatting), driven from a small JSON descriptor
written per post, since the raw content came in one post at a time via the
Kit_SAI MCP connection rather than a single script run against the live
Kit API (this sandboxed session cannot reach api.kit.com).

Usage: python3 script/import_post.py path/to/post.json
"""
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

from bs4 import BeautifulSoup, NavigableString

SITE_ROOT = Path(__file__).resolve().parent.parent
ARTICLES_DIR = SITE_ROOT / "src" / "_articles"

AD_UTM_CONTENT_RE = re.compile(r"utm_content=[^&\"']*(ad|cta|sponsor)", re.I)
READ_ONLINE_RE = re.compile(r"^\s*read\b.*\bonline\b", re.I)
BIO_START_RE = re.compile(r"^\s*Lee Atchison is a software architect", re.I)


def strip_kit_chrome(html: str) -> str:
    soup = BeautifulSoup(html, "html.parser")

    for tag in soup.find_all("style"):
        tag.decompose()

    # ck-layout-block ad/house-ad tables (has the class directly)
    for tag in soup.find_all("table", class_=lambda c: c and "ck-layout-block" in c):
        tag.decompose()

    # Promo/CTA blocks that don't carry the ck-layout-block class (plain
    # sponsor tables) -- identified by an embedded ad/cta/sponsor-tagged
    # link or an email-button class anywhere inside. Innermost-first (the
    # whole document is technically a "div containing an ad link" once you
    # walk far enough up, so a matching child must be removed before its
    # ancestors are even considered).
    for tag in reversed(soup.find_all(["table", "div"])):
        if tag.decomposed or not tag.find("a"):
            continue
        html_frag = str(tag)
        if AD_UTM_CONTENT_RE.search(html_frag) or 'class="email-button"' in html_frag:
            tag.decompose()

    # Promo callout blockquotes (webinar/event announcements)
    for tag in soup.find_all("div", class_=lambda c: c and "blockquotes" in c):
        tag.decompose()

    for tag in soup.find_all(string=re.compile(r"ck\.ad_slot")):
        tag.replace_with("")

    # Trailing "Read this article/online" CTA paragraph(s)
    for p in soup.find_all("p"):
        text = p.get_text(strip=True).replace("​", "")
        if READ_ONLINE_RE.match(text):
            p.decompose()

    # Trailing bio paragraph (the layout renders its own from bio.yml)
    for p in soup.find_all("p"):
        text = p.get_text(strip=True)
        if BIO_START_RE.match(text):
            p.decompose()

    for tag in soup.find_all("hr"):
        tag.decompose()

    # Drop now-empty paragraphs/divs (zero-width space, stray whitespace --
    # what's left of a sponsor block's outer wrapper once its ad table,
    # matched above, has been decomposed out from under it). Bottom-up and
    # run twice so a div that's only empty once ITS empty child div is
    # gone also gets cleaned up.
    for _ in range(2):
        for tag in reversed(soup.find_all(["p", "div"])):
            if not tag.decomposed and not tag.get_text(strip=True).replace("​", "") and not tag.find(["img"]):
                tag.decompose()

    # Strip presentation-only attributes everywhere
    for tag in soup.find_all(True):
        for attr in ("class", "style", "target", "rel", "align", "width", "height", "cellpadding", "cellspacing", "border"):
            if attr in tag.attrs:
                del tag.attrs[attr]

    # Unwrap the outer table(s)/tbody/tr/td wrapper Kit's email template adds
    for tag_name in ("table", "tbody", "tr", "td", "thead", "colgroup", "col", "body", "html", "head"):
        for tag in soup.find_all(tag_name):
            tag.unwrap()

    return str(soup)


def html_to_markdown(html: str) -> str:
    with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as f:
        f.write(html)
        path = f.name
    result = subprocess.run(
        ["pandoc", "--from", "html", "--to", "gfm", path],
        capture_output=True, text=True, encoding="utf-8",
    )
    if result.returncode != 0:
        raise RuntimeError(f"pandoc failed: {result.stderr}")
    markdown = result.stdout
    markdown = re.sub(r"\A#\s+[^\n]+\n+", "", markdown)
    return markdown.strip()


YAML_INDICATOR_CHARS = set('"\'-?:,[]{}#&*!|>%@`')


def yaml_scalar(value):
    if value is None:
        return ""
    s = str(value)
    needs_quoting = (
        s == ""
        or s != s.strip()
        or any(c in s for c in [":", "#"])
        or (s[0] in YAML_INDICATOR_CHARS)
    )
    if needs_quoting:
        return json.dumps(s)
    return s


def front_matter_for(data: dict) -> str:
    lines = ["---"]
    lines.append(f"title: {yaml_scalar(data.get('title'))}")
    lines.append(f"subtitle: {yaml_scalar(data.get('subtitle', ''))}")
    lines.append(f"author: {yaml_scalar(data.get('author') or 'Lee Atchison')}")
    lines.append("status: published")
    lines.append(f"created: {data.get('created')}")
    lines.append(f"date: {data.get('date')}")
    lines.append(f"published_on: {data.get('published_on')}")
    lines.append("")
    lines.append(f"sai_url: {data.get('sai_url')}")
    lines.append(f"email_sent: {data.get('email_sent')}")
    lines.append("linkedin_url:")
    lines.append("")
    lines.append(f"hero_image: {data.get('hero_image') or ''}")
    lines.append("")
    lines.append("internal_note:")
    lines.append(f"meta_description: {yaml_scalar(data.get('meta_description'))}")
    lines.append(f"slug: {data.get('slug')}")
    lines.append("description: >")
    lines.append(f"  {data.get('description', '')}")
    if data.get("former_slug"):
        lines.append(f"former_slug: {data['former_slug']}")
    lines.append("categories:")
    for c in data.get("categories", []):
        lines.append(f"  - {json.dumps(c)}")
    if data.get("series"):
        lines.append(f"series: {json.dumps(data['series'])}")
        if data.get("series_position"):
            lines.append(f"series_position: {yaml_scalar(data['series_position'])}")
    lines.append("")
    lines.append("---")
    return "\n".join(lines)


def main():
    descriptor_path = Path(sys.argv[1])
    data = json.loads(descriptor_path.read_text(encoding="utf-8"))

    slug = data["slug"]

    if data.get("content_file"):
        raw_content = (descriptor_path.parent / data["content_file"]).read_text(encoding="utf-8")
    else:
        raw_content = data.get("content", "")

    source = data["source"]
    if source == "kit_html":
        cleaned = strip_kit_chrome(raw_content)
        markdown = html_to_markdown(cleaned)
    elif source == "markdown":
        markdown = raw_content.strip()
    else:
        raise ValueError(f"unknown source: {source!r}")

    fm = front_matter_for(data)

    ARTICLES_DIR.mkdir(parents=True, exist_ok=True)
    out_path = ARTICLES_DIR / f"{slug}.md"
    out_path.write_text(f"{fm}\n\n{markdown}\n", encoding="utf-8")
    print(f"wrote {out_path} ({len(markdown.splitlines())} lines of body)")


if __name__ == "__main__":
    main()
