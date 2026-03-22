#!/bin/bash
# Blog Post Creator CLI
# Usage: blog-cli.sh {create|list|serve|build|setup}

set -euo pipefail

BLOG_DIR="${BLOG_DIR:-$HOME/docker/website}"
SERVER_HOST="${SERVER_HOST:-localhost}"

log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

case "$1" in
  create)
    if [ -z "$2" ]; then
      log_error "Usage: blog-cli.sh create \"Post Title\""
      exit 1
    fi
    TITLE="$2"
    SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    POST_DIR="$BLOG_DIR/content/posts/$SLUG"
    
    if [ -d "$POST_DIR" ]; then
      log_error "Post already exists: $POST_DIR"
      exit 1
    fi
    
    mkdir -p "$POST_DIR/images"
    
    cat > "$POST_DIR/index.md" << EOF
---
title: "$TITLE"
date: $(date +%Y-%m-%d)
lastmod: $(date +%Y-%m-%d)
draft: true
description: ""
tags: []
categories: []
---
    
# $TITLE
    
Content goes here...
    
---

*Published: $(date +%Y-%m-%d)*
EOF
    
    log_info "Created: $POST_DIR/index.md"
    log_info "Edit the file and set draft: false to publish"
    ;;
    
  list)
    if [ ! -d "$BLOG_DIR/content/posts" ]; then
      log_info "No posts directory found. Run 'blog-cli.sh setup' first."
      exit 0
    fi
    ls -la "$BLOG_DIR/content/posts/"
    ;;
    
  serve)
    cd "$BLOG_DIR"
    docker-compose up -d
    log_info "Hugo server running at http://${SERVER_HOST}:1313"
    ;;
    
  build)
    cd "$BLOG_DIR"
    docker-compose exec hugo hugo
    log_info "Site built to $BLOG_DIR/public/"
    ;;
    
  setup)
    mkdir -p "$BLOG_DIR"/{content/posts,layouts,static,themes}
    
    if [ ! -f "$BLOG_DIR/config.toml" ]; then
      cat > "$BLOG_DIR/config.toml" << EOF
baseURL = 'http://${SERVER_HOST}:1313/'
languageCode = 'en-us'
title = 'My Blog'

[params]
  description = 'Blog description'
  author = 'Your Name'

[menu]
  [[menu.main]]
    name = 'Home'
    url = '/'
    weight = 1
  [[menu.main]]
    name = 'Posts'
    url = '/posts/'
    weight = 2
EOF
      log_info "Created config.toml"
    fi
    
    log_info "Hugo blog structure created at $BLOG_DIR"
    log_info "Next: Copy docker-compose.hugo.yml and run 'blog-cli.sh serve'"
    ;;
    
  status)
    if docker ps | grep -q hugo; then
      log_info "Hugo container: Running"
      curl -s "http://localhost:1313" > /dev/null && log_info "Hugo server: Accessible" || log_error "Hugo server: Not responding"
    else
      log_info "Hugo container: Not running"
    fi
    ;;
    
  *)
    echo "Blog Post Creator CLI"
    echo ""
    echo "Usage: blog-cli.sh {command} [args]"
    echo ""
    echo "Commands:"
    echo "  create \"Title\"   Create new blog post"
    echo "  list              List all posts"
    echo "  serve             Start Hugo development server"
    echo "  build             Build static site"
    echo "  setup             Initialize Hugo blog structure"
    echo "  status            Check Hugo status"
    ;;
esac
