#import "@preview/fletcher:0.5.3" as fletcher: diagram, edge, node, shapes
#import "@preview/gentle-clues:1.2.0": *
#import "@preview/wrap-it:0.1.1": wrap-content
#set text(lang: "fr")

// ===============================
// CONFIGURATION GLOBALE
// ===============================

// Global variable for corrections default
#let CORRECTION_GLOBAL = true

// State to control corrections from main document
#let correction_state = state("correction_enabled", true)

// ===============================
// FONCTIONS UTILITAIRES
// ===============================


// Generic function to create complete lines
#let full_lines_generic(
  lines: 1,
  spacing: 1em,
  length: 100%,
  stroke: (dash: "dotted", thickness: 0.3pt),
) = {
  v(spacing)
  for i in range(lines) {
    [
      #if i > 0 [#v(spacing)]
      #line(length: length, stroke: stroke)
    ]
  }
}

// ===============================
// SYSTÈME DE CORRECTION
// ===============================

// Allows content superposition
#let z_stack(..items) = {
  grid(
    columns: items.pos().len() * (1fr,),
    column-gutter: -100%,
    rows: 1,
    ..items
  )
}


// Function to enable/disable corrections
#let set_correction(enabled) = correction_state.update(enabled)

// Gaps to fill with optional correction
#let gap(width: 100%, margin: 1em, correction: "") = context [
  #let correction_enabled = correction_state.get()
  #h(margin)
  #if correction_enabled and correction != "" [
    #box(rect(
      width: width,
      height: 1em,
      outset: 3pt,
      inset: 3pt,
      stroke: (dash: "dotted", thickness: 0.7pt),
      fill: yellow.lighten(80%),
      [#text(size: 9pt, correction)],
    ))
  ] else [
    #box(rect(
      width: width,
      height: 0.5em,
      outset: 5pt,
      stroke: (dash: "dotted", thickness: 0.7pt),
    ))
  ]
  #h(margin)
]


// Function to complete a line + additional lines
#let lines(
  count: 1,
  spacing: 1em,
  stroke: (dash: "dotted", thickness: 0.3pt),
  correction: "",
) = context {
  let correction_enabled = correction_state.get()

  // First line: complete current line
  h(0.2em)
  if correction_enabled and correction != "" {
    // Display correction on first line with yellow background
    box(width: 1fr, [
      #box(
        fill: yellow.lighten(80%),
        inset: (top: spacing + 0.2em),
        radius: 2pt,
        height: spacing,
        text(size: 10pt, correction)
      )
      #h(1fr)
    ])
  } else {
    box(width: 1fr, inset: (top: spacing + 0.2em), line(length: 100%, stroke: stroke, ))
  }

  // Additional lines if count > 1 (always dotted lines)
  if count > 1 {
    for i in range(1, count) {
      [
        #v(spacing)
        #line(length: 100%, stroke: stroke)
      ]
    }
  }
}

// Function for separate complete lines
#let full_lines(
  count: 1,
  spacing: 1em,
  length: 100%,
  stroke: (dash: "dotted", thickness: 0.3pt),
  correction: "",
) = context {
  let correction_enabled = correction_state.get()

  if correction_enabled and correction != "" {
    // Display correction on first line with yellow background
    v(spacing)
    box(
      fill: yellow.lighten(80%),
      inset: 3pt,
      radius: 2pt,
      text(size: 10pt, correction)
    )

    // Additional dotted lines if count > 1
    if count > 1 {
      for i in range(1, count) {
        [
          #v(spacing)
          #line(length: length, stroke: stroke)
        ]
      }
    }
  } else {
    // Display all dotted lines
    full_lines_generic(
      lines: count,
      spacing: spacing,
      length: length,
      stroke: stroke,
    )
  }
}

