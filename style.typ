#import "@preview/fletcher:0.5.3" as fletcher: diagram, edge, node, shapes
#import "@preview/gentle-clues:1.2.0": *
#import "@preview/wrap-it:0.1.1": wrap-content
#import "@preview/grayness:0.4.1": *
#set text(lang: "fr")

#set text(slashed-zero: true)
// ===============================
// CONFIGURATION GLOBALE
// ===============================

// State to control corrections from main document
#let correction_state = state("correction_enabled", false)

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

// Gaps to fill with optional correction and customizable borders
#let gap(
  width: 100%,
  margin: 1em,
  correction: "",
  stroke: (dash: "dotted", thickness: 0.7pt),
  outset: auto,
  height: auto,
  fill: auto
) = context [
  #let correction_enabled = correction_state.get()
  #h(margin)
  #if correction_enabled and correction != "" [
    #block(rect(
      width: width,
      height: if height == auto { 0.5em } else { height },
      outset: if outset == auto { 5pt } else { outset },
      inset: 0pt,
      stroke: stroke,
      fill: if fill == auto { yellow.lighten(80%) } else { fill },
      [#text(size: 9pt, correction)],
    ))
  ] else [
    #block(rect(
      width: width,
      inset: 0pt,
      stroke: stroke,
      outset: if outset == auto { 5pt } else { outset },
      height: if height == auto { 0.5em } else { height },
      fill: if fill == auto { none } else { fill },
    ))
  ]
  #h(margin)
]
#let gapb(
  width: 100%,
  margin: 1em,
  correction: "",
  stroke: (dash: "dotted", thickness: 0.7pt),
  outset: auto,
  height: auto,
  fill: auto
) = context [
  #let correction_enabled = correction_state.get()
  #h(margin)
  #if correction_enabled and correction != "" [
    #box(rect(
      width: width,
      height: if height == auto { 0.5em } else { height },
      outset: if outset == auto { 5pt } else { outset },
      inset: 0pt,
      stroke: stroke,
      fill: if fill == auto { yellow.lighten(80%) } else { fill },
      [#text(size: 9pt, correction)],
    ))
  ] else [
    #box(rect(
      width: width,
      inset: 0pt,
      outset: if outset == auto { 5pt } else { outset },
      height: if height == auto { 0.5em } else { height },
      stroke: stroke,
      fill: if fill == auto { none } else { fill },
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
        radius: 2pt,
        height: spacing,
        text(size: 8pt, correction)
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
      inset: 0.5em,
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
      inset: 0.5em,
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
#let activity(title) = context {
  // Simple global counter for activities without reset
  let activity_counter = counter("activity-global")
  activity_counter.step()
  let activity_num = activity_counter.get().first() + 1

  // Create title with automatic numbering
  let full_title = if title != "" {
    "Activité " + str(activity_num) + " - " + title
  } else {
    "Activité " + str(activity_num)
  }

  // Custom header style matching goal design
  v(0.5em)
  block(
    width: 100%,
    breakable: false,
    above: 0.1em,
    below: 0.3em,
    {
      // Header box with icon and title - matching goal style
      rect(
        width: 100%,
        fill: rgb("#fbe3e5"),  // Light red/pink background (softer)
  
        stroke: (
          left: 2pt + rgb("#e74c3c"),   // Thicker red left border
          rest: 0.3pt + rgb("#e74c3c")     // Thin borders on other sides
        ),
        {
          align(center)[
          #text(
            size: 1.1em,
            weight: "bold",
            fill: black
          )[🎯 #full_title 🎯]
          ]
        }
      )
    }
  )
  v(0.5em)
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
            inset: 3pt,
            [#text(weight: "bold", size: title_size, fill: color.darken(20%))[#title]],
          ),
        )
        #v(spacing_after_title)
      ]
      #content
    ],
  )
    v(0em)
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
// LISTES AVEC PUCES PERSONNALISÉES
// ===============================

// Fonction pour créer des listes avec des puces spéciales
#let special_list(marker: [▶], spacing: 0.6em, content) = {
  set list(marker: marker, spacing: spacing)
  content
}

