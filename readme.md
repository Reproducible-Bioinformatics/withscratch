# withscratch

Execute code inside a scratch directory context.

---

Get the latest [release](https://github.com/Reproducible-Bioinformatics/withscratch/releases/latest).

Usage example:

```R
with_scratch(
  source_directory = "/your/source/",
  target_directory = "/the/target",
  callback_function = function(target_directory) {
    # Your analysis here, using the target_directory.
  },
  cleanup_after = TRUE,
  copy_pattern = "result.txt"
)
```

