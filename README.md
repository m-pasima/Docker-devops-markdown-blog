
<p align="center">
  <img src="static/devops-logo.png" alt="DevOps Academy Logo" width="120"/>
</p>

<h1 align="center">DevOps Academy Blog 📘</h1>

<p align="center">
  🐳 A Dockerized Static Markdown Blog Generator  
  ✨ Designed for DevOps learners, teachers, and portfolio builders.
</p>

---

## 📌 Overview

This project builds a sleek, modern, and fully Dockerized static site using:

- Markdown for content
- Custom HTML templates
- `markdown-html` + `serve` for conversion & hosting
- A clean DevOps-style UI

Perfect for students, bootcamps, or professionals who want to showcase tech writeups in style.

---

## 📂 Project Structure

```

.
├── Dockerfile                # Docker build file (Node-based)
├── entrypoint.sh            # Markdown generator + static builder
├── posts/                   # All markdown blog posts
├── static/                  # Logos, images, CSS
├── templates/               # HTML templates (index & post)

````

---

## 🚀 Quick Start

> 💡 **No dependencies** needed — just Docker!

### 1️⃣ Clone this repo

```bash
git clone https://github.com/m-pasima/Docker-devops-markdown-blog.git
cd Docker-devops-markdown-blog
````

### 2️⃣ Build the image

```bash
docker build -t devops-blog .
```

### 3️⃣ Run the container

```bash
docker run -d -p 8080:8080 devops-blog
```

Visit the blog at:
👉 [http://localhost:8080](http://localhost:8080)
(or your EC2 public IP if deploying remotely)

---

## ✍️ Writing a New Blog Post

Just add a new `.md` file under `posts/`:

```bash
# Example: posts/k8s-vs-ecs.md

# Kubernetes vs ECS: Battle of Container Orchestration

Ever wondered when to use Kubernetes vs AWS ECS? Let's break it down...

...
```

Then rebuild:

```bash
docker build -t devops-blog .
docker run -d -p 8080:8080 devops-blog
```

---

## 💡 Tech Stack

| Tool            | Purpose                          |
| --------------- | -------------------------------- |
| `Docker`        | Containerize the site generator  |
| `Node.js`       | Used inside container (alpine)   |
| `markdown-html` | Converts `.md` to HTML           |
| `serve`         | Static server for `/public` HTML |
| `bash` + `sed`  | Template injection logic         |

---

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/m-pasima/Docker-devops-markdown-blog/main/static/devops-logo.png" alt="screenshot" width="120">
</p>

![screenshot](https://via.placeholder.com/800x400?text=Blog+Screenshot+Here)

---

## 📘 Credits

Built with ❤️ by **Pasima**
Part of the **DevOps Academy** learning series.


