#!/bin/sh
set -e

echo "[+] Cleaning and preparing public directory..."
rm -rf public
mkdir -p public
mkdir -p public/posts

cp -r static public/

echo "[+] Rendering markdown posts..."
for mdfile in posts/*.md; do
  base=$(basename "$mdfile" .md)
  outfile="public/${base}.html"
  title=$(grep -m1 '^# ' "$mdfile" | sed 's/^# //')

  if [ -z "$title" ]; then
    echo "[-] Skipping $mdfile (no H1 title found)"
    continue
  fi

  echo "  • $base → $outfile (Title: $title)"

  npx markdown-html "$mdfile" > "public/${base}.content.html"

  sed "s|<!-- POST_TITLE -->|$title|g" templates/post_template.html | \
    sed "/<!-- POST_BODY -->/{
      r public/${base}.content.html
      d
    }" > "$outfile"

  rm "public/${base}.content.html"
done

echo "[+] Creating index.html..."
POST_LINKS=""
for mdfile in posts/*.md; do
  base=$(basename "$mdfile" .md)
  title=$(grep -m1 '^# ' "$mdfile" | sed 's/^# //')
  if [ -n "$title" ]; then
    POST_LINKS="${POST_LINKS}<a class='post-link' href='${base}.html'>${title}</a>\\n"
  fi
done

sed "s|<!-- POST_LINKS -->|$POST_LINKS|" templates/index_template.html > public/index.html

echo "[✓] All posts generated."

