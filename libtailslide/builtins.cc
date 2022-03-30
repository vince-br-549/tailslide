#include <cstdio>
#include <cstring>

#include "lslmini.hh"
#include "logger.hh"
#include "strings.hh"

namespace Tailslide {

extern char *builtins_txt[];

static ScriptAllocationManager gStaticAllocator {};
static LLScriptSymbolTable gGlobalSymbolTable {};

struct LSLTypeMap {
    const char *name;
    LST_TYPE type;
} types[] = {
        {"void",     LST_NULL},
        {"integer",  LST_INTEGER},
        {"float",    LST_FLOATINGPOINT},
        {"string",   LST_STRING},
        {"key",      LST_KEY},
        {"vector",   LST_VECTOR},
        {"rotation", LST_QUATERNION},
        {"list",     LST_LIST},
        {nullptr,    LST_ERROR}
};

LLScriptType *str_to_type(const char *str) {
  for (int i = 0; types[i].name != nullptr; ++i) {
    if (strcmp(types[i].name, str) == 0)
      return LLScriptType::get(types[i].type);
  }
  fprintf(stderr, "invalid type in builtins.txt: %s\n", str);
  exit(EXIT_FAILURE);
  return LLScriptType::get(LST_ERROR);
}

// called once at startup, not thread-safe.
void tailslide_init_builtins(const char *builtins_file) {
  assert(gAllocationManager == nullptr);
  LLScriptFunctionDec *dec = nullptr;
  FILE *fp = nullptr;
  char buf[1024];
  char original[1024];
  char *ret_type = nullptr;
  char *name = nullptr;
  char *ptype = nullptr, *pname = nullptr, *tokptr = nullptr, *value = nullptr;
  int line = 0;
  bool user_builtins = (builtins_file != nullptr);

  if (user_builtins) {
    fp = fopen(builtins_file, "r");

    if (fp == nullptr) {
      snprintf(buf, 1024, "couldn't open %s", builtins_file);
      perror(buf);
      exit(EXIT_FAILURE);
    }
  }

  gAllocationManager = &gStaticAllocator;
  while (true) {
    if (fp) {
      if (fgets(buf, 1024, fp) == nullptr)
        break;
    } else {
      if (builtins_txt[line] == nullptr)
        break;
      strncpy(buf, builtins_txt[line], 1024);
      ++line;
    }

    // skip blank lines and comment lines
    if (strncmp("//", buf, 2) == 0 || strncmp("\n", buf, 1) == 0)
      continue;

    strcpy(original, buf);

    ret_type = strtok_r(buf, " (),", &tokptr);

    if (ret_type == nullptr) {
      fprintf(stderr, "error parsing %s: %s\n", builtins_file, original);
      exit(EXIT_FAILURE);
      return;
    }

    if (!strcmp(ret_type, "const")) {
      ret_type = strtok_r(nullptr, " =(),", &tokptr);
      name = strtok_r(nullptr, " =(),", &tokptr);
      value = strtok_r(nullptr, "=", &tokptr);


      if (ret_type == nullptr || name == nullptr || value == nullptr) {
        fprintf(stderr, "error parsing %s: %s\n", builtins_file, original);
        exit(EXIT_FAILURE);
        return;
      }

      // key constants don't exist, and there are no key literals either.
      LLScriptType *const_type;
      if (strcmp(ret_type, "key") == 0) {
        const_type = str_to_type("string");
      } else {
        const_type = str_to_type(ret_type);
      }
      auto *sym = gStaticAllocator.new_tracked<LLScriptSymbol>(
        gStaticAllocator.copy_str(name), const_type, SYM_VARIABLE, SYM_BUILTIN
      );

      while (*value == ' ') {
        ++value;
      }


#define _CONST_PARSE_FAIL() fprintf(stderr, "couldn't parse value for '%s'\n", name); exit(EXIT_FAILURE)

#define _CONST_SSCANF(num, fmt, ...) \
if(sscanf(value, (fmt), __VA_ARGS__) != num) { \
   _CONST_PARSE_FAIL(); \
}; do { } while(0)

      switch (const_type->get_itype()) {
        case LST_INTEGER: {
          int const_val;
          _CONST_SSCANF(1, "%d", &const_val);
          // We might be reading the `0x` portion of `0xF00`, double-check.
          // Normally you'd just use %D, but LSL doesn't have octal.
          if (const_val == 0) {
            int const_val_hex;
            if (sscanf(value, "0x%x", &const_val_hex) == 1) {
              const_val = const_val_hex;
            }
          }
          auto const_built = gStaticAllocator.new_tracked<LLScriptIntegerConstant>(const_val);
          const_built->mark_static();
          sym->set_constant_value(const_built);
        }
          break;
        case LST_FLOATINGPOINT: {
          float const_val;
          _CONST_SSCANF(1, "%f", &const_val);
          auto const_built = gStaticAllocator.new_tracked<LLScriptFloatConstant>(const_val);
          const_built->mark_static();
          sym->set_constant_value(const_built);
        }
          break;
        case LST_VECTOR: {
          float x, y, z;
          _CONST_SSCANF(3, "<%f, %f, %f>", &x, &y, &z);
          auto const_built = gStaticAllocator.new_tracked<LLScriptVectorConstant>(x, y, z);
          const_built->mark_static();
          sym->set_constant_value(const_built);
        }
          break;
        case LST_QUATERNION: {
          float x, y, z, s;
          _CONST_SSCANF(4, "<%f, %f, %f, %f>", &x, &y, &z, &s);
          auto const_built = gStaticAllocator.new_tracked<LLScriptQuaternionConstant>(x, y, z, s);
          const_built->mark_static();
          sym->set_constant_value(const_built);
        }
          break;
        case LST_STRING:
        case LST_KEY: {
          if (value[0] != '"') {
            _CONST_PARSE_FAIL();
          }
          auto const_built = gStaticAllocator.new_tracked<LLScriptStringConstant>(
              parse_string(value)
          );
          const_built->mark_static();
          sym->set_constant_value(const_built);
        }
          break;
        default:
          break;
      }

#undef _CONST_PARSE_FAIL
#undef _CONST_SSCANF

      gGlobalSymbolTable.define(sym);

    } else if (!strcmp(ret_type, "event")) {
      name = strtok_r(nullptr, " (),", &tokptr);

      if (name == nullptr) {
        fprintf(stderr, "error parsing %s: %s\n", builtins_file, original);
        exit(EXIT_FAILURE);
        return;
      }

      dec = gStaticAllocator.new_tracked<LLScriptFunctionDec>();
      while ((ptype = strtok_r(nullptr, " (),", &tokptr)) != nullptr) {
        if ((pname = strtok_r(nullptr, " (),", &tokptr)) != nullptr) {
          dec->push_child(gStaticAllocator.new_tracked<LLScriptIdentifier>(
            str_to_type(ptype), gStaticAllocator.copy_str(pname))
          );
        }
      }

      gGlobalSymbolTable.define(gStaticAllocator.new_tracked<LLScriptSymbol>(
        gStaticAllocator.copy_str(name), str_to_type("void"), SYM_EVENT, SYM_BUILTIN, dec
      ));
    } else {
      name = strtok_r(nullptr, " (),", &tokptr);

      if (name == nullptr) {
        fprintf(stderr, "error parsing %s: %s\n", builtins_file, original);
        exit(EXIT_FAILURE);
        return;
      }

      dec = gStaticAllocator.new_tracked<LLScriptFunctionDec>();
      while ((ptype = strtok_r(nullptr, " (),", &tokptr)) != nullptr) {
        if ((pname = strtok_r(nullptr, " (),", &tokptr)) != nullptr) {
          dec->push_child(gStaticAllocator.new_tracked<LLScriptIdentifier>(
            str_to_type(ptype), gStaticAllocator.copy_str(pname)
          ));
        }
      }

      gGlobalSymbolTable.define(gStaticAllocator.new_tracked<LLScriptSymbol>(
        gStaticAllocator.copy_str(name), str_to_type(ret_type), SYM_FUNCTION, SYM_BUILTIN, dec
      ));
    }
  }
  // stop using the static allocator as the general allocator
  gAllocationManager = nullptr;
}

LLScriptSymbol *LLScriptScript::lookup_symbol(const char *name, LLSymbolType sym_type, LLASTNode *start_node) {
  auto *sym = gGlobalSymbolTable.lookup(name, sym_type);
  if (sym != nullptr)
    return sym;
  return LLASTNode::lookup_symbol(name, sym_type, start_node);
}

}