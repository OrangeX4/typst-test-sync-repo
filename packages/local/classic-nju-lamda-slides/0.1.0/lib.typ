#import "@preview/touying:0.4.2": *

#let slide(
  self: none,
  title: auto,
  footer: auto,
  ..args,
) = {
  if title != auto {
    self.t-title = title
  }
  if footer != auto {
    self.t-footer = footer
  }
  (self.methods.touying-slide)(
    self: self,
    title: self.t-title,
    ..args,
  )
}

#let logo-slide(
  self: none,
  body,
) = {
  self = utils.empty-page(self)
  self.page-args.header = {
    set align(top)
    show: pad.with(left: 1.2em, right: 1em, y: 2.2em)
    grid(
      column-gutter: .5em,
      columns: (1fr, auto, auto),
      {},
      align(center, (stack(
        spacing: 3.3em,
        v(-1.5em),
        image("assets/lamda-logo.png", height: 3.5em),
        text(.48em, weight: "medium", link("https://www.lamda.nju.edu.cn")),
      ))),
      {
        v(-1.4em)
        image("assets/nju-logo.svg", height: 4.5em)
      },
    )
  }
  self.page-args.footer = {
    set align(bottom + center)
    image(height: 100pt, "assets/first-footer.png")
  }
  (self.methods.touying-slide)(self: self, repeat: none, body)
}

#let title-slide(
  self: none,
  extra: none,
  ..args,
) = {
  let info = self.info + args.named()
  let body = {
    set text(fill: self.colors.neutral-dark)
    set par(justify: false)
    set align(horizon + center)
    block(
      width: 100%,
      inset: 2em,
      {
        text(size: 1.8em, text(weight: "medium", fill: self.colors.primary, info.title))
        v(1em)
        if info.author != none {
          block(spacing: 1.5em, info.author)
        }
        if info.date != none {
          block(spacing: 1em, utils.info-date(self))
        }
        if extra != none {
          block(spacing: 1em, extra)
        }
      },
    )
  }
  (self.methods.logo-slide)(self: self, body)
}

#let end-slide(
  self: none,
  body: [Thanks for listening!],
) = {
  let body = {
    set text(fill: self.colors.neutral-dark)
    set par(justify: false)
    set align(horizon + center)
    block(
      width: 100%,
      inset: 2em,
      {
        text(size: 1.8em, text(weight: "medium", fill: self.colors.primary, body))
      },
    )
  }
  (self.methods.logo-slide)(self: self, body)
}

#let focus-slide(self: none, body) = {
  self = utils.empty-page(self)
  self.page-args += (
    fill: self.colors.primary,
    margin: 2em,
  )
  set text(fill: self.colors.neutral-lightest, size: 1.5em, weight: "medium")
  (self.methods.touying-slide)(self: self, repeat: none, align(horizon + center, body))
}

#let slides(
  self: none,
  title-slide: true,
  outline-slide: false,
  end-slide: true,
  outline-title: [Table of contents],
  slide-level: 1,
  ..args,
) = {
  if title-slide {
    (self.methods.title-slide)(self: self)
  }
  if outline-slide {
    (self.methods.slide)(self: self, title: outline-title, (self.methods.touying-outline)())
  }
  (self.methods.touying-slides)(self: self, slide-level: slide-level, ..args)
  if end-slide {
    (self.methods.end-slide)(self: self)
  }
}

#let register(
  self: themes.default.register(),
  aspect-ratio: "4-3",
  header: states.current-section-title,
  footer: none,
  footer-right: states.slide-counter.display() + " / " + states.last-slide-number,
  ..args,
) = {
  // color theme
  self = (self.methods.colors)(
    self: self,
    primary: rgb("#002060"),
    neutral-lightest: rgb("#ffffff"),
    neutral-light: rgb("#898989"),
  )
  // save the variables for later use
  self.t-title = header
  self.t-footer = footer
  self.t-footer-right = footer-right
  // set page
  let header(self) = {
    set align(top)
    show: pad.with(left: 1.2em, right: 1em, y: 2em)
    grid(
      columns: (1fr, auto, auto),
      stack(
        box(height: 0em, text(size: 1.8em, weight: "medium", fill: self.colors.primary, utils.call-or-display(self, self.t-title))),
        v(3em),
        line(length: 480pt, stroke: .2em + self.colors.primary),
      ),
      h(5em),
      align(center, (stack(
        spacing: 1.5em,
        v(-1.5em),
        image("assets/lamda-logo.png", height: 3.5em),
        text(.48em, weight: "medium", link("https://www.lamda.nju.edu.cn")),
      ))),
    )
  }
  let footer(self) = {
    set align(bottom)
    pad(
      x: 1.2em,
      y: .5em,
      {
        set text(size: 0.8em)
        line(length: 100%, stroke: .1em + self.colors.primary)
        v(-.5em)
        text(fill: self.colors.neutral-light, utils.call-or-display(self, self.t-footer))
        h(1fr)
        text(fill: self.colors.neutral-light, utils.call-or-display(self, self.t-footer-right))
        v(.5em)
      },
    )
  }
  self.page-args += (
    paper: "presentation-" + aspect-ratio,
    header: header,
    footer: footer,
    header-ascent: 30%,
    footer-descent: 30%,
    margin: (top: 6.2em, bottom: 3em, x: 1.5em),
  )
  // register methods
  self.methods.slide = slide
  self.methods.logo-slide = logo-slide
  self.methods.title-slide = title-slide
  self.methods.end-slide = end-slide
  self.methods.focus-slide = focus-slide
  self.methods.slides = slides
  self.methods.touying-outline = (self: none, enum-args: (:), ..args) => {
    states.touying-outline(self: self, enum-args: (tight: false) + enum-args, ..args)
  }
  self.methods.alert = (self: none, it) => text(fill: self.colors.primary, it)
  self
}