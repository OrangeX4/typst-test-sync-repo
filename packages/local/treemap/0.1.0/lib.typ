#let _treemap(is-root: false, max-columns: 3, is-child-of-root: false, tree) = {
  if is-root {
    table(
      inset: (x: 0.2em, y: 0.6em),
      columns: calc.min(tree.children.len(), max-columns),
      ..tree.children.map(_treemap.with(is-child-of-root: true)),
    )
  } else {
    if tree.children == () {
      box(inset: (x: 0.2em, y: 0em), rect(tree.title))
    } else {
      let res = stack(
        {
          set align(center)
          set text(size: 1.25em, weight: "bold")
          tree.title
        },
        v(0.8em),
        {
          tree.children.map(_treemap).sum()
        },
      )
      if is-child-of-root {
        res
      } else {
        box(
          inset: (x: 0.2em, y: 0em),
          rect(
            width: 100%,
            inset: (x: 0.2em, y: 0.6em),
            res,
          ),
        )
      }
    }
  }
}


#let _list-title(cont) = {
  let res = ([],)
  for child in cont.children {
    if child.func() != list.item {
      res.push(child)
    } else {
      break
    }
  }
  res.sum()
}


#let _treemap-converter(cont) = {
  if not cont.has("children") {
    if cont.func() == list.item {
      (title: cont.body, children: ())
    } else {
      (title: cont, children: ())
    }
  } else {
    (
      title: _list-title(cont),
      children: cont.children
        .filter(it => it.func() == list.item)
        .map(it => _treemap-converter(it.body))
    )
  }
}


#let treemap(cont) = _treemap(is-root: true, _treemap-converter(cont))