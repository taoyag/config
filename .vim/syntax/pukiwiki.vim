syn match pukiwikiHeading		"^\*\{1,3}\(\w\+\*\)\=.\+$"			contains=pukiwikiHeadingName,pukiwikiLink
syn match pukiwikiHeadingName		"^\*\{1,3}[^*]\{-1,}\*\|^\*\{1,3}"	contained	nextgroup=pukiwikiCategory
syn match pukiwikiCategory		"\(\[.\{-}\]\)\+"					contained

syn match pukiwikiList			"^[+-]\+"

syn match pukiwikiDefinition		"^:.\{-1,}:.\+$"	contains=pukiwikiDefColon
syn match pukiwikiDefColon		":"					contained

syn match pukiwikiTable			"^|\(.\{-}|\)\+"	contains=pukiwikiTableHeader,pukiwikiTableSeparator
syn match pukiwikiTableHeader		"\*[^|]\+"			contained
syn match pukiwikiTableSeparator	"|"					contained

syn match pukiwikiLink			"\[\(http\|google\(:news\|:image\)\=\|amazon\|rakuten\):.\{-}\]"	contains=pukiwikiLinkSpecial
syn match pukiwikiLinkURL			"https\=://[-!#$%&*+,./:;=?@0-9a-zA-Z_~]\+"
syn match pukiwikiLinkSpecial		":title\(=[^]]*\)\=\ze\]\|:barcode\|:image"

syn match pukiwikiKeyword			"\[\[.\{-}\]\]"
syn match pukiwikiCancelLink		"\[\]"

syn match pukiwikiFootNote		"((.\{-}))"
syn match pukiwikiCancelFootNote	")((.\{-}))("	contains=pukiwikiCanceledParen
syn match pukiwikiCanceledParen	"))(\|)(("		contained

syn match pukiwikiReadMore		"=====\?"
syn match pukiwikiTex				"\[tex:.\{-}\]"

syn region pukiwikiCancelP		matchgroup=pukiwikiBlockDelimiter start=+>\ze<+ end=+>\zs<$+ contains=htmlTag

syn cluster pukiwikiSpecials		contains=pukiwikiDefColon,pukiwikiTableSeparator

syn region pukiwikiBlockQuote	matchgroup=pukiwikiBlockDelimiter start=+^>>+  end=+<<+ contains=ALLBUT,@pukiwikiSpecials
syn region pukiwikiPre		matchgroup=pukiwikiBlockDelimiter start=+^>|+  end=+|<+ contains=ALLBUT,@pukiwikiSpecials
syn region pukiwikiSuperPre	matchgroup=pukiwikiBlockDelimiter start=+^>||+ end=+||<+
syn cluster pukiwikiBlocks	contains=pukiwikiPre,pukiwikiSuperPre,pukiwikiBlockQuote

" コメント
syn region pukiwikiComment	start=+<!--+	end=+-->+

hi link pukiwikiHeading			Title
hi link pukiwikiCategory			Label
hi link pukiwikiHeadingName		Identifier
hi link pukiwikiList				Statement
hi link pukiwikiDefColon			Statement
hi link pukiwikiTableSeparator	Statement
hi link pukiwikiTableHeader		Title
hi link pukiwikiKeyword			Underlined
hi link pukiwikiLink				Underlined
hi link pukiwikiLinkURL			Underlined
hi link pukiwikiLinkSpecial		Special
hi link pukiwikiFootNote			Identifier
hi link pukiwikiCanceledParen		Special
hi link pukiwikiCancelLink		Special
hi link pukiwikiError				Error
"hi link pukiwikiBlockQuote		String
"hi link pukiwikiPre				String
"hi link pukiwikiSuperPre			String
hi link pukiwikiBlockDelimiter	Delimiter
hi link pukiwikiReadMore			Special
hi link pukiwikiComment			Comment