// Function for response blocks with optional correction and customizable height/lines
#let response_block(
  height: 3cm,
  width: 100%,
  inset: 0.5cm,
  stroke: (dash: "dotted", thickness: 0.7pt),
  lines_count: 0,
  lines_spacing: 1em,
  correction: "",
) = context {
  let correction_enabled = correction_state.get()

  if correction_enabled and correction != "" {
    // Display correction with yellow background
    block(
      width: width,
      height: height,
      inset: inset,
      stroke: stroke,
      fill: yellow.lighten(80%),
      radius: 2pt,
      [
        #text(size: 10pt, correction)
        #if lines_count > 0 {
          for i in range(lines_count) {
            [
              #v(lines_spacing)
              #line(length: 100%, stroke: stroke)
            ]
          }
        }
      ]
    )
  } else {
    // Display empty response block
    block(
      width: width,
      height: height,
      inset: inset,
      stroke: stroke,
      [
        #if lines_count > 0 {
          for i in range(lines_count) {
            [
              #if i > 0 [#v(lines_spacing)]
              #line(length: 100%, stroke: stroke)
            ]
          }
        }
      ]
    )
  }
}

// Function for auto-incrementing activities
#let activity(
  title: "",
  breakable: true,
  content
) = context {
  // Find the nearest heading level 2 or 3
  let h2_locations = query(heading.where(level: 2))

  let current_pos = here()

  // Find the most recent heading (level 2) before current position
  let most_recent_heading = none
  let most_recent_page = 0

  // Check level 2 headings
  for h in h2_locations {
    if h.location().page() <= current_pos.page() {
      if h.location().page() > most_recent_page {
        most_recent_heading = h
        most_recent_page = h.location().page()
      }
    }
  }


  // Create unique counter based on heading
  let counter_key = if most_recent_heading != none {
    "activity-" + str(most_recent_heading.location().page()) + "-" + str(most_recent_heading.level)
  } else {
    "activity-default"
  }

  let activity_counter = counter(counter_key)
  activity_counter.step()
  let activity_num = activity_counter.get().first() + 1

  // Create title with automatic numbering
  let full_title = if title != "" {
    "Activité " + str(activity_num) + " - " + title
  } else {
    "Activité " + str(activity_num)
  }

  // Use goal from gentle-clues
  goal(title: full_title, breakable: breakable)[#content]
}

#let yield_cells(cols, rows, stroke_style, fill_color: none, striped: false, is_header: false) = {
  for j in range(0, cols * (rows - 1)) {
    let row_index = calc.div-euclid(j, cols)
    let cell_fill = if striped and not is_header and calc.rem(row_index, 2) == 1 {
      gray.lighten(90%)
    } else if is_header and fill_color != none {
      fill_color
    } else {
      none
    }

    (
      table.cell(stroke: stroke_style, fill: cell_fill, " "),
    )
  }
}

#let empty_table(
  cols: 6,
  rows: 3,
  header_solid: true,
  solid: true,
  striped: false,
  header_fill: none,
  inset: 0.9em,
  thickness: 0.7pt
) = {
  let dash_header = if header_solid { "solid" } else { "dashed" }
  let dash_body = if solid { "solid" } else { "dashed" }
  let global_stroke = (dash: dash_body, thickness: thickness)
  let header_stroke = (dash: dash_header, thickness: thickness)

  // Default header color if header_fill enabled
  let header_color = if header_fill != none {
    if header_fill == true { gray.lighten(70%) } else { header_fill }
  } else { none }

  table(
    columns: (1fr,) * cols,
    inset: inset,
    stroke: global_stroke,
    table.header(
      ..yield_cells(cols, 2, header_stroke, fill_color: header_color, is_header: true),
    ),
    table.hline(stroke: header_stroke),
    ..yield_cells(cols, rows, global_stroke, striped: striped)
  )
}

// ===============================
// BOX STYLES
// ===============================

// Generic function for all boxes
#let generic_box(
  title: "",
  content,
  color: blue,
  breakable: false,
  stroke_thickness: 1pt,
  stroke_dash: "solid",
  inset_top: 5pt,
  inset_rest: 10pt,
  title_offset: -11pt,
  title_size: 11pt,
  spacing_after_title: -1em,
) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (top: inset_top, rest: inset_rest),
    radius: 5pt,
    stroke: (paint: color, thickness: stroke_thickness, dash: stroke_dash),
    fill: color.lighten(95%),
    breakable: breakable,
    [
      #if title != "" [
        #move(
          dx: 0pt,
          dy: title_offset,
          rect(
            fill: white,
            radius: 5pt,
            inset: 4pt,
            [#text(weight: "bold", size: title_size, fill: color.darken(20%))[#title]],
          ),
        )
        #v(spacing_after_title)
      ]
      #content
    ],
  )
}

