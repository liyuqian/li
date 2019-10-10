Tools used by Yuqian Li.

Currently, there's only one tool to check if the Skia shader cache is binary
or SkSL.

# Install

Install [dart](https://dart.dev/get-dart) and then
```
pub global activate --source git https://github.com/liyuqian/li.git
```

# Run

```
pub global run li check_skia_shader <shader-cache-file-or-directory>
```

If pub packages path has been added to `PATH` by
`export PATH="$PATH":"$HOME/.pub-cache/bin"`, then `pub global run` can
be omitted:


```
li check_skia_shader <shader-cache-file-or-directory>
```

Sample output:

```
Found 2 shaders in SkSL type.
  test/resources/shader_cache/CAZAAAACAAAAAAAAAAAACAAAAAJQAAIADQABIAAPAALQAAAAAAABIAA2AAAAAAAAAAAAAAACAAAAAKAAMMAA
  test/resources/shader_cache/CAZAAAACAAAAAAAAAAABGAABAAOAAFAADQAAGAAQABSQAAAAAAAAAAAAAABAAAAAEAAGGAA

Found 1 shaders in binary type.
  test/resources/shader_cache/CAZAAAACAAAAACIAAAABGAABAAOAAAYABQAEMAAAAAAAAAAAAAAAEAAAAAOAAYYA

Found 0 shaders in unknown type.
```

# Test

See `test/check_skia_shader_test.dart` for some example runs and their expected outputs.
