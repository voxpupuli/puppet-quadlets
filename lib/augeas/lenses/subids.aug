
(*
  Subids — Augeas lens for /etc/subuid and /etc/subgid
  ----------------------------------------------------
  PURPOSE
    Parse/write subordinate ID maps (shadow-utils): USER:START:COUNT
  TREE
    /files/etc/subuid/steve
      start = "100000"
      count = "65536"
  NOTES
    - Username is the node label
    - Blank lines and full-line '#' comments are supported
    - No trailing inline-comment support (ignored on write)
    - Duplicates (same username multiple times) are allowed by lens;
*)

module Subids =

autoload xfm

let eol       = Util.eol
let empty     = Util.empty
let comment   = Util.comment
let sep_colon = Util.del_str ":"

let username_re = /[^:#\n]+/
let num         = store /[0-9]+/

let entry =
  [ key username_re
    . sep_colon
    . [ label "start" . num ]
    . sep_colon
    . [ label "count" . num ]
  ] . eol

let lns = (comment | empty | entry)*

let filter =
     incl "/etc/subuid"
  .  incl "/etc/subgid"

let xfm = transform lns filter