// Specific boxes using generic function
#let format_box(title: "", content, color: blue, breakable: false) = {
  generic_box(
    title: title,
    content,
    color: color,
    breakable: breakable,
    stroke_thickness: 2pt,
    inset_top: 8pt,
    inset_rest: 15pt,
    title_offset: -16pt,
    title_size: 12pt,
    spacing_after_title: -1.5em,
  )
}

#let definition_box(title: "DÉFINITION", content, breakable: false) = {

  generic_box(
    title: [📖 #title],
    content,
    color: green.darken(20%),
    breakable: breakable,
    stroke_thickness: 1.5pt,
    stroke_dash: "dashed",
    inset_top: 6pt,
    inset_rest: 12pt,
    title_offset: -13pt,
    title_size: 11pt,
    spacing_after_title: -1.2em,
  )
}


#let example_box(content, title: "EXEMPLE", breakable: false) = {
  generic_box(
    title: [📋 #title],
    content,
    color: orange,
    breakable: breakable,
  )
}

#let info_box(content,title: "INFORMATION", breakable: false) = {
  generic_box(
    title: "ⓘ " + title,
    content,
    color: blue.darken(10%),
    breakable: breakable,
  )
}

#let warning_box(content, title: "ATTENTION", breakable: false) = {
  generic_box(
    title: "⚠ " + title,
    content,
    color: red.darken(10%),
    breakable: breakable,
  )
}

#let synthesis_box(title: "SYNTHHÈSE", content, color: purple, breakable: false) = {
  generic_box(
    title: "📝 " + title,
    content,
    color: color,
    breakable: breakable,
    stroke_thickness: 1.5pt,
    inset_top: 6pt,
    inset_rest: 8pt,
    title_offset: -13pt,
    title_size: 12pt,
    spacing_after_title: -1.2em,
  )
}

// ===============================
// HEADER AND PAGE LAYOUT
// ===============================

#let HEADER(
  class: "Première",
  level: "NSI",
  duration: "2h",
  title: "Titre du document",
  academy: "ACADÉMIE DE NANTES",
  school: "LPO CARNOT BERTIN",
  logo_path: "Tux.png",
  logo_width: 1cm,
  cell_fill_color: yellow,
) = {
  table(
    columns: (1fr, 2.5cm, 2.5cm, 2cm, 2cm, 2cm),
    stroke: 0.7pt,
    align: (center + horizon, center + horizon, center + horizon, horizon, center + horizon, center + horizon),
    
    [
      #table(
        inset: 0cm,
        columns: (2cm, 1fr),
        stroke: 0pt,
        [#image(logo_path, width: logo_width)],
        [
          *#academy*
          #linebreak()
          #school
        ],
      )],
    [Classe #linebreak() #text(weight: "bold", size: 12pt)[#class]],
    [Durée : #linebreak() #duration],
    table.cell(colspan: 3, align: (center))[
      #text(weight: "bold", size: 20pt)[#level]
    ],
    
    // Line 3
    table.cell(colspan: 2)[
      #text(weight: "bold", size: 12pt)[
        
        
        #title
      ]
    ],
    [*#context {
      let pages = counter(page).final().first()
      str(pages) + " page" + if pages > 1 { "s" } else { "" }
    }*],
    
    table.cell(fill: cell_fill_color, align: center)[],
    table.cell(fill: cell_fill_color)[],
    table.cell(fill: cell_fill_color)[],
  )
}


