# The PBC documentation

The documentation is deployed to https://partisiablockchain.gitlab.io/documentation/index.html

Documentation is written in Markdown

## Testing the documentation on localhost

The Markdown is converted to HTML using [Python-Markdown](https://python-markdown.github.io/).

It can be convenient to test that the generated HTML looks as intended on localhost.

Run the following command in the root folder of the documentation source. The command works on
Ubuntu and in Windows PowerShell.

```
docker run --rm -it -p 8000:8000 -u 1000:1000 -v "${PWD}:/docs" registry.gitlab.com/partisia/dockerimages/mkdocs:latest mkdocs serve -a 0.0.0.0:8000
```

The HTML can now be accessed at http://localhost:8000/
