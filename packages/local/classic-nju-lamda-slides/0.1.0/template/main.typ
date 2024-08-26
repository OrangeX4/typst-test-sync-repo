#import "@preview/classic-nju-lamda-slides:0.1.0": *

#let s = register()
#let s = (s.methods.info)(
  self: s,
  title: [Title],
  author: [Authors],
  date: [2024/7],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#show: init

#set text(font: "Fira Sans", weight: "light")
#set strong(delta: 100)
#set par(justify: true)
#show strong: alert

#let (slide, empty-slide, title-slide, focus-slide) = utils.slides(s)
#show: slides

= Introduction

slides.