#let COURSE(
  class: "Seconde",
  level: "SNT",
  duration: "2h",
  title: "Titre du document",
  academy: "ACADÉMIE DE NANTES",
  school: "LPO CARNOT BERTIN",
  logo_path: "Tux.png",
  logo_width: 1cm,
  cell_fill_color: yellow,
  body,
) = {
  // Simplified solution: fixed but optimized margins
  set page(
    numbering: "1",
    margin: (top: 2cm, bottom: 1.2cm, left: 0.5cm, right: 0.5cm),
    header: context {
      if counter(page).get().first() == 1 {
        HEADER(
          class: class,
          level: level,
          duration: duration,
          title: title,
          academy: academy,
          school: school,
          logo_path: logo_path,
          logo_width: logo_width,
          cell_fill_color: cell_fill_color,
        )
      }
    },
    footer: context {
      let current_page = counter(page).get().first()
      let total_pages = counter(page).final().first()

      // Find current section title (level 2 heading)
      let h2_locations = query(heading.where(level: 2))
      let current_section_title = none
      let current_section_number = 0

      for h in h2_locations {
        if h.location().page() <= current_page {
          current_section_title = h.body
          current_section_number = current_section_number + 1
        }
      }

      [
        #box(width: 100%, stroke: (top: 0.6pt + black))
        #text(size:0.8em)[#title#{if current_section_title != none [*\- PARTIE #numbering("A", current_section_number) - #current_section_title*]}] #h(1fr) #text(size: 10pt)[#current_page/#total_pages]
      ]

    },
    header-ascent: 0cm,
    footer-descent: 0cm,
  )
  
  
  show raw.where(block: false): it => box(
    fill: luma(235),
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
  )[#it]
  
  /*
  show raw.where(block: true): it => block(
  
  )[#text(font:"DejaVu Sans Mono")[#it]]
  */
  set par(justify: true)
  set text(
    size: 11pt,
    lang: "fr",
  )
  set heading(numbering: (..nums) => {
    let formats = ("  ", "A", "1", "1.1", "1.1.1", "1.1.1.1")
   if nums.pos().len() == 2 {
      numbering(formats.at(1), nums.pos().at(1))
    } else if nums.pos().len() == 3 {
      numbering(formats.at(2), nums.pos().at(2))
    } else if nums.pos().len() == 4 {
      numbering("1", nums.pos().at(2)) + "." + numbering("1", nums.pos().at(3))
    } else if nums.pos().len() == 5 {
      numbering("1", nums.pos().at(2)) + "." + numbering("1", nums.pos().at(3)) + "." + numbering("1", nums.pos().at(4))
    } else if nums.pos().len() == 6 {
      (
        numbering("1", nums.pos().at(2))
          + "."
          + numbering("1", nums.pos().at(3))
          + "."
          + numbering("1", nums.pos().at(4))
          + "."
          + numbering("1", nums.pos().at(5))
      )
    }
  })
  
  set figure.caption(separator: [ -- ])
  set figure(supplement: "Figure")
  show figure: it => [#it #v(0.5em)]
  
  
  show heading.where(level: 1): it => {
    block(
      above: 0.5em,
      stroke: 1pt + black,
      width: 100%,
      inset: 0.4em,
      fill: black,
    )[
      #align(center)[#text(size: 1.6em, weight: "bold", fill: white)[#it]]
    ]
  }
  show heading.where(level: 2): it => {
    pagebreak()
    block(
      above: 1.5em,
      stroke: 1.5pt + black,
      width: 100%,
      inset: (left: 1.4em, rest: 0.6em),
      fill: gray.lighten(80%),
    )[
        
         #text(size: 1.5em, weight: "bold")[PARTIE #counter(heading).display() - #it.body] ]
  }
  
  show heading.where(level: 3): it => {
    block(
      above: 1em,
      stroke: 1pt + black,
      width: 100%,
      inset: (left: 2.6em, rest: 0.4em),
      fill: gray.lighten(90%),
    )[
      #text(size: 1.4em, weight: "bold")[#counter(heading.where(level: 2)).display()#counter(heading).display() - #it.body]
    ]
  }
  
  show heading.where(level: 4): it => {
    block(
      above: 1em,
      stroke: (bottom: 2pt + black),
      width: 100%,
      inset: (left: 3.8em, bottom: 0.3em),
    )[
      
      #text(size: 1.3em, weight: "bold")[#counter(heading.where(level: 2)).display()#counter(heading).display() - #it.body]
    ]
  }
  
  show heading.where(level: 5): it => {
    block(
      above: 0.8em,
      stroke: (bottom: 1pt + gray),
      width: 100%,
      inset: (left: 5.0em, bottom: 0.2em),
    )[
      #text(size: 1.2em, weight: "bold")[#counter(heading.where(level: 2)).display()#counter(heading).display() - #it.body]
    ]
  }
  
  show heading.where(level: 6): it => {
    block(
      above: 0.5em,
      width: 100%,
      inset: (left: 6.2em),
    )[
      #text(size: 1.1em, weight: "bold")[#counter(heading.where(level: 2)).display()#counter(heading).display() - #it.body]
    ]
  }
  show link: set text(fill: blue)
  show link: underline

  [#body]
}

