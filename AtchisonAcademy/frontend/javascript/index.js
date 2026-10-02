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

  // Only collapse the nav once we know the script is running, so a failed
  // script leaves a plain visible nav rather than an unreachable one.
  header.setAttribute("data-nav-enhanced", "")

  const setOpen = (open) => {
    nav.classList.toggle("is-open", open)
    toggle.setAttribute("aria-expanded", String(open))
    toggle.setAttribute("aria-label", open ? "Close menu" : "Open menu")
  }

  const isOpen = () => toggle.getAttribute("aria-expanded") === "true"

  toggle.addEventListener("click", () => setOpen(!isOpen()))

  // Close on link tap, Escape, or a click outside the header.
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

  // Widening past the breakpoint reveals the desktop nav; drop the open state
  // so the toggle is not left reading "expanded". Listen on resize as well as
  // the media query, since a change event is not guaranteed for every path
  // that alters the viewport.
  const wide = window.matchMedia("(min-width: 821px)")
  const syncToViewport = () => {
    if (wide.matches && isOpen()) setOpen(false)
  }
  wide.addEventListener("change", syncToViewport)
  window.addEventListener("resize", syncToViewport)
})

// AI-Native self-assessment checklist: live count + score band highlight
document.addEventListener("DOMContentLoaded", () => {
  const checklist = document.querySelector("[data-ain-checklist]")
  if (!checklist) return

  const boxes     = checklist.querySelectorAll('input[type="checkbox"]')
  const countEl   = checklist.querySelector("[data-ain-count]")
  const labelEl   = checklist.querySelector("[data-ain-band]")
  const bandEls   = document.querySelectorAll("[data-ain-band-range]")

  const bandFor = (n) => (n >= 13 ? "13-16" : n >= 7 ? "7-12" : "0-6")
  const messageFor = (n) => {
    if (n === 0) return "Check the boxes you can honestly answer yes to."
    if (n >= 13) return "Your architecture accounts for what AI is."
    if (n >= 7)  return "Uneven. Find the weakest property and start there."
    return "You have bolt-on AI. Start with the eval set."
  }

  const update = () => {
    const checked = Array.from(boxes).filter((b) => b.checked).length
    countEl.textContent = checked
    labelEl.textContent = messageFor(checked)

    const active = checked === 0 ? null : bandFor(checked)
    bandEls.forEach((el) => {
      el.classList.toggle("is-active", el.dataset.ainBandRange === active)
    })
  }

  boxes.forEach((b) => b.addEventListener("change", update))
  update()
})

// ============================================================
// Selling pages (Spec0031): sales, offer and supporting pages
// ============================================================

// An ended offer sends the visitor to its sales page (§A7, in-page layer).
// Runs as soon as this deferred script executes, before DOMContentLoaded
// listeners, so an expired offer never gets a chance to sell. The forced 302
// in _redirects takes over from the next deploy after redirect_at.
;(() => {
  const marker = document.querySelector("[data-offer-redirect-at]")
  if (!marker) return

  const at = Date.parse(marker.dataset.offerRedirectAt)
  if (!Number.isNaN(at) && Date.now() >= at) {
    window.location.replace(marker.dataset.offerRedirectTo)
  }
})()

// Buy links (§A8). Each [data-buy] link already carries this page's own
// utm_ tags. Copy any utm_* parameters the visitor arrived with onto it, so
// the newsletter or LinkedIn source survives to checkout. Arrival
// parameters win over the page's defaults. Each click also fires the page's
// Fathom event, so traffic and Buy clicks can be compared per page.
document.addEventListener("DOMContentLoaded", () => {
  const links = document.querySelectorAll("a[data-buy]")
  if (links.length === 0) return

  const arrival = [...new URLSearchParams(window.location.search)]
    .filter(([key]) => key.startsWith("utm_"))

  links.forEach((link) => {
    if (arrival.length > 0) {
      const url = new URL(link.href)
      arrival.forEach(([key, value]) => url.searchParams.set(key, value))
      link.href = url.toString()
    }

    link.addEventListener("click", () => {
      const name = link.dataset.fathomEvent
      if (name && window.fathom?.trackEvent) window.fathom.trackEvent(name)
    })
  })
})

// Trailer (§A9): click to play, never autoplay. The Vimeo iframe is created
// only on click, so no Vimeo request is made before then. Captions on by
// default via texttrack.
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-trailer]").forEach((trailer) => {
    const button = trailer.querySelector("button")
    button?.addEventListener("click", () => {
      const iframe = document.createElement("iframe")
      const params = new URLSearchParams({ autoplay: "1", texttrack: "en", dnt: "1" })
      iframe.src = `https://player.vimeo.com/video/${trailer.dataset.vimeoId}?${params}`
      iframe.title = "Course trailer"
      iframe.allow = "autoplay; fullscreen; picture-in-picture"
      iframe.allowFullscreen = true
      trailer.replaceChildren(iframe)
      trailer.classList.add("is-playing")
    })
  })
})
