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
