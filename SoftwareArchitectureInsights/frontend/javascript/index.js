import "$styles/index.css"
import "$styles/syntax-highlighting.css"

// Import all JavaScript & CSS files from src/_components
import components from "$components/**/*.{js,jsx,js.rb,css}"

console.info("Bridgetown is loaded!")

// Mobile nav menu
document.addEventListener("DOMContentLoaded", () => {
  const header = document.querySelector(".site-header")
  const toggle = header?.querySelector(".nav-toggle")
  const nav    = header?.querySelector(".site-nav")
  if (!header || !toggle || !nav) return

  header.setAttribute("data-nav-enhanced", "")

  const setOpen = (open) => {
    nav.classList.toggle("is-open", open)
    toggle.setAttribute("aria-expanded", String(open))
    toggle.setAttribute("aria-label", open ? "Close menu" : "Open menu")
  }

  const isOpen = () => toggle.getAttribute("aria-expanded") === "true"

  toggle.addEventListener("click", () => setOpen(!isOpen()))

  nav.addEventListener("click", (e) => {
    if (e.target.closest("a")) setOpen(false)
  })

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && isOpen()) {
      setOpen(false)
      toggle.focus()
    }
  })

  document.addEventListener("click", (e) => {
    if (isOpen() && !header.contains(e.target)) setOpen(false)
  })

  const wide = window.matchMedia("(min-width: 641px)")
  const syncToViewport = () => {
    if (wide.matches && isOpen()) setOpen(false)
  }
  wide.addEventListener("change", syncToViewport)
  window.addEventListener("resize", syncToViewport)
})

// Free-resource signup forms (WEB-15, WEB-21): src/_partials/_free_signup_form.erb.
// Each posts to a Kit-hosted form's own subscribe endpoint. Submit it in the
// background so the reader stays on this site, fire the form's Fathom event
// once Kit says it worked, then go to the thank-you page or show the
// success message in place. If the background submit can't reach Kit at
// all, fall back to the plain form post so the signup still goes through.
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-free-signup]").forEach((form) => {
    const status = form.querySelector(".free-signup-status")
    const button = form.querySelector("button[type=submit]")
    let sending = false

    const say = (text, kind) => {
      if (!status) return
      status.textContent = text
      status.dataset.kind = kind || ""
    }

    form.addEventListener("submit", async (e) => {
      e.preventDefault()
      if (sending) return
      sending = true
      if (button) button.disabled = true
      say("Sending…")

      let result
      try {
        const response = await fetch(form.action, {
          method: "POST",
          body: new FormData(form),
          headers: { Accept: "application/json" },
        })
        result = await response.json().catch(() => ({}))
        if (!response.ok && !result.status) result.status = "failed"
      } catch (_networkError) {
        // Couldn't reach Kit from here: let the browser post it instead.
        form.submit()
        return
      }

      if (result.status === "success") {
        const name = form.dataset.fathomEvent
        if (name && window.fathom?.trackEvent) window.fathom.trackEvent(name)

        const next = form.dataset.successUrl
        if (next) {
          // Give Fathom a moment to send the event before leaving the page.
          setTimeout(() => { window.location.href = next }, 300)
          return
        }
        form.classList.add("is-done")
        say(form.dataset.successMessage || "Thanks. Check your inbox.", "success")
        return
      }

      sending = false
      if (button) button.disabled = false
      const errors = Array.isArray(result.errors) ? result.errors.join(" ") : ""
      say(errors || "That didn't go through. Check the email address and try again.", "error")
    })
  })
})
