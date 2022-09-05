-- A custom reader for Fountain screenplay markup.
-- https://fountain.io/

-- For better performance we put these functions in local variables:
local P, S, R, Cf, Cc, Ct, V, Cs, Cg, Cb, B, C, Cmt =
  lpeg.P, lpeg.S, lpeg.R, lpeg.Cf, lpeg.Cc, lpeg.Ct, lpeg.V,
  lpeg.Cs, lpeg.Cg, lpeg.Cb, lpeg.B, lpeg.C, lpeg.Cmt

local whitespacechar = S(" \t\r\n")
local specialchar = S("_*[]()<>\\")
local wordchar = (1 - (whitespacechar + specialchar))
local spacechar = S(" \t")
local newline = P"\r"^-1 * P"\n"
local blankline = spacechar^0 * newline
local blanklines = blankline * blankline^1
local endline = newline - blanklines
local boneyard = P"/*" * P(1 - P"*/")^0 * P"*/"
local upperascii = R"AZ"

local function divwith(class, contents)
  return pandoc.Div(contents, { class = class,
                                ['custom-style'] = class })
end

-- Grammar
G = P{ "Pandoc",
  Pandoc = V"TitleBlock"
         * Ct((V"Block")^0)
         / function(meta, blocks)
             return pandoc.Pandoc(blocks, meta)
           end;
  TitleBlock = Cf(Cc{}
               * (V"MetaKey" * V"MetaValue" / table.pack)^0,
                function(acc,tbl)
                  local key, val = table.unpack(tbl)
                  acc[key] = pandoc.MetaInlines(val)
                  return acc
                end);
  MetaKey = C(P(1 - (P":" + newline))^1)
          * P":"
          * spacechar^0
          * (newline * spacechar^1)^-1
          / function(s)
              local new = s:gsub("%s+","-")
                           :gsub("%u", function(c) return string.lower(c) end)
              return new
            end;
  MetaValue = (Ct(((V"Inline" - newline)
                  + (newline * #-blankline * spacechar^3
                      / function() return pandoc.LineBreak() end))^1))
            * blankline^1
            ;
  Block = (blankline + boneyard)^0
        * (V"SceneHeading" + V"CenteredText" + V"Transition" +
           V"SectionHeading" + V"DialogueBlock" + V"Action") ;
  Transition =
    (Cmt(C((1 - blankline)^1),
       function(subj,pos,capt)
         if string.match(capt, "[%u%s%p]*TO:$") then
           return pos, capt
         end
       end)
    + (P">" * spacechar^0 * C(P(1 - blankline)^0)))
    * blanklines
    / function(s)
        return divwith("Transition", pandoc.Plain(s))
      end;
  DialogueBlock = Ct(V"Character"
                * (V"Parenthetical" + V"Lyric" + V"Dialogue")^1)
                / function(pars)
                    return divwith("Dialogue", pars)
                  end ;
  Dialogue = spacechar^0 -- skip leading space
           * Ct((V"Inline" - blankline)^1)
           * blankline
           / pandoc.Para ;
  Character = ((P"@" * Cc"") + C(upperascii^1)) * C((1 - newline)^0)
            * newline
            / function(s,t)
                return divwith("Character", pandoc.Plain(s..t))
              end ;
  Action = P"!"^-1 * Ct(V"Inline"^1) * blanklines
         / function(ils)
             return divwith("Action", pandoc.Para(ils))
           end;
  Lyric = Ct(V"LyricLine"^1)
        / function(lns)
            return divwith("Lyrics", pandoc.LineBlock(lns))
          end;
  LyricLine = P"~" * Ct((V"Inline" - newline)^0) * newline ;
  CenteredText = P">"
               * spacechar^0
               * Ct((V"Inline" - (P"<" * newline))^0)
               * P"<"
               * newline
               / function(ils)
                   return divwith("Centered", pandoc.Para(ils))
                 end ;
  SceneHeading = Cs((P"." / "") +
                    (P"INT" + P"EXT" + P"EST" +
                     P"INT./EXT" + P"INT/EXT" + P"I/E"))
               * C(P(1 - newline)^1)
               * newline
               / function(x,y)
                   return divwith("SceneHeading", pandoc.Para(x..y))
                 end;
  SectionHeading = (P"#"^1 / string.len)
                 * spacechar^0
                 * Ct((V"Inline" - blankline)^0)
                 * blankline
                 / function(lev, ils)
                     return pandoc.Header(lev, ils)
                   end ;
  Parenthetical = Ct((P"(" / pandoc.Str)
                * (V"Inline" - P")")^1
                * (P")" / pandoc.Str))
                * endline
                / function(ils)
                    return divwith("Parenthetical", pandoc.Plain(ils))
                  end ;
  Inline = V"Strong" + V"Emph" + V"Underline" +
           V"Str" + V"Space" + V"LineBreak" +
           V"Note" + V"Escaped" + V"Special";
  Str = wordchar^1 / pandoc.Str;
  Space = spacechar^1 / pandoc.Space;
  LineBreak = endline
            * #-(V"Parenthetical" + V"Lyric")
            * spacechar^0  -- skip indent on next line
            / pandoc.LineBreak;
  Escaped = P"\\" * C(specialchar) / pandoc.Str ;
  Note = P"[["
       * Ct((V"Inline" - P"]]")^0)
       * P"]]"
       / function(ils)
           return pandoc.Span(ils, {class="Note", ["custom-style"]="Note"})
         end;
  Emph = P"*"
       * Ct((V"Strong" + (V"Inline" - P"*"))^1)
       * P"*"
       / pandoc.Emph ;
  Underline = P"_"
       * Ct((V"Inline" - P"_")^1)
       * P"_"
       / pandoc.Underline ;
  Strong = P"**"
         * Ct((V"Inline" - P"**")^1)
         * P"**"
         / pandoc.Strong ;
  Special = C(specialchar) / pandoc.Str ;
}

function Reader(input)
  return lpeg.match(G, tostring(input))
end
