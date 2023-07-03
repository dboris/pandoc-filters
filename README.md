## Usage

### remove_by_attr

This [Pandoc filter](https://pandoc.org/filters.html) filters out the elements
that match the provided attribute(s). The attrubtes are passed in a Pandoc meta
parameter `remove-attr`:

```sh
pandoc -M remove-attr=class:foo --filter remove_by_attr ...
```

The attribute name and value are separated by a colon. The `remove-attr`
parameter can be repeated multiple times to supply a list of attributes, eg:

```sh
pandoc -M remove-attr=class:foo -M remove-attr=id:bar --filter remove_by_attr ...
```
