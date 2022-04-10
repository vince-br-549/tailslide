#include <string>

#include "tailslide.hh"

int tailslide_lex_init_extra(Tailslide::ScriptContext *, void **);

void tailslide_set_in(FILE *, void *);

int tailslide_lex_destroy(void *);

namespace Tailslide {

extern LSLSymbolTable gGlobalSymbolTable;

ScopedScriptParser::ScopedScriptParser(LSLSymbolTable *builtins) : allocator(), logger(&allocator) {
  context.allocator = &allocator;
  context.logger = &logger;
  if (builtins)
    context.builtins = builtins;
  else
    context.builtins = &gGlobalSymbolTable;
}

LSLScript *ScopedScriptParser::parse_lsl(const std::string &filename) {
  // can only be used to parse a single script.
  assert(!script);
  FILE *yyin = fopen(filename.c_str(), "rb");
  if (yyin == nullptr) {
    throw "couldn't open file";
  }
  auto result = parse_lsl(yyin);
  fclose(yyin);
  return result;
}

LSLScript *ScopedScriptParser::parse_lsl(FILE *yyin) {
  assert(!script);
  void *scanner;
  // ScopedScriptParser owns the allocator and context instance because we can't
  // reasonably re-use Allocator instances with our current model of having
  // it magically pass along the current script context.
  allocator.set_context(&context);

  // initialize flex
  tailslide_lex_init_extra(&context, &scanner);

  // set input file
  tailslide_set_in(yyin, scanner);

  // parse
  tailslide_parse(scanner);

  // clean up flex
  tailslide_lex_destroy(scanner);
  ast_sane = context.ast_sane;
  script = context.script;

  return script;
}

}
