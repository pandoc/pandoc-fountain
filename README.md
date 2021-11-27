# pandoc-fountain

A custom pandoc reader for [Fountain] screenplay markup.

To use:

```
pandoc -f fountain.lua input.fountain -t html5
```

When converting to Word docx, use the reference doc
`fountain-ref.docx`, which defines the needed custom styles:

```
pandoc -f fountain.lua --reference-docx fountain-ref.docx \
  sample.fountain -o sample.docx
```

[Fountain]: https://fountain.io/

