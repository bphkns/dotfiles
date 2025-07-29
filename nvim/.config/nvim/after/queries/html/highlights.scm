;; extends

;; MJML root and structure tags
((tag_name) @tag.mjml.structure
 (#match? @tag.mjml.structure "^(mjml|mj-head|mj-body|mj-attributes|mj-all|mj-class)$"))

;; MJML layout tags  
((tag_name) @tag.mjml.layout
 (#match? @tag.mjml.layout "^(mj-section|mj-column|mj-group|mj-wrapper)$"))

;; MJML content tags
((tag_name) @tag.mjml.content
 (#match? @tag.mjml.content "^(mj-text|mj-button|mj-image|mj-divider|mj-spacer|mj-table|mj-raw)$"))

;; MJML interactive tags
((tag_name) @tag.mjml.interactive
 (#match? @tag.mjml.interactive "^(mj-navbar|mj-navbar-link|mj-social|mj-social-element|mj-carousel|mj-carousel-image)$"))

;; MJML special tags
((tag_name) @tag.mjml.special
 (#match? @tag.mjml.special "^(mj-hero|mj-style|mj-title|mj-preview)$"))

;; MJML-specific attributes
((attribute_name) @attribute.mjml
 (#match? @attribute.mjml "^(background-color|background-url|css-class|font-family|font-size|font-weight|line-height|text-align|align|padding|padding-top|padding-bottom|padding-left|padding-right|margin|margin-top|margin-bottom|margin-left|margin-right|width|height|min-width|max-width|color|border|border-radius|href|src|alt|path|inline|full-width|vertical-align|container-background-color|inner-padding|mode|icon-size|icon-height|icon-width|text-decoration|direction|icon-padding|table-layout|cellpadding|cellspacing|role|aria-label)$"))

;; Template variables (Handlebars, Angular, etc.)
((text) @variable.template
 (#match? @variable.template "\\{\\{[^}]*\\}\\}"))

;; Angular-style template variables
((text) @variable.template.angular
 (#match? @variable.template.angular "\\*ng[A-Za-z]+"))

;; MJML style tag content
((element (start_tag (tag_name) @_tag) (text) @injection.content)
 (#eq? @_tag "mj-style")
 (#set! injection.language "css"))