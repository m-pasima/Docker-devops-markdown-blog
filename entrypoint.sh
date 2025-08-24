#!/usr/bin/env sh
set -eu

# Output dirs
mkdir -p public/posts
mkdir -p public/static

# Copy static assets
if [ -d "static" ]; then
  cp -r static/* public/static/ 2>/dev/null || true
fi

# Helper: title from first heading or filename
md_title() {
  f="$1"
  t=$(awk 'BEGIN{FS="\r"} /^#/ { sub(/^#+[[:space:]]*/,"",$0); print; exit }' "$f" 2>/dev/null || true)
  [ -n "${t:-}" ] && { echo "$t"; return; }
  basename "$f" .md
}

# Render posts and collect links
POST_LINKS="$(mktemp)"; : > "$POST_LINKS"
for f in posts/*.md; do
  [ -e "$f" ] || continue
  slug=$(basename "$f" .md)
  out="public/posts/${slug}.html"
  title="$(md_title "$f")"

  pandoc \
    --from=gfm \
    --to=html5 \
    --standalone \
    --metadata=title:"$title" \
    --template=templates/post_template.html \
    -o "$out" \
    "$f"

  # Fix relative asset paths inside each post
  sed -i \
    -e 's/src="static\//src="\/static\//g' \
    -e 's/href="static\//href="\/static\//g' \
    "$out"

  # Link used on home & posts index
  printf '<a class="post-link" href="/posts/%s"><img class="post-logo" src="/static/devops-logo.png" alt="" /> %s</a>\n' "$slug" "$title" >> "$POST_LINKS"
done

# ---------- HOME PAGE ----------
# Use your glossy home shell and inject links
INDEX_SRC="templates/index_shell.html"
INDEX_DST="public/index.html"
sed \
  -e 's/src="static\//src="\/static\//g' \
  -e 's/href="static\//href="\/static\//g' \
  "$INDEX_SRC" > "$INDEX_DST"
awk -v LINKS="$(sed 's/[&/\]/\\&/g' "$POST_LINKS")" '{ gsub("<!-- POST_LINKS -->", LINKS); print }' "$INDEX_DST" > "$INDEX_DST.tmp" && mv "$INDEX_DST.tmp" "$INDEX_DST"

# ---------- ALL POSTS PAGE (/posts) ----------
# Generate /public/posts/index.html with same theme + nav + links
cat > public/posts/index.html <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>All Posts • DevOps Academy Blog</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&family=Open+Sans&display=swap" rel="stylesheet">
  <link rel="icon" href="/static/devops-logo.png"/>
  <style>
    body { background: linear-gradient(120deg, #232526 0%, #2c5364 100%); font-family:'Open Sans',sans-serif; color:#fff; margin:0; }
    .topbar{background:rgba(44,229,193,0.07);border-bottom:1px solid #44e7b6}
    .topbar-inner{max-width:980px;margin:0 auto;padding:.8rem 1rem;display:flex;align-items:center;justify-content:space-between}
    .brand{font-family:'Montserrat',sans-serif;color:#44e7b6;text-decoration:none;font-weight:700;letter-spacing:1px}
    .nav a{color:#44e7b6;text-decoration:none;font-weight:600;margin-left:1rem;padding:.35rem .75rem;border-radius:999px;border:1px solid rgba(68,231,182,.35);background:rgba(0,0,0,.25)}
    .nav a:hover{color:#feca57;border-color:#feca57;background:rgba(0,0,0,.35)}
    .wrap{max-width:980px;margin:2rem auto;padding:0 1rem}
    .post-list{background:rgba(0,0,0,0.3);border-radius:20px;box-shadow:0 8px 32px rgba(0,0,0,0.2);padding:2em}
    .post-link{display:flex;align-items:center;gap:18px;color:#44e7b6;font-weight:bold;font-size:1.1em;text-decoration:none;margin:1rem 0;transition:color .2s}
    .post-link:hover{color:#feca57;text-decoration:underline}
    .post-logo{width:32px;height:32px;border-radius:6px;background:#222c36;box-shadow:0 0 2px #44e7b6;object-fit:contain;padding:3px}
  </style>
</head>
<body>
  <header class="topbar">
    <div class="topbar-inner">
      <a class="brand" href="/">DevOps Academy Blog</a>
      <nav class="nav">
        <a href="/">Home</a>
        <a href="/posts">All Posts</a>
      </nav>
    </div>
  </header>
  <main class="wrap">
    <div class="post-list">
      <!-- POST_LINKS -->
    </div>
  </main>
</body>
</html>
HTML

# Inject same links into /posts index
awk -v LINKS="$(sed 's/[&/\]/\\&/g' "$POST_LINKS")" '{ gsub("<!-- POST_LINKS -->", LINKS); print }' public/posts/index.html > public/posts/index.tmp && mv public/posts/index.tmp public/posts/index.html

rm -f "$POST_LINKS"

echo "Build complete. Home: /  •  All posts: /posts  •  Post: /posts/<slug>"

