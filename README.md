## Usage

### remove_by_attr

This [Pandoc](https://pandoc.org/) [filter](https://pandoc.org/filters.html)
filters out the elements that match the provided attribute(s). The attrubtes
are passed in a Pandoc meta parameter `remove-attrs`, eg:

```sh
pandoc -M remove-attrs=class:foo,id:bar --filter remove_by_attr ...
```

The attribute name and value are separated by colon, and multiple attribute
key-value pairs are separated by comma.

You can specify a "class", "id", or any custom attribute, eg:

-M remove-attrs=myattr:someval
