# iQuery COE — simple web prototype

Single-page prototype for a school COE (Centre of Excellence) portal: **school SPOC** vs **parent / student** journeys, with sign-in and dashboards. Built with HTML, CSS, and JavaScript in `index.html`.

## What’s in this folder

| File        | Purpose |
|------------|---------|
| `index.html` | The whole app (styles + script included) |
| `Prompt.txt` | Original product notes this UI is based on |
| `share-public.sh` | Optional: temporary **public HTTPS** link (Cloudflare quick tunnel, no account) |
| `share-ngrok.sh` | Optional: **ngrok free** public HTTPS link (`*.ngrok-free.app`) |

## Temporary public link (share with anyone)

Use this when a colleague needs a **real URL** (not `localhost`). You still run the site on your Mac; a tunnel forwards traffic in.

**Requirements:** Your Python server must already be running on the port you tunnel (default **8765**).

1. Terminal 1 — start the site:

   ```bash
   cd "/Users/ashutoshaagawane/Documents/Ashutosh Porjects/Sample HTML"
   python3 -m http.server 8765
   ```

2. Terminal 2 — start a tunnel (first run downloads a small `cloudflared` binary into `.tools/`):

   ```bash
   cd "/Users/ashutoshaagawane/Documents/Ashutosh Porjects/Sample HTML"
   chmod +x share-public.sh
   ./share-public.sh
   ```

   For a different local port: `./share-public.sh 8766`

3. Copy the **`https://….trycloudflare.com`** URL from the terminal output. Send your colleague:

   **`https://YOUR-SUBDOMAIN.trycloudflare.com/index.html`**

   (Add `/index.html` so they land on the app, not the directory listing.)

4. Stop the tunnel with **Ctrl+C** in Terminal 2. The URL stops working immediately.

**Notes:** Quick tunnels are **free, temporary, and best-effort**—fine for demos, not for production. Each run usually gets a **new** hostname. Do not put secrets on the page.

### ngrok free (recommended if you want `ngrok-free.app`)

Ngrok needs a **free account** and a one-time authtoken (cannot run without it).

1. Sign up: [dashboard.ngrok.com/signup](https://dashboard.ngrok.com/signup)
2. Copy your token: [dashboard.ngrok.com/get-started/your-authtoken](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Terminal 1 — local site (if not already running):

   ```bash
   cd "/Users/ashutoshaagawane/Documents/Ashutosh Porjects/Sample HTML"
   python3 -m http.server 8765
   ```

4. Terminal 2 — save token once, then start tunnel:

   ```bash
   cd "/Users/ashutoshaagawane/Documents/Ashutosh Porjects/Sample HTML"
   chmod +x share-ngrok.sh
   ./share-ngrok.sh --setup YOUR_AUTHTOKEN_HERE
   ./share-ngrok.sh
   ```

5. Copy the **`Forwarding`** line, e.g. `https://abc123.ngrok-free.app` → share **`https://abc123.ngrok-free.app/index.html`**

6. Optional: open the request inspector at [http://127.0.0.1:4040](http://127.0.0.1:4040)

**Free tier notes:** Visitors may see a short ngrok interstitial on first visit; URLs change when you restart ngrok unless you use a reserved domain on a paid plan.

## Live site status

**Currently offline.** The public GitHub Pages URL is disabled. Code remains in [github.com/Ashu9594/sample_webpage](https://github.com/Ashu9594/sample_webpage). To go live again later, see **Re-enable GitHub Pages** below.

## How to open it (local)

### Option A — Double-click (quickest)

Open `index.html` in Chrome, Safari, or Firefox (double-click in Finder, or drag the file into a browser window).

### Option B — Local server (recommended)

Some browsers are stricter with `file://` pages. A tiny local server avoids that:

1. Open Terminal.
2. Go to this folder:

   ```bash
   cd "/Users/ashutoshaagawane/Documents/Ashutosh Porjects/Sample HTML"
   ```

3. Start the server:

   ```bash
   python3 -m http.server 8765
   ```

4. In the browser, open: **http://127.0.0.1:8765/index.html**

5. When you’re done, stop the server: press **Ctrl+C** in Terminal.

If port `8765` is already in use, pick another port (e.g. `8766`) and open `http://127.0.0.1:8766/index.html` instead.

### Option C — Cursor Simple Browser

With the server running (Option B), press **Cmd+Shift+P**, run **“Simple Browser: Show”**, and paste the same `http://127.0.0.1:8765/index.html` URL.

## How to use the prototype

1. **Home**  
   Read the two cards (school SPOC vs parent/student). Use **Get started**, **Sign in**, or **Continue as…** to open the sign-in screen.

2. **Sign in or create account**  
   Switch modes with the **Sign in** and **Create account** tabs at the top of the form.

3. **Account type**  
   Choose **School SPOC** or **Parent / student** using the radio buttons.

4. **Sign in**  
   Enter any email and a password of at least **6 characters**. This prototype runs only in your browser; nothing is sent to a server.

5. **Create account**  
   If you selected **School SPOC**, also fill **School / organisation**. Use the same password rule (at least 6 characters).

6. **Dashboard and sign out**  
   After sign-in, you’ll see the dashboard for your account type. Use **Sign out** to return to the home screen.

## Notes

- This is a **front-end preview** for demos and walkthroughs, not a production app.
- There is **no backend**; data is not saved or transmitted.

## Re-enable GitHub Pages (when ready)

1. On GitHub: **Settings → Pages → Build and deployment → Source** → choose **Deploy from a branch**.
2. Branch: **gh-pages** / **/ (root)** — or restore the deploy workflow from git history.
3. From this folder, recreate `gh-pages` and push:

   ```bash
   git checkout --orphan gh-pages
   git rm -rf .
   cp index.html .
   git add index.html
   git commit -m "Publish site"
   git push -f origin gh-pages
   git checkout main
   ```

   Site URL: **https://ashu9594.github.io/sample_webpage/**
