#import "@preview/tablex:0.0.6": *
#import "@preview/quick-maths:0.1.0": shorthands
#import "@preview/showybox:2.0.1": showybox

#let theorem-box(title: "", it) = {
  showybox(
    frame: (
      border-color: orange.darken(10%),
      title-color: orange.lighten(0%),
      body-color: orange.lighten(90%),
    ),
    title-style: (
      color: white,
      weight: "bold",
    ),
    title: title,
    it,
  )
}

#let conclusion-box(title: "", it) = {
  showybox(
    frame: (
      border-color: green.darken(40%),
      title-color: green.darken(20%),
      body-color: green.lighten(90%),
    ),
    title-style: (
      color: white,
      weight: "bold",
    ),
    title: title,
    it,
  )
}

#let question-box(title: "", it) = {
  showybox(
    frame: (
      border-color: navy.darken(20%),
      title-color: navy.lighten(10%),
      body-color: navy.lighten(90%),
    ),
    title-style: (
      color: white,
      weight: "bold",
    ),
    title: title,
    it,
  )
}

#let info-box(title: "", it) = {
  showybox(
    frame: (
      border-color: blue.darken(20%),
      title-color: blue.lighten(10%),
      body-color: blue.lighten(90%),
    ),
    title-style: (
      color: white,
      weight: "bold",
    ),
    title: title,
    it,
  )
}

#let emph-box(it) = {
  showybox(
    frame: (
      dash: "dashed",
      border-color: yellow.darken(30%),
      body-color: yellow.lighten(90%),
    ),
    sep: (
      dash: "dashed"
    ),
    it,
  )
}

#let argmax = math.op("argmax", limits: true)
#let argmin = math.op("argmin", limits: true)

#let indent() = {
    box(width: 2em)
}

#let indent_par(body) = {
    box(width: 1.8em)
    body
}

#let empty_par() = {
    v(-1em)
    box()
}

// Answer box
#let answer(body) = rect(width: 100%, stroke: 0.5pt, inset: 10pt, body)

// Heading Numbering
#let Numbering(base: 1, first-level: none, second-level: none, third-level: none, format, ..args) = {
    if (first-level != none and args.pos().len() == 1) {
        if (first-level != "") {
            numbering(first-level, ..args)
        }
        return
    }
    if (second-level != none and args.pos().len() == 2) {
        if (second-level != "") {
            numbering(second-level, ..args)
        }
        return
    }
    if (third-level != none and args.pos().len() == 3) {
        if (third-level != "") {
            numbering(third-level, ..args)
        }
        return
    }
    // default
    if (args.pos().len() >= base) {
        numbering(format, ..(args.pos().slice(base - 1)))
        return
    }
}

// three-line-table
#let three-line-table(columns: 1, ..options) = tablex(
    columns: columns,
    align: center + horizon,
    auto-lines: false,
    ..options.named(),
    hlinex(),
    ..options.pos().slice(0, columns),
    hlinex(),
    ..options.pos().slice(columns),
    hlinex(),
)

// Chinese in Math
#let zh(it) = {
  set text(font: ("IBM Plex Serif", "Source Han Serif SC"))
  it
}


