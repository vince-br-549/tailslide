#include <cstring>
#include <string>

#include "allocator.hh"

namespace Tailslide {

char *parse_string(ScriptAllocationManager *allocator, char *input) {
  char *str = allocator->alloc((strlen(input) * 2) + 1);
  char *yp = input + 1;
  char *sp = str;
  int end = 0;
#define _APPEND_CHAR(_x) do {*sp++ = (_x); ++end; } while(0)
  // The first `"` after an `L"` string opener is part of the string value itself
  // due to lscript's broken parser.
  if (input[0] == 'L' && input[1] == '"') {
    _APPEND_CHAR('"');
    ++yp;
  }
  while (*yp) {
    if (*yp == '\\') {
      switch (*++yp) {
        case 'n':
          _APPEND_CHAR('\n');
          break;
        case 't':
          // Tab escape really means "four spaces" in LSL.
          for (int i = 0; i < 4; ++i) {
            _APPEND_CHAR(' ');
          }
          break;
        case '\\':
          _APPEND_CHAR('\\');
          break;
        case '"':
          _APPEND_CHAR('"');
          break;
        // should never be possible, but stop parsing if we hit a NUL immediately after a '\'
        case '\0':
          goto escaped_null;
        default:
          // "\f" just outputs "f"
          _APPEND_CHAR(*yp);
          break;
      }
      ++yp;
      escaped_null:;
    } else if (*yp == '"') {
      break;
    } else {
      _APPEND_CHAR(*yp++);
    }
  }
#undef _APPEND_CHAR
  str[end] = '\0';
  return str;
}

std::string escape_string(const char *data) {
  std::string new_str;
  size_t datasize = strlen(data);
  for(int i=0; i<datasize; ++i) {
    char c = data[i];
    if (c == '\\')
      new_str += "\\\\";
    else if (c == '"')
      new_str += "\\\"";
    else if (c == '\n')
      new_str += "\\n";
    else
      new_str += c;
  }
  return new_str;
}

}
