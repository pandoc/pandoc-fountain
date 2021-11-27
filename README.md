# pandoc-fountain

A [custom pandoc reader] for [Fountain] screenplay markup.

To convert from Fountain to HTML:

```
pandoc -f fountain.lua sample.fountain -s -t html5 \
  --css fountain.css --template ./fountain.html5 -o sample.html
```

To convert to EPUB:

```
pandoc -f fountain.lua sample.fountain -s -t epub3 \
  --css fountain.css --template ./fountain.epub3 -o sample.epub
 ```

To convert to Docx:

```
pandoc -f fountain.lua --reference-doc fountain-ref.docx \
  sample.fountain -o sample.docx
```

To convert to PDF (assuming you have wkhtmltopdf installed):

```
pandoc -f fountain.lua sample.fountain -s -t html5 \
  --css fountain.css --template ./fountain.html5 -o sample.pdf
```

[Fountain]: https://fountain.io/
[custom pandoc reader]: https://pandoc.org/custom-readers.html