// Variantes prédéfinies de listes spéciales
#let arrow_list(content) = special_list(marker: [▶], content)
#let check_list(content) = special_list(marker: [✓], content)
#let star_list(content) = special_list(marker: [★], content)
#let diamond_list(content) = special_list(marker: [◆], content)
#let circle_list(content) = special_list(marker: [●], content)
#let triangle_list(content) = special_list(marker: [▲], content)

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
  logo_path: "logo.png",
  logo_width: 1cm,
  cell_fill_color: yellow,
  jaune: "Nom/Prénom : ",
  version: none,
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
    [ ],
    [Date  #linebreak()#linebreak()],
    table.cell(colspan: 3, align: (center))[
      #text(weight: "bold", size: 20pt)[#level]
    ],
    
    // Line 3
    table.cell(colspan: 2, inset: 1em)[
      #text(weight: "bold", size: 12pt)[
        
        
        #title
      ]
    ],
    
    
    table.cell(colspan: 4, fill: cell_fill_color, align: left)[
#jaune
    ],

  )
}


#let COURSE(
  class: "Seconde",
  level: "SNT",
  duration: "2h",
  theme: "Titre du document",
  doc_title: none,  // Grand titre du document (affiché en haut)
  academy: "ACADÉMIE DE NANTES",
  school: "LPO CARNOT BERTIN",
  logo_path: "logo.png",
  logo_width: 1cm,
  cell_fill_color: yellow,
  version: none,
  jaune: "Nom/Prénom : ",
  h2_prefix: none,  // Option pour ajouter un préfixe aux titres de niveau 2
  h2_prefix_word: "Partie",  // Mot à utiliser pour le préfixe
  show_header: false,  // Option pour afficher l'en-tête
  body,
) = {
  // Simplified solution: fixed but optimized margins
  set page(
    numbering: "1",
    margin: (top: 0.8cm, bottom: 1.2cm, left: 0.5cm, right: 0.5cm),
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
        
        
        #text(size:0.8em)[#theme#{if current_section_title != none and h2_prefix != none [*\- #h2_prefix_word #text[#context counter(heading.where(level: 2)).display()] - #current_section_title*]}] #h(1fr) #text(size: 10pt)[#current_page/#total_pages]
      ]

    },
    header-ascent: 1cm,
    footer-descent: 0cm,
  )
  
  
  // Style pour le code inline
  show raw.where(block: false): it => box(
    fill: luma(235),
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
  )[
    #set text(fill: black)
    #it

  ]

  // Style pour les blocs de code Python (Style 4 : Fond dégradé subtil)
  show raw.where(block: true, lang: "python"): it => {
    block(
      width: 100%,
      fill: gradient.linear(rgb("#e3f2fd"), rgb("#f5f7fa"), angle: 135deg),
      stroke: (left: 4pt + rgb("#2196F3"), rest: 1pt + rgb("#bbdefb")),
      radius: 5pt,
      inset: (left: 1.2em, y: 1em, right: 1em),
      above: 0.8em,
      below: 0.8em,
      it
    )
  }
  set par(justify: true, leading: 0.9em)
  set text(
    size: 11pt,
    lang: "fr",
  )
  set heading(numbering: if h2_prefix == false {
    // Mode sans préfixe : fonction qui retourne une chaîne vide
    (..nums) => ""
  } else {
    // Mode avec préfixe : numérotation A, B, C...
    (..nums) => {
      // Niveau 1 : A, B, C... (sections principales)
      // Niveau 2 : A1, A2, A3... (sous-sections)
      // Niveau 3 : A1.1, A1.2... (sous-sous-sections)
      // etc.

      if nums.pos().len() == 1 {
        // Niveau 1 : A, B, C...
        numbering("A", nums.pos().at(0))
      } else if nums.pos().len() == 2 {
        // Niveau 2 : A1, A2...
        numbering("A", nums.pos().at(0)) + numbering("1", nums.pos().at(1))
      } else if nums.pos().len() == 3 {
        // Niveau 3 : A1.1, A1.2...
        numbering("A", nums.pos().at(0)) + numbering("1", nums.pos().at(1)) + "." + numbering("1", nums.pos().at(2))
      } else if nums.pos().len() == 4 {
        // Niveau 4 : A1.1.1, A1.1.2...
        numbering("A", nums.pos().at(0)) + numbering("1", nums.pos().at(1)) + "." + numbering("1", nums.pos().at(2)) + "." + numbering("1", nums.pos().at(3))
      } else if nums.pos().len() == 5 {
        // Niveau 5 : A1.1.1.1, A1.1.1.2...
        (
          numbering("A", nums.pos().at(0))
            + numbering("1", nums.pos().at(1))
            + "."
            + numbering("1", nums.pos().at(2))
            + "."
            + numbering("1", nums.pos().at(3))
            + "."
            + numbering("1", nums.pos().at(4))
        )
      } else if nums.pos().len() == 6 {
        // Niveau 6 : A1.1.1.1.1, A1.1.1.1.2...
        (
          numbering("A", nums.pos().at(0))
            + numbering("1", nums.pos().at(1))
            + "."
            + numbering("1", nums.pos().at(2))
            + "."
            + numbering("1", nums.pos().at(3))
            + "."
            + numbering("1", nums.pos().at(4))
            + "."
            + numbering("1", nums.pos().at(5))
        )
      }
    }
  })
  
  set figure.caption(separator: [ -- ])
  set figure(supplement: "Figure")
  show figure: it => [#it #v(0.5em)]
  
  
  // Niveau 1: Sections principales avec numérotation A, B, C...
  show heading.where(level: 1): it => {
    
    block(
      above: 0.5em,
      width: 100%,
      inset: (left: 0.8em, rest: 0.4em),
      radius: 6pt,
      fill: rgb("#001845").lighten(30%),
      stroke: (
        left: 6pt + rgb("#001845"),
        rest: 2pt + rgb("#001845")
      ),
    )[
      #set par(leading: 0.3em)
      #text(size: 1.1em, weight: "bold", fill: white)[
        #counter(heading).display()🔹#it.body
      ]
    ]
  }

  // Niveau 2: Sous-sections
  show heading.where(level: 2): it => {
    block(
      above: 0.5em,
      width: 100%,
      inset: (left: 0.7em, rest: 0.4em),
      radius: 5pt,
      fill: rgb("#003560").lighten(35%),
      stroke: (
        left: 5pt + rgb("#003560"),
        rest: 1.5pt + rgb("#003560")
      ),
    )[
      #text(size: 1.05em, weight: "bold", fill: white)[
        #set par(leading: 0.3em)
        #counter(heading).display()▸#it.body
      ]
    ]
  }

  // Niveau 3: Sous-sous-sections
  show heading.where(level: 3): it => {
    block(
      above: 0.5em,
      width: 100%,
      inset: (left: 0.5em, top: 0.3em, bottom: 0.4em),
      fill: rgb("#002617").lighten(40%),
      stroke: (bottom: 4pt + rgb("#002617")),
      radius: 4pt,
    )[
      #text(size: 1.04em, weight: "bold", fill: white)[
        #set par(leading: 0.3em)
        #counter(heading).display() ◆ #it.body
      ]
    ]
  }

  // Niveau 4: Détails
  show heading.where(level: 4): it => {
    block(
      above: 0.5em,
      width: 100%,
      inset: (left: 1em, top: 0.2em, bottom: 0.3em),
      fill: rgb("#0D3B17").lighten(45%),
      stroke: (bottom: 3pt + rgb("#0D3B17")),
      radius: 3pt,
    )[
      #text(size: 1.03em, weight: "bold", fill: white)[
        #set par(leading: 0.3em)
        #counter(heading).display() • #it.body
      ]
    ]
  }

  // Niveau 5: Sous-détails
  show heading.where(level: 5): it => {
    block(
      above: 0.5em,
      width: 100%,
      inset: (left: 1.2em, top: 0.2em, bottom: 0.2em),
      fill: rgb("#1A1A1A").lighten(50%),
      radius: 3pt,
    )[
      #text(size: 1.01em, weight: "bold", fill: white)[
        #set par(leading: 0.3em)
        #counter(heading).display() ‣ #it.body
      ]
    ]
  }
  show link: set text(fill: blue)
  show link: underline

  [
    #if show_header [
      #HEADER(
        class: class,
        level: level,
        duration: duration,
        title: theme,
        academy: academy,
        school: school,
        logo_path: logo_path,
        jaune: jaune,
        logo_width: logo_width,
        cell_fill_color: cell_fill_color,
        version: version,
      )
    ]
  #set text(
    size: 11pt,
    lang: "fr",
  )
    // Afficher le grand titre du document si fourni
    #if doc_title != none [
      #block(
        above: 0.5em,
        width: 100%,
        inset: 0.6em,
        radius: 4pt,
        fill: gradient.linear(
          rgb("#001845"),
          rgb("#002617"),
          angle: 45deg
        ),
        stroke: 3pt + black,
      )[
        #align(center)[
          #text(size: 1.6em, weight: "bold", fill: white)[
            #set par(spacing: 0em)
            #doc_title
          ]
        ]
      ]
    ]

    #body
  ]
}

