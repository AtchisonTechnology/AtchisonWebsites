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
