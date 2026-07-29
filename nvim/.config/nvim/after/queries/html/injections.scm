; extends

;; Highlight CSS inside MJML style tags.
((element (start_tag (tag_name) @_tag) (text) @injection.content)
 (#eq? @_tag "mj-style")
 (#set! injection.language "css"))