#let report(size: 12pt, screen-size: 14pt, subject: "", title: "", date: "", author: "", show-outline: false, par-indent: false, media: "print", theme: "Light", display-inline-equation: true, body) = {
    // Save heading and body font families in variables.
    let font-set = (
        title: ("IBM Plex Serif", "Times New Roman", "Source Han Serif SC", "Songti SC"),
        body: ("IBM Plex Serif", "Times New Roman", "Source Han Serif SC", "Songti SC"),
        mono: ("IBM Plex Mono", "Menlo", "Source Han Sans", "Source Han Sans SC", "PingFang SC"),
    )

    let page-margin = if (media == "screen") { (x: 35pt, y: 35pt) } else { auto }
    let text-size = if (media == "screen") { screen-size } else { size } 
    let bg-color = if (theme == "Dark" or theme == "dark") { rgb("#1f1f1f") } else { rgb("#ffffff") }
    let text-color = if (theme == "Dark" or theme == "dark") { rgb("#ffffff") } else { rgb("#000000") }
    let raw-color = if (theme == "Dark" or theme == "dark") { rgb("#27292c") } else { luma(240) }
    let quota-bg-color = if (theme == "Dark" or theme == "dark") { rgb(255, 255, 255, 15) } else { rgb(0, 0, 0, 15) }

    // Set the document's basic properties.
    set document(author: author, title: subject + title + author)
    set page(numbering: "1", number-align: center, fill: bg-color, margin: page-margin)
    
    // Set body font family.
    set text(text-size, font: font-set.body, fill: text-color, lang: "zh", region: "cn")
    // scale cjk font
    show regex("[^\\x00-\\xff]+"): set text(0.9em)
    show heading: it => {
        set block(below: 1em)
        it
    } + if (par-indent) { empty_par() }
    show heading.where(level: 1): it => {
        v(0.5em)
        it
        v(0.2em)
    }

    set par(justify: true, first-line-indent: if (par-indent) {2em} else {0em})
    show par: set block(spacing: 1.5em) // spacing between paragraphs

    // Image
    set image(width: 80%)
    show image: align.with(center)

    // Quota
    show quote: it => pad(x: 0pt, top: -15pt, bottom: -10pt, rect(width: 100%, fill: quota-bg-color, stroke: (left: 0.25em), it.body))

    // Code Block
    show raw.where(block: false): body => box(
        fill: raw-color,
        inset: (x: 3pt, y: 0pt),
        outset: (x: 0pt, y: 3pt),
        radius: 2pt,
        {
          set text(font: font-set.mono)
          set par(justify: false)
          body
        },
    )
    show raw.where(block: true): body => block(
        width: 100%,
        fill: raw-color,
        inset: 10pt,
        radius: 4pt,
        {
          set text(font: font-set.mono)
          set par(justify: false)
          body
        },
    )

    if (subject != "") {
        // Title page
        align(center + top)[
            #v(20%)
            #text(font: font-set.title, 2em, weight: 500, subject)
            #v(2em, weak: true)
            #text(font: font-set.title, 2em, weight: 500, title)
            #v(2em, weak: true)
            #text(author)
        ]
        pagebreak()
    }

    // Page Header
    set page(
        header: {
            set text(font: font-set.body, 0.9em)
            stack(
                spacing: 0.2em,
                grid(
                    columns: (1fr, auto, 1fr),
                    align(left, date),
                    align(center, subject),
                    align(right, title),
                ),
                v(0.1em),
                line(length: 100%, stroke: 1pt + text-color),
                line(length: 100%, stroke: 0.5pt + text-color)
            )
            // reset footnote counter
            counter(footnote).update(0)
        }
    )

    if (show-outline) {
        set par(first-line-indent: 0em)

        align(center)[
          #heading(level: 1, numbering: none, outlined: false)[
            目录
          ]
        ]
        
        show outline: set box(height: 1.2em, baseline: 0.5em)
        
        outline(depth: 2, indent: true, title: none)
        
        pagebreak()
    }

    // Links
    show link: it => {
      if type(it.dest) == str {
        [#underline(it)#footnote(it.dest)]
      } else {
        underline(it)
      }
    }

    // shorthands for math equations
    show: shorthands.with(
      ($+-$, $plus.minus$),
      ($...$, $dots.c$),
      ($|-$, math.tack),
      ($::=$, $eq.delta$),
      ($~~$, $approx$),
      ($~$, $tilde$),
    )

    // display inline equation
    show math.equation.where(block: false): it => {
      if not display-inline-equation or (it.has("label") and it.label == label("displayed-inline-math-equation")) {
        it
      } else {
        [$display(it)$<displayed-inline-math-equation>]
      }
    }

    body
}