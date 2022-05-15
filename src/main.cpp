#include <cstdio>
#include <cstdlib>

#include "elaborator/CElaborator.h"
#include "parser/CParser.h"

void usage(const char* argv0)
{
	fprintf(stderr, "Usage: %s synth.vhd\n", argv0);
	exit(1);
}

int main(int argc, char** argv)
{
	if (argc < 2)
	{
		usage(argv[0]);
	}

	vhdl::CParser parser;

	parser.parse(argv[1]);

	vhdl::CElaborator elaborator(&parser);
	elaborator.printUnassignedSignals();

	return 0;
}
