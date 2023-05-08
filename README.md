# pandoc-fountain

A [custom pandoc reader] for [Fountain] screenplay markup.

## Basic Usage

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

## The `fountaincvt` Utility

The `fountaincvt` utility is a shell script wrapper around the foregoing
code samples. Its help message, which explains usage, is reproduced
below:

```text
******************************************************************************
*****               Pandoc Fountain Conversion Wrapper 1.00              *****
*****  Tammy Cravit / tammy@tammymakesthings.com / tammymakesthings.com  *****
******************************************************************************

******************************************************************************
*****               Pandoc Fountain Conversion Wrapper 1.00              *****
*****  Tammy Cravit / tammy@tammymakesthings.com / tammymakesthings.com  *****
******************************************************************************

Usage: fountaincvt -h
       fountaincvt [ -v ] [ -d ] [ -q ] [-o output_file] [-x extra_opts] <input_file> <output_format>

Command-Line Options:
    -v                     Enable debugging messages.
    -d                     Skip tools checks.
    -q                     Quiet mode (less verbose output).
    -o <output_file>       Override the automatically set output file.
    -x <extra_options>     Add extra options to Pandoc. See below for
                           an important note if using this option.

Environment Variables:
    PANDOC                  Location of the 'pandoc' binary.
                            Searched for in the path if not set.
                            Current Value: /opt/homebrew/bin/pandoc
    PANDOC_FOUNTAIN         Location of the 'pandoc-fountain' files.
                            Defaults to '/Users/tammycravit/projects/pandoc-fountain'.
                            Current Value: /Users/tammycravit/projects/pandoc-fountain
    PANDOC_PDF_EXTRA_OPTS   Extra options for pandoc for PDF conversion.
                            Current Value: <none>
    PANDOC_HTML_EXTRA_OPTS  Extra options for pandoc for HTML conversion.
                            Current Value: <none>
    PANDOC_EPUB_EXTRA_OPTS  Extra options for pandoc for EPUB conversion.
                            Current Value: <none>
    PANDOC_DOCX_EXTRA_OPTS  Extra options for pandoc for DOCX conversion.
                            Current Value: <none>

NOTE: If any of the PANDOC_*_EXTRA_OPTS variables are set, those options
      will be applied IN ADDITION TO options specified with the '-x'
      flag.

Version: 1.00, 2023-05-08
https://github.com/tammymakesthings/pandoc-fountain
```

[Fountain]: https://fountain.io/
[custom pandoc reader]: https://pandoc.org/custom-readers.html
