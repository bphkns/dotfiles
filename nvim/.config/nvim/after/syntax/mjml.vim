" MJML syntax file
" Language: MJML (Mailjet Markup Language)

if exists("b:current_syntax")
  finish
endif

" Load HTML syntax as base
runtime! syntax/html.vim
unlet! b:current_syntax

" MJML tag names
syn match mjmlTagName "\<mj-\(head\|body\|section\|column\|text\|button\|image\|divider\|spacer\)\>" contained
syn match mjmlTagName "\<mj-\(table\|raw\|navbar\|navbar-link\|social\|social-element\)\>" contained
syn match mjmlTagName "\<mj-\(hero\|carousel\|carousel-image\|wrapper\|group\)\>" contained
syn match mjmlTagName "\<mj-\(title\|preview\|attributes\|all\|class\|style\|font\|breakpoint\|include\)\>" contained
syn match mjmlTagName "\<mjml\>" contained

" MJML tags with proper regions
syn region mjmlTag start="<mj-" end=">" contains=mjmlTagName,htmlArg,htmlString,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster
syn region mjmlTag start="<mjml" end=">" contains=mjmlTagName,htmlArg,htmlString,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster
syn region mjmlTag start="</mj-" end=">" contains=mjmlTagName
syn region mjmlTag start="</mjml" end=">" contains=mjmlTagName

" MJML-specific attributes
syn keyword mjmlArg padding padding-top padding-right padding-bottom padding-left contained
syn keyword mjmlArg margin margin-top margin-right margin-bottom margin-left contained
syn keyword mjmlArg background-color background-url background-position background-size contained
syn keyword mjmlArg width height align vertical-align text-align contained
syn keyword mjmlArg font-family font-size font-weight font-style line-height contained
syn keyword mjmlArg color text-decoration text-transform letter-spacing contained
syn keyword mjmlArg border border-radius border-color border-width border-style contained
syn keyword mjmlArg css-class container-background-color inner-background-color contained
syn keyword mjmlArg href rel target title alt src icon-size icon-height icon-width contained
syn keyword mjmlArg mode direction hamburger ico-align ico-color contained
syn keyword mjmlArg inline path type full-width contained

" Template variables (for Angular/Handlebars style)
syn region mjmlTemplateVar start="{{" end="}}" containedin=ALL

" Highlight groups
hi def link mjmlTagName Statement
hi def link mjmlTag Function
hi def link mjmlArg Type
hi def link mjmlTemplateVar PreProc

" Set current syntax
let b:current_syntax = "mjml"